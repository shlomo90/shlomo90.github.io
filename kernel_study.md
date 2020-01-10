<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Kernel Study With RaspberryPi

## A. Purpose

1. Kernel Study (focus on Network)
2. Understand Low Level Programming

## B. Setup Raspberry Pi

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


## C. Kernel

### 1. Locking system in kernel

* why need it?
	* to provide synchronization in critical sections


### 2. Basic Assembly Language

#### Intel Assembly

* Instructions
	* Label
	* Instruction
	* Operands
	* Comment
* operands

* Ref
	* https://en.wikipedia.org/wiki/X86_assembly_language
	* https://stackoverflow.com/questions/38751614/what-are-the-return-values-of-system-calls-in-assembly
	* https://stackoverflow.com/questions/10461798/asm-code-containing-0-what-does-that-mean
	* https://stackoverflow.com/questions/9342659/assembly-jz-instruction-after-cmp
	* https://stackoverflow.com/questions/2465232/what-does-subl-do-here
	* https://docs.oracle.com/cd/E19120-01/open.solaris/817-5477/esqaq/index.html


## D. Kernel

### 1. Kernel Panic Debug

#### Terminology

* Most Significant Bit (MSB or high-order bit or left most bit)
	* is the bit position in a binary number having the greatest value

* RIP
	* Instruction pointer. It points to a memory address
	* On 32-bit arch, the instruction pointer is called EIP.
* CS
	* Code Segment (CS) register
	* the one that points to a segment where program instructions are set.
	* The two least significant bits of this register specify the Current Privilege Level of the CPU
	* example
		* 0010 : two least significant bits '00' is kernel mode
		* 1110 : two least significant bits '11' is user mode

* Privilege Levels
	* concept of protecting resources on a CPU.
	* Defferent execution threads can have different privilege level which grant access to system resources
	* Linux used 0 for kernel level and 3 for user mode in range 0~3.

* Descriptor Privilege Level
	* the highest level of privilege that can access the resource and is defined
* Requested Privilege Level
	* is defined in the Segment Selector, the last two bits

#### See Also

* [perf][1]


### 2. Kernel Locking System

* Ref
	* https://www.linuxjournal.com/article/5833




[1]: http://www.brendangregg.com/perf.html
