 OpenSSL CHANGES
 _______________

 This is a high-level summary of the most important changes.
 For a full list of changes, see the git commit log; for example,
 https://github.com/openssl/openssl/commits/ and pick the appropriate
 release branch.

 Changes between 1.1.1c and 1.1.1d [10 Sep 2019]


*) All libssl internal structures have been removed from the public header
   files, and the OPENSSL_NO_SSL_INTERN option has been removed (since it is
   now redundant). Users should not attempt to access internal structures
   directly. Instead they should use the provided API functions.
   [Matt Caswell]

