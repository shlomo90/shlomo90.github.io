---
layout: post
tags: kernel doc rst
title: Kernel ReStructure Text
comments: true
---


# ReStructure Text


Linux Kernel 문서화 작업에 쓰이는 양식이다. 손쉽게 글의 내용을 HTML 로
바꾸어 줌으로써, 주로 문서화에 사용된다. `sphinx` 기능은 RST 파일을 HTML 및
문서화로 변환해주는 기능을 담당한다. Python 에서 주로 사용되며, Python.org
역시 Sphinx 을 사용한다.


## RST Syntax

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
