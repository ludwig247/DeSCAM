//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_UART_H
#define UART_UART_H



#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"

#include "TX.h"
#include "RX.h"
#include "Control.h"
#include "Memory_manager.h"


class UART : public sc_module {
public:

    SC_HAS_PROCESS(UART);


    TX TX1;
    RX RX1;

    Control ctrl1;
    Memory_manager mem_man;



    blocking_in<CUtoME_IF>request;
    blocking_out<MEtoCU_IF> response;

    master_in<unsigned int> rx;
    master_out<unsigned int> tx;



    master_out<bool> interrupt;
    MasterSlave<rx_data> RX_reg_from_rec;
    MasterSlave<tx_data> TX_reg_to_trans;
    MasterSlave<CUtoME_IF> mem_to_ctrl;
    MasterSlave<reg_files> ctrl_to_mem;





    MasterSlave<unsigned int> trans_to_reg_flags;



    UART(sc_module_name name) :
            mem_to_ctrl("mem_to_ctrl"),
            ctrl_to_mem("ctrl_to_mem"),
            mem_man("mem_man"),
            trans_to_reg_flags("trans_to_reg_flags"),
            rx("rx"),
            tx("tx"),
            RX_reg_from_rec("RX_reg_from_rec"),
            TX_reg_to_trans("TX_reg_to_trans"),
            ctrl1("controller1"),
            TX1("Transmitter1"),
            RX1("Receiver1"),
//            baudgen1("baudgen1"),
            interrupt("interrupt")



    {
        mem_man.bus_to_mem_man(request);
        mem_man.mem_man_to_bus(response);

        mem_man.mem_man_to_ctrl(mem_to_ctrl);
        mem_man.ctrl_to_mem_man(ctrl_to_mem);

        ctrl1.req_from_mem(mem_to_ctrl);
        ctrl1.resp_to_mem(ctrl_to_mem);

        //Transmitter
        ctrl1.ctrl_to_tx(TX_reg_to_trans);
        ctrl1.TX_flags_in(trans_to_reg_flags);

        //Receiver

        ctrl1.ctrl_from_rx(RX_reg_from_rec);
        //receiver
        RX1.rx_to_ctrl(RX_reg_from_rec);

        RX1.RX_pin(rx);

        //transmitter
        TX1.TX_flags_out(trans_to_reg_flags);
        TX1.tx_from_ctrl(TX_reg_to_trans);


        TX1.TX_pin(tx);


        ctrl1.interrupt(interrupt);
    }
};



#endif //UART_UART_H
