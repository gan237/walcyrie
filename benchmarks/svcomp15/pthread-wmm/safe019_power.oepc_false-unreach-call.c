extern void __VERIFIER_error() __attribute__ ((__noreturn__));
void __VERIFIER_assert(int expression) { if (!expression) { ERROR: __VERIFIER_error(); }; return; }
int __global_lock;
void __VERIFIER_atomic_begin() { __VERIFIER_assume(__global_lock==0); __global_lock=1; return; }
void __VERIFIER_atomic_end() { __VERIFIER_assume(__global_lock==1); __global_lock=0; return; }

#include <assert.h>
#include <pthread.h>
#ifndef TRUE
#define TRUE (_Bool)1
#endif
#ifndef FALSE
#define FALSE (_Bool)0
#endif
#ifndef NULL
#define NULL ((void*)0)
#endif
#ifndef FENCE
#define FENCE(x) ((void)0)
#endif
#ifndef IEEE_FLOAT_EQUAL
#define IEEE_FLOAT_EQUAL(x,y) (x==y)
#endif
#ifndef IEEE_FLOAT_NOTEQUAL
#define IEEE_FLOAT_NOTEQUAL(x,y) (x!=y)
#endif



void * P0(void *arg);


void * P1(void *arg);


void * P2(void *arg);


void * P3(void *arg);


void fence();


void isync();


void lwfence();




int __unbuffered_cnt;


int __unbuffered_cnt = 0;


int __unbuffered_p0_EAX;


int __unbuffered_p0_EAX = 0;


_Bool __unbuffered_p0_EAX$flush_delayed;


int __unbuffered_p0_EAX$mem_tmp;


_Bool __unbuffered_p0_EAX$r_buff0_thd0;


_Bool __unbuffered_p0_EAX$r_buff0_thd1;


_Bool __unbuffered_p0_EAX$r_buff0_thd2;


_Bool __unbuffered_p0_EAX$r_buff0_thd3;


_Bool __unbuffered_p0_EAX$r_buff0_thd4;


_Bool __unbuffered_p0_EAX$r_buff1_thd0;


_Bool __unbuffered_p0_EAX$r_buff1_thd1;


_Bool __unbuffered_p0_EAX$r_buff1_thd2;


_Bool __unbuffered_p0_EAX$r_buff1_thd3;


_Bool __unbuffered_p0_EAX$r_buff1_thd4;


_Bool __unbuffered_p0_EAX$read_delayed;


int *__unbuffered_p0_EAX$read_delayed_var;


int __unbuffered_p0_EAX$w_buff0;


_Bool __unbuffered_p0_EAX$w_buff0_used;


int __unbuffered_p0_EAX$w_buff1;


_Bool __unbuffered_p0_EAX$w_buff1_used;


int __unbuffered_p0_EBX;


int __unbuffered_p0_EBX = 0;


int __unbuffered_p2_EAX;


int __unbuffered_p2_EAX = 0;


_Bool main$tmp_guard0;


_Bool main$tmp_guard1;


int x;


int x = 0;


int y;


int y = 0;


_Bool y$flush_delayed;


int y$mem_tmp;


_Bool y$r_buff0_thd0;


_Bool y$r_buff0_thd1;


_Bool y$r_buff0_thd2;


_Bool y$r_buff0_thd3;


_Bool y$r_buff0_thd4;


_Bool y$r_buff1_thd0;


_Bool y$r_buff1_thd1;


_Bool y$r_buff1_thd2;


_Bool y$r_buff1_thd3;


_Bool y$r_buff1_thd4;


_Bool y$read_delayed;


int *y$read_delayed_var;


int y$w_buff0;


_Bool y$w_buff0_used;


int y$w_buff1;


_Bool y$w_buff1_used;


_Bool weak$$choice0;


_Bool weak$$choice1;


_Bool weak$$choice2;



