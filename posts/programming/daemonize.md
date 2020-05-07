---
layout: post
comments: true
---

# Daemon Process

## What Is The Daemon Process?

### Many Kinds Of Daemon Processes

- **rsyslogd daemon** is available to any program to log system messages for an administrator.
- **nfsd, nfsiod, lockd, rpciod** are kernel daemons.
- **cron** daemon executes commands at regularly scheduled dates and times.

### Daemon Process Requirements

* Most of the daemons run with superuser (root) privileges
* None of the daemons has a controlling terminal
* Most of the user-level daemons are process group leaders and session leaders, and are the only
  processes in their process group and session.
* the parent of the user-level daemons is the init process.

## How to Code The Daemon Process?

Firstly, Daemon Process needs to prevent unwanted interactions from happening.

1. Call umask to set the file mode creation mask to a known value, usually 0
    - 예를 들면, 데몬 프로세스가 group-read 그리고 group-write 가 설정된 파일을 만들고자 할 때, group-read 또는 group-write 를 끄는 file mode creation mask 인 경우에는 저 group-read, group-write 에 대한 권한 파일을 생성할 수 없다.
  - 하지만, 라이브러리를 이용해서 파일을 생성하는 경우, 다시 말해서 기존 file mode 의 더 제한적인 설정을 내릴 수 있다. 이게 좋은 점이라면, 라이브러리에서 제공하지 않는 권한을 미리 daemon 에게 주어 같이 사용할 수 있다는 것

2. Call fork and have the parent exit
  - 첫번째로, parent 가 exit 됨은 terminal 이 해당 프로세스가 종료되었다고 인식할 수 있다.
  - 두번째로, fork 후, child 는 그 자신만의 process ID 를 가짐. 하지만 이 child 는 process group 의 leader 가 아님으로, setsid 함수를 수행할 수 있는 조건이 됨

3. Call setsid to create a new session.
  - 이 함수가 수행이 되면, 
    1. new session leader 가 된다.
    2. new process group leader 가 된다.
    3. terminal 제어권을 잃어버린다.

4. Change the current working directory to the root directory.
  - 재부팅 시점에서 daemon 은 정상 종료가 되어야 하는데, mount 지점에서 daemon 이 떠있게 되면, 해당 mount 는 unmount 가 되지 않는다.
  - 하지만, 간혹 필요한 directory 에서 수행되는 daemon 도 있다.

5. Unneeded file descriptors should be closed
  - getrlimit 이나, open_max 함수를 이용하여 0부터 최대 설정할 수 있는 file descriptor 들을 모두 닫도록 한다. (그 이유는 불필요하기 때문)
