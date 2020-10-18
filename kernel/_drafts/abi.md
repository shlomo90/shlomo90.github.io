---
layout: post
tags: kernel programming
title: kernel understanding abi
comments: true
---

# ABI (Application Binary Interface)

---

## What is the ABI?

* It's an interface between two binary program modules;
  * Library and kernel vs User level application.


## Why Does ABI need?

* Kernel (OS) and User Level Application are binary programs.
* They have a same environment to be run together. That's why ABI is needed.
* When the compiler builds source codes, they consider system's ABI and output the
  binary files that is dependent the hardware.
  * compilers can build the source files according to another hardware dependent
    (See "Cross Compile")
* intel has their ABI **IBCS**
  * iBCS (intel Binary Compatibility Standard)
    * it standardized an Unix operating system on intel-386-compatible.
