---
layout: post
comments: true
---

# Terminology

## RX/TX

* RX
    * "Received Data"
* TX
    * "Transmitted Data"

The meaning of RX/TX may differ depending on DTE, DCE. Let's figure them out.

* DTE
    * Data Terminal Equipment.
    * This would usually be a terminal or a printer, or equipment emulating those.
* DCE
    * Data Communications Equipment
    * This would usually be a modem or other WAN interface

* On a piece of DTE, the pin labelled "Transmitted Data" does send data.
* On a pices of DCE, the pin known as "Transmitted Data" is actually an input, which receives the signal from the DTE.
* The PC's serial port will also be configured as DTE.
* PC or NIC cards are generally considered as DTE devices while Modems and CSU/DSU are considered as DCE

* The primary differnce between DCE and DTE is clocking (Something sends clocking signal)
    * if a device acts as a DTE, then it expects clocking and certain cable signals to be proviced.
    * DCE supplies clocking and certian cable signal (DCD, DSR, CTS, etc)
    * clock signal
        * It oscillates between a high and a low state and is used like a metronome to cooridinate actions of digital circuits.
