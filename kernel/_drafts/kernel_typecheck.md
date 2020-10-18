# Kernel The way of checking type

.

## typecheck function

* source code
```c
/*
 * Check at compile time that something is of a particular type.
 * Always evaluates to 1 so you may use it easily in comparisons.
 */

#define typecheck(type,x) \
({  type __dummy; \
    typeof(x) __dummy2; \
    (void)(&__dummy == &__dummy2); \
    1; \
})
```

* features
    * It checks compile time not a running time.
    * It alwasy returns 1.
