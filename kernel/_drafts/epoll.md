---
layout: post
tags: kernel programming
title: kernel understanding epoll
comments: true
---

# What is the `epoll`?

* The `epoll` is a linux kernel system call for a scalable I/O event notification
* `epoll` operates `O(1)` time. but `select`, `poll` are `O(n)`.
  * `epoll` is better performance.
* `epoll` uses `RBTree`.

---

## Understanding `epoll` at kernel code

* Before understanding `epoll` system call. 


* In *sys_ni.c* file, 

```c
// ... snipped ... 

COND_SYSCALL(epoll_wait);

// ... snipped ... 
```

```c
#define cond_syscall(x)  asm(".weak\t" #x "\n" #x " = sys_ni_syscall")

/*-------------------------linux/kernel/sys_ni.--------------------------------*/
/*
 * Non-implemented system calls get redirected here.
 */
asmlinkage long sys_ni_syscall(void)
{
    return -ENOSYS;
}

```

* `cond_syscall(x)` means check the symbol "x" is defined. if not, mapping the
  `sys_ni_syscall` which error code returns `ENOSYS`.
  * `ENOSYS` : Function is not implemented
  * See the *asm* file.
