**Make file**
=

- Setting Variable
    - `:=`
        ```
        x := foo
        ```
    - `=`
        - It's the same
    -  `?=`
       ```
       x := 10
       x ?= 30
       x is 10
       ```
       - only if the variable is not set.
    - `+=`
       - Add text
       
- Pattern-specific Variable Value
    ```
    pattern ... : override variable-assignment
    ```
    ```
    %.o : CFLAGS = -O
    ```
    - 패턴 %.o 와 일치하는 모든 타겟에 대해서 -O CFLAGS 값으로 할당