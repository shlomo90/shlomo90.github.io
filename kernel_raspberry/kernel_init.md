<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />


# Kernel Initialize

## *init_thread_info*, *init_task*

* defined at **init/init_task.c**
* source code 

```c
/*
 * Set up the first task table, touch at your own risk!. Base=0,
 * limit=0x1fffff (=2MB)
 */
struct task_struct init_task
#ifdef CONFIG_ARCH_TASK_STRUCT_ON_STACK
        __init_task_data
#endif
= {
#ifdef CONFIG_THREAD_INFO_IN_TASK
        .thread_info    = INIT_THREAD_INFO(init_task),
        .stack_refcount = ATOMIC_INIT(1),
#endif
        .state          = 0,
        .stack          = init_stack,
        .usage          = ATOMIC_INIT(2),
        .flags          = PF_KTHREAD,
        .prio           = MAX_PRIO - 20,
        .static_prio    = MAX_PRIO - 20,
        .normal_prio    = MAX_PRIO - 20,
        .policy         = SCHED_NORMAL,
        .cpus_allowed   = CPU_MASK_ALL,
        .nr_cpus_allowed= NR_CPUS,
        .mm             = NULL,
        .active_mm      = &init_mm,
        .restart_block  = {
                .fn = do_no_restart_syscall,
        },
        .se             = {
                .group_node     = LIST_HEAD_INIT(init_task.se.group_node),
        },
        .rt             = {
                .run_list       = LIST_HEAD_INIT(init_task.rt.run_list),
                .time_slice     = RR_TIMESLICE,
        },
        .tasks          = LIST_HEAD_INIT(init_task.tasks),
#ifdef CONFIG_SMP
        .pushable_tasks = PLIST_NODE_INIT(init_task.pushable_tasks, MAX_PRIO),
#endif
#ifdef CONFIG_CGROUP_SCHED
        .sched_task_group = &root_task_group,
#endif
        .ptraced        = LIST_HEAD_INIT(init_task.ptraced),
        .ptrace_entry   = LIST_HEAD_INIT(init_task.ptrace_entry),
        .real_parent    = &init_task,
        .parent         = &init_task,
        .children       = LIST_HEAD_INIT(init_task.children),
        .sibling        = LIST_HEAD_INIT(init_task.sibling),
        .group_leader   = &init_task,
        RCU_POINTER_INITIALIZER(real_cred, &init_cred),
        RCU_POINTER_INITIALIZER(cred, &init_cred),
        .comm           = INIT_TASK_COMM,
        .thread         = INIT_THREAD,
        .fs             = &init_fs,
        .files          = &init_files,
        .signal         = &init_signals,
        .sighand        = &init_sighand,
        .nsproxy        = &init_nsproxy,
        .pending        = {
                .list = LIST_HEAD_INIT(init_task.pending.list),
                .signal = {{0}}
        },
        .blocked        = {{0}},
        .alloc_lock     = __SPIN_LOCK_UNLOCKED(init_task.alloc_lock),
        .journal_info   = NULL,
        INIT_CPU_TIMERS(init_task)
        .pi_lock        = __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
        .timer_slack_ns = 50000, /* 50 usec default slack */
        .thread_pid     = &init_struct_pid,
        .thread_group   = LIST_HEAD_INIT(init_task.thread_group),
        .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
#ifdef CONFIG_AUDITSYSCALL
        .loginuid       = INVALID_UID,
        .sessionid      = AUDIT_SID_UNSET,
#endif
#ifdef CONFIG_PERF_EVENTS
        .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
        .perf_event_list = LIST_HEAD_INIT(init_task.perf_event_list),
#endif
#ifdef CONFIG_PREEMPT_RCU
        .rcu_read_lock_nesting = 0,
        .rcu_read_unlock_special.s = 0,
        .rcu_node_entry = LIST_HEAD_INIT(init_task.rcu_node_entry),
        .rcu_blocked_node = NULL,
#endif
#ifdef CONFIG_TASKS_RCU
        .rcu_tasks_holdout = false,
        .rcu_tasks_holdout_list = LIST_HEAD_INIT(init_task.rcu_tasks_holdout_list),
        .rcu_tasks_idle_cpu = -1,
#endif
#ifdef CONFIG_CPUSETS
        .mems_allowed_seq = SEQCNT_ZERO(init_task.mems_allowed_seq),
#endif
#ifdef CONFIG_RT_MUTEXES
        .pi_waiters     = RB_ROOT_CACHED,
        .pi_top_task    = NULL,
#endif
        INIT_PREV_CPUTIME(init_task)
#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
        .vtime.seqcount = SEQCNT_ZERO(init_task.vtime_seqcount),
        .vtime.starttime = 0,
        .vtime.state    = VTIME_SYS,
#endif
#ifdef CONFIG_NUMA_BALANCING
        .numa_preferred_nid = -1,
        .numa_group     = NULL,
        .numa_faults    = NULL,
#endif
#ifdef CONFIG_KASAN
        .kasan_depth    = 1,
#endif
#ifdef CONFIG_TRACE_IRQFLAGS
        .softirqs_enabled = 1,
#endif
#ifdef CONFIG_LOCKDEP
        .lockdep_recursion = 0,
#endif
#ifdef CONFIG_FUNCTION_GRAPH_TRACER
        .ret_stack      = NULL,
#endif
#if defined(CONFIG_TRACING) && defined(CONFIG_PREEMPT)
        .trace_recursion = 0,
#endif
#ifdef CONFIG_LIVEPATCH
        .patch_state    = KLP_UNDEFINED,
#endif
#ifdef CONFIG_SECURITY
        .security       = NULL,
#endif
};
EXPORT_SYMBOL(init_task);
```

