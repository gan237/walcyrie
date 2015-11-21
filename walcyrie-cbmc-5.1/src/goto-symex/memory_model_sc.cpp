/*******************************************************************\

Module: Memory model for partial order concurrency

Author: Michael Tautschnig, michael.tautschnig@cs.ox.ac.uk

\*******************************************************************/

#include <util/std_expr.h>
#include <util/i2string.h>

#include "memory_model_sc.h"

/*******************************************************************\

Function: memory_model_sct::operator()

  Inputs: 

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::operator()(symex_target_equationt &equation)
{
  print(8, "Adding SC constraints");

  build_event_lists(equation);
  build_clock_type(equation);

#ifdef WALCYRIE
  build_rw(equation);
  build_ppo(equation);

  generate_succ_constraints(equation);
  generate_match_constraints(equation);
  write_serialization_external(equation);
#else  
  read_from(equation);
  write_serialization_external(equation);
  program_order(equation);
  from_read(equation);
#endif
}

/*******************************************************************\

Function: memory_model_sct::before

  Inputs: 

 Outputs:

 Purpose:

\*******************************************************************/

exprt memory_model_sct::before(event_it e1, event_it e2)
{
  return partial_order_concurrencyt::before(
    e1, e2, AX_PROPAGATION);
}

/*******************************************************************\

Function: memory_model_sct::program_order_is_relaxed

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

bool memory_model_sct::program_order_is_relaxed(
  partial_order_concurrencyt::event_it e1,
  partial_order_concurrencyt::event_it e2) const
{
  assert(is_shared_read(e1) || is_shared_write(e1));
  assert(is_shared_read(e2) || is_shared_write(e2));

  return false;
}

/*******************************************************************\

Function: memory_model_sct::build_per_thread_map

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::build_per_thread_map(
  const symex_target_equationt &equation,
  per_thread_mapt &dest) const
{
  // this orders the events within a thread
  
  for(eventst::const_iterator
      e_it=equation.SSA_steps.begin();
      e_it!=equation.SSA_steps.end();
      e_it++)
  {
    // concurreny-related?
    if(!is_shared_read(e_it) &&
       !is_shared_write(e_it) &&
       !is_spawn(e_it) &&
       !is_memory_barrier(e_it)) continue;

    dest[e_it->source.thread_nr].push_back(e_it);
  }
}

#ifdef WALCYRIE

/*******************************************************************\

Function: memory_model_sct::gt

  Inputs: 

 Outputs:

 Purpose:

\*******************************************************************/

exprt memory_model_sct::gt(event_it e1, event_it e2)
{
  return not_exprt(before(e1, e2));
}

/*******************************************************************\

Function: memory_model_sct::genvar

  Inputs: 

 Outputs:

 Purpose:

\*******************************************************************/

exprt memory_model_sct::genvar(
  const event_it &r, const event_it &w)
{
  assert(is_shared_read(r) && is_shared_write(w));
  std::ostringstream rss, wss;
  rss << "RW_READ" 
      << "$" << r->source.thread_nr << "$"
      << id2string(id(r)) ;

  wss << "_WRITE" 
      << "$" << w->source.thread_nr << "$"
      << id2string(id(w)) ;

  irep_idt symbol = rss.str() + wss.str();
  return symbol_exprt(symbol, bool_typet());
}

