

**Hardware interrupt**

1. is an electronic signal issued by an external (to the processor) hardware device, to communicate that
   it needs attention from the operating system(OS). [Wiki]

**Masking**

- The processor can ignore interrupt request or take by checking interrupt mask.
  Some interrupt signals are not affected by the interrupt mask and therefore cannot be disabled (NMI)

- call_softirq
	- 어셈블리어로 됨
	- 어셈블리어 내부에서 __do_softirq 함수 수행

**softirq**

- 각 프로세스마다 ksoftirqd 를 가짐
- cpu 가 online 인 경우에만 수행이 됨
	- cpu 는 항상 모두 동작하지 않음. 저전력을 위해 필요한 cpu 만 online 됨
- cpu 가 offline 인 경우 수행되지 않음
- cpu 가 offline 인 뜻은 cpu 자원을 모두 사용할 필요가 없다는 

-------------------------------------------------------------------------------------------

What is the 크래시 유틸? 

wake_up_interruptible 수행 시, 기존 wait_event_interruptible 에서 설정된 (set_current_state 함수이용해서) 가 부활

-------------------------------------------------------------------------------------------
Ref

softirq
- http://jake.dothome.co.kr/softirq/
- http://egloos.zum.com/rousalome/v/9978671

PDF 
- https://www.sciencedirect.com/topics/engineering/interrupt-service-routine
