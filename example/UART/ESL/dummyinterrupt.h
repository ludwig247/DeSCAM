//
// Created by ovsthus on 1/23/19.
//

#ifndef UART_DUMMYINTERRUPT_H
#define UART_DUMMYINTERRUPT_H

#include "systemc.h"
#include "Interfaces.h"

//CR
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


class dummyinterrupt : public sc_module {
public:

    SC_HAS_PROCESS(dummyinterrupt);

    unsigned int CR_reg;
    unsigned int SR_reg;



    master_out<bool> interrupt_enabled;

    master_in<unsigned int> int_from_CR;
    master_in<unsigned int> int_from_SR;

    dummyinterrupt(sc_module_name name) :
        int_from_CR("int_from_CR"),
        int_from_SR("int_from_SR"),
        interrupt_enabled("interrupt_enabled")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void dummyinterrupt::fsm(){
    while(true) {

        int_from_CR->read(CR_reg);
        int_from_SR->read(SR_reg);

        if((CR_reg & RXNEIE_FLAG) && (SR_reg & RXNE_FLAG)){
            interrupt_enabled->write(true);
        }
        if((CR_reg & TXEIE_FLAG) && (SR_reg & TXE_FLAG)){
            interrupt_enabled->write(true);
        }
        if((CR_reg & TCIE_FLAG) && (SR_reg & TC_FLAG)){
            interrupt_enabled->write(true);
        }
        if((CR_reg & PEIE_FLAG) && (SR_reg & PE_FLAG)){
            interrupt_enabled->write(true);
        }
        if((CR_reg & FEIE_FLAG) && (SR_reg & FE_FLAG)){
            interrupt_enabled->write(true);
        }

        wait(SC_ZERO_TIME);
    }
}



#endif //UART_DUMMYINTERRUPT_H