/*******************************************************************\

Function: memory_model_sct::funct_latesw

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

exprt memory_model_sct::funct_latestw(
  const event_it &r, const event_it &w)
{
  assert(is_shared_read(r) && is_shared_write(w));
  exprt::operandst funct_operands, latestw_operands;

  for(event_listt::const_iterator
      w_it = matching_writes[r].begin();
      w_it != matching_writes[r].end(); w_it++)
  {
    if(w == *w_it)
      continue;

    exprt Xm = genvar(r, *w_it);
    funct_operands.push_back(not_exprt(Xm));

    exprt latestw_lhs, latestw_rhs, latestw;
    // TODO: further static pruning?
    if((po(*w_it, w) && !program_order_is_relaxed(*w_it, w)) ||
          (po(r, *w_it) && !program_order_is_relaxed(r, *w_it)))
        continue;
      else if(po(r, w) && !program_order_is_relaxed(r, w))
        latestw = false_exprt(); // exit(0) even?
      else if((po(w, *w_it) && !program_order_is_relaxed(w, *w_it)) && 
              (po(*w_it, r) && !program_order_is_relaxed(*w_it, r)))
        latestw = implies_exprt((*w_it)->guard, false_exprt());
      else if(po(w, *w_it) && !program_order_is_relaxed(w, *w_it))
        latestw = implies_exprt((*w_it)->guard, before(r, *w_it));
      else
      {
        latestw_lhs = and_exprt(gt(r, *w_it), (*w_it)->guard);
        latestw_rhs = gt(w, *w_it);
        latestw = implies_exprt(latestw_lhs, latestw_rhs);
      }
    latestw_operands.push_back(latestw);
  }

  return and_exprt (conjunction(funct_operands), 
                    conjunction(latestw_operands));
}

/*******************************************************************\

Function: memory_model_sct::transitive_reduction

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::transitive_reduction(const  event_it &e1, const  event_it &e2)
{
  if (e1 == e2)
    return;

  // transitive closed ppo
  tsuccessors[e1].insert(e2);

  // pick the edges to remove
  if(!predecessors[e2].empty())
  {
    event_listt::const_iterator pred  = predecessors[e2].begin();
    event_listt::const_iterator done = predecessors[e2].end();

    for(;pred != done ; pred++)
    {
      // see if e1 figures in pred's tsuccessors
      if(tsuccessors[*pred].find(e1) != tsuccessors[*pred].end())
      {
        event_listt::iterator is = successors[*pred].begin();
        event_listt::iterator js = successors[*pred].end();
        successors[*pred].erase(std::remove(is, js, e2),
        successors[*pred].end());

        event_listt::iterator ip = predecessors[e2].begin();
        event_listt::iterator jp = predecessors[e2].end();
        predecessors[e2].erase(std::remove(ip, jp, *pred),
        predecessors[e2].end());
      }
    }
  }

  // transitive reduced ppo
  predecessors[e2].push_back(e1);
  successors[e1].push_back(e2);
}

/*******************************************************************\

Function: memory_model_sct::build_rw

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void  memory_model_sct::build_rw(
  symex_target_equationt &equation)
{

  print(12, "Populating rw");

  for(address_mapt::const_iterator
      a_it=address_map.begin();
      a_it!=address_map.end();
      a_it++)
  {
    const a_rect &a_rec=a_it->second;
  
    for(event_listt::const_iterator
        r_it=a_rec.reads.begin();
        r_it!=a_rec.reads.end();
        r_it++)
    {
      const event_it r=*r_it;
      
      for(event_listt::const_iterator
          w_it=a_rec.writes.begin();
          w_it!=a_rec.writes.end();
          ++w_it)
      {
        const event_it w=*w_it;
       
        if(po(r, w) && !program_order_is_relaxed(r, w))
          continue; // rw contradicts po

        matching_reads[w].push_back(r);
        matching_writes[r].push_back(w);
        rw_matches.push_back(rw_matcht(r, w));
      }
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::build_ppo

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void  memory_model_sct::build_ppo(
  symex_target_equationt &equation)
{
  print(12, "Populating ppo");

  // TODO: push the per_thread_map into the sct.
  per_thread_mapt per_thread_map;
  build_per_thread_map(equation, per_thread_map);

  thread_spawn(equation, per_thread_map);
 
  // iterate over threads
  for(per_thread_mapt::const_iterator
      t_it=per_thread_map.begin();
      t_it!=per_thread_map.end();
      t_it++)
  {
    const event_listt &events=t_it->second; 

    for(event_listt::const_iterator
        e_it1=events.begin();
        e_it1!=events.end();
        e_it1++)
    {
      if(is_memory_barrier(*e_it1))
         continue;

      for(event_listt::const_iterator
        e_it2=e_it1+1; 
        e_it2!=events.end();
        e_it2++)
      {
        if(is_memory_barrier(*e_it2))
         continue; 

        transitive_reduction(*e_it1, *e_it2);
      } 
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::generate_succ_constraint

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void  memory_model_sct::generate_succ_constraints(
  symex_target_equationt &equation)
{
  print(8, "Adding succ constraints");

  per_thread_mapt per_thread_map;
  build_per_thread_map(equation, per_thread_map);
 
  for(per_thread_mapt::const_iterator
      t_it=per_thread_map.begin();
      t_it!=per_thread_map.end();
      t_it++)
  {
    const event_listt &events=t_it->second;

    for(event_listt::const_iterator
        p_it=events.begin();
        p_it!=events.end();
        p_it++)
    {
      for(event_listt::const_iterator
        q_it=successors[*p_it].begin();
        q_it!=successors[*p_it].end();
        q_it++)
      {
        exprt succ = before(*p_it, *q_it);
        add_constraint(equation, succ, "succ", (*p_it)->source);
      }
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::generate_match_constraints

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void  memory_model_sct::generate_match_constraints(
  symex_target_equationt &equation)
{
  print(8, "Adding ext/m2clk constraints");

  if(0 == rw_matches.size())
  {
    print(equation.SSA_steps.size(), "empty rw");
    return;
  }

  for(rw_matchst::const_iterator
      rw_it=rw_matches.begin();
      rw_it!=rw_matches.end();
      rw_it++)
  {
    rw_matcht m = *rw_it;
    event_it r = m.first;
    event_it w = m.second;
    exprt Xm = genvar(r, w);

    exprt guards   = and_exprt(r->guard, w->guard);
    exprt ext_rhs  = and_exprt(guards, funct_latestw(r, w));
    exprt ext = and_exprt(implies_exprt(Xm, ext_rhs),
                          implies_exprt(ext_rhs, Xm));
    add_constraint(equation, ext, "ext", r->source);

    exprt m2clk_rhs_before = before(w, r);
    exprt m2clk_rhs_equal  = equal_exprt(r->ssa_lhs, w->ssa_lhs);
    exprt m2clk_rhs = and_exprt(
                        m2clk_rhs_before,
                        m2clk_rhs_equal);
    exprt m2clk = implies_exprt(Xm, m2clk_rhs);
    add_constraint(equation, m2clk, "m2clk", r->source);
  }
}


#endif

/*******************************************************************\

Function: memory_model_sct::thread_spawn

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::thread_spawn(
  symex_target_equationt &equation,
  const per_thread_mapt &per_thread_map)
{
  // thread spawn: the spawn precedes the first
  // instruction of the new thread in program order
  
  unsigned next_thread_id=0;
  for(eventst::const_iterator
      e_it=equation.SSA_steps.begin();
      e_it!=equation.SSA_steps.end();
      e_it++)
  {
    if(is_spawn(e_it))
    {
      per_thread_mapt::const_iterator next_thread=
        per_thread_map.find(++next_thread_id);
      if(next_thread==per_thread_map.end()) continue;

      // For SC and several weaker memory models a memory barrier
      // at the beginning of a thread can simply be ignored, because
      // we enforce program order in the thread-spawn constraint
      // anyway. Memory models with cumulative memory barriers
      // require explicit handling of these.
      event_listt::const_iterator n_it=next_thread->second.begin();
      for( ;
          n_it!=next_thread->second.end();
          n_it++)
      {
          if(!(*n_it)->is_memory_barrier())
            add_constraint(
              equation,
              before(e_it, *n_it),
              "thread-spawn",
              e_it->source);
      }
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::program_order

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::program_order(
  symex_target_equationt &equation)
{
  per_thread_mapt per_thread_map;
  build_per_thread_map(equation, per_thread_map);

  thread_spawn(equation, per_thread_map);
  
  // iterate over threads

  for(per_thread_mapt::const_iterator
      t_it=per_thread_map.begin();
      t_it!=per_thread_map.end();
      t_it++)
  {
    const event_listt &events=t_it->second;
    
    // iterate over relevant events in the thread
    
    event_it previous=equation.SSA_steps.end();
    
    for(event_listt::const_iterator
        e_it=events.begin();
        e_it!=events.end();
        e_it++)
    {
      if(is_memory_barrier(*e_it))
         continue;

      if(previous==equation.SSA_steps.end())
      {
        // first one?
        previous=*e_it;
        continue;
      }

      add_constraint(
        equation,
        before(previous, *e_it),
        "po",
        (*e_it)->source);

      previous=*e_it;
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::write_serialization_external

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::write_serialization_external(
  symex_target_equationt &equation)
{
  for(address_mapt::const_iterator
      a_it=address_map.begin();
      a_it!=address_map.end();
      a_it++)
  {
    const a_rect &a_rec=a_it->second;

    // This is quadratic in the number of writes
    // per address. Perhaps some better encoding
    // based on 'places'?    
    for(event_listt::const_iterator
        w_it1=a_rec.writes.begin();
        w_it1!=a_rec.writes.end();
        ++w_it1)
    {
      event_listt::const_iterator next=w_it1;
      ++next;

      for(event_listt::const_iterator w_it2=next;
          w_it2!=a_rec.writes.end();
          ++w_it2)
      {
        // external?
        if((*w_it1)->source.thread_nr==
           (*w_it2)->source.thread_nr)
          continue;

        // ws is a total order, no two elements have the same rank
        // s -> w_evt1 before w_evt2; !s -> w_evt2 before w_evt1

        symbol_exprt s=nondet_bool_symbol("ws-ext");

        // write-to-write edge
        add_constraint(
          equation,
          implies_exprt(s, before(*w_it1, *w_it2)),
          "ws-ext",
          (*w_it1)->source);

        add_constraint(
          equation,
          implies_exprt(not_exprt(s), before(*w_it2, *w_it1)),
          "ws-ext",
          (*w_it1)->source);
      }
    }
  }
}

/*******************************************************************\

Function: memory_model_sct::from_read

  Inputs:

 Outputs:

 Purpose:

\*******************************************************************/

