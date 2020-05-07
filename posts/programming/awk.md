---
layout: post
comments: true
---

# Awk

## Purpose

* is to search files for lines.
* is a data driven.
* it can be used as self-contained program or interactive program.
    * "self-contained program" means that awk file (i.e. a.awk) itself can be a execute file.
    * "interactive program" means that you can get the result after inputing.


## program format

```bash
awk 'program' input-file1 input-file2 ...
```

## Case study

### awk 'BEGIN { print "hello\47  world!" }'

* `BEGIN` is one of the statements. (without this awk would be stopped instead of trying to read input.
* `\47` is a single quote. it is used for avoiding ugly shell quoting.

### awk '{ print }'

* it just acts like `cat` program.

### Using -f option

* You can write the program into a file you named and load it with `-f` options.

* file 'advice.awk'
    * awk's extension is '.awk'

```awk
BEGIN { print "Don't panic!" }
```

* command

```bash
awk -f ./advice.awk
```

### Executable awk program

* awk file can be executable file using `#!` script mechanism.

* file 'advice_exec.awk'

```awk
#! /bin/awk -f

BEGIN { print "Don't panic!" }
```

* You need to grant the permission and executable with `chmod` command.

```bash
chmod 755 ./advice_exec.awk
```

* Understanding using `#!`
    * Don't put arguments more than one after full name
        * `#! /bin/awk -f -a -b -c`
        * It can take just one arguement.
    * System limit length of interpreter name to 32 chracters
        * It can be dealt with symbolic link.


### Comment awk program

* You can make comment sentenses with `#`.
* But, DON'T PUT APOSTROPHE IN COMMENTS
    * `awk -f something # Let's be cute'`


### Quote issues

* You can use single quote or double quotes in many cases.
* Also, In the cases, you need to escape them (",',$,...)
* The Best things to avoid this cases are below
    1. Use octal escape sequences and put comments nicely
    2. Use command line variables
* I think taking the number 2 is better than the other one.


### Terminology

* 'null string' it has no characters. it's the same term with 'empty string'.
