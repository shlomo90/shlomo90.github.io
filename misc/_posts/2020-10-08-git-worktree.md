---
layout: post
tags: git
title: git How to use worktree
comments: true
---

# Git worktree

* "git worktree" allows you to have multiple working directories in the current `$GIT_DIR`.
* It's useful when you need to use branches at the same time.


## How to use?

* `git worktree add <path> <branch|commit>`
  * Create new worktree checked out commit or branch at the path including directory name.
* `git worktree remove <path>`
  * Remove worktree
* `git worktree lock <path>`
  * Lock the worktree
* `git worktree unlock <path>`
