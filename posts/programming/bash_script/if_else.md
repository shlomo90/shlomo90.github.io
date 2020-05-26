---
layout: post
comments: true
---

# Bash Script Language

---

## if statement

* Basic if statement Form (in file)

```bash
if [ $# == 1 ]; then
    #Something Code
fi

```

* Basic if statement Form (in command line)

```bash
cmd$ if [ 1 == 1 ]; then <Something Code>; fi
```

### Square Bracket in if statement

The single bracket `[]` is another expression of `test` command. You can check the manual page `man test`.
This command is for **comparing values** and **checking the file types**. Let's figure out that how
to use the single bracket and what the differences between double square brackets `[[]]` and single square
bracket.  

Major Evaluation of the command (or Usage)
* File check
* String compare
* Arithmetic tests (equal, greater than, etc.)

#### File check

I am gonna arrange the file operators that I usually frequently use.

`-a FILE` or `-e FILE`
* True if file exists.

```
[hwan@jh bash_script]$ ls
if_else.md
[hwan@jh bash_script]$ [ -a "./if_else.md" ] && echo "True"
True
[hwan@jh bash_script]$
```

`-f FILE`
* True if file exists and is a regular file.

```
[hwan@jh bash_script]$ [ -f "./if_else.md" ] && echo "True"
True
[hwan@jh bash_script]$ 
```

`-d FILE`
* True if file is a directory.

```[hwan@jh bash_script]$ ll
total 28
drwxrwxr-x.  3 hwan hwan  4096 May 21 12:35 ./
drwxrwxr-x. 13 hwan hwan  4096 May 20 14:54 ../
-rw-rw-r--.  1 hwan hwan  1417 May 21 12:35 if_else.md
-rw-r--r--.  1 hwan hwan 12288 May 21 12:35 .if_else.md.swp
drwxrwxr-x.  2 hwan hwan  4096 May 21 12:35 test/
[hwan@jh bash_script]$ [ -d "./test" ] && echo "True"
True
```

#### String compare

`-z STRING`
* True if string is empty.

```
[hwan@jh bash_script]$ [ -z "" ] && echo "True"
True
[hwan@jh bash_script]$ [ -z "s" ] && echo "True"
[hwan@jh bash_script]$ 
```
* `-n` is the opposite command.

`STRING1 = STRING2`
* True if the strings are equal
`STRING1 != STRING2`
* True if the strings are not equal
`STRING1 < STRING2`
* True if the STRING1 sorts before STRING2 lexicographically.
`STRING1 > STRING2`
* True if the STRING2 sorts before STRING1 lexicographically.

#### Arithmetic test

`-eq`
* The integers are equal
`-ne`
* The integers are not equal
`-lt`
* The first integer is less than the second integer.
`-le`
* The first integer is less than or equal the second integer.
`-gt`
* The first integer is greater than the second integer.
`-ge`
* The first integer is greater than or equal the second integer.


#### Double square brackets

First, Have a look at this code block. You may notice what's differences.

```
[hwan@jh bash_script]$ [ 2 > 3 ] && echo "True"
True
[hwan@jh bash_script]$ [[ 2 > 3 ]] && echo "True"
[hwan@jh bash_script]$
```

The first one, Bash built-in `test` command, doesn't evaluate well for `<`, `>`, etc. If you want use them,
you should use the `[[ ]]`. Another problem is `[[ ]]` is not compatible (other shells may not support).  
[Here is the summary of the differences](http://mywiki.wooledge.org/BashFAQ/031). It's helpful.


#### Reference

* [Man page of test](http://linuxcommand.org/lc3_man_pages/testh.html)
