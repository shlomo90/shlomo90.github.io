---
layout: post
tags: daemon programming c
comments: true
---

# Daemon Process

---

## What Is The Daemon Process?

The APUE said,
* Daemons are processes that live for a long time.
  * From the system is bootstrapped to the system is shutdown.
  * They don't have a controlling terminal. (maybe it means they don't get input directly from users?)
    * Daemon reports errors some different ways. (logging, etc.)
    * Terminal is something to interact users and computer resources.
    * It would be a printer (a teletype, TTY), monitor display and so on.


## Many Kinds Of Daemon Processes

* log system daemons
  * *rsyslogd*
* schedule daemons
  * *cron*
* kernel daemons
  * *kthreadd*
    * to create other kernel processes
  * *kswapd*
    * to write dirty pages to disk slowly over time
  * *flush*
    * to flush dirty pages to disk when available memory reaches a configured minimum threshold.
  * *nfsd, nfsiod, lockd, rpciod*

## Daemon Process Requirements

* None of the daemons have controlling terminal
  * The terminal name (e.g TTY at the `ps`) is set to a question mark.
  * The process that is run in terminal is under the shell process ID's Session Group.
    ```
 PPID     PID    PGID     SID   COMMAND
 0       1       1       1      /sbin/init splash
 1       7841    7841    7841   /lib/systemd/systemd --user
 7841    125128  125128  125128 gnome-terminal-
 125128  447555  447555  447555 bash                        <-- bash shell process
 447555  618308  618308  447555 vi
 447555  619399  619399  447555 python2.7                   <-- process in terminal
 447555  619541  619541  447555 ps
    ```
    * The program "python2.7" has session ID 44755 that is bash shell process. 
    * TODO: need to dig in the Process group and Session.
* Most of the user-level daemons are process group leaders and session leaders, and are the only
  processes in their process group and session.
* Most of the daemons run with superuser (root) privileges.
* The parent of the user-level daemons is the init process.


## How to Code The Daemon Process?

* *umask* to set the file mode creation mask as 0
  * some files from daemon process are inherited file mode.
* *fork* and parent process *exit*
  * To let bash shell process know that the parent process is done
  * Make the child process a process group leader.
* *setsid* to create a new session
  * To disassociate its controlling terminal.
* *chdir* to change current directory to a specific directory
  * Abnormally a daemon process is exited whil system shuting down, A file system could be unmounted.
* *close* to unneeded file descriptors
  * the parent process or bash shell process would have opened files and daemon process would have
    inherited open file descriopters.
* *dup* to redirect `stdin`, `stdout`, `stderr` to `/dev/null`
  * To shut any input and output
  * Maybe you can use Unix error-logging facility `syslogd`.


## References

* APUE(Advanced Programming Unix Environment)
