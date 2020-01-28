# SSL structure

## SSL 구조체의 statem

<details><summary>State of Message</summary>
<p>

- Message flow 상태를 나타낸다.
	- MSG_FLOW_UNINITED
	- MSG_FLOW_ERROR
	- MSG_FLOW_READING
	- MSG_FLOW_WRITING
	- MSG_FLOW_FINISHED

</p>
</details>

## OSSL_HANDSHAKE_STATE value

<details><summary>OSSL_HANDSHAKE_STATE value</summary>
<p>

```c
typedef enum {
    TLS_ST_BEFORE,
    TLS_ST_OK,
    DTLS_ST_CR_HELLO_VERIFY_REQUEST,
    TLS_ST_CR_SRVR_HELLO,
    TLS_ST_CR_CERT,
    TLS_ST_CR_CERT_STATUS,
    TLS_ST_CR_KEY_EXCH,
    TLS_ST_CR_CERT_REQ,
    TLS_ST_CR_SRVR_DONE,
    TLS_ST_CR_SESSION_TICKET,
    TLS_ST_CR_CHANGE,
    TLS_ST_CR_FINISHED,
    TLS_ST_CW_CLNT_HELLO,
    TLS_ST_CW_CERT,
    TLS_ST_CW_KEY_EXCH,
    TLS_ST_CW_CERT_VRFY,
    TLS_ST_CW_CHANGE,
    TLS_ST_CW_NEXT_PROTO,
    TLS_ST_CW_FINISHED,
    TLS_ST_SW_HELLO_REQ,
    TLS_ST_SR_CLNT_HELLO, 
    DTLS_ST_SW_HELLO_VERIFY_REQUEST,
    TLS_ST_SW_SRVR_HELLO,
    TLS_ST_SW_CERT, 
    TLS_ST_SW_KEY_EXCH,
    TLS_ST_SW_CERT_REQ,
    TLS_ST_SW_SRVR_DONE,
    TLS_ST_SR_CERT,
    TLS_ST_SR_KEY_EXCH,
    TLS_ST_SR_CERT_VRFY,
    TLS_ST_SR_NEXT_PROTO,
    TLS_ST_SR_CHANGE,
    TLS_ST_SR_FINISHED,
    TLS_ST_SW_SESSION_TICKET,
    TLS_ST_SW_CERT_STATUS,
    TLS_ST_SW_CHANGE,
    TLS_ST_SW_FINISHED,
    TLS_ST_SW_ENCRYPTED_EXTENSIONS,
    TLS_ST_CR_ENCRYPTED_EXTENSIONS,
    TLS_ST_CR_CERT_VRFY,
    TLS_ST_SW_CERT_VRFY,
    TLS_ST_CR_HELLO_REQ,
    TLS_ST_SW_KEY_UPDATE,
    TLS_ST_CW_KEY_UPDATE,
    TLS_ST_SR_KEY_UPDATE,
    TLS_ST_CR_KEY_UPDATE,
    TLS_ST_EARLY_DATA,
    TLS_ST_PENDING_EARLY_DATA_END,
    TLS_ST_CW_END_OF_EARLY_DATA,
    TLS_ST_SR_END_OF_EARLY_DATA
} OSSL_HANDSHAKE_STATE;
```

</p>
</details>

## record_layer_st structure declare

<details><summary>rlayer variable</summary>
<p>

- SSL 구조체의 rlayer 는 record layer 이다. 

```c
typedef struct record_layer_st {
    /* The parent SSL structure */
    SSL *s;
    /*
     * Read as many input bytes as possible (for
     * non-blocking reads)
     */
    int read_ahead;
    /* where we are when reading */
    int rstate;
    /* How many pipelines can be used to read data */
    size_t numrpipes;
    /* How many pipelines can be used to write data */
    size_t numwpipes;
    /* read IO goes into here */
    SSL3_BUFFER rbuf;
    /* write IO goes into here */
    SSL3_BUFFER wbuf[SSL_MAX_PIPELINES];
    /* each decoded record goes in here */
    SSL3_RECORD rrec[SSL_MAX_PIPELINES];
    /* used internally to point at a raw packet */
    unsigned char *packet;
    size_t packet_length;
    /* number of bytes sent so far */
    size_t wnum;
    unsigned char handshake_fragment[4];
    size_t handshake_fragment_len;
    /* The number of consecutive empty records we have received */
    size_t empty_record_count;
    /* partial write - check the numbers match */
    /* number bytes written */
    size_t wpend_tot;
    int wpend_type;
    /* number of bytes submitted */
    size_t wpend_ret;
    const unsigned char *wpend_buf;
    unsigned char read_sequence[SEQ_NUM_SIZE];
    unsigned char write_sequence[SEQ_NUM_SIZE];
    /* Set to true if this is the first record in a connection */
    unsigned int is_first_record;
    /* Count of the number of consecutive warning alerts received */
    unsigned int alert_count;
    DTLS_RECORD_LAYER *d;
} RECORD_LAYER;
```

</p>
</details>
