---
layout: post
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
