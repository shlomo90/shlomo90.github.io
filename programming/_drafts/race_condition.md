


Race Condition

- Meaning
  - Final outcome depends on the **exact** instruction sequence of the processes


- The reason why this occurs
  - In a multiprogrammed system, more than one process access a shared memory area.
    But, each process is scheduled by CPU scheduler.


- Examples
  * The too much milk problem
  * Withdraw at the same time from a joint account problem


- Solution
  * critical section
    * proposed by Dijkstra in 1965.
    * Prohibits more than one process from accessing shared memory at same time.


Semaphores

* to ensure that only one process is in a critical section.

* Meaning
  * It can act like a gate into a restricted area. (Seems like Toilet)
  * Binary Semaphore often referred to as MUTEX (MUTual Exclusion).


* Needs
  * Indivisible operation that is not interrupted by OS
    * Once started, they will be completed without interruption.



https://www.sjsu.edu/people/robert.chun/courses/cs159/s0/Day-8---Race-Semaphores.pdf
