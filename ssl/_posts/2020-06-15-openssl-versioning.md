---
layout: post
tags: openssl version code
title: OPENSSL Versioning
comments: true
---

# OPENSSL Version

---

## How to make version?

* `< 0.9.3`
	* `0xMMNNFFRBB`
    * `M`: Major, `N`: Minor, `F`: Fix, `R`: Final B: beta/patch)
* `>= 0.9.3`
	* 0xMNNFFPPS
    * `M`: Major, `N`: Minor, `F`: Fix, `P`: Patch, `S`: Status
	* The **status** nibble has one of the values *0 for development*, *1 to e for betas*, *f for release*.
* Macro OPENSSL_VERSION_NUMBER, OPENSSL_VERSION are defined.

Here is the examples.  
`1.1.1d` has major number `1` and minor number `1` and fix number `1` and beta/patch number `d`.
`0x10101004` is the hex version of the `1.1.1d`. Simple!

## How To Define OPENSSL_VERSION_NUMBER?

In the openssl repository, `configdata.pm` file has many meta data for building the openssl. In the file, There
are `major`, `minor`, `patch` variables. These variables are used in `include/openssl/opensslv.h.in` file.  

Let's see the `include/openssl/opensslv.h.in` file.
```c
... snipped ...
# define OPENSSL_VERSION_MAJOR  {- $config{major} -}
# define OPENSSL_VERSION_MINOR  {- $config{minor} -}
# define OPENSSL_VERSION_PATCH  {- $config{patch} -}

... snipped ...
# define OPENSSL_VERSION_TEXT "OpenSSL {- "$config{full_version} $config{release_date}" -}"

/* Synthesize OPENSSL_VERSION_NUMBER with the layout 0xMNN00PPSL */
# ifdef OPENSSL_VERSION_PRE_RELEASE
#  define _OPENSSL_VERSION_PRE_RELEASE 0x0L
# else
#  define _OPENSSL_VERSION_PRE_RELEASE 0xfL
# endif
# define OPENSSL_VERSION_NUMBER          \
    ( (OPENSSL_VERSION_MAJOR<<28)        \
      |(OPENSSL_VERSION_MINOR<<20)       \
      |(OPENSSL_VERSION_PATCH<<4)        \
      |_OPENSSL_VERSION_PRE_RELEASE )

# ifdef  __cplusplus
}
# endif

# include <openssl/macros.h>
# ifndef OPENSSL_NO_DEPRECATED_3_0
#  define HEADER_OPENSSLV_H
# endif
... snipped ...
```

`OPENSSL_VERSION_MAJOR` and `OPENSSL_VERSION_MINOR` and `OPENSSL_VERSION_PATCH` have each matched value and
These are assembled to `OPENSSL_VERSION_NUMBER`.
