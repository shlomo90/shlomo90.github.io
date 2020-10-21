
# Chapter 3

* About processes' life (from create to die.)

## The process

* They also include a set of resources such as open file and pending
  signals internal kernel data, processor state, a memory address space
  with one or more memory mappings, one or more threads of execution,
  a data section containing global variables
* Kernel manage all these details 

* Thread is the object of activity within the process
    * it includes a unique program counter
    * program stack
    * set of processor registers
* Process has multi threads
* To linux, a thread is just a special kind of process.

* Create
    * **fork()** system call.
        * duplicating exist one
        * **fork()** is implemented via the **clone()**
        * if parent process lives longer than child process,
          the child process could be zombe state untill parent call wait()
* Change
    * **exec()**
* Finish
    * **exit()**


## Process Descriptor and the task structure

* the list of processes is in a circular doubly linked list called
  **task list**
* Process Descrioptor has the type of **struct task_struct**

* Allocating Process Descriptor
    * slab allocator
        * object reuse
        * caching color
        * dynamically created via the slab allocator, a new structure
          **struct thread_info**
            * 사진 첨부 필요
        * thread_info structure is allocated *at the end of its stack*

* Storing the Process Descriptor
    * process descrioptor has the PID.
    * current_thread_info()
        * it returns thread_info structure pointer
        * need to access fastly


## Process State



