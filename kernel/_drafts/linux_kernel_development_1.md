

# Linux kernel development chapter 1

---

* liberally apply comentary to the code
* Developers can gain that essential view of what services the kernel
  subsystems are supposed to provide, and of how they set about 
  providing them
* The best way to understand a part of the kernel is to make changes
  to it.

* You need to dig in and change some code. Find a bug and fix it.
  Improve the drivers for your hardware.


## Unix

* Unix systems implement only hundred of system calls
* Unix, everything is a file
    * open, read, write, lseek, close
    * Sockets are a notable exception.
* Unix has fast process creation time and the unique fork system call 
* do one thing and do it well


## What is os?

* includes
    * kernel
    * device drivers
    * boot loader
    * command shell
    * other user interface
    * basic file and system utilities

* Typical components of a kernel are
    * interrupt handlers to service interrupt requests
    * scheduler to share processor time among multiple processes
    * memory management system to manage process address spaces
    * system services such as networking and interprocess communication.


## Kernel memeory

* kernel memory is protected memory space (kernel space)


## Communication with kernel and user

* via system calls
* C library rely on the system call interface to instruct the kernel to
  carry out tasks on the application's behalf
    * printf: call "write" to write the data to the console
    * open : just do open() system call

* executes a system call
    * kernel is running in process context
    * executing a system call in kernel-space


## interrupt

* when hardware wants to communicate with the system
* it issues an interrupt that literally interrupts the processor.
* A number identifies interrupts and the kernel uses this number to
  execute a specific *interrupt handler* to process and respond to the
  interrupt
* To provide synchronization, the kernel can disable interrupts either all
  interrupts or just one specific interrupt number.
    * interrupt handlers do not run in a process context. instead they run
      special *interrupt context*.


### Monolithic

* One large image file
* linux is Hybrid!
    * dynamically load separate binaries (kernel moduels)
* everything runs in kernel mode

### Microkernel

* It has many servers (kernel is broken down into separate processes)
* Use IPC mechanism
    * high cost than trivial function call


### What's difference btw unix & linux

* dynamic kernel loadable
* SMP support
* preemptive
* thread support(?)
* provides oop model with device classes 
*
