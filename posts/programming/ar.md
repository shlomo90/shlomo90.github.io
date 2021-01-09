What is the ar in unix?
=======================

- The archiver
- Unix utility that maintains groups of files as a single archive file
- is included as one of the GNU Binutils
- LSB(Linux Standard Base) has been deprecated.
	- "the LSB does not include software development utilities nor does it specify .o and .a file format.


Format
------

1. An ar file begins with a global header, followed by a header and data section for each file stored within
  the ar file.


File signature
--------------

- The file signature is a single field containing the magic ASCII string "!<arch>"


How to see the ar file?
-----------------------

- use objdump
```bash
objdump -a file.a
```
- use hexdump
```
jay@autotest1:/opt/nitrox/SDK_5_3/.openssl/lib$ hexdump -C libssl.a  | head -10
00000000  21 3c 61 72 63 68 3e 0a  2f 20 20 20 20 20 20 20  |!<arch>./       |  <-- magic number
00000010  20 20 20 20 20 20 20 20  31 35 37 35 34 34 33 39  |        15754439|
00000020  36 33 20 20 30 20 20 20  20 20 30 20 20 20 20 20  |63  0     0     |
00000030  30 20 20 20 20 20 20 20  31 35 30 32 34 20 20 20  |0       15024   |
00000040  20 20 60 0a 00 00 02 65  00 00 3a f4 00 01 3d d8  |  `....e..:...=.|
00000050  00 01 3d d8 00 02 bd 84  00 02 bd 84 00 02 bd 84  |..=.............|
00000060  00 04 3e 28 00 04 3e 28  00 04 3e 28 00 04 3e 28  |..>(..>(..>(..>(|
```

See also
	- .so file
