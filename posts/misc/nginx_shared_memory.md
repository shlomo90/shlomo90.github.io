# Shared Memory

## Init process

persist 를 예시로 한다.

1. ngx_http_upstream_persist 함수는 parsing 타임에서 "persist" directive 를 만나면 수행됨
    - 이 과정에서 uscf->peer.init_upstream 에 ngx_http_upstream_init_persist 함수가 설정
    - 이는 아래 2번에서 수행됨

2. 1. 번은 ngx_http_block 함수에서 http block 내부 directive 를 파싱하기전에 각 모든 http 모듈 관련하여
   create main_conf 를 만들고, 내부 directive 를 파싱한 후에 init_main_conf 를 수행
   여기서 ngx_http_upstream_init_main_conf 함수에서 수행이 됨.
   여기서 각 모듈의 uscf->peer.init_upstream 함수 포인터 가 호출 (즉, ngx_http_upstream_init_persist 수행)

    2-1. ngx_http_upstream_init_persist 수행 시, shm_zone 을 추가하고, 여기에 shm_zone->init 을 설정


3. parsing  이 모두 종료가 되고나서, shared memory 를 초기화 합니다. 
   cycle->shared_memory.part 에 각각 모듈에서 필요한 shared memory 를 list 로 추가가 되고
   일괄적으로 for 문을 돌면서 각각의 shm_zone (part->elts 배열)를 순회하면서 아래를 수행

    3-1. ngx_shm_alloc 
        - shm_zone[i].shm 을 가지고 shm_zone[i].shm->addr 를 할당합니다. (mmap 사용)
        - 이 때, mmap 을 사용하여 할당을 하는데 그 사이즈를 ngx_http_upstream_init_persist 에서 
          ngx_shared_memory_add 함수 호출 시 사용된 사이즈이다.
    3-2. ngx_init_zone_pool
        - shm_zone 구조체 자체를 init 한다.
        - 즉, 3-1 에서 할당된 사이즈를 가지고 관리하기위한 메타데이터를 설정(시작포인트, 끝 포인트. 등등..)
        - 또한 뮤텍스 락 등등
        - slab 데이터 초기화
    3-3. shm_zone[i].init()
        - 앞서 2-1 에서 설정한 함수포인터가 수행 (즉, ngx_http_upstream_persist_init_shm_zone 호출)


ngx_slab 구조체 공부가 필요하다. 

