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
