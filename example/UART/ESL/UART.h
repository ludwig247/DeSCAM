//
//Created by Harald on 24.11.18
//

#ifndef PROJECT_UART_H
#define PROJECT_UART_H






#define LSB 1
#define MSB 128


#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "Req_handler.h"
#include "Uart_registers.h"
#include "dummytrans.h"
#include "dummyrec.h"
#include "dummyinterrupt.h"
#include "baudgen.h"



class UART : public sc_module {
public:

    SC_HAS_PROCESS(UART);

    Uart_registers u_regs;
    Req_handler r_handler;
    dummytrans dummytrans1;
    dummyrec dummyrec1;
    dummyinterrupt dummyinterrupt1;
    baudgen baudgen1;



    blocking_in<CUtoME_IF> uart_in;
    blocking_out<MEtoCU_IF> uart_out;

    shared_in<bool> rx;
    shared_out<bool> tx;

    master_out<bool> interrupt_enabled;

    MasterSlave<unsigned int> Req_to_CR;
    MasterSlave<unsigned int> CR_to_req;
    MasterSlave<unsigned int> Req_to_SR;
    MasterSlave<unsigned int> SR_to_req;
    MasterSlave<unsigned int> Req_to_TX_reg;
    MasterSlave<unsigned int> RX_reg_to_req;
    MasterSlave<unsigned int> RX_reg_from_rec;
    MasterSlave<unsigned int> TX_reg_to_trans;



    MasterSlave<bool> RXNE_from_req;
    MasterSlave<bool> TXE_from_trans;
    MasterSlave<bool> TC_from_trans;
    MasterSlave<bool> PE_from_rec;
    MasterSlave<bool> FE_from_rec;
    MasterSlave<bool> RE_to_rec;
    MasterSlave<bool> TE_to_trans;

    MasterSlave<bool> baud_to_rec;
    MasterSlave<bool> baud_to_trans;

    MasterSlave<unsigned int> CR_int;
    MasterSlave<unsigned int> SR_int;


    UART(sc_module_name name) :
            uart_in("uart_in"),
            uart_out("uart_out"),
            rx("rx"),
            tx("tx"),
            Req_to_CR("Req_to_CR"),
            CR_to_req("CR_to_req"),
            Req_to_SR("Reg_to_SR"),
            SR_to_req("SR_to_req"),
            Req_to_TX_reg("Req_to_TX_reg"),
            RX_reg_to_req("RX_reg_to_req"),
            RX_reg_from_rec("RX_reg_from_rec"),
            TX_reg_to_trans("TX_reg_to_trans"),
            u_regs("u_regs"),
            r_handler("r_handler"),
            dummytrans1("dummytrans1"),
            dummyrec1("dummyrec1"),
            dummyinterrupt1("dummyinterrupt1"),
            baudgen1("baudgen1"),
            interrupt_enabled("interrupt_enabled"),
            RXNE_from_req("RXNE_from_req"),
            TXE_from_trans("TXE_from_trans"),
            TC_from_trans("TC_from_trans"),
            PE_from_rec("PE_from_rec"),
            FE_from_rec("FE_from_rec"),
            RE_to_rec("RE_to_rec"),
            TE_to_trans("TE_to_trans"),
            baud_to_rec("baud_to_rec"),
            baud_to_trans("baud_to_trans"),
            SR_int("SR_int"),
            CR_int("CR_int")

    {
       r_handler.request(uart_in);
       r_handler.response(uart_out);
       r_handler.CR_write(Req_to_CR);
       r_handler.CR_read(CR_to_req);
       r_handler.SR_write(Req_to_SR);
       r_handler.SR_read(SR_to_req);
       r_handler.TX_write(Req_to_TX_reg);
       r_handler.RX_read(RX_reg_to_req);
       r_handler.RXNE_false(RXNE_from_req);

       u_regs.cr_write(Req_to_CR);
       u_regs.cr_read(CR_to_req);
       u_regs.sr_write(Req_to_SR);
       u_regs.sr_read(SR_to_req);
       u_regs.tx_write(Req_to_TX_reg);
       u_regs.rx_read(RX_reg_to_req);
       //Transmitter
       u_regs.tx_send(TX_reg_to_trans);
       u_regs.TE_flag(TE_to_trans);
       u_regs.TXE_flag_in(TXE_from_trans);
       u_regs.TC_flag_in(TC_from_trans);
       //Receiver
       u_regs.RE_flag(RE_to_rec);
       u_regs.RXNE_flag_in(RXNE_from_req);
       u_regs.PE_flag_in(PE_from_rec);
       u_regs.FE_flag_in(FE_from_rec);
       u_regs.rx_receive(RX_reg_from_rec);
       //interrups
       u_regs.SR_to_int(SR_int);
       u_regs.CR_to_int(CR_int);

       //receiver
       dummyrec1.RE_flag_rec(RE_to_rec);
       dummyrec1.PE_flag_rec(PE_from_rec);
       dummyrec1.FE_flag_rec(FE_from_rec);
       dummyrec1.receive_data(RX_reg_from_rec);
       dummyrec1.baudrate_in(baud_to_rec);
       dummyrec1.RX_pin(rx);

       //transmitter
       dummytrans1.TE_flag_trans(TE_to_trans);
       dummytrans1.TXE_flag_trans(TXE_from_trans);
       dummytrans1.TC_flag_trans(TC_from_trans);
       dummytrans1.transfer_data(TX_reg_to_trans);
       dummytrans1.baudrate_in(baud_to_trans);
       dummytrans1.TX_pin(tx);

       dummyinterrupt1.interrupt_enabled(interrupt_enabled);
       dummyinterrupt1.int_from_SR(SR_int);
       dummyinterrupt1.int_from_CR(CR_int);


       baudgen1.trans_trigger(baud_to_trans);
       baudgen1.rec_trigger(baud_to_rec);


    }



};




#endif //PROJECT_UART_H
