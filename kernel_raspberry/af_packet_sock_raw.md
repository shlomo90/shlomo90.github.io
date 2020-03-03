<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# kernel socket for AF_PACKET family and SOCK_RAW type 

아래 예시는 AF_PACKET family 와 SOCK_RAW type 을 사용하는 경우입니다.

## Creat socket

* socket(AF_PACKET, SOCK_RAW, ...) 으로 할당을 하면
    1. 내부적으로 socket_create kernel 함수가 호출 (socket.c)
    2. socket_create 함수호출 시 `__sock_create` 함수가 호출 (socket.c)
    3. `__sock_create` 함수 에서 SOCK_RAW type 인 경우, socket 자원을 할당하고  
       `rcu_dereference(net_families[family (즉, AF_PACKET]))` 을 통하여 pf (net_proto_family 구조체를 구함)
    4. *packet_init* 함수를 통하여 *sock_register* (&packet_family_ops) 를 수행
        - 해당 함수는 net/packet/af_packet.c 소스파일에 있음
        - *net_families* 배열에는 *ops->family* ( *PF_PACKET 또는 AF_PACKET* ) 인덱스에 해당 *ops* 구조체를 저장  
          (ex: *packet_family_ops*) 
    5. *pf* 변수는 4번에서와 같이 등록된 *ops* (ex: *packet_family_ops*) 를 가지게 됨.
        - *rcu_dereference* 함수에 대해서 더 공부할 필요가 있다.
    6. *pf->create* 함수를 수행하여 이미 할당된 *sock* 의 *ops* (ex: *packet_ops*) 에 pf 를 할당
        - **이 부분 중요!**
        - *sock* 구조체에 *ops* 를 할당하는 이유는 다시 *ops* 를 찾는 과정을 수행하지 않기위함
        - 또한, 바로 *ops* 에 있는 각 handler 함수들을 바로 접근하기 위함.
    7. 각종 socket 에 대한 initialize 작업을 진행한다.
        - po 라는 변수도 생성 pkt_sk(sk)
        - sk->sk_family 에 PF_PACKET 설정
        - sk->sk_destruct 함수 포인터 설정


## Operations with socket

* *sendto* 함수 호출
    1. socket.c 소스 파일 내 *SYSCALL_DEFINE6(sendto, ...)* 함수가 호출
    2. user interface 에서 *Ethernet Frame* 버퍼와 소켓 *sock* file descriptor 가 파라미터로 넘어옵니다.
        - socket file descriptor 는 내부 *sockfd_lookup_light* 함수를 통해 socket 구조체를 구할 수 있다.
    3. *sendto* 함수에서는 *sock_sendmsg* 함수가 호출이 됩니다.
    4. *sock_sendmsg* 함수는 내부 함수 *__sock_sendmsg* 함수가 호출되고 이 과정에서 *kiocb* 등등이 작업
        - 조금더 공부할 필요가 있음.
    5. *__sock_sendmsg* 함수에서는 *sock->ops->sendmsg* 가 호출이 됩니다.
        - *sock* 은 앞서 *sockfd_lookup_light* 함수에서 구한 *struct socket* 구조체입니다.
        - *sock->ops* 는 **Create socket** 섹션에서 6번에 해당하는 *packet_family_ops* 입니다.
        - *sock->ops->sendmsg* 는 *packet_family_ops* 내부 정의된 함수가 호출

```
static const struct proto_ops packet_ops = {
    .family =   PF_PACKET,
    .owner =    THIS_MODULE,
    .release =  packet_release,
    .bind =     packet_bind,
    .connect =  sock_no_connect,
    .socketpair =   sock_no_socketpair,
    .accept =   sock_no_accept,
    .getname =  packet_getname,
    .poll =     packet_poll,
    .ioctl =    packet_ioctl,
    .listen =   sock_no_listen,
    .shutdown = sock_no_shutdown,
    .setsockopt =   packet_setsockopt,
    .getsockopt =   packet_getsockopt,
    .sendmsg =  packet_sendmsg,
    .recvmsg =  packet_recvmsg,
    .mmap =     packet_mmap,
    .sendpage = sock_no_sendpage,
};
```
    6. 결과적으로 *packet_sendmsg*   -> *packet_snd*  가 차례로 호출되어 수행됩니다. 

* ref
http://www.haifux.org/lectures/217/netLec5.pdf
