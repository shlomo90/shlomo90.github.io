
# less with color

* 'less' command can retain the color with '-r' option.
    * "raw-control-chars"
    * The default is to display control characters using the caret notation;
        * 
        * See https://en.wikipedia.org/wiki/Caret_notation



```
grep test --color=always | less -r
```
  * The result 
```
^[[35m^[[Kless_with_color.md^[[m^[[K^[[36m^[[K:^[[m^[[Kgrep ^[[01;31m^[[Ktest^[[m^[[K --color=always | less -r
```