void * P0(void *arg)
{
  __VERIFIER_atomic_begin();
  weak$$choice0 = nondet_0();
  weak$$choice2 = nondet_0();
  y$flush_delayed = weak$$choice2;
  y$mem_tmp = y;
  weak$$choice1 = nondet_0();
  y = !y$w_buff0_used ? y : (y$w_buff0_used && y$r_buff0_thd1 ? y$w_buff0 : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? (weak$$choice0 ? y : (weak$$choice1 ? y$w_buff0 : y$w_buff1)) : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? (weak$$choice0 ? y$w_buff1 : y$w_buff0) : (weak$$choice0 ? y$w_buff0 : y))));
  y$w_buff0 = weak$$choice2 ? y$w_buff0 : (!y$w_buff0_used ? y$w_buff0 : (y$w_buff0_used && y$r_buff0_thd1 ? y$w_buff0 : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? y$w_buff0 : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? y$w_buff0 : y$w_buff0))));
  y$w_buff1 = weak$$choice2 ? y$w_buff1 : (!y$w_buff0_used ? y$w_buff1 : (y$w_buff0_used && y$r_buff0_thd1 ? y$w_buff1 : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? y$w_buff1 : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? y$w_buff1 : y$w_buff1))));
  y$w_buff0_used = weak$$choice2 ? y$w_buff0_used : (!y$w_buff0_used ? y$w_buff0_used : (y$w_buff0_used && y$r_buff0_thd1 ? FALSE : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? weak$$choice0 || !weak$$choice1 : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? weak$$choice0 : weak$$choice0))));
  y$w_buff1_used = weak$$choice2 ? y$w_buff1_used : (!y$w_buff0_used ? y$w_buff1_used : (y$w_buff0_used && y$r_buff0_thd1 ? FALSE : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? weak$$choice0 : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? FALSE : FALSE))));
  y$r_buff0_thd1 = weak$$choice2 ? y$r_buff0_thd1 : (!y$w_buff0_used ? y$r_buff0_thd1 : (y$w_buff0_used && y$r_buff0_thd1 ? FALSE : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? y$r_buff0_thd1 : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? FALSE : FALSE))));
  y$r_buff1_thd1 = weak$$choice2 ? y$r_buff1_thd1 : (!y$w_buff0_used ? y$r_buff1_thd1 : (y$w_buff0_used && y$r_buff0_thd1 ? FALSE : (y$w_buff0_used && !y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? (weak$$choice0 ? y$r_buff1_thd1 : FALSE) : (y$w_buff0_used && y$r_buff1_thd1 && y$w_buff1_used && !y$r_buff0_thd1 ? FALSE : FALSE))));
  __unbuffered_p0_EAX$read_delayed = TRUE;
  __unbuffered_p0_EAX$read_delayed_var = &y;
  __unbuffered_p0_EAX = y;
  y = y$flush_delayed ? y$mem_tmp : y;
  y$flush_delayed = FALSE;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __unbuffered_p0_EBX = x;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __unbuffered_cnt = __unbuffered_cnt + 1;
  __VERIFIER_atomic_end();
  return nondet_1();
}



void * P1(void *arg)
{
  __VERIFIER_atomic_begin();
  x = 1;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __unbuffered_cnt = __unbuffered_cnt + 1;
  __VERIFIER_atomic_end();
  return nondet_1();
}



void * P2(void *arg)
{
  __VERIFIER_atomic_begin();
  __unbuffered_p2_EAX = x;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  y = 1;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  y = y$w_buff0_used && y$r_buff0_thd3 ? y$w_buff0 : (y$w_buff1_used && y$r_buff1_thd3 ? y$w_buff1 : y);
  y$w_buff0_used = y$w_buff0_used && y$r_buff0_thd3 ? FALSE : y$w_buff0_used;
  y$w_buff1_used = y$w_buff0_used && y$r_buff0_thd3 || y$w_buff1_used && y$r_buff1_thd3 ? FALSE : y$w_buff1_used;
  y$r_buff0_thd3 = y$w_buff0_used && y$r_buff0_thd3 ? FALSE : y$r_buff0_thd3;
  y$r_buff1_thd3 = y$w_buff0_used && y$r_buff0_thd3 || y$w_buff1_used && y$r_buff1_thd3 ? FALSE : y$r_buff1_thd3;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __unbuffered_cnt = __unbuffered_cnt + 1;
  __VERIFIER_atomic_end();
  return nondet_1();
}



void * P3(void *arg)
{
  __VERIFIER_atomic_begin();
  y = 2;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  y = y$w_buff0_used && y$r_buff0_thd4 ? y$w_buff0 : (y$w_buff1_used && y$r_buff1_thd4 ? y$w_buff1 : y);
  y$w_buff0_used = y$w_buff0_used && y$r_buff0_thd4 ? FALSE : y$w_buff0_used;
  y$w_buff1_used = y$w_buff0_used && y$r_buff0_thd4 || y$w_buff1_used && y$r_buff1_thd4 ? FALSE : y$w_buff1_used;
  y$r_buff0_thd4 = y$w_buff0_used && y$r_buff0_thd4 ? FALSE : y$r_buff0_thd4;
  y$r_buff1_thd4 = y$w_buff0_used && y$r_buff0_thd4 || y$w_buff1_used && y$r_buff1_thd4 ? FALSE : y$r_buff1_thd4;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  __unbuffered_cnt = __unbuffered_cnt + 1;
  __VERIFIER_atomic_end();
  return nondet_1();
}



