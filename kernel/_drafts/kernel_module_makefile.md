# Kernel module Makefile

* If you are not familar with using `make`, Check `programming/_draft/Makefile.md`


## Basic Kernel Makefile Understanding


* Basic `Makefile`

```make
obj-m   := key_drv.o    # obj-m assigned "key_drv.o"
APP     = key_app       # APP is assigned as recursively extanded variable.

KDIR    := /lib/modules/$(shell uname -r)/build

all : module app

module:
    $(MAKE) -C $(KDIR) SUBDIRS=$$PWD modules

app:
    $(CC) -o $(APP) $(APP).c

clean:
    -$(MAKE) -C $(KDIR) M=$$PWD clean
    -rm $(APP)
```

* `obj-m` or `obj-y`
    * `obj-m` is compiled as a kernel module.
    * `obj-y` is compiled and put in kernel image
    * These are used to determine the object whether is module or built-in
      when it compiles a kernel source.
* `KDIR`
    * It's kernel directory.
    * `$(MAKE) -C $(KDIR) SUBDIRS=$$PWD modules`
        * change directory to kernel module directory before doing `make`
        * if `SUBDIRS` is set, the kernel is noticed that current build is external module
        * if `modules` set, do `make` build as a kernel module

* `M=$$PWD`
    * `$$PWD` is a current path. (ex: `pwd`)


### See also "Internal Kernel Makefile (module)"

* ...

## Internel Kernel Makefile (module)

```make

###
# External module support.
# When building external modules the kernel used as basis is considered
# read-only, and no consistency checks are made and the make
# system is not used on the basis kernel. If updates are required
# in the basis kernel ordinary make commands (without M=...) must
# be used.
#
# The following are the only valid targets when building external
# modules.
# make M=dir clean     Delete all automatically generated files
# make M=dir modules   Make all modules in specified dir
# make M=dir           Same as 'make M=dir modules'
# make M=dir modules_install
#                      Install the modules built in the module directory
#                      Assumes install directory is already created

# We are always building modules
KBUILD_MODULES := 1
PHONY += crmodverdir
crmodverdir:
        $(cmd_crmodverdir)

PHONY += $(objtree)/Module.symvers
$(objtree)/Module.symvers:
        @test -e $(objtree)/Module.symvers || ( \
        echo; \
        echo "  WARNING: Symbol version dump $(objtree)/Module.symvers"; \
        echo "           is missing; modules will have no dependencies and modversions."; \
        echo )

module-dirs := $(addprefix _module_,$(KBUILD_EXTMOD))
PHONY += $(module-dirs) modules
$(module-dirs): crmodverdir $(objtree)/Module.symvers
        $(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)

modules: $(module-dirs)
        @$(kecho) '  Building modules, stage 2.';
        $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost

PHONY += modules_install
modules_install: _emodinst_ _emodinst_post
```
