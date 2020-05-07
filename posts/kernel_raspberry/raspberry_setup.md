---
layout: post
comments: true
---

# Setup Raspberry Pi

## 1. Checking IP in one to one LAN

### ifconfig

* You can check the network interfaces in your computer.
```
$ ifconfig
```

### arp command

* See MAC Learned ARP Table

```
$ arp -i <interface> -a
```
