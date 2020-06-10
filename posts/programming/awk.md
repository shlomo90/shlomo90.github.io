---
layout: post
comments: true
---

# Awk

---

## Introduction

* Awk is to search files for lines.
* Awk is a data driven.
* Awk can be used as self-contained program or interactive program.
  * "self-contained program" means that awk file (i.e. a.awk) itself can be a execute file.
  * "interactive program" means that you can get the result after inputing.

---

## Awk Basic Things 

Explain the basic things of Awk.

### Execute Awk 

```bash
awk 'program' input-file1 input-file2 ...
```

We well see what consists of the 'program' below.

### Executable awk program

Awk file can be executable file using `#!` script mechanism.

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

Or, you can read the awk file with -f option.

* file 'advice.awk'
  * awk's extension is '.awk'

```awk
BEGIN { print "Don't panic!" }
```

* command

```bash
awk -f ./advice.awk
```

### BEGIN, END Rules

* **BEGIN**
  * It is an action statement before any input lines read.
* **END**
  * It is an action statement after all input lines read.

### Awk speical variables

* They are awk special variables.
* **NR**
  * It's a variable for current read line number.
* **NF**
  * It's a variable for total number of the field.
* **OFS**
  * It's Output Field Separtor. This special variable is usually in BEGIN Rule.
  * you can set a separator character to OFS. It will print each field with the character. 
  * *printf* has no effect this.
* **ORS**
  * It's Output Record Separator. This special variable is usually in BEGIN Rule.
  * You can set a separator character to ORS. After Awk prints all field on the line,
    The ORS character will show up.
  * *printf* has no effect this.
* **OFMT**
  * IT's Output Format Specification variable.
  * The default value is "%.6g".
  * The integers in print function argument will be affected not string.

Here is the example.

```
ll | awk '{print NR}'
```

* The input is current paths' files and directories list.
* _awk_ read each input line and print the line number.

```
ll | awk 'END {print NR}'
```
* It's the same with the above but, it prints the total line of the input.

```
ll | awk '{ if (NF == 2) print "Its first line"; else printf "this line field %d\n", NF; } \
          BEGIN { printf "This program starts\n" } \
          END { printf "This program done\n" } '
```

* This program will print "This program starts" at the first line because of the "BEGIN".
* and Each line will process the if conditionals and print the results.
* Finally, after read all input lines, print "This program done".

### Awk Redirect

* not written.

---

## Case study

### awk 'BEGIN { print "hello\47  world!" }'

* `BEGIN` is one of the statements. (without this awk would be stopped instead of trying to read input.
* `\47` is a single quote. it is used for avoiding ugly shell quoting.

### awk '{ print }'

* it just acts like `cat` program.


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