## *INIT_THREAD_INFO()*

* 각 arch 마다 다르게 정의되어있다. (defined "/usr/src/linux/arch/arm/include/asm/thread_info.h")

```c
#define INIT_THREAD_INFO(tsk)                                           \
{                                                                       \
        .task           = &tsk,                                         \
        .flags          = 0,                                            \
        .preempt_count  = INIT_PREEMPT_COUNT,                           \
        .addr_limit     = KERNEL_DS,                                    \
}
```
* .preempt_count = INIT_PREEMPT_COUNT : 0
* .addr_limit = *KERNEL_DS* : 0x0000000

### *INIT_PREEMPT_COUNT*

```c
#define PREEMPT_BITS    8
#define SOFTIRQ_BITS    8
#define HARDIRQ_BITS    4
#define NMI_BITS        1

#define PREEMPT_SHIFT   0
#define SOFTIRQ_SHIFT   (PREEMPT_SHIFT + PREEMPT_BITS)
#define HARDIRQ_SHIFT   (SOFTIRQ_SHIFT + SOFTIRQ_BITS)
#define NMI_SHIFT       (HARDIRQ_SHIFT + HARDIRQ_BITS)

// ... 중략 ...

#define PREEMPT_OFFSET  (1UL << PREEMPT_SHIFT)
#define SOFTIRQ_OFFSET  (1UL << SOFTIRQ_SHIFT)
#define HARDIRQ_OFFSET  (1UL << HARDIRQ_SHIFT)
#define NMI_OFFSET      (1UL << NMI_SHIFT)
```

* PREEMPT_SHIFT is set 0 (range 0xFF)
* SOFTIRQ_SHIFT is set 8 (range 0xFF00)
* HARDIRQ_SHIFT is set 16 (range 0xF0000)
* NMI_SHIFT is set 20 (range 0xFF00000)

## *init_stack*

* Ref
    * https://isun2501.tistory.com/17

## *cpu_init*

* *NR_CPUS*
	* Maximum supported CPUs (>= 2)
	* Set in config file (CONFIG_NR_CPUS)



## *stack_smp_processor_id()*

```c
#define stack_smp_processor_id()	\
({                              \
    struct thread_info *ti;                     \
    __asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));  \
    ti->cpu;                            \
})
```

* I don't know what this does but, I guess that it gets the thread_info's cpu.




## Process Flags

```c
/*
 * Per process flags
 */
#define PF_IDLE                 0x00000002      /* I am an IDLE thread */
#define PF_EXITING              0x00000004      /* Getting shut down */
#define PF_EXITPIDONE           0x00000008      /* PI exit done on shut down */
#define PF_VCPU                 0x00000010      /* I'm a virtual CPU */
#define PF_WQ_WORKER            0x00000020      /* I'm a workqueue worker */
#define PF_FORKNOEXEC           0x00000040      /* Forked but didn't exec */
#define PF_MCE_PROCESS          0x00000080      /* Process policy on mce errors */
#define PF_SUPERPRIV            0x00000100      /* Used super-user privileges */
#define PF_DUMPCORE             0x00000200      /* Dumped core */
#define PF_SIGNALED             0x00000400      /* Killed by a signal */
#define PF_MEMALLOC             0x00000800      /* Allocating memory */
#define PF_NPROC_EXCEEDED       0x00001000      /* set_user() noticed that RLIMIT_NPROC was exceeded */
#define PF_USED_MATH            0x00002000      /* If unset the fpu must be initialized before use */
#define PF_USED_ASYNC           0x00004000      /* Used async_schedule*(), used by module init */
#define PF_NOFREEZE             0x00008000      /* This thread should not be frozen */
#define PF_FROZEN               0x00010000      /* Frozen for system suspend */
#define PF_KSWAPD               0x00020000      /* I am kswapd */
#define PF_MEMALLOC_NOFS        0x00040000      /* All allocation requests will inherit GFP_NOFS */
#define PF_MEMALLOC_NOIO        0x00080000      /* All allocation requests will inherit GFP_NOIO */
#define PF_LESS_THROTTLE        0x00100000      /* Throttle me less: I clean memory */
#define PF_KTHREAD              0x00200000      /* I am a kernel thread */
#define PF_RANDOMIZE            0x00400000      /* Randomize virtual address space */
#define PF_SWAPWRITE            0x00800000      /* Allowed to write to swap */
#define PF_NO_SETAFFINITY       0x04000000      /* Userland is not allowed to meddle with cpus_allowed */
#define PF_MCE_EARLY            0x08000000      /* Early kill for mce process policy */
#define PF_MUTEX_TESTER         0x20000000      /* Thread belongs to the rt mutex tester */
#define PF_FREEZER_SKIP         0x40000000      /* Freezer should not count it as freezable */
#define PF_SUSPEND_TASK         0x80000000      /* This thread called freeze_processes() and should not be frozen */
```

* cpus_allowed

```c
/* Don't assign or return these: may not be this big! */
typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;

#define DECLARE_BITMAP(name,bits) \
        unsigned long name[BITS_TO_LONGS(bits)]
```


