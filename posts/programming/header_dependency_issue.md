<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# header dependency issues

* how to solve the dependency issues?
    1. use forwward declare
    2. self-sufficient
        * the header file should have all of the declarations or include in the target c or cpp file
        * Don't depend on other include file or declaration. it may cause a compile error when you user the header file.
    3. Separate code and declaration
        * header files should only have declarations not code.
        * code should be in the corresponding implementation file.

* Ref
    * http://gernotklingler.com/blog/care-include-dependencies-cpp-keep-minimum/
    * http://stackoverflow.com/questions/1892043/self-sufficient-header-files-in-c-c
