<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Fiber (computer science)

* a particularly lightweight thread of execution.
* fibers use cooperative multitasking while threads use preemptive multitasking.
* Threads often depend on the kernel's thread scheduler to preempt a busy thread and resume another thread
* fibers yied themselves to run another fiber while executing.

# Fiber and corutines

* coroutines are a language-level construct.
* fibers are systems-level construct, viewed as threads that happen to not run concurrently

```
Fibers yield control to the single-threaded main program, and when the I/O operation (not needed CPU processing)
is completed fibers continue where they left off.
```

* `setjmp/longjmp` mechanism only supports jumps up the call stack. You cannot do side-jumps or down-jumps.
  Only up-jumps are supported.
    * See the link :https://stackoverflow.com/questions/51545566/why-a-segmentation-fault-occurs-calling-a-function-inside-setjmp

