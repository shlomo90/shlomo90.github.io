---
layout: post
tags: python epochtime
comments: true
---

# Python Epoch Time

* "Epoch time" is also called "Unix time".
    * See [Unix time wiki](https://en.wikipedia.org/wiki/Unix_time)

## Python code example

* python2.7

```python
import datetime

t = (datetime.datetime.now() - datetime.datetime(1970,1,1)).total_seconds()
print t
```

* Python3

```python
import datetime

t = datetime.datetime.now().timestamp()
print t
```
