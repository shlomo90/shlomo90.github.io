# Getting Started with the kernel

---

## Where to install and hack on the source

* The kernel source is typically installed in /usr/src/linux
    * you should not use this source tree for development because
      the kernel version against which your C library is compiled is often
      linked to this tree
    * you should not require root to make changes to the kernel
    * work out of your home directory and use root only to install new
      kernel


## Kernel Source Tree

* Need to know the meaning

```
arch			Architecture-specific source
block			Block I/O layer
crypto			Crypto API
Documentation	Kernel source documentation
drivers			Device drivers
firmware		Device firmware needed to use certain drivers
fs			    The VFS and the individual filesystems
include			Kernel headers
init			Kernel boot and initialization
ipc			    Interprocess communication code
kernel			Core subsystems, such as the scheduler
lib			    Helper routines
mm			    Memory management subsystem and the VM
net			    Networking subsystem
samples			Sample, demonstrative code
scripts			Scripts used to build the kernel
security		Linux Security Module
sound			Sound subsystem
usr			    Early user-space code (called initramfs)
tools			Tools helpful for developing Linux
virt			Virtualization infrastructure
```

## Configuring the kernel

* Kernel has many functions, You should select what you want.

```
make gconfig
```

* After that, The configuration options are stored in *root of kernel
  source tree in a file name .config*

* to validate current configurations and update do this
    ```
    make oldconfig
    ```

    * You should always run this befor building a kernel
    * It save kernel configuration at `/proc/config.gz`
    * Restore
        ```
        zcat /proc/config.gz > .config
        make oldconfig
        ```


* Let's build
    ```
    make
    or
    make -j4 #<-- use Multi cores 

    make modules_install
    ````

    * compiled modules goes to */lib/modules*
    * *System.map* in the root of the kernel source tree
        * symbol lookup table, mapping kernel symbols to their start
          address 

## A Beast of a Different Nature

* The kernel has access to neither the C Lib and standard C Headers
    * Because of Performance
* The kernel is conded in GNU C
    * GNU C has many extensions
    * inline functions
        * Use only small time-critical functions (copy every call site) 
        * Common practice is to place inline functions in header files
            * if it's used by only one file, placed the top of the file.
        * **inline function is preferred over complicated macros for
          reason of type safety and readability**
    * inline Assembly
        * use **asm()**
    * Branch Annotation
        * **unlikely()** : this branch as very unlikely taken
        * **likely()**
        * Use this for performance boost
* The kernel lacks the memory protections affored to user-space
    * if kernel attempts an illegal memory access (IDK...)
    * Additinonally, kernel memory is not pageable. Therefore, Every byte
      of memory you consume is one less byte of available physical memory
* The kernel, use of floating point is not easy
    * Kernel is hard to trap itself, so, it needs to save value and restoring the floating point registers
    * Don't do it
* The kernel has fixed stack size
    * kernel stack is neither large nor dynamic; it's small and fixed in
      in size 
    * It's configurable at compile-time (4~8KB) usually two pages


## Synchronization and Concurrency

* The kernel is susceptible to race conditions.
* Linux is a preemptive multitasking OS
* Linux supports SMP, two or more processors can concurrently access the
  same resource
* Linux is preemptive.
    * kernel code can be preempted in favor of different code that then
      accesses the same resource 
* Race conditions
    * solutions: Spinlock and Sepmaphore
* Portability is important

## Importance of portability

* Architecture independent C code must correctly compile and run on a
  wide range of systems and Architecture dependent code must be segregated
 in system-specific directories 
    * Do not assume the word or page size 

---

## misc

* Bzip2 is better performance than gzip

