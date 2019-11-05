//
// Created by ovsthus on 2/8/19.
//

#ifndef UART_COMPOUND_H
#define UART_COMPOUND_H

#define CR_ADDRESS 0
#define SR_ADDRESS 4
#define RX_ADDRESS 9
#define TX_ADDRESS 8
#define DR_ADDRESS 8


//CR
#define TE_FLAG 1
#define RE_FLAG 2
#define RXNEIE_FLAG 8
#define TCIE_FLAG 16
#define TXEIE_FLAG 32
#define PEIE_FLAG 64
#define FEIE_FLAG 128
#define PAR_CTRL_START 256
#define BAUD_CTRL_START 65536
#define IP_OVRD 4096

#define NO_PARITY 0
#define ODD_PARITY 256
#define EVEN_PARITY 512

//SR
#define TXE_FLAG 32
#define RXNE_FLAG 8
#define TC_FLAG 16
#define PE_FLAG 64
#define FE_FLAG 128
#define IP_FLAG 2

#define SR_BITMASK   40
#define RX_MASK 65280
#define I_RX_MASK -65281
#define BYTEMASK 255
#define I_BYTEMASK -256
#define L1_BYTEMASK 65280
#define I_L1_BYTEMASK -65281
#define L2_BYTEMASK 16711680
#define I_L2_BYTEMASK -16711681
#define L3_BYTEMASK -16777216
#define I_L3_BYTEMASK 16777215



#define HALFWORDMASK 65535
#define I_HALFWORDMASK -65536


#define I_TXE -33
#define I_RXNE -9 //4294967287 //-9 inverse of 8
#define I_TC  -17 //4294967279//-17 inverse of 16
#define I_PE -65
#define I_FE -129
#define I_IP -3;


#define LSB 1
#define MSB 128





enum reg_action {NA, RX_RD, RX_WR, CR_RD, CR_WR, SR_RD, SR_WR, TX_WR};

enum tx_flags {RESET, SET, NF};

struct tx_flag_values{
    tx_flags txe_flag;
    tx_flags tc_flag;
};

struct tx_data{
    unsigned int TX_temp_register;
    reg_action r_act;
};


struct reg_files{
    unsigned int CR_reg;
    unsigned int SR_reg;
    unsigned int DR_reg;

    reg_action r_act;
//    w_out write_out;

};



//struct update_inf{
//    upd_inf upd_inf1;
//};

#endif //UART_COMPOUND_H
