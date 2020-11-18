---
layout: post
tags: nginx programing
comments: true
---

#### Doc Update

* 2020-11-18: Format Change
* 2020-06-15: init

# Stream module's peer init

---

## A. Configuration time

Nginx's configuration time has two periods (Directive parsing time, Initialization time)
<br/>
<br/>

### 1. Directive parsing time

---

1. When a nginx parser meets "upstream" directive, it makes a new upstream block by running `ngx_stream_upstream_add` function.
  * `ngx_stream_upstream_add` does:
	* Allocate new memory space for an upstream variable `uscf` pointing to `umcf->upstreams`.
	* Set flags for `uscf` variable.
2. upstream 블럭에 'persist' directive 가 있으면, `ngx_stream_upstream_persist_srv_conf_t` 의 `original_init_upstream`
   에다가 기존 `uscf->peer.init_upstream` 을 저장
3. `uscf->peer.init_upstream` 에다가는 `ngx_stream_upstream_init_persist` 로 교체
<br/>
<br/>


### 2. Initialization Time (After Directive parsing time)

---

1. `ngx_stream_upstream_init_main_conf` 수행시, `uscf->peer.init_upstream` 을 수행 (`ngx_stream_upstream_init_persist`)
2. 기존 저장된 `ngx_stream_upstream_persist_srv_conf_t` 의 `original_init_upstream` 에 저장된 함수를 호출
   (`original_init_upstream` 을 가지고 오기 위해 기존 `uscf->peer.init_upstream` 이 존재하는지 보는데 없음!
	따라서, 디폴트값인 `ngx_stream_upstream_init_round_robin` 을 세팅한다.

```
ngx_stream_upstream_init_round_robin

load uscf->servers
                                +---------------+
        uscf->servers  ------>  |us1|us2|us3|...|
                                +---------------+

alloc    peers (ngx_stream_upstream_rr_peers_t)
                           +------------------------------+
        peers  -------->   |ngx_stream_upstream_rr_peers_t|
                           +------------------------------+
alloc    peer * n

                           +------------------------------+------------------------------+---+
        peer   -------->   |ngx_stream_upstream_rr_peer_t |ngx_stream_upstream_rr_peer_t |...|
                           +------------------------------+------------------------------+---+
                                        ^
                                        | max_conns 복사
                           +----------------------------+----------------------------+---+
        uscf->servers  ->  |ngx_stream_upstream_server_t|ngx_stream_upstream_server_t|...|
                           +----------------------------+----------------------------+---+
        (uscf == ngx_stream_upstream_srv_conf_t)


                           +------------------------------+---+------------------------------+
        peer   -------->   |ngx_stream_upstream_rr_peer_t |...|ngx_stream_upstream_rr_peer_t |
                           +------------------------------+---+------------------------------+

                           각 peer 의 next 는 바로 옆의 배열을 가리킴



                           +------------------------------+
        peers  -------->   |ngx_stream_upstream_rr_peers_t|
                           +------------------------------+
                                        | peers->next    (backup)
                                        V
                           +------------------------------+
                           |ngx_stream_upstream_rr_peers_t|
                           +------------------------------+


위 복사 작업이 끝나면 아래와 같이 형상이 된다.

        +-------------------------------+
        |ngx_stream_upstream_main_conf_t|
        +-------------------------------+
                        | .upstreams
                        V
        +------------------------------+---+
        |ngx_stream_upstream_srv_conf_t|...|        // 해당 변수는 알다시피, 'proxy_pass' 파싱시 생성되고, pscf->upstream 에 저장
        +------------------------------+---+        // proxy_handler 에서 pscf->upstream 은 running 타임에서 r->upstream->upstream 으로 설정됨
                        | .peer
                        V
        +------------------------------+   data 는 아래를 포인팅
        |ngx_stream_upstream_peer_t    |
        |                              | ----+
        |                              |     | .init_upstream  (ngx_stream_upstream_init_main_conf 에서 수행)
        |                              | -----------------------> ngx_stream_upstream_init_persist
        +------------------------------+     |
                                             |
                                             |    
                                             V
                           +------------------------------+
        peers  -------->   |ngx_stream_upstream_rr_peers_t|  새로 생성됨
                           +------------------------------+
                                        | peers->peer
                                        V
                           +------------------------------+---+------------------------------+
        peer   -------->   |ngx_stream_upstream_rr_peer_t |...|ngx_stream_upstream_rr_peer_t | 새로 생성됨
                           +------------------------------+---+------------------------------+
                                        ^
                                        | max_conns 복사 (러닝타임에서 복사)
                           +----------------------------+----------------------------+---+
        uscf->servers  ->  |ngx_stream_upstream_server_t|ngx_stream_upstream_server_t|...|
                           +----------------------------+----------------------------+---+
        (uscf == ngx_stream_upstream_srv_conf_t)  초기 설정타임의 값을 가짐

```

3. ngx_stream_upstream_init_round_robin 을 수행하면서 us->peer.init 은 ngx_stream_upstream_init_round_robin_peer
   로 설정이 됩니다. 그리고 위 그래프 (`uscf->servers` 형성 및 구조) 같이 설정이 됨.
4. persist 설정했다면, 3번이 끝나고나서 ngx_stream_upstream_persist_srv_conf_t 의 original_init_peer 에 
   3번에 설정된 ngx_stream_upstream_init_round_robin_peer 를 넣고, `us->peer.init` 은 다음 함수
   ngx_stream_upstream_init_persist_peer 를 설정(바꿔치기)
    - 각 모듈에서 원하는 동작을 하기 위해 hook 포인트 제공.
5. ngx_stream_upstream_init_main_conf 끝
	- (init_main_conf 는 ngx_stream_block 함수에서 수행됩니다.
<br/>
<br/>

## B. Running Time

---

The "Running Time" means the time when a packet comes from client and nginx processes the request

1. peer init 을 먼저 수행한다.
	- persist 가 존재한다면 persist init 을 수행하는데, 내부적으로 미리 저장된 peer init 을 수행
	- persist init 에서는 미리저장된 init 을 통해 get, free, data 등등 결정된 거를 persist 가 가지는 구조체에
	  따로 저장 (오리진 복사)


!!!!!!!1 stream 에서의 get 하는 방법 !!!!!!!!!

1. ngx_stream_upstream_get_round_robin_peer 함수를 호출
	- 다른 모듈이 있다면 다른 모듈에서 수행이 될 것
2. peers 가 1개라면 그 하나의 peer 가 살아있는지 검사
	1. max_connection 보다 높은가?
	2. 죽었는가 
	- 1,2 조건에 해당하지 않으면,  ngx_stream_upstream_rr_peer_get_t 구조체의 current 를 peer 로 설정
   여러개라면?
    - ngx_stream_upstream_get_peer 함수를 수행
		- 이 함수 내에서는 여러 peer 를 순회하면서 아래 조건을 본다
			1. max_connecetion 보다 높은가
			2.max fail 보다 많은가
			3. 죽었는가?
		- 조건에 해당하지 않는 peer 를 얻는다.


하지만, persist 에서 get 하는 방법은 조금 다름

Persist 갱신 조건
	- max conn full

```
		pp
		+-----------+
		|peer_data_t|
		+-----------+
		  |
		  V
		+----+
		|conf|
		+----+
		  |
		  V
		local_cache
		+-------+-------+-------+---+
		|lo_item|lo_item|lo_item|...|
		+-------+-------+-------+---+


		lo_item
		
```

- persist 가 현재 maxconn 상태를 만족하는 경우, 다른 persist persist entry 를 갱신한다. 옮겨간 곳으로
