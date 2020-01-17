<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# *setsockopt* in kernel

## setsockopt 시 Kernel 에 정보가 들어가게 되는 과정

* 다음은 아래 파이썬 코드에서 setsockopt 를 하면, 아래와 같이 동작으로 추정 (검증 필요)

```python
def setsockopt(cmd, data):
    sockfd = _libc.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
    if sockfd == -1:
        raise_error(get_errno())

    try:
        ret = _libc.setsockopt(sockfd, socket.IPPROTO_IP, cmd,
                               byref(data), sizeof(data))
	#... 중략 ...#
```

* 코드에서 보면 setsockopt 시, RAW socket 을 생성 후,  socket.IPPROTO_IP 값으로 설정.
* raw socket 을 생성하게되면,  inet_init 함수에서 raw_prot 이라는 변수를 등록.

```c
struct proto raw_prot = {
    .name          = "RAW",
    .owner         = THIS_MODULE,
    .close         = raw_close,
    .destroy       = raw_destroy,
    .connect       = ip4_datagram_connect,
    .disconnect    = udp_disconnect,
    .ioctl         = raw_ioctl,
    .init          = raw_init,
    .setsockopt    = raw_setsockopt,
    .getsockopt    = raw_getsockopt,
    .sendmsg       = raw_sendmsg,
    .recvmsg       = raw_recvmsg,
    .bind          = raw_bind,
    .backlog_rcv       = raw_rcv_skb,
    .hash          = raw_hash_sk,
    .unhash        = raw_unhash_sk,
    .obj_size      = sizeof(struct raw_sock),
    .h.raw_hash    = &raw_v4_hashinfo,
#ifdef CONFIG_COMPAT
    .compat_setsockopt = compat_raw_setsockopt,
    .compat_getsockopt = compat_raw_getsockopt,
#endif
};
```

* 이후, *inetsw_array* 를 순회하면서 *inet_register_protosw* 함수를 수행하여 등록

```c
void inet_register_protosw(struct inet_protosw *p)
{
    struct list_head *lh;
    struct inet_protosw *answer;
    int protocol = p->protocol;
    struct list_head *last_perm;

    spin_lock_bh(&inetsw_lock);

    if (p->type >= SOCK_MAX)
        goto out_illegal;

    /* If we are trying to override a permanent protocol, bail. */
    answer = NULL;
    last_perm = &inetsw[p->type];
    list_for_each(lh, &inetsw[p->type]) {
        answer = list_entry(lh, struct inet_protosw, list);

        /* Check only the non-wild match. */
        if (INET_PROTOSW_PERMANENT & answer->flags) {
            if (protocol == answer->protocol)
                break;
            last_perm = lh;
        }

        answer = NULL;
    }
    if (answer)
        goto out_permanent;

    /* Add the new entry after the last permanent entry if any, so that
     * the new entry does not override a permanent entry when matched with
     * a wild-card protocol. But it is allowed to override any existing
     * non-permanent entry.  This means that when we remove this entry, the
     * system automatically returns to the old behavior.
     */
    list_add_rcu(&p->list, last_perm);
out:
    spin_unlock_bh(&inetsw_lock);

    return;

out_permanent:
    printk(KERN_ERR "Attempt to override permanent protocol %d.\n",
           protocol);
    goto out;

out_illegal:
    printk(KERN_ERR
           "Ignoring attempt to register invalid socket type %d.\n",
           p->type);
    goto out;
}
EXPORT_SYMBOL(inet_register_protosw);

```

* 아래는 *inetsw_array* 배열의 구조

```c
static struct inet_protosw inetsw_array[] =
{
    {
        .type =       SOCK_STREAM,
        .protocol =   IPPROTO_TCP,
        .prot =       &tcp_prot,
        .ops =        &inet_stream_ops,
        .no_check =   0,
        .flags =      INET_PROTOSW_PERMANENT |
                  INET_PROTOSW_ICSK,
    },

    {
        .type =       SOCK_DGRAM,
        .protocol =   IPPROTO_UDP,
        .prot =       &udp_prot,
        .ops =        &inet_dgram_ops,
        .no_check =   UDP_CSUM_DEFAULT,
        .flags =      INET_PROTOSW_PERMANENT,
       },


       {
           .type =       SOCK_RAW,
           .protocol =   IPPROTO_IP,    /* wild card */
           .prot =       &raw_prot,
           .ops =        &inet_sockraw_ops,
           .no_check =   UDP_CSUM_DEFAULT,
           .flags =      INET_PROTOSW_REUSE,
       }
};

```

* socket 을 생성하면, inet_create 함수를 호출합니다.
	1. sk 초기화.
	2. 타입별로 prot 선택 및 설정
	3. 설정된 prot init




