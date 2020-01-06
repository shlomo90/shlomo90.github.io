<link rel="stylesheet" type="text/css" media="all" href="homepage.css" />

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
