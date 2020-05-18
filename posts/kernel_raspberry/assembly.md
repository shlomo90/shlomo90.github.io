---
layout: post
comments: true
---

# Kernel Assemply

---

## .rept

* Repeat the sequence of lines between the .rept directive and the next .endr directive count times.


## .long 


## _asm()_ in c language

* Simple Example of asm in c.

```c
#include <stdio.h>

int main(int argc, char* argv[])
{
    int src = 1;
    int dst;

    // "\n\t" 는 개행 문자. 마지막 전에는 붙혀주자.
    // %0 is output operand referred by dst.
    // %1 is input operand referred by src.
    // "=r" means that write only and use any register.
    //      '=' means write only.
    //      'r' say to gcc to use any register for storing operand

    // this assembly is add the
    asm ("mov %1, %0\n\t"
         "add %1, %0"
         : "=r" (dst)
         : "r" (src));

    printf("dst: %d, src: %d\n", dst, src);
    return 0;
}
```
