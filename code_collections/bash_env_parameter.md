---
layout: post
title: Code
comments: true
---

# Getting user defined enviroment parameter variables 

---

This is a simple bash script code.

```bash
#!/bin/bash

# Parsing the lowercase variable.
# the uppercase variables are reserved in system (like PATH, etc.)
# There is a naming convention for using lowercase your own variables.
ret=$(export | sed -e 's/declare -x//' \
             | sed -e 's/\([a-zA-Z0-9_]\+\)=/\1 /' \
             | awk '{ if ($1 != toupper($1)) print $1}')

for i in $ret
do
    if [ $i = "param" ]; then #<-- you can define the parameter variables
        #echo $param          #    to get a value.
        :
    fi
done

default="hello my name"
test=${param:-$default}
echo $test
```
