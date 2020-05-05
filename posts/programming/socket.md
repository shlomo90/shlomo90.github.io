<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Header Issue

## socket 에서의 writable/readable 의 뜻은?

Under What Conditions Is a Descriptor Ready?

[...] The conditions that cause select to return "ready" for sockets [are]:

1. A socket is ready for reading if any of the following four conditions is true:

The number of bytes of data in the socket receive buffer is greater than or equal to the current size of the low-water mark for the socket receive buffer. A read operation on the socket will not block and will return a value greater than 0 (i.e., the data that is ready to be read). [...]
The read half of the connection is closed (i.e., a TCP connection that has received a FIN). A read operation on the socket will not block and will return 0 (i.e., EOF).
The socket is a listening socket and the number of completed connections is nonzero. [...]
A socket error is pending. A read operation on the socket will not block and will return an error (–1) with errno set to the specific error condition. [...]

2. A socket is ready for writing if any of the following four conditions is true:

The number of bytes of available space in the socket send buffer is greater than or equal to the current size of the low-water mark for the socket send buffer and either: (i) the socket is connected, or (ii) the socket does not require a connection (e.g., UDP). This means that if we set the socket to nonblocking, a write operation will not block and will return a positive value (e.g., the number of bytes accepted by the transport layer). [...]
The write half of the connection is closed. A write operation on the socket will generate SIGPIPE.
A socket using a non-blocking connect has completed the connection, or the connect has failed.
A socket error is pending. A write operation on the socket will not block and will return an error (–1) with errno set to the specific error condition. [...]

3. A socket has an exception condition pending if there is out-of-band data for the socket or the socket is still at the out-of-band mark.

Our definitions of "readable" and "writable" are taken directly from the kernel's soreadable and sowriteable macros on pp. 530–531 of TCPv2. Similarly, our definition of the "exception condition" for a socket is from the soo_select function on these same pages.

Notice that when an error occurs on a socket, it is marked as both readable and writable by select.

The purpose of the receive and send low-water marks is to give the application control over how much data must be available for reading or how much space must be available for writing before select returns a readable or writable status. For example, if we know that our application has nothing productive to do unless at least 64 bytes of data are present, we can set the receive low-water mark to 64 to prevent select from waking us up if less than 64 bytes are ready for reading.

As long as the send low-water mark for a UDP socket is less than the send buffer size (which should always be the default relationship), the UDP socket is always writable, since a connection is not required.

![Alt text](/posts/pics/summary_of_condition.png)


위의 내용과 같이, Connection 이 맺어질 때의 writable 함을 확인할 수 있다.

Ref
  - 
https://stackoverflow.com/questions/31314547/what-does-readable-writable-mean-in-a-socket-file-descriptor-and-why-regular-fi
