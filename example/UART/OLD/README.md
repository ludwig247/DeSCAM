This readme gives an overview of the UART and its operation.

**Content:**
- *ESL*: Electronic system level description of Universal Asynchronous Receiver Transmitter (UART)
- *RTL*: RTL design of UART including testbench and properties

# Electronic System Level (ESL):

The UART top level has the following communication ports: 
- *blocking_in<CUtoME_IF> request* : Used to send a read/write request to the UART.
- *blocking_out<MEtoCU_IF> response* : Used to read requested data. 
- *shared_in<bool> rx* : Serial data input.
- *shared_out<bool> tx* : Serial data output.
- *master_out<bool> interrupt* : Signals when interrupt has been triggered.

It is comprised of 5 modules.

### Control:
Communicates data/control signals to and from *RX* and *TX*, slave.

### Memory_manager:
Acts as interface to *Control* to enable blocking communication with CPU.

### baudgen: 
Toggles r/w in *RX* and *TX* respectively, with frequency determined by received clock divider and system clock.
In ESL simulation, due to low level of abstraction and asynchronous communication, scheduler needs to be "fixed" by use of masterslave or blocking ports rather than the current shared ports. 

### TX:
Sends serial byte.

### RX:
Receives serial byte.

# Registers:
UART has three 32 bit registers that can be read as word, 2 halfwords or bytewise.

### Control Register (CR):
Local address 0-3, with lower 16 bits for control, and upper 16 bits for clock divider.
*[0]*: Transfer Enable (TE)
*[1]*: Receive Enable (RE)
*[3]*: Receive Register Not Empty Interrupt Enable (RXNEIE)
*[4]*: Transfer Complete Interrupt Enable (TCIE)
*[5]*: Transfer Register Empty Interrupt Enable (TXEIE)
*[6]*: Parity Error Interrupt Enable (PEIE)
*[7]*: Frame Error Interrupt Enable (FEIE) 
*[8:9]*: Parity control; 0 - No parity, 1 - Odd parity, 2 - Even parity.
*[12]*: Override IP flag, disables the need to clear Interrupt Pending flag. 

*[16:31]*: Baudrate trigger for *RX/TX* toggles every time system clock counts to this value.

### Status Register (SR):
Local address 4-7, with only lower 8 bits currently implemented.
*[1]*: Interrupt Pending (IP): Written when interrupt is triggered, no new interrupt is triggered until cleared by software. 
*[3]*: Receive Register Not Empty (RXNE): Data received, correct if (PE & FE) = 0. Cleared when data is read from register. 
*[4]*: Transfer Complete (TC): Set when data is sent and transfer register is empty, cleared by reading SR or writing 0 to bit position.
*[5]*: Transfer Register Empty (TXE): Indicates data is loaded into shiftregister. Only set and cleared by implementation.
*[6]*: Parity Error (PE): Set when received parity bit is incorrect, cleared by reading SR or writing 0 to bit position. 
*[7]*: Frame Error (FE): Set when received stop bit is incorrect, cleared by reading SR or writing 0 to bit position.

### Data Register (DR):
Local address 8-11, with upper 16 bits currently not implemented.
*[0:7]*: Transfer register.
*[8:15]*: Receive register.

# Operation options:

### Without interrupts:
Simple busy waiting, poll *SR* for appropriate flags before any attempt to r/w *RX/TX*.

### With interrupts:
Set the desired *IE* flag in *CR*, when corresponding flag is set in *SR* an interrupt is simultaneously triggered. 
Read *SR* to determine interrupt source and/or clear interrupt source before clearing IP flag.


# Timing:
When data is requested (read request *ME_RD*) from CPU, data is available on response port in the next clock cycle. 
The effects of the read can be "seen" two clock cycles after the request.

If request is a write to TX, if TX is ready then data is loaded to shiftregister 3 clock cycles after request. (TXE is set the following clock cycle).

When data is received on RX it it can be read 2 clock cycles after stop bit + baudrate trigger. RXNE and interrupt (if enabled) is simultaneously set, and RX is ready to receive new data. 

Serial data packet is expected to be 8 bits for data, 1 bit for parity (if enabled), and 1 stop bit. 
Each bit is sent/received with frequency determined by *sysclk/clockdiv* (see *CR*). 

 



 


