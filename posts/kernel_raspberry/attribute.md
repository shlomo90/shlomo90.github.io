---
layout: post
comments: true
---

# Attributes

---

## ____cacheline_aligned

* Define

```c
#define SMP_CACHE_BYTES L1_CACHE_BYTES

#define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
```

* Effects
	1. gcc 가 compile 시 SMP CACHE (L1_CACHE_BYTES) 에 맞게 alignment 를 맞춰줌으로 성능 향상.
