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

---

## misc

* Bzip2 is better performance than gzip
