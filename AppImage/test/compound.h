
#ifndef UART_COMPOUND_H
#define UART_COMPOUND_H

//Protocol Specifications
#define STARTBIT 0
#define STOPBIT 0
#define MINFRAME 5

//Uart Frame Positions
#define STARTBIT_POS 0
#define DATABITS_POS 1
#define PARITYBIT_POS 8
#define STOPBIT_1_POS 10
#define STOPBIT_2_POS 11
#define PE_POS 2
#define FE_POS 1
#define BI_POS 0


//Transmitter Masks
#define TX_WLS 3
#define TX_START 4
#define TX_STB 8
#define TX_PEN 16
#define TX_EPS 32
#define TX_SP 64
#define TX_BC 128

//Receiver Masks
#define RX_WLS 3
#define RX_PEN 4
#define RX_SP	8
#define RX_EPS 16
#define RX_STB 32
#define RX_CTRLWIDTH 8
#define RX_PE 4
#define RX_FE 2
#define RX_BI 1

struct uart_message
{
  unsigned int StartBit;
  unsigned int DataBits;
  unsigned int ParityBit;
  unsigned int StopBitFirst;
  unsigned int StopBitSecond;
};

struct uart_transaction
{
  unsigned int ctrl_reg;
  unsigned int data_reg;
};

#endif //UART_COMPOUND_H
