//
// Created by ovsthus on 18.01.19.
//

#ifndef UART_UART_REGISTERS_H
#define UART_UART_REGISTERS_H


//CR
#define TE_FLAG 1
#define RE_FLAG 2
#define RXNEIE_FLAG 8
#define TCIE_FLAG 16
#define TXEIE_FLAG 32
#define PEIE_FLAG 64
#define FEIE_FLAG 128

//SR
#define TXE_FLAG 1
#define RXNE_FLAG 2
#define TC_FLAG 4
#define PE_FLAG 8
#define FE_FLAG 16


#include "systemc.h"
#include "Interfaces.h"




class Uart_registers : public sc_module {
public:

    SC_HAS_PROCESS(Uart_registers);

    unsigned int CR_reg = 0;
    unsigned int SR_reg = TXE_FLAG;
    unsigned int RX_reg = 0;
    unsigned int TX_reg = 0;

    bool TC_flag = false;
    bool RXNE_flag = false;
    bool TXE_flag;
    bool PE_flag = false;
    bool FE_flag = false;
    bool init = true;

    slave_out<unsigned int> CR_to_int;
    slave_out<unsigned int> SR_to_int;

    slave_in<unsigned int> cr_write;
    slave_in<unsigned int> sr_write;
    slave_in<unsigned int> tx_write;
    slave_in<unsigned int> rx_receive;
    slave_out<unsigned int> cr_read;
    slave_out<unsigned int> sr_read;
    slave_out<unsigned int> rx_read;
    slave_out<unsigned int> tx_send;

    slave_out<bool> TE_flag;
    slave_out<bool> RE_flag;
    slave_in<bool> RXNE_flag_in;
    slave_in<bool> TC_flag_in;
    slave_in<bool> TXE_flag_in;
    slave_in<bool> PE_flag_in;
    slave_in<bool> FE_flag_in;



    Uart_registers(sc_module_name name) :
            CR_to_int("CR_to_int"),
            SR_to_int("SR_to_int"),
            cr_write("cr_write"),
            cr_read("cr_read"),
            sr_write("sr_write"),
            sr_read("sr_read"),
            tx_write("tx_write"),
            tx_send("tx_send"),
            rx_read("rx_read"),
            rx_receive("rx_receive"),
            TE_flag("TE_flag"),
            RE_flag("RE_flag"),
            TC_flag_in("TC_flag_in"),
            RXNE_flag_in("RXNE_flag_in"),
            TXE_flag_in("TXE_flag_in"),
            PE_flag_in("PE_flag_in"),
            FE_flag_in("FE_flag_in")
    {
        SC_THREAD(fsm);
    }


    void fsm();

};


void Uart_registers::fsm(){
    while(true) {



        if(cr_write->nb_read(CR_reg)){

        }
        if(sr_write->nb_read(SR_reg)){}
        if(tx_write->nb_read(TX_reg)){
            SR_reg &= ~TXE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
            tx_send->nb_write(TX_reg); //write to transmitter if TX_reg not empty

        }
        if(rx_receive->nb_read(RX_reg)){
            SR_reg |= RXNE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);

        }
        rx_read->nb_write(RX_reg);


        //ENABLE FLAGS START
        TE_flag->nb_write(CR_reg & TE_FLAG);
        RE_flag->nb_write(CR_reg & RE_FLAG);
        //ENABLE FLAGS END


        //REGISTER UPDATE START
        if(RXNE_flag_in->nb_read(RXNE_flag)) {
            if (RXNE_flag) SR_reg |= RXNE_FLAG;
            else SR_reg &= ~RXNE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
        }



        if(TXE_flag_in->nb_read(TXE_flag)) {
            if (TXE_flag) SR_reg |= TXE_FLAG;
            else SR_reg &= ~TXE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
        }



        if(TC_flag_in->nb_read(TC_flag)) {
            if (TC_flag) SR_reg |= TC_FLAG;
            else SR_reg &= ~TC_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
        }



        if(PE_flag_in->nb_read(PE_flag)) {
            if (PE_flag) SR_reg |= PE_FLAG;
            else SR_reg &= ~PE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
        }



        if(FE_flag_in->nb_read(FE_flag)) {
            if (FE_flag) SR_reg |= FE_FLAG;
            else SR_reg &= ~FE_FLAG;
            sr_read->nb_write(SR_reg);
            SR_to_int->nb_write(SR_reg);
        }


        CR_to_int->nb_write(CR_reg);

        //REGISTER UPDATE END

        cr_read->nb_write(CR_reg);
        sr_read->nb_write(SR_reg);


        //INTERRUPT FLAGS START




        wait(SC_ZERO_TIME);
    }
}




#endif //UART_UART_REGISTERS_H
