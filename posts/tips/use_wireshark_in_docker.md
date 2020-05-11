---
layout: post
comments: true
---

# Use Wireshark in Docker Macvlan Network

## Purpose

* Make it possible to use wireshark on Docker instance

## Prerequisite

* Ubuntu 18.04 Docker image

## Process

### 1. Create Docker with volume

```bash
#macvlan3166 is docker netowrk that already created
img_name='yourimage'

docker run --cap-add=NET_ADMIN -v /home/jay/jay_dockers:/workspace \
        --net=macvlan3166 --name=jay_mirr \
        --ip=172.29.1.1 \
        --ip6=2001:db8:abc7::1:1 \
        -itd  $img_name /bin/bash
```

* IMPORTANT!
	* *-v* option is to make your volume connect to the docker.
	* You need a directory to be used as a docker volume.

### 2. Make FIFO File at Docker Host

* Generate FIFO File with `mkfifo` command.
* Current directory path is the parameter that we set with `docker run -v` option.
* At the volume, Create FIFO file.

```bash
jay@k5test:~/jay_dockers$ pwd
/home/jay/jay_dockers
jay@k5test:~/jay_dockers$ rm mirror.fifo		#<-- remove previous fifo file
jay@k5test:~/jay_dockers$ mkfifo ./mirror.fifo	#<-- create new one
```

### 3. Turn on the wireshark from mirror.fifo

* The file `mirror.fifo` is the input packet file for wireshark.
* We execute the wireshark with few options below
	* `-k` : start the capture session immediately.
	* `-n` : Disable network object name resolution
	* `-i` : Set the name of the network interface (Not this time), or **pipe to use for live packet  capture.**

```bash
jay@k5test:~/jay_dockers$ sudo wireshark -kni ./mirror.fifo &
```


### 4. Enter the Docker Guest

```bash
jay@k5test:~/jay_dockers$ docker exec -it jay_mirr /bin/bash
root@ed889c85da1b:/workspace# 
```


### 5. TCPDUMP with options

* Run `tcpdump` command with options ...
	* `-s` is to set snaplen default of 261244.
	* `-ni` is for interface.
	* `-w -` indicates output is printed to standard out.
	* `-U` means writing packet buffer to output file right away.
* `> mirror.fifo` is redirecting output packets of tcpdump to wireshark that turned on from docker host.

```bash
root@ed889c85da1b:/workspace# tcpdump -s 0 -ni eth0 -w - -U > mirror.fifo
```

* Now, We can see the packets from docker guest in the docker host side.


