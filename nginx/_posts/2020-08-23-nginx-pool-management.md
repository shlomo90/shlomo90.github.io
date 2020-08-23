---
layout: post
tags: nginx programming
title: Nginx Pool Management
comments: true
---

# Nginx Pool

---

## Why does Nginx use Pool?

* Good Performance
  * Reduce the cost of memory allocation (large size memory allocated once)
* Make coding easy
  * Not too much worry about memory leaking or double free memory.
  * Allocation once and Free once.

## *ngx_pool_t* structure

![Alt text](/pics/nginx/create_pool.png)

* *ngx_pool_t* controls the allocated memory for Packets or Configuration settings.
* It has pointers to know how much memory allocated and how much memory left.
* If a pool needs more memory area, create another pool that is linked to previous pool (See Below)

![Alt text](/pics/nginx/allocate_pool.png)
