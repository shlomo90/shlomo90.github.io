
# Promiscuous mode 

* Wikipedia says
  * NIC, WNIC 으로 받은 트래픽 패킷을 단순히 넘겨버리기보단 CPU 까지 전달하는 것
  * 이 모드는 일반적으로 packet sniffing 에 사용
  * Ethernet 또는 IEEE 802.11 에서는 자신에게 온 MAC주소가 아닌 경우,
    * Non-promiscuous mode 에서는 drop.
    * Promiscuous mode 에서는 NIC 이 모든 프래임을 받도록 허락한다.
