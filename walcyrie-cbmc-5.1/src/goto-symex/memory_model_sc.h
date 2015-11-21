/*******************************************************************\

Module: Memory models for partial order concurrency

Author: Michael Tautschnig, michael.tautschnig@cs.ox.ac.uk

\*******************************************************************/

#ifndef CPROVER_MEMORY_MODEL_SC_H
#define CPROVER_MEMORY_MODEL_SC_H


#ifdef WALCYRIE
#include <algorithm>
#endif

#include "memory_model.h"

class memory_model_sct:public memory_model_baset
{
public:
  inline explicit memory_model_sct(const namespacet &_ns):
    memory_model_baset(_ns)
  {
  }

  virtual void operator()(symex_target_equationt &equation);
  
protected:
  virtual exprt before(event_it e1, event_it e2);
  virtual bool program_order_is_relaxed(
    partial_order_concurrencyt::event_it e1,
    partial_order_concurrencyt::event_it e2) const;

  void build_per_thread_map(
    const symex_target_equationt &equation,
    per_thread_mapt &dest) const;
  void thread_spawn(
    symex_target_equationt &equation,
    const per_thread_mapt &per_thread_map);
  void program_order(symex_target_equationt &equation);
  void from_read(symex_target_equationt &equation);
  void write_serialization_external(symex_target_equationt &equation);

#ifdef WALCYRIE

  typedef std::map<
    partial_order_concurrencyt::event_it,
    event_listt> event2listt;

  typedef std::map<
    partial_order_concurrencyt::event_it,
    std::set<event_it> > event2sett;

  typedef std::pair<event_it, event_it> rw_matcht;
  typedef std::vector<rw_matcht> rw_matchst;

  event2listt successors, predecessors;
  event2listt matching_reads, matching_writes;
  event2sett tsuccessors;
  rw_matchst rw_matches;

  /* gt = \neg before(...) */
  void transitive_reduction
              (const event_it &e1, const event_it &e2);
  virtual void build_ppo(symex_target_equationt &equation);
  void build_rw(symex_target_equationt &equation);

  exprt genvar(const event_it &r, const event_it &w);
  exprt gt(event_it e1, event_it e2);
  exprt funct_latestw(const event_it &r, const event_it &w);

  void  generate_succ_constraints(symex_target_equationt &equation);
  void  generate_match_constraints(symex_target_equationt &equation);

#endif
};

#endif

