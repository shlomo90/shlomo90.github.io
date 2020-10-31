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
