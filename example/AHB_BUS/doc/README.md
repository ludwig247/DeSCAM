This README is a quick explanation of the contents of the AHB_gen folder.

**content**

* **Docs**: Diagrams of the system, amba spec.
* **ESL**: System level description of an ahb bus, currently 4 masters and 3 slaves, no burst.
* **GEN**: RTL files of the system, stripped for use for generation.
* **RTL**: Contains various RTL descriptions of the ahb bus, with properties, only Latest folder is relevant.

# ESL 
This folder contains a system level description of an AHB bus with 4 masters and 3 slaves, using only single transfer (no burst) and where reads and
writes are treated as the same operation (this would be differentiated within the master and slave for now, to save on states and properties).

### Master Agent
A system level master agent description is needed for property generation to be feasible, The masters have too much parallel behaviour to be verified in the same cluster. 
The master agent FSM is easily modelled using blocking ports.
![Agent_FSM](Docs/mAgent_FSM.png)
The request is modelled by writing an arbitrary boolean value to the blocking port *agent_request*. 
Reading this port on the other side acts as grant. 
Data and control are written to the bus upon entering request phase using a shared port *bus_to_agent*.

The *bus_ready* signal is modelled the same way, where agents write to be blocked, and a read on the other side acts as ready signal.

Agents write arbitrary boolean value to *bus_ready* port in address and data phase. 
After data ready is issued the shared in port *bus_to_agent* containing the data is read, agent enters response phase and agent writes data back to master before returning to idle. 

Error phase has been removed to close a gap in the verification cause by the two cycle error response and above mentioned blocking ready port. 
Without pipelined behaviour internally in the agent it is not needed, for now it is modelled within the data phase. 

### Bus

The system level has, much like the RTL, 3 phases; idle, address and data.
![Bus_FSM](Docs/Bus_FSM.png)

The challenge in modelling an ahb bus is knowing what state is next, since any master can request at any point. 
This can be modelled with high abstraction by simply storing the requesting masters data, address and control signals in a compound, and ensuring that the
package makes its way to its destination. All masters receive the same response always, with grant as an exception, so slave responses do not need
to differentiate between masters. No more than a single slave can be active at any point. 
The signal *htrans* from the diagram is in RTL the control signal used to trigger operation in slaves, a *nonseq* value inititates activity in selected slave. 
It can only be active for these master agents when they are in the address phase, and is therefore used together with requests to determine which state follows data phase. 

In all phases an arbitrary boolean value is written (non blocking) to the *grant_ready* port, which is the other side of the agents
*agent_request* and *bus_ready* ports. The pipelined bus behaviour can be modelled using this 2->1 port, whos behaviour is described in the *custom_port* module.
The shared ports *agent_to_bus(x)* are simultaneously read to fetch any requests and data/address and control signals.
  
If there is a request, the data, address and control signal from the highest priority requesting agent are stored in compound *request*.
Upon entry to data phase the contents of *request* are copied to *request_pipelined*.
In the data phase the slaves are selected based on the address copied into *request_pipelined*, the address offset is subtracted before the compound is written
to the slave. The address offset is immediately added back to the address to simplify property macros.
A wait state is used to add an extra state so that the difference between ok and error response can be abstracted away (see RTL).

The *bus_to_agent* shared port is set in every conceptual state to satisfy completeness, and although the grant for every master is functionally represented by
the custom_port, the value needs to be determined at every point to satisfy completeness. This is done by writing an enum value m(X)_grant to every master, and redefining
this enum as a boolean in the properties, and using a macro to determine what value m(x)_grant has at any point. Since this is a combinational output, it can not be
represented at time t+1 with anything other than a function. 


### custom_port

![custom_port](Docs/port_diagrams.png)

All masters are connected on the "left hand side (lhs)" with their *agent_request* and *bus_ready* ports.
The bus is connected on the "right hand side (rhs)" with its *grant_ready* port.

This reads (blocking) its side of *grant_ready*, when unblocked the module atomically unblocks the highest priority requesting master
and all masters blocked on ready before itself is blocked again on *grant_ready*.


### issues
timing issue 1:
When all master dummies are re-requesting with no delay, a fourth master is never granted the bus unless all masters are requesting out of range. 
the time between end of data phase and a new request in master agent is then less than 3x bus in data phase for no slave selected. In this case a fourth master
is granted the bus in hardware. This behaviour is not represented on the systemlevel because master agents have zero time delay here. 
It is assumed that any master will have some form of error handling, so a delay if received error can be introduced in the master dummies to remove this issue. 

timing issue 2:
On the bus side the *grant_ready* port is chosen as an out port because of the wait state called for every non blocking write (as opposed to non blocking read).
Because of requests being modelled through both shared port and blocking port, there is at times a mismatch between which master is granted (agent unblocked) and
which masters request is processed. 
In order to fix this a port type is needed ensures proper behaviour (work in progress). 

#GEN
The folder gen containts empty top level and bus matrix to be used for automatic generation of bus.

#RTL

The AHB bus used in this design is *ahb_system_generator* found [here](https://github.com/freecores/ahb_system_generator)
A minor modification to the arbiter.vhdl is necessary to make property generation through DeSCAM possible.
The default slave in this design originally constantly provides an error response, regardless of control signals. 
This makes property generation an verification impossible, as well as it is a slight violation of the spec (see page 53, or 3-19 of amba_spec.pdf)
To match the spec the default slave behaviour in the arbiter.vhdl is modified, and property generation and verification becomes possible.



## Agents
Master and slave agents have been designed to interface masters and slaves designed with DeSCAM (blocking ports) to the AHB bus.
The agents only support single transfer, and does not differentiate between reads and writes because the status (ok or error) 
is always written back to the master. Differentiating between read and writes can save 1 clock cycle for reads in this case, at
the cost of higher complexity on the system level and verification. 
 

### Master Agent
Has been mostly described under ESL.

Does not support the split or retry response. 


### Slave Agent
![slave_FSM](Docs/slave_agent_fsm.png)

Slave agent samples address, control and as according to AHB spec, and inserts wait states by driving ready signal low. 
The waits states are inserted to allow give agent time to communicate request to slave, and get response.
If the slave responds with error, the error response is given. 
The outputs are registered (gives 1 clk cycle delay) to simplify property generation and verification. 


# Verification

![Verification diagram](Docs/Verification_block_diagram.png)

Design is split in clusters for verification, master agents and the rest of the system, where the states of the master agents are used as an output 
to their clusters to aid in verification of the main cluster.

The custom port is on the main cluster side defined as all combinations of *hready* and *hgrant* it is supposed to represent.
The grant must however be represented as a seperate signal to satisfy completeness.
The ready signal does not need that, only using an assertion that all ready signals are equal. 






