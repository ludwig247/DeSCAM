//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_CONTROL_H
#define UART_CONTROL_H



#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"
#include "Memory_Interfaces.h"



class Control : public sc_module {
public:

    SC_HAS_PROCESS(Control);

    enum Sections {INIT, RUN};

    Sections section, nextsection;

    reg_files regs;
    rx_data rx_temp;
    tx_data tx_temp;


    CUtoME_IF req;



    bool from_mem;
    bool from_rx;
    bool from_tx;


    unsigned int tx_flag;




    slave_in<CUtoME_IF> req_from_mem;
    slave_out<reg_files> resp_to_mem;


    slave_out<tx_data> ctrl_to_tx;


    slave_in<rx_data> ctrl_from_rx;


    slave_in<unsigned int> TX_flags_in;

    master_out<bool> interrupt;




    Control(sc_module_name name) :
            resp_to_mem("resp_to_mem"),
            req_from_mem("req_from_mem"),
            interrupt("interrupt"),
            ctrl_from_rx("ctrl_from_rx"),
            ctrl_to_tx("ctrl_to_tx"),
            TX_flags_in("TX_flags_in"),
            nextsection(Sections::INIT),
            section(Sections::INIT)
    {
        SC_THREAD(fsm);
    }


    void fsm();


    unsigned int register_CR_command(unsigned int CR_reg, CUtoME_IF u_in) const;
    unsigned int register_SR_command(unsigned int SR_reg, CUtoME_IF u_in) const;
    unsigned int register_TX_command(unsigned int DR_reg, CUtoME_IF u_in) const;

    unsigned int register_RX_event(unsigned int DR_reg1, unsigned int DR_reg2, unsigned int SR_reg2) const;
    unsigned int manage_RX_flags(unsigned int SR_reg1, unsigned int SR_reg2) const;

    unsigned int manage_TX_flags(unsigned int flags, unsigned int SR_reg) const;

    reg_action tx_no_action(tx_data temp, unsigned int flags) const;
    reg_action tx_action(tx_data temp, CUtoME_IF u_in) const;


    unsigned int countones(unsigned int reg) const;

//    unsigned int align_flag(unsigned int reg, unsigned int flag) const;
//    unsigned int align_control(unsigned int reg, unsigned int ctrl) const;
    unsigned int check_interrupt(unsigned int SR_reg, unsigned int CR_reg) const;
    unsigned int parity_bit(unsigned int bitcount) const;

    unsigned int set_tx(unsigned int data) const;

};


void Control::fsm() {
    while (true) {


        if (section == Sections::INIT) {
            regs.CR_reg = 0;
            regs.SR_reg = TXE_FLAG;
            regs.DR_reg = 0;

            nextsection = Sections::RUN;
        }
        if (section == Sections::RUN) {

            from_mem = req_from_mem->nb_read(req);


            if (from_mem) {
                regs.CR_reg = register_CR_command(regs.CR_reg, req);
                regs.SR_reg = register_SR_command(regs.SR_reg, req);
                regs.DR_reg = register_TX_command(regs.DR_reg, req);
                tx_temp.tx_reg = set_tx(req.dataIn);
                tx_temp.r_act = tx_action(tx_temp, req);


            }


            from_rx = ctrl_from_rx->nb_read(rx_temp);


            if (from_rx) {
                regs.DR_reg = register_RX_event(regs.DR_reg, rx_temp.DR_reg, rx_temp.SR_reg);
                regs.SR_reg = manage_RX_flags(regs.SR_reg, rx_temp.SR_reg);
            }

            from_tx = TX_flags_in->nb_read(tx_flag);

            ctrl_to_tx->nb_write(tx_temp);

            if (from_tx) {

                regs.SR_reg = manage_TX_flags(tx_flag, regs.SR_reg);
                tx_temp.r_act = tx_no_action(tx_temp, tx_flag);
            }








            if (check_interrupt(regs.SR_reg, regs.CR_reg) != 0) {


                regs.SR_reg = regs.SR_reg | IP_FLAG;
                interrupt->write(true);
            }


            resp_to_mem->nb_write(regs);


        }


        section = nextsection;

        wait(SC_ZERO_TIME);
    }

}


unsigned int Control::set_tx(unsigned int data) const {

    return ((((data & BYTEMASK)) << 1) | parity_bit(countones(data & BYTEMASK)) | STOPBIT);

}

unsigned int Control::parity_bit(unsigned int bitcount) const {

    if((bitcount % 2) != 0) return PARITYBIT;
    else return 0;
}


unsigned int Control::register_CR_command(unsigned int CR_reg, CUtoME_IF u_in) const{
    if (u_in.addrIn == CR_ADDRESS && u_in.req == ME_WR && u_in.mask == MT_W) {
        return u_in.dataIn;
    }else if (u_in.addrIn == CR_ADDRESS && u_in.req == ME_WR && (u_in.mask == MT_H || u_in.mask == MT_HU)) {
        return (CR_reg & I_HALFWORDMASK) | (u_in.dataIn & HALFWORDMASK);
    }else if (u_in.addrIn == (CR_ADDRESS + 2) && u_in.req == ME_WR && (u_in.mask == MT_H || u_in.mask == MT_HU)) {
        return (CR_reg & HALFWORDMASK) | ((u_in.dataIn << 16) & I_HALFWORDMASK);
    }else if (u_in.addrIn == CR_ADDRESS && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return (CR_reg & I_BYTEMASK) | (u_in.dataIn & BYTEMASK);
    }else if (u_in.addrIn == (CR_ADDRESS + 1) && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return (CR_reg & I_L1_BYTEMASK) | ((u_in.dataIn << 8) & L1_BYTEMASK);
    }else if (u_in.addrIn == (CR_ADDRESS + 2) && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return (CR_reg & I_L2_BYTEMASK) | ((u_in.dataIn << 16) & L2_BYTEMASK);
    }else if (u_in.addrIn == (CR_ADDRESS + 3) && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return (CR_reg & I_L3_BYTEMASK) | ((u_in.dataIn << 24) & L3_BYTEMASK);
    }else{
        return CR_reg;
    }
}

