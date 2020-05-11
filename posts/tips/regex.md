
# vim regex

## Non greedy match

* Purpose
    * I want to capture the first parameter in strings.
* Strings
    * `test(sssssssss, sssssssss, ssssssssss)`
* Regex
    * `test(\(.\{-}\),`
* Explanation
    * `:help non-greedy`

```
                                                               non-greedy
       If a "-" appears immediately after the "{", then a shortest match
       first algorithm is used (see example below).  In particular, "\{-}" is
       the same as "*" but uses the shortest match first algorithm.  BUT: A
       match that starts earlier is preferred over a shorter match: "a\{-}b"
       matches "aaab" in "xaaab".

       Example                 matches
       ab\{2,3}c               "abbc" or "abbbc"
       a\{5}                   "aaaaa"
       ab\{2,}c                "abbc", "abbbc", "abbbbc", etc.
       ab\{,3}c                "ac", "abc", "abbc" or "abbbc"
       a[bc]\{3}d              "abbbd", "abbcd", "acbcd", "acccd", etc.
       a\(bc\)\{1,2}d          "abcd" or "abcbcd"
       a[bc]\{-}[cd]           "abc" in "abcd"
       a[bc]*[cd]              "abcd" in "abcd"

       The } may optionally be preceded with a backslash: \{n,m\}.
```

* ref
    * https://stackoverflow.com/questions/1305853/how-can-i-make-my-match-non-greedy-in-vim
