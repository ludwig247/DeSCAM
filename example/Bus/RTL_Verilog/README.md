SystemVerilog Bus Implementation
===

This folder contains 2 bus implementations in SV.

* A **parallel** implementation, `Bus.sv`
* A **serial** implementation, `Bus_serial.sv`

The bus system is a Master/Slave bus system with one master and four slaves, as described in `Bus.h`.

---

## `Bus_serial.sv`
This design implements the following bus protocol:

Request:

* 1 read/write bit
* 5 address bits
* 32 data bits

, a total of 38 request bits.

Respond:

* 1 ack bit
* 32 data bits

, a total of 33 respond bits.

The properties used for developing this implementation can be found in the file `Properties/Bus_serial.sva`. This file uses the `OneSpin` `tidal` library, and thus some changes to the ipc was needed, and is found in `Properties/ipc_serial.sva`. The file `Properties/Bus_serial.gfv` contains the needed completeness info for Gap-Free Verification in `OneSpin` using `tidal`.

**Note:**
At the very top of `Properties/Bus_serial.sva`, the parameter `next_shift_amount` is defined to be 37. This is used by the functions in the ipc file to implement a virtual `next` function: by shifting forward and using the SV system function `$past`, we can obtain "future" values of signals.

## `Bus.sv`
This design implements a parallel bus with

* 1 read/write bit
* 32 address bits
* 32 data bits

for requests and

* 1 ack bit
* 32 data bits

for responds.

The properties used for developing this implementation are found in the file `Properties/Bus.sva`. This file does not use the `OneSpin` `tidal` library, but includes the ipc functions in `Properties/ipc.sva`.
