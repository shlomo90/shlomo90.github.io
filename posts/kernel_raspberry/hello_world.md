---
layout: post
comments: true
---

# Print Hello World at booting time

---

## Steps

<aside class="notice">
Plz, Check the Setup Raspberry Pi before you start to read.
</aside>

* open init/main.c and find *start_kernel* function and add log code.
```c
asmlinkage __visible void __init start_kernel(void)
{
        char *command_line;
        char *after_dashes;

        // ... 중략 ...

        /* Do the rest non-__init'ed, we're now alive */
        pr_notice("jhlim's raspberry pi kernel start!!!!");
        rest_init();
}
```
* compile kernel (with install.sh)
    * execute install.sh file

```
KERNEL=kernel7

echo "make -j4 zImage"
sudo make -j4 zImage
echo "make -j4 modules"
sudo make -j4 modules
echo "make -j4 dtbs"
sudo make -j4 dtbs
echo "make -j4 modules_install"
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
```

* reboot
* check the kern.log file (/var/log/kern.log)
