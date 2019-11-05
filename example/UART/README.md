This README gives and overview of the implementation of the UART protocol 

**content**
* **ESL**: Electronic system level description of UART
* **RTL**: Register transfer level description of UART, subfolders include properties and testbench


# ESL 

A Universal Asynchronous Receiver Transmitter has been written according to the rules of SystemC-PPA.
This implementation is a simplified model of the USART on the STM32f100rb microcontroller, link to 
reference manual can be found [here](https://www.st.com/resource/en/reference_manual/cd00246267.pdf)
This UART is fixed with even parity, 1 stop bit and 8 data bits.

In and out values from rx and tx are abstracted from 11 bits serial to 32 bits parallel (mask all but 11 bits to 0).
An example 11 bit serial value looks as follows:
*[1 0 0 0 0 0 1 1 1 1 0]*
This shows the value 15 when loaded or received to either shiftregister. 
Bit 10: Stop bit = 1
Bit 9: Parity bit = even parity
Bit 8-1: data 
Bit 0: Start bit = 0

The notion of baudrate does not exist on the systemlevel.

The UART is a memory mapped component occupying 12 bytes of memory, using three 32-bit registers.
*Control register (CR)*:
Local address :  0-3
 
Bits 31-16 : Clock division, baudrate will be triggered every sysclk/clk_div (not for ESL)
Bit     12 : Interrupt pending bit override (experimental)
Bit      7 : Enable interrupt for frame error (FEIE)
Bit      6 : Enable interrupt for parity error (PEIE)
Bit      5 : Enable interrupt for empty TX (TXEIE) (not to be confused with shiftregister)
Bit      4 : Enable interrupt for transfer complete (TCIE)
Bit      3 : Enable interrupt for received data (RXNEIE)
Bit      1 : Enable RX baudrate clock (RE) (not for ESL)
Bit      0 : Enable TX baudrate clok (TE) (not for ESL)

*Status register (SR)*:
Local address : 4-7

Bit      7 : Frame error flag (FE)                  (cleared by read or write 0 )
Bit      6 : Parity error flag (PE)                 (cleared by read or write 0)
Bit      5 : Transfer register empty flag (TXE)     (Read only, cleared by write to TX)
Bit      4 : Transfer complete flag (TC)            (cleared by read or write 0)
Bit      3 : Receive register not empty flag (RXNE) (Read only, cleared by reading RX)
Bit      1 : interrupt pending                      (cleared by write 0)

*Data register (DR)*:
Local address : 8-11

Bits 23-16 : Stores faulty received data (FE or PE set, RXNE not set)
Bits  15-8 : RX byte, stores correctly received data (RXNE set, FE and PE not set)
Bits   7-0 : TX byte, stores data to be sent before loaded to shiftregister (TXE cleared when written, set when loaded to shiftregister)


### Memory manager:
Acts simply as an interface to the blocking interface of the master (e.g. CPU).
A write request is directly forwarded to the controller, so any write or effects of read is visible 2 cycles after sync between 
master and UART. Value is available on out port in the next clk cycle after sync with master on a read request. 
Any effects of a read is not visible to the causing read.

### TX: 
The TX module transfers the data using an abstract representation of the tx pin, and a state machine. Upon received write request
TX signals to the controller that value is received, so status register can be updated. Tx receives the entire 11 bit value from the
controller to keep the properties simpler. Entire value is written out in one cycle using a master out port. 
Master ports are chosen over shared ports due to event notification in simulation, shared ports does not work even though they more correctly represent hardware.
Upon finished transfer the controller is notified, and TC is set if TXE is set. 

### RX: 
The RX module "scans" for a 0 in bit position 0, if detected the statemachine proceeds and either correct or erroneous data is loaded 
to the approriate register byte and appropriate flags are set and controller is notified. 

### Control: 
Control reads from and/or writes to all other modules and updates the registers, if an interrupt flag matches a flag in the status register, an interrupt is
generated using master_out<bool>. Simultaneously a interrupt pending bit is set to prevent repeated interrupts from occuring from the same source.
Source of the interrupt should be cleared before clearing IP bit. 

# RTL

### baudrate generator
A simple baudrate generator is written which triggers RX/TX if RE/TE is set respectively
Baudrate is controlled by the top 16 bits of CR (clock divider). Either signal is set high for 1 sysclk cycle
when counter = clock divider. 
Shiftregisters are defined inside a process triggered by the baudrate edge, so a minimum clock divider value of 1 is needed. 

# HoWTo
Set clock divider value and enable TE and/or RE as needed. Either enable desired interrupt sources or operate system
by polling SR for TXE/TC and RXNE. 
When interrupt is generated it is necessary to clear the interrupt source in SR and then clear interrupt pending bit.
Overriding interrupt pending bit will generate false interrupts if source is not rapidly cleared (not tested for RTL).
Signal connected to rx pin must be high upon reset. 