void fence()
{
  
}



void isync()
{
  
}



void lwfence()
{
  
}



int main()
{
  pthread_create(NULL, NULL, P0, NULL);
  pthread_create(NULL, NULL, P1, NULL);
  pthread_create(NULL, NULL, P2, NULL);
  pthread_create(NULL, NULL, P3, NULL);
  __VERIFIER_atomic_begin();
  main$tmp_guard0 = __unbuffered_cnt == 4;
  __VERIFIER_atomic_end();
  __VERIFIER_assume(main$tmp_guard0);
  __VERIFIER_atomic_begin();
  y = y$w_buff0_used && y$r_buff0_thd0 ? y$w_buff0 : (y$w_buff1_used && y$r_buff1_thd0 ? y$w_buff1 : y);
  y$w_buff0_used = y$w_buff0_used && y$r_buff0_thd0 ? FALSE : y$w_buff0_used;
  y$w_buff1_used = y$w_buff0_used && y$r_buff0_thd0 || y$w_buff1_used && y$r_buff1_thd0 ? FALSE : y$w_buff1_used;
  y$r_buff0_thd0 = y$w_buff0_used && y$r_buff0_thd0 ? FALSE : y$r_buff0_thd0;
  y$r_buff1_thd0 = y$w_buff0_used && y$r_buff0_thd0 || y$w_buff1_used && y$r_buff1_thd0 ? FALSE : y$r_buff1_thd0;
  __VERIFIER_atomic_end();
  __VERIFIER_atomic_begin();
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  weak$$choice0 = nondet_0();
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  weak$$choice2 = nondet_0();
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$flush_delayed = weak$$choice2;
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$mem_tmp = y;
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y = !y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y : (y$w_buff0_used && y$r_buff0_thd0 ? y$w_buff0 : y$w_buff1);
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$w_buff0 = weak$$choice2 ? y$w_buff0 : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$w_buff0 : (y$w_buff0_used && y$r_buff0_thd0 ? y$w_buff0 : y$w_buff0));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$w_buff1 = weak$$choice2 ? y$w_buff1 : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$w_buff1 : (y$w_buff0_used && y$r_buff0_thd0 ? y$w_buff1 : y$w_buff1));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$w_buff0_used = weak$$choice2 ? y$w_buff0_used : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$w_buff0_used : (y$w_buff0_used && y$r_buff0_thd0 ? FALSE : y$w_buff0_used));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$w_buff1_used = weak$$choice2 ? y$w_buff1_used : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$w_buff1_used : (y$w_buff0_used && y$r_buff0_thd0 ? FALSE : FALSE));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$r_buff0_thd0 = weak$$choice2 ? y$r_buff0_thd0 : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$r_buff0_thd0 : (y$w_buff0_used && y$r_buff0_thd0 ? FALSE : y$r_buff0_thd0));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$r_buff1_thd0 = weak$$choice2 ? y$r_buff1_thd0 : (!y$w_buff0_used || !y$r_buff0_thd0 && !y$w_buff1_used || !y$r_buff0_thd0 && !y$r_buff1_thd0 ? y$r_buff1_thd0 : (y$w_buff0_used && y$r_buff0_thd0 ? FALSE : FALSE));
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  weak$$choice1 = nondet_0();
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  __unbuffered_p0_EAX = __unbuffered_p0_EAX$read_delayed ? (weak$$choice1 ? *__unbuffered_p0_EAX$read_delayed_var : __unbuffered_p0_EAX) : __unbuffered_p0_EAX;
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  main$tmp_guard1 = !(y == 2 && __unbuffered_p0_EAX == 2 && __unbuffered_p0_EBX == 0 && __unbuffered_p2_EAX == 1);
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y = y$flush_delayed ? y$mem_tmp : y;
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  y$flush_delayed = FALSE;
  __VERIFIER_atomic_end();
  /* Program was expected to be safe for X86, model checker should have said NO.
This likely is a bug in the tool chain. */
  __VERIFIER_assert(main$tmp_guard1);
  return 0;
}

