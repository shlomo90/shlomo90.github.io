<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# functools

## wraps

* It's a decorator to wrap the specific function.
* Usage

```python
>>> def main_function():
...     print "This is main function"
...
>>>
>>>
>>> @wraps(main_function)
... def wrapper_function(*args, **kwargs):
...     print "wrapper"
...     return main_function(*args, **kwargs)
...
>>>
>>>
>>> main_function
<function main_function at 0x7fd78c95d9b0>
>>> main_function()
This is main function
>>> wrapper_functino
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'wrapper_functino' is not defined
>>> wrapper_function
<function main_function at 0x7fd78c95da28>      #<--- the function name is not wrapper_function
>>> wrapper_function()                          #     It's main_function.
wrapper
This is main function
>>>
```

* This is convenience function for invoking update_wrapper() as a function decorator when defining a wrapper function.

## lru_cache

* It's a decorator to wrap a function with a memorizing callable that saves up to the maxsize most recent calls.
* It' can save the time when an expensive or I/O bound function is periodically called with the same arguements.
* Usage

```python
from functools import lru_cache
import sys


@lru_cache(maxsize=128)
def work_lru():
    with open("./test.txt", 'r') as f:
        data = f.read()
    return data


def work_no_lru():
    with open("./test.txt", 'r') as f:
        data = f.read()
    return data


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("argv!")
        exit(1)

    if sys.argv[1] == 'lru':
        use_lru_cache = True
    else:
        use_lru_cache = False

    for i in range(0, 1000000):
        if use_lru_cache is True:
            work_lru()
        else:
            work_no_lru()

```
    * Simply, run this code and check the elapsed time.
