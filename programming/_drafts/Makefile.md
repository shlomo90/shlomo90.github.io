# Make file

## Built-in Variables

* `$(MAKE)`
    * Usually `/bin/make`
    * you can override the variable.
* `$(CC)`
    * Usually `cc`
    * you can override the variable.


## How to debug the variable value?

* Here is the solution
    * Command
        ```
        $(info $$MAKE is [${MAKE}])
        ```
    * Result
        ```
        $MAKE is [make]
        ```

## How to assign the variable?

* recursively expanded variable
    * using `=` 
        ```make
        foo = $(bar) -o
        bar = $(ugh) -t
        ugh = Huh?

        all:
            echo $(foo)

        #result

        Huh? -t -o
        ```
    * Make Makefile simpler

* simply expanded variable
    * using `:=`, `::=`
        ```make
        x := foo
        y := $(x) bar
        x := later

        is 

        y := foo bar
        x := later
        ```
    * intuitive but, make Makefile more complex.
* conditional expanded variable
    * using `?=`
    * It assigns a value only if current variable is never assigned at all.


## If/else if/else in Makefile

* `ifeq (var1, var2)`
    * if var1 and var2 is same, do below code
    * var2 could be empty string like `ifeq (var1,)`


## Special Prefix Characters

* `@`
    * Suppresses the normal 'echo' of the command that is executed.
* `-`
    * Ignore the exit status of the command that is executed
    * Non-zero exit status would stop the part of the build.
* `+`
    * usually used in `-n`, `-q` mode. It actually executes the command that
      has prefix `+`.


## What is the PHONY?

* Meaning
    * It's a special target that is not a file name.
      (The implicit rule search is skipped for .PHONY targets)
    * PHONY doesn't consider the target as a file. (target always executed)
* Why use?
    * To avoid a conflict with a file of the same name.


* See this Makefile

```make
clean:
    rm *.o temp
```

* `clean` target has no prerequisite, and `rm` doesn't make "clean" file.
* If there is a file named "clean" as a prerequisite, The target "clean" won't work well
    * Because "clean" is always considered up to date.


## Makefile Variables

* `$@`
    * The file name of target rule.
* `$<`
    * The name of first prerequisite.
* `$?`
    * The name of all prerequisites that are newer than the target.
* `$%`
    * The name of target member.
