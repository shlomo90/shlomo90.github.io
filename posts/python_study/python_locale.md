<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Python locale

---

* The local module opens access to the POSIX locale database and functionality.

## locale wiki

* a locale is a set of parameters that defines the user's language, region and any special variant preferences that the user wants to see in their user interface.

### General locale settings

* Number format setting
* Character classification, case conversion settings
* Date-time format setting
* String collation setting
* Currency format setting
* Paper size setting
* Color setting
* other minor settings

## python locale module

```python
>>> import locale
>>> a = locale.localeconv()
>>> a['p_sign_posn']
```

* `p_sign_posn`
    * `value 0 :` Currency and value are surrounded py parentheses.
    * `value 1 :` The sign should precede the value and currency.
    * `value 2 :` The sign should follow the value and currency symbol.

### LC_COLLATE: collation

* `LC_COLLATE` value can be the result of `locale -a`.
* Example, `C`, `en_US.UTF-8`.
