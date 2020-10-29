---
layout: post
tags: programming c incomplete struct declare
comments: true
---


# Declare incomplete structure and using `typedef`

* Sometimes, we are exploring the Linux Kernel code, We see the many
  unfamilar things like declaring "incomplete structure" or `typedef`
* Let's dig into them more details

## Incomplete Structure

* The GCC Compiler allows us to declare an incomplete structure
    * Why? When compiler is reading code and find undefined symbols,
      It throws an error and stoping building. In code flow, We need
      just declare the struct and defined later.

* How to use?
    ```c
    struct test;            //<-- 2. It needs to be declared first

    struct foo {
        struct test *t;     //<-- 1. I need to use the "struct test"
    }
    ```


## `typedef` structure In C

* Why need?
    * it's clear! Make the code simpler.

```c
typedef struct test_s test_t;       //<-- "struct test_s" is declared incompletely
                                    //    and changed structure name as "test_t"
                                    //    Structure name is now shorter.

typedef int (*test_handler_ptr)(test_t *);  //<-- Also, It can apply for
                                            //    function pointer.

#if 0

struct {
    test_t              *next;
    test_handler_ptr     handler;
}test_s;

#elif 1

struct test_s {
    test_t              *next;
    test_handler_ptr     handler;
};

#else

struct test_s {
    struct test_s *next;
    int          (*handler)(struct test_s *);
};

#endif

int main(int argc, char* argv[])
{
    return 0;
}
```
