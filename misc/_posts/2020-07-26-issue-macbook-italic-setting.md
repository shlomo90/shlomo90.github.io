---
layout: post
tags: environment macbook vim
title: issue vim doesn't show italic characters
comments: true
---

# When Vim doesn't show the italic characters

* Issue
  * I was writing markdown files, the italic characters showed by `*italic*`
    syntax didn't show well.
  * I am using `iterm2` newly updated, vim 8.1 versiona and Macbook 2011 pretty old.
  * I installed `vim-markdown` plugin but, it doesn't work well.
  * It looks like vim doesn't understand italic character code in terminal.
* Solution
  * I added the code in `.vimrc`.
      ```
" I've tried to apply italic characters in vim.
" Finally, the below code work well.
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic
      ```
  * [Reference](https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic)