```c
static const struct proto_ops inet_sockraw_ops = {
    .family        = PF_INET,
    .owner         = THIS_MODULE,
    .release       = inet_release,
    .bind          = inet_bind,
    .connect       = inet_dgram_connect,
    .socketpair    = sock_no_socketpair,
    .accept        = sock_no_accept,
    .getname       = inet_getname,
    .poll          = datagram_poll,
    .ioctl         = inet_ioctl,
    .listen        = sock_no_listen,
    .shutdown      = inet_shutdown,
    .setsockopt    = sock_common_setsockopt,
    .getsockopt    = sock_common_getsockopt,
    .sendmsg       = inet_sendmsg,
    .recvmsg       = sock_common_recvmsg,
    .mmap          = sock_no_mmap,
    .sendpage      = inet_sendpage,
#ifdef CONFIG_COMPAT
    .compat_setsockopt = compat_sock_common_setsockopt,
    .compat_getsockopt = compat_sock_common_getsockopt,
#endif
};

```


* inet_sockraw_ops 구조체 변수는 초기 raw 일 경우 세팅이 되고, 여기서 set, getsockopt 기능이 있다.

```c
int sock_common_setsockopt(struct socket *sock, int level, int optname,
                char __user *optval, unsigned int optlen)
 {
     struct sock *sk = sock->sk;

     return sk->sk_prot->setsockopt(sk, level, optname, optval, optlen);
 }
 EXPORT_SYMBOL(sock_common_setsockopt);
```

* 위와 같이 sk_prot 은 raw_prot 을 가지며, raw_prot->setsockopt 는 raw_setsockopt 입니다.
* raw_setsockopt 는 level (SOL_RAW, 등등) 에 따라 SOL_RAW 가 아니므로, ip_setsockopt 함수를 호출하게 됩니다.
* ip_setsockopt 함수는 처음 do_ip_setsockopt 함수를 수행하게 되고, 여기서 optname은 우리가 설정한 값(PIOL7_SO_SET_ADD_FILTER) 를 가지지 못함으로 없는 경우에 대비한 nf_setsockopt 함수가 호출

```c
int ip_setsockopt(struct sock *sk, int level,
        int optname, char __user *optval, unsigned int optlen)
{
    int err;

    if (level != SOL_IP)
        return -ENOPROTOOPT;

    err = do_ip_setsockopt(sk, level, optname, optval, optlen);
#ifdef CONFIG_NETFILTER
    /* we need to exclude all possible ENOPROTOOPTs except default case */
    if (err == -ENOPROTOOPT && optname != IP_HDRINCL &&
            optname != IP_IPSEC_POLICY &&
            optname != IP_XFRM_POLICY &&
            !ip_mroute_opt(optname)) {
        lock_sock(sk);
        err = nf_setsockopt(sk, PF_INET, optname, optval, optlen);
        release_sock(sk);
    }
#endif
    return err;
}
```

* *do_ip_setsockopt* 함수에서는 optname (IP_NEXTHOP, IP_OPTIONS, ...) 에 따라 기능이 동작
	* IP_OPTIONS 인 경우 socket 에 필요한 옵션 플래그를 설정합니다.
	* 이와 같은 용도로 setsockopt 가 사용됨
* 하지만 *do_ip_setsockopt* 함수에서 찾지 못하는 경우 *nf_sockopt_find* 함수를 호출하여 원하는 optname 을 찾는다.
	* *nf_sockopt_find* 에선 기존에 등록된 ( *nf_register_sockopt* 함수를 통해 등록된) nf_sockopt_ops 구조체 들을 순회하여 pf 맴버변수가 같은지를 보고 찾는다.

```c
static struct nf_sockopt_ops piolb_sockopts = {
    .pf     = PF_INET,

    .set_optmin = XXXXXXXXXXXXXXX, 
    .set_optmax = XXXXXXXXXXXXXXX + 1,
    .set        = XXXXXXXXXXXXXXX,

    .get_optmin = XXXXXXXXXXXXXXX,
    .get_optmax = XXXXXXXXXXXXXXX + 1,
    .get        = XXXXXXXXXXXXXXX,

    .owner      = THIS_MODULE,
};
```
	* 이는 보통 init 과정에서 등록을 해놓는다.
* init 과정에서 이미 nf_sockopt_ops 가 설정이 되었기에 쉽게 get, set 함수를 불러올 수 있다.

```c
static int nf_sockopt(struct sock *sk, u_int8_t pf, int val,
              char __user *opt, int *len, int get)
{
    struct nf_sockopt_ops *ops;
    int ret;

    ops = nf_sockopt_find(sk, pf, val, get);
    if (IS_ERR(ops))
        return PTR_ERR(ops);

    if (get)
        ret = ops->get(sk, val, opt, len);	// <--- 앞의 nf_sockopt_find 함수를 통해 얻은 get, set 함수 
    else									//      로 원하는 동작을 수행 (ex: setsockopt)
        ret = ops->set(sk, val, opt, *len);

    module_put(ops->owner);
    return ret;
}
```
