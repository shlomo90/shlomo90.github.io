# Docker

## Network drivers

* bridge
    * Bridge networks are ususally used when your applications run in standalone containers that need to
      communicate
* host
    * For standalone containers. use the host's networking directly

* overlay
    * overlay networks connect multiple Docker daemons together
* macvlan
    * Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device
    * The docker daemon routes traffic to containers by their MAC addresses.


### macvlan

* It allows a single physical interface to have multiple mac and ip addresses using macvlan sub-interfaces.
* With macvlan, each sub-interface will get unique mac and ip address and will be exposed directly in underlay
  network.

### bridge

* In linux bridge implementation, VMs or Containers will connect to bridge and bridge will connect to outside
  world.


### ipvlan

* It's similar to macvlan with the difference being that the endpoints have the same **mac address**.


## References

* https://sreeninet.wordpress.com/2016/05/29/macvlan-and-ipvlan/
