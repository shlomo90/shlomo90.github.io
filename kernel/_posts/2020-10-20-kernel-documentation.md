---
layout: post
tags: kernel doc rst
comments: true
---

# Kernel Documentation

* Why reading kernel documentation?
    * To get the basic knowledge of kernel (hint?)


## ReStructureText (.rst extension) Understanding

* Kernel Documentation uses RST extension files to convert to HTML or
  Other formatted text.
* `sphinx`: help making documentations


### RST Syntax

* Common Things
    * No more 80 characters in each line.


* Sections
    * Document title
        * overline and underline
        * shown as centered heading
    * Document Section
        * underline
        * shown as lefted heading
    * Special Characters
        * Usually characters `=`, `-`, `~` used in hierarchy.
        * repectively, section1, section1-1, section1-1-1.

* Bulleted list
    * Use `* - +` in order.
    * `*` Bullet point
    * `-` Sub-list
    * `+` Another Sub-list


* Definition list

    ``` 
    What
      This is a paragraph for "what"

    *How*
      This is a definition for How. surrounding '*' means the text is
      shown as italic.

    ```


### Kernel Doc RST


* `.. toctree::`
    * Show the "Table of Contents"
    * Each "rst" file's Document title is shown.
    * Usage
        ```
.. toctree::
   :maxdepth: 2

   path/to/index
   path/to/index2
```


## Kernel Documentation Websites

* https://www.kernel.org/doc/html/latest/
