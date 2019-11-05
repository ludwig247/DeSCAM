//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_COMPOUND_H
#define UART_COMPOUND_H


#define CR_ADDRESS 0
#define SR_ADDRESS 4
#define RX_ADDRESS 9
#define TX_ADDRESS 8
#define DR_ADDRESS 8




//CR

#define RXNEIE_FLAG 8
#define TCIE_FLAG 16
#define TXEIE_FLAG 32
#define PEIE_FLAG 64
#define FEIE_FLAG 128

#define IP_OVRD 4096



//SR
#define TXE_FLAG 32
#define RXNE_FLAG 8
#define TC_FLAG 16
#define PE_FLAG 64
#define FE_FLAG 128
#define IP_FLAG 2

#define SR_BITMASK   40

#define BYTEMASK 255
#define I_BYTEMASK -256
#define L1_BYTEMASK 65280
#define I_L1_BYTEMASK -65281
#define L2_BYTEMASK 16711680
#define I_L2_BYTEMASK -16711681
#define L3_BYTEMASK -16777216
#define I_L3_BYTEMASK 16777215

#define BUFFERMASK 2047


#define HALFWORDMASK 65535
#define I_HALFWORDMASK -65536


#define I_TXE -33
#define I_RXNE -9 //4294967287 //-9 inverse of 8
#define I_TC  -17 //4294967279//-17 inverse of 16
#define I_PE -65
#define I_FE -129
#define I_IP -3;




#define bits(x) ((x & 1) + ((x >> 1) & 1) + ((x >> 2) & 1) + ((x >> 3) & 1) + ((x >> 4) & 1) + ((x >> 5) & 1)+ ((x >> 6) & 1) + ((x >> 7) & 1))


#define PARITYBIT 512
#define STOPBIT 1024
#define INVERTED_STARTBIT 1


enum reg_action {NA, TX_WR};

#define txe 1
#define tc 2


struct tx_data{
    unsigned int tx_reg;
    reg_action r_act;
};


struct rx_data{
    unsigned int SR_reg;
    unsigned int DR_reg;
};


struct reg_files{
    unsigned int CR_reg;
    unsigned int SR_reg;
    unsigned int DR_reg;

};




#endif //UART_COMPOUND_H
