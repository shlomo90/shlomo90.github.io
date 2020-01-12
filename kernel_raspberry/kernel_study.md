<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Kernel Study With RaspberryPi

## A. Purpose

1. Kernel Study (focus on Network)
2. Understand Low Level Programming

## B. Raspberry Pi Specs

* [Raspberry Pi Spec](raspberry_spec.md)

## C. Setup Raspberry Pi

### 1. Checking IP in one to one LAN

#### ifconfig

* You can check the network interfaces in your computer.
```
$ ifconfig
```

#### arp command

* See MAC Learned ARP Table
```
$ arp -i <interface> -a
```


## D. Kernel Basic

### Print Hello World at booting time

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


## E. Assemply

### .rept

* Repeat the sequence of lines between the .rept directive and the next .endr directive count times.


### .long 


### current_therad_info

http://egloos.zum.com/rousalome/v/9990732


