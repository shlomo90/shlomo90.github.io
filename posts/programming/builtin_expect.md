---
layout: post
comments: true
---

# GCC builtin expect

---

## __builtin_expect (long exp, long c)

* to provide the compiler with branch prediction information.
* You should prefer to use actual profile feedback for this (-fprofile-arcs)

```c
if (__builtin_expect (x, 0))
    foo ();
```

* We expect x to be zero.
* You are limited to use integral exp

```c
if (__builtin_expect (ptr != NULL, 1))
    foo (*ptr)
```

* It's one of the GCC built-in functions.
* `builtin-expect-brobability` default 90%.
    * or you can use `__builtin_expect_with_probability` to explicitly assign a probabiltiy value



https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#index-g_t_005f_005fbuiltin_005fexpect-4159