void memory_model_sct::from_read(symex_target_equationt &equation)
{
  // from-read: (w', w) in ws and (w', r) in rf -> (r, w) in fr
  
  for(address_mapt::const_iterator
      a_it=address_map.begin();
      a_it!=address_map.end();
      a_it++)
  {
    const a_rect &a_rec=a_it->second;

    // This is quadratic in the number of writes per address.
    for(event_listt::const_iterator
        w_prime=a_rec.writes.begin();
        w_prime!=a_rec.writes.end();
        ++w_prime)
    {
      event_listt::const_iterator next=w_prime;
      ++next;

      for(event_listt::const_iterator w=next;
          w!=a_rec.writes.end();
          ++w)
      {
        exprt ws1, ws2;
        
        if(po(*w_prime, *w) &&
           !program_order_is_relaxed(*w_prime, *w))
        {
          ws1=true_exprt();
          ws2=false_exprt();
        }
        else if(po(*w, *w_prime) &&
                !program_order_is_relaxed(*w, *w_prime))
        {
          ws1=false_exprt();
          ws2=true_exprt();
        }
        else
        {
          ws1=before(*w_prime, *w);
          ws2=before(*w, *w_prime);
        }

        // smells like cubic
        for(choice_symbolst::const_iterator
            c_it=choice_symbols.begin();
            c_it!=choice_symbols.end();
            c_it++)
        {
          event_it r=c_it->first.first;
          exprt rf=c_it->second;
          exprt cond;
          cond.make_nil();
        
          if(c_it->first.second==*w_prime && !ws1.is_false())
          {
            exprt fr=before(r, *w);

            // the guard of w_prime follows from rf; with rfi
            // optimisation such as the previous write_symbol_primed
            // it would even be wrong to add this guard
            cond=
              implies_exprt(
                and_exprt(r->guard, (*w)->guard, ws1, rf),
                fr);
          }
          else if(c_it->first.second==*w && !ws2.is_false())
          {
            exprt fr=before(r, *w_prime);

            // the guard of w follows from rf; with rfi
            // optimisation such as the previous write_symbol_primed
            // it would even be wrong to add this guard
            cond=
              implies_exprt(
                and_exprt(r->guard, (*w_prime)->guard, ws2, rf),
                fr);
          }

          if(cond.is_not_nil())
            add_constraint(equation,
              cond, "fr", r->source);
        }
        
      }
    }
  }
}

