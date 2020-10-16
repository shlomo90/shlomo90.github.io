# Browser traffic send analysis

* Browser 내에서 트래픽을 어떻게 쏘는지 확인

## Firefox

* F5 새로고침 시
    * 기존 Session 을 끊음 (Fin Packet 전송)
    * 다시 Syn Packet 전송

* New Tab 에서 새로 요청 시
    * 새로운 Syn Packet 전송