unsigned int Control::register_SR_command(unsigned int SR_reg, CUtoME_IF u_in) const{

    if (u_in.addrIn == SR_ADDRESS && u_in.req == ME_WR && u_in.mask == MT_W) {
        return SR_reg & (u_in.dataIn | SR_BITMASK);
    }else if (u_in.addrIn == SR_ADDRESS && u_in.req == ME_WR && (u_in.mask == MT_H || u_in.mask == MT_HU)) {
        return SR_reg & (u_in.dataIn | SR_BITMASK);
    }else if (u_in.addrIn == SR_ADDRESS  && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return SR_reg & ((u_in.dataIn | I_BYTEMASK) | SR_BITMASK);
    } else if (u_in.addrIn == (SR_ADDRESS + 1)  && u_in.req == ME_WR && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return SR_reg & ((u_in.dataIn << 8) | I_L1_BYTEMASK);
    }else if (u_in.addrIn == SR_ADDRESS &&  u_in.req == ME_RD && u_in.mask == MT_W) {
        return SR_reg & (I_TC & I_PE & I_FE);
    }else if (u_in.addrIn == SR_ADDRESS &&  u_in.req == ME_RD && (u_in.mask == MT_H || u_in.mask == MT_HU)) {
        return SR_reg & (I_TC & I_PE & I_FE);
    }else if (u_in.addrIn == SR_ADDRESS &&  u_in.req == ME_RD && (u_in.mask == MT_B || u_in.mask == MT_BU)) {
        return SR_reg & (I_TC & I_PE & I_FE);
    } else if(u_in.addrIn == DR_ADDRESS && u_in.req == ME_RD &&  (u_in.mask == MT_W || u_in.mask == MT_H || u_in.mask == MT_HU)){
        return SR_reg & I_RXNE;
    }else if(u_in.addrIn == RX_ADDRESS && u_in.req == ME_RD && (u_in.mask == MT_B || u_in.mask == MT_BU)){
        return SR_reg & I_RXNE;
    } else if(u_in.addrIn == TX_ADDRESS && u_in.req == ME_WR && u_in.mask != MT_X){
        return SR_reg & I_TXE;
    } else {
        return SR_reg;
    }



}

unsigned int Control::register_TX_command(unsigned int DR_reg, CUtoME_IF u_in) const{

    if (u_in.addrIn == TX_ADDRESS && u_in.req == ME_WR && u_in.mask != MT_X) {
        return (DR_reg & I_BYTEMASK) | (u_in.dataIn & BYTEMASK);
    }else{
        return DR_reg;
    }

}

reg_action Control::tx_action(tx_data temp, CUtoME_IF u_in) const{
    if (u_in.addrIn == TX_ADDRESS && u_in.req == ME_WR) {
        return TX_WR;
    }else{
        return temp.r_act;
    }


}

reg_action Control::tx_no_action(tx_data temp, unsigned int flags) const{
    if(flags == txe) return NA;
    else return temp.r_act;
}




unsigned int Control::manage_TX_flags(unsigned int flags, unsigned int SR_reg) const{

    if(flags == tc) {
    if(((SR_reg & TXE_FLAG) != 0)){
    return SR_reg | TXE_FLAG | TC_FLAG;
}else{
	return SR_reg;
	}
    }else if((SR_reg & TXE_FLAG) == 0 && flags == txe) return SR_reg | TXE_FLAG;
    else return SR_reg;

}

unsigned int Control::manage_RX_flags(unsigned int SR_reg1, unsigned int SR_reg2) const {

    return SR_reg1 | SR_reg2;
}





unsigned int Control::register_RX_event(unsigned int DR_reg1, unsigned int DR_reg2, unsigned int SR_reg2) const {

    if((SR_reg2 & RXNE_FLAG) != 0){
        return (DR_reg1 & I_L1_BYTEMASK) | (DR_reg2 & L1_BYTEMASK) ;
    }else if((SR_reg2 & FE_FLAG) != 0 || (SR_reg2 & PE_FLAG) != 0){
        return (DR_reg1 & I_L2_BYTEMASK) | (DR_reg2 & L2_BYTEMASK) ;
    }else{
        return DR_reg1;
    }



}

unsigned int Control::countones(unsigned int reg) const {

    return bits(reg); //very messy ITL without it.
}

unsigned int Control::check_interrupt(unsigned int SR_reg, unsigned int CR_reg) const {

    if((SR_reg & IP_FLAG) == 0 || (CR_reg & IP_OVRD) != 0){

        if ((SR_reg & RXNEIE_FLAG) != 0 && (CR_reg & RXNE_FLAG) != 0){
            return 1;
        }else if((SR_reg & TXEIE_FLAG) != 0 && (CR_reg & TXE_FLAG) != 0){//Overriding IP bit for this flag has uncertain results, should work in RTL but breaks ESL simulation
            return 1;
        }else if((SR_reg & TCIE_FLAG) != 0 && (CR_reg & TC_FLAG) != 0){
            return 1;
        }else if((SR_reg & PEIE_FLAG) != 0 && (CR_reg & PE_FLAG) != 0){
            return 1;
        }else if((SR_reg & FEIE_FLAG) != 0 && (CR_reg & FE_FLAG) != 0){
            return 1;
        }else return 0;


    }else return 0;


}






#endif //UART_CONTROL_H
