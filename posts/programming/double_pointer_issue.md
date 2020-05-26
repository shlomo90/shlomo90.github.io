---
layout: post
title: Code
comments: false
---

# Single Pointer vs Double Pointer

There are many ways of using array of structure. I am going to show what differences between
double pointer and single pointer for array.  
For test code, I am using 64bit computer and notice the size of pointer is 8 bytes.
Let's See the below.

```
1. Using Single Pointer

struct foo {
    int * test1;
    int * test2;
};

struct foo *t;
t = malloc(sizeof(struct foo) * 7);

0xaa0  +------------------+  <--- t[0]
       |int * test1       |  <--- t[0].test1
       |int * test2       |  <--- t[0].test2
0xab0  +------------------+  <--- t[1]
       |                  |
       |                  |
       +------------------+
       |                  |
       |                  |

       ...
       +------------------+
       |                  |
       |                  |
       +------------------+


2. Using Double Pointer

struct foo {
    int * test1;
    int * test2;
};

struct foo **t;
t = malloc(sizeof(struct foo*) * 7);

for (i=0; i<7; i++) {
    t[i] = malloc(sizeof(struct foo));
}

0xaa0  +------------------+ <--- t[0]
       |struct foo *      |---------> +-------------------+ 0xbb0
0xaa8  +------------------+ <--- t[1] |int * test1        |
       |struct foo *      |           |int * test2        |
0xab0  +------------------+ <--- t[2] +-------------------+
       |struct foo *      |---------> +-------------------+ 0xcc0
0xab8  +------------------+           |                   |
       |                  |           |                   |
                                      +-------------------+
                                      |                   |
       ...                            |                   |
       |                  |           +-------------------+
       |                  |
       +------------------+
       |                  |
       |                  |
       +------------------+
```

Before you decide which one to use, You should consider your data structure.
If the array size is fixed and no changed, The first one is better performance.
In the other hands, If you need not fixed size, the second one is good for you.  
It really depends on data structure you need. In addition, Memory fragments would be
not ignorable.
