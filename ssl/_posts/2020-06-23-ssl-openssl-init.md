---
layout: post
tags: openssl code init
title: OPENSSL Init
comments: true
---

# OPENSSL Init

---

* process
  1. `SSL_CTX_new`
    * Create SSL_CTX structure (It's base)
  2. `SSL_CTX_*`
    * Some callback functions
    * Set the ex data.
      * Call `CRYPTO_set_ex_data`

## `STACK_OF`

* file : `include/openssl/safestack.h`
* define

```c
# define STACK_OF(type) struct stack_st_##type
```

* example

```c
struct crypto_ex_data_st {
    STACK_OF(void) *sk;
};
DEFINE_STACK_OF(void)
```

### `DEFINE_STACK_OF(t1)`

* It generates below functions and function pointers

```c
STACK_OF(t1); \
typedef int (*sk_##t1##_compfunc)(const t1 * const *a, const t1 *const *b); \
typedef void (*sk_##t1##_freefunc)(t1 *a); \
typedef t1 * (*sk_##t1##_copyfunc)(const t1 *a); \
static ossl_unused ossl_inline int sk_##t1##_num(const STACK_OF(t1) *sk) \
{ \
    return OPENSSL_sk_num((const OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_value(const STACK_OF(t1) *sk, int idx) \
{ \
    return (t1 *)OPENSSL_sk_value((const OPENSSL_STACK *)sk, idx); \
} \
static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new(sk_##t1##_compfunc compare) \
{ \
    return (STACK_OF(t1) *)OPENSSL_sk_new((OPENSSL_sk_compfunc)compare); \
} \
static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_null(void) \
{ \
    return (STACK_OF(t1) *)OPENSSL_sk_new_null(); \
} \
static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_reserve(sk_##t1##_compfunc compare, int n) \
{ \
    return (STACK_OF(t1) *)OPENSSL_sk_new_reserve((OPENSSL_sk_compfunc)compare, n); \
} \
static ossl_unused ossl_inline int sk_##t1##_reserve(STACK_OF(t1) *sk, int n) \
{ \
    return OPENSSL_sk_reserve((OPENSSL_STACK *)sk, n); \
} \
static ossl_unused ossl_inline void sk_##t1##_free(STACK_OF(t1) *sk) \
{ \
    OPENSSL_sk_free((OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline void sk_##t1##_zero(STACK_OF(t1) *sk) \
{ \
    OPENSSL_sk_zero((OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_delete(STACK_OF(t1) *sk, int i) \
{ \
    return (t1 *)OPENSSL_sk_delete((OPENSSL_STACK *)sk, i); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_delete_ptr(STACK_OF(t1) *sk, t1 *ptr) \
{ \
    return (t1 *)OPENSSL_sk_delete_ptr((OPENSSL_STACK *)sk, \
                                       (const void *)ptr); \
} \
static ossl_unused ossl_inline int sk_##t1##_push(STACK_OF(t1) *sk, t1 *ptr) \
{ \
    return OPENSSL_sk_push((OPENSSL_STACK *)sk, (const void *)ptr); \
} \
static ossl_unused ossl_inline int sk_##t1##_unshift(STACK_OF(t1) *sk, t1 *ptr) \
{ \
    return OPENSSL_sk_unshift((OPENSSL_STACK *)sk, (const void *)ptr); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_pop(STACK_OF(t1) *sk) \
{ \
    return (t1 *)OPENSSL_sk_pop((OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_shift(STACK_OF(t1) *sk) \
{ \
    return (t1 *)OPENSSL_sk_shift((OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline void sk_##t1##_pop_free(STACK_OF(t1) *sk, sk_##t1##_freefunc freefunc) \
{ \
    OPENSSL_sk_pop_free((OPENSSL_STACK *)sk, (OPENSSL_sk_freefunc)freefunc); \
} \
static ossl_unused ossl_inline int sk_##t1##_insert(STACK_OF(t1) *sk, t1 *ptr, int idx) \
{ \
    return OPENSSL_sk_insert((OPENSSL_STACK *)sk, (const void *)ptr, idx); \
} \
static ossl_unused ossl_inline t1 *sk_##t1##_set(STACK_OF(t1) *sk, int idx, t1 *ptr) \
{ \
    return (t1 *)OPENSSL_sk_set((OPENSSL_STACK *)sk, idx, (const void *)ptr); \
} \
static ossl_unused ossl_inline int sk_##t1##_find(STACK_OF(t1) *sk, t1 *ptr) \
{ \
    return OPENSSL_sk_find((OPENSSL_STACK *)sk, (const void *)ptr); \
} \
static ossl_unused ossl_inline int sk_##t1##_find_ex(STACK_OF(t1) *sk, t1 *ptr) \
{ \
    return OPENSSL_sk_find_ex((OPENSSL_STACK *)sk, (const void *)ptr); \
} \
static ossl_unused ossl_inline void sk_##t1##_sort(STACK_OF(t1) *sk) \
{ \
    OPENSSL_sk_sort((OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline int sk_##t1##_is_sorted(const STACK_OF(t1) *sk) \
{ \
    return OPENSSL_sk_is_sorted((const OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline STACK_OF(t1) * sk_##t1##_dup(const STACK_OF(t1) *sk) \
{ \
    return (STACK_OF(t1) *)OPENSSL_sk_dup((const OPENSSL_STACK *)sk); \
} \
static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_deep_copy(const STACK_OF(t1) *sk, \
                                                sk_##t1##_copyfunc copyfunc, \
                                                sk_##t1##_freefunc freefunc) \
{ \
    return (STACK_OF(t1) *)OPENSSL_sk_deep_copy((const OPENSSL_STACK *)sk, \
                                        (OPENSSL_sk_copyfunc)copyfunc, \
                                        (OPENSSL_sk_freefunc)freefunc); \
} \
static ossl_unused ossl_inline sk_##t1##_compfunc sk_##t1##_set_cmp_func(STACK_OF(t1) *sk, sk_##t1##_compfunc compare) \
{ \
    return (sk_##t1##_compfunc)OPENSSL_sk_set_cmp_func((OPENSSL_STACK *)sk, (OPENSSL_sk_compfunc)compare); \
}
```

* if `t1` is `void`, it generates
    * `sk_void_value`
        * it calls `OPENSSL_sk_new((OPENSSL_sk_comfunc)compare);`
    * `sk_void_num`
    * etc. 


### `sk_reserve(OPENSSL_STACK *st, int n, int exact)`

* internal STACK storage allocation (`st->data`)
* return value
    * `0`: Allocation fail or not match `st->data` and `st->num_alloc`.
    * `1`: It is reserved. You can do insert or append whatever. it has area to save something.
* reserve (allocate) nth `(void *)` memory at `st->data`
* update `st->num_alloc` (= `st->num + n`)
* exact set 1, return `1` only required the number of alloc memory matches exactly `st->num_alloc`. otherwise realloc.
* exact set 0, return `1` only required the number of alloc memory equal or less than `st->num_alloc`. otherwise realloc.


### `OPENSSL_sk_*`

* file : `crypto/stack/stack.c`


#### `OPENSSL_sk_new_reserve`

* Alloc *stack_st* structure with `sk_reserve`, initialize and return it.

```c
struct stack_st {
    int num;            //<-- the number of data in use (stack)
    const void **data;  //<-- data stack
    int sorted;
    int num_alloc;      //<-- allocated number of type in memory 
    OPENSSL_sk_compfunc comp;
};
```

### `OPENSSL_sk_reserve`

* Check `st` is not NULL.
* call `sk_reserve(st, n, 1)`

### `OPENSSL_sk_insert(OPENSSL_STACK *st, const void *data, int loc)`

* check the `st` is available (`st->data` has empty space)
* return `st->num` after updated.
* insert the `data` at `loc` index.
    * if data is already occupied at `loc`, each item is moved to next.
* if loc is less than zero or upper than `st->num`, just append data item.
* update `st->num`, `st->sorted`
