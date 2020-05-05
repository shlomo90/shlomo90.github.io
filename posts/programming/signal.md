<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# signal

* signal flags
    * sa_flags specifies a set of flags which modify the behavior of the signal.  It is formed by the bitwise OR of zero or more of the following:
    * SA_NOCLDSTOP
        * If  signum  is SIGCHLD, do not receive notification when child processes stop (i.e., when they receive one of SIGSTOP, SIGTSTP, SIGTTIN, or SIGTTOU) or resume (i.e., they receive SIGCONT) (see wait(2)).  This flag is meaningful only when establishing a handler for SIGCHLD.
    * SA_NOCLDWAIT (since Linux 2.6)
        * If signum is SIGCHLD, do not transform children into zombies when they terminate.  See also waitpid(2).  This flag is meaningful only when establishing a handler for SIGCHLD, or when setting that signal's disposition to SIG_DFL. If  the  SA_NOCLDWAIT  flag  is  set when establishing a handler for SIGCHLD, POSIX.1 leaves it unspecified whether a SIGCHLD signal is generated when a child process terminates.  On Linux, a SIGCHLD signal is generated in this case; on some other implementations, it is not.
    * SA_NODEFER
        * Do not prevent the signal from being received from within its own signal handler.  This flag is meaningful only when establishing a signal handler.
    * SA_NOMASK
        * is an obsolete, nonstandard synonym for this flag.
    * SA_ONSTACK
        * Call  the  signal  handler  on  an alternate signal stack provided by sigaltstack(2).  If an alternate stack is not available, the default stack will be used. This flag is meaningful only when establishing a signal handler.
    * SA_RESETHAND
        * Restore the signal action to the default upon entry to the signal handler.  This flag is meaningful only when establishing a signal handler.
    * SA_ONESHOT
        * is an obsolete, nonstandard synonym for this flag.
    * SA_RESTART
        * Provide behavior compatible with BSD signal semantics by making certain system calls restartable across signals.  This flag is meaningful only when establishing a signal handler.  See signal(7) for a discussion of system call restarting.
    * SA_RESTORER
        * Not intended for application use.  This flag is used by C libraries to indicate that the sa_restorer field contains the address of a "signal trampoline".  See sigreturn(2) for more details.
    * SA_SIGINFO (since Linux 2.2)
        * The  signal handler takes three arguments, not one.  In this case, sa_sigaction should be set instead of sa_handler.  This flag is meaningful only when establishing a signal handler.
