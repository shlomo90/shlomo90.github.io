# POSIX Thread

## What is the Thread and why does it need?

1. It's used for multi-proessor or multi-core systems where the process flow can be scheduled to run
   on another processor thus gaining speed through parallel or distributed processign.
2. It's light. System does not need to initialize a new system virtual memory space and environment
   for the process.
3. It's faster. Using POSIX thread is to execute software faster.

## Basics

* A thread does not maintain a list of created threads, nor does it know the thread that created it.
* All threads within a process share the same address space. (Plus below...)
  * Process instructions
  * Most data
  * Open files
  * Signals and signal handlers
  * Current working directory
  * User and group id.
* Each thread has a unique:
  * Thread ID
  * Set of registors, stack pointer
  * Stack for local variables, return addresses
  * Signal mask
  * Priority
  * Return value

