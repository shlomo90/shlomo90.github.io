
# go basic

---

## Function Prototype

```go
func Print(a ...interface{}) (n int, err error)
```

* Function "print" parameters
  * a
    * variable to be printed
  * interface{}
    * I don't know yet.


## New features

* `:=`
  * Declare a temporary variable
  * No need to define type (Maybe depends on function's return type)
  * **This only works in function scope**

## Issues

* Global variable assignment
  * Different with "C" language, golan doesn't allow a global variable
    to assign a value.
  * So, you can use *init* function that is called when the program starts
    to assign global variables.

## map

* It works like a dictionary in python.

```go
dic := make(map[string]int)
```

* `make` can be used only for `map`.
* dic has `key-value` map.
  * key type is string.
  * value type is integer.
