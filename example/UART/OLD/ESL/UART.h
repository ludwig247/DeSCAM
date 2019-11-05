//
//Created by Harald on 24.11.18
//

#ifndef PROJECT_UART_H
#define PROJECT_UART_H



#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "baudgen.h"
#include "TX.h"
#include "RX.h"
#include "Control.h"
#include "Memory_manager.h"


class UART : public sc_module {
public:

    SC_HAS_PROCESS(UART);


    TX TX1;
    RX RX1;
    baudgen baudgen1;
    Control ctrl1;
    Memory_manager mem_man;



    blocking_in<CUtoME_IF>request;
    blocking_out<MEtoCU_IF> response;

    master_in<bool> rx;
    master_out<bool> tx;



    master_out<bool> interrupt;
    MasterSlave<reg_files> RX_reg_from_rec;
    MasterSlave<tx_data> TX_reg_to_trans;
    MasterSlave<CUtoME_IF> mem_to_ctrl;
    MasterSlave<reg_files> ctrl_to_mem;



    Shared<unsigned int> RE_to_rec;
    Shared<unsigned int> TE_to_trans;
    Shared<unsigned int> parity_control_tx;
    Shared<unsigned int> parity_control_rx;

    MasterSlave<tx_flag_values> trans_to_reg_flags;

//    Blocking<bool> baud_to_rec;
//    Blocking<bool> baud_to_trans;
    Shared<bool> baud_to_rec;
    Shared<bool> baud_to_trans;
    Shared<unsigned int> baud_control;


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
            baudgen1("baudgen1"),
            interrupt("interrupt"),
            parity_control_tx("parity_control_tx"),
            parity_control_rx("parity_control_rx"),
            RE_to_rec("RE_to_rec"),
            TE_to_trans("TE_to_trans"),
            baud_to_rec("baud_to_rec"),
            baud_to_trans("baud_to_trans"),
            baud_control("baud_control")


    {
        mem_man.bus_to_mem_man(request);
        mem_man.mem_man_to_bus(response);

        mem_man.mem_man_to_ctrl(mem_to_ctrl);
        mem_man.ctrl_to_mem_man(ctrl_to_mem);

        ctrl1.req_from_mem(mem_to_ctrl);
        ctrl1.resp_to_mem(ctrl_to_mem);
        ctrl1.Parity_control_TX(parity_control_tx);
        ctrl1.Parity_control_RX(parity_control_rx);
        ctrl1.Baudrate_control(baud_control);

        //Transmitter
        ctrl1.TX_reg_to_shiftreg(TX_reg_to_trans);
        ctrl1.TX_flags_in(trans_to_reg_flags);
        ctrl1.TE_flag_out(TE_to_trans);
        //Receiver
        ctrl1.RE_flag_out(RE_to_rec);
        ctrl1.shiftreg_to_RX_reg(RX_reg_from_rec);



        //receiver
        RX1.RE_flag_in(RE_to_rec);
        RX1.shiftreg_to_RX_reg(RX_reg_from_rec);
        RX1.baudrate_in(baud_to_rec);

        RX1.RX_pin(rx);
        RX1.Parity_control_in(parity_control_rx);

        //transmitter
        TX1.TE_flag_in(TE_to_trans);
        TX1.TX_flags_out(trans_to_reg_flags);
        TX1.TX_reg_to_shiftreg(TX_reg_to_trans);
        TX1.baudrate_in(baud_to_trans);

        TX1.TX_pin(tx);
        TX1.Parity_control_in(parity_control_tx);

        ctrl1.interrupt(interrupt);



        baudgen1.trans_trigger(baud_to_trans);
        baudgen1.rec_trigger(baud_to_rec);

        baudgen1.baudrate_control(baud_control);

    }



};



#endif //PROJECT_UART_H
