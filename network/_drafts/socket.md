# Socket

---

##  Socket descriptors

```
int socket(int domain, int type, int protocol);
```

* domain
  * AF_INET
  * AF_INET6
  * AF_UNIX (AF_LOCAL)
  * AF_UNSPEC
    * wildcard 'any' domain

* type
  * SOCK_DGRAM
  * SOCK_RAW
  * SOCK_SEQPACKET
  * SOCK_STREAM


## recv

```
ssize_t recv(int sockfd, void *buf, size_t nbytes, int flags);
```

* flag
  * MSG_PEEK
    * Return packet contents without consuming the packet.
    * The next call to read or one of the recv functions will return the same data we peeked at.


## Socket readable, writable

* A socket is ready for reading if any of the following four conditions is true:
  * a. The number of bytes of data in the socket receive buffer is greater than or
    equal to the current size of the low-water mark for the socket receive buffer.
    A read operation on the socket will not block and will return a value greater
    than 0 (i.e., the data that is ready to be read). We can set this low-water
    mark using the SO_RCVLOWAT socket option. It defaults to 1 for TCP and UDP
    sockets.
  * b. The read half of the connection is closed (i.e., a TCP connection that has
    received a FIN). A read operation on the socket will not block and will return
    0 (i.e., EOF).
  * c. The socket is a listening socket and the number of completed connections is
    nonzero. An accept on the listening socket will normally not block, although
    we will describe a timing condition in Section 16.6 under which the accept
    can block.
  * d. A socket error is pending. A read operation on the socket will not block and
    will return an error ( 1) with errno set to the specific error condition. These
    pending errors can also be fetched and cleared by calling getsockopt and
    specifying the SO_ERROR socket option.

* A socket is ready for writing if any of the following four conditions is true:
a. The number of bytes of available space in the socket send buffer is greater
than or equal to the current size of the low-water mark for the socket send
buffer and either: 
    (i) the socket is connected, or
    (ii) the socket does not require a connection (e.g., UDP). This means that if we set the socket to
         nonblocking (Chapter 16), a write operation will not block and will return a
         positive value (e.g., the number of bytes accepted by the transport layer).
         We can set this low-water mark using the SO_SNDLOWAT socket option. This
         low-water mark normally defaults to 2048 for TCP and UDP sockets.
b. The write half of the connection is closed. A write operation on the socket will
generate SIGPIPE (Section 5.12).

c. A socket using a non-blocking connect has completed the connection, or the
connect has failed.
d. A socket error is pending. A write operation on the socket will not block and
will return an error ( 1) with errno set to the specific error condition. These
pending errors can also be fetched and cleared by calling getsockopt with
the SO_ERROR socket option.
