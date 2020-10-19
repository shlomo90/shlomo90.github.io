---
layout: post
tags: kernel lock rst spinlock
comments: true
---

# Kernel Lock

* About kernel lock systems

## 1. Kernel spinlock

* It's global lock.
* Using more than one spinlock causes performance down
  (Use it when you know needs).
* Spinlock protects the shared data structure everywhere they are used.

```c
static DEFINE_SPINLOCK(xxx_lock);

  unsigned long flags;

  spin_lock_irqsave(&xxx_lock, flags);
  ... critical section here ..
  spin_unlock_irqrestore(&xxx_lock, flags);
```

## 2. Kernel Reader-Writer-Lock

* Read Lock 
    * one thread requires the Read Lock to read some critical section. (e.g., linked list)
    * multiple requirement of Read lock is okay but, if one write lock is required and after other
      Read Locks are required, they are blocked. (to prevent from starvation of write lock)
* Write Lock
    * It requires the Write Lock to change something in critical section.
    * All Read Lock requirements are blocked if current Write Lock is working.


## 3. Dead Lock

* When spinlock revisited and lock-holder and lock-caller is on the same CPU. It could be deadlock.
    * That's why irq-version spinlock disables _local_ interrupt.
    * Maybe, _local_ means same cpu?
