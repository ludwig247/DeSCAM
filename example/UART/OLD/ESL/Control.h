//
// Created by ovsthus on 08.05.19.
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
    reg_files regs2;
    tx_data tx_temp;
    tx_flag_values tx_flag;

    CUtoME_IF req;









    slave_in<CUtoME_IF> req_from_mem;
    slave_out<reg_files> resp_to_mem;


    slave_out<tx_data> TX_reg_to_shiftreg;
    slave_in<reg_files> shiftreg_to_RX_reg;
    slave_in<tx_flag_values> TX_flags_in;

    master_out<bool> interrupt;

    shared_out<unsigned int> Baudrate_control;
    shared_out<unsigned int> Parity_control_TX;
    shared_out<unsigned int> Parity_control_RX;
    shared_out<unsigned int> TE_flag_out;
    shared_out<unsigned int> RE_flag_out;



    Control(sc_module_name name) :
            resp_to_mem("resp_to_mem"),
            req_from_mem("req_from_mem"),
            interrupt("interrupt"),
            shiftreg_to_RX_reg("shiftreg_to_RX_reg"),
            TX_reg_to_shiftreg("TX_reg_to_shiftreg"),
            TX_flags_in("TX_flags_in"),
            Baudrate_control("Baudrate_control"),
            Parity_control_TX("Parity_control_TX"),
            Parity_control_RX("Parity_control_RX"),
            TE_flag_out("TE_flag_out"),
            RE_flag_out("RE_flag_out"),
            nextsection(Sections::INIT),
            section(Sections::INIT)
    {
        SC_THREAD(fsm);
    }


    void fsm();


    unsigned int register_CR_command(unsigned int CR_reg, CUtoME_IF u_in) const;
    unsigned int register_SR_command(unsigned int SR_reg, CUtoME_IF u_in) const;
    unsigned int register_TX_command(unsigned int DR_reg, CUtoME_IF u_in) const;

    unsigned int register_RX_event(unsigned int DR_reg1, reg_files regs_2) const;

    unsigned int manage_TX_flags(tx_flag_values flags, unsigned int SR_reg) const;
    unsigned int manage_RX_flags(unsigned int SR_reg1, reg_files reg_2) const;
    reg_action tx_no_action(tx_data temp, tx_flag_values flags) const;
    reg_action tx_action(tx_data temp, CUtoME_IF u_in) const;


    unsigned int align_flag(unsigned int reg, unsigned int flag) const;
    unsigned int align_control(unsigned int reg, unsigned int ctrl) const;
    unsigned int check_interrupt(unsigned int SR_reg, unsigned int CR_reg) const;

};


void Control::fsm(){
    while(true) {




        if(section == Sections::INIT){
            regs.CR_reg = 0;
            regs.SR_reg = TXE_FLAG;
            regs.DR_reg = 0;
            regs.r_act = NA;
            req.req = ME_X;
            regs2.r_act = NA;
            nextsection = Sections::RUN;
        }
        if(section == Sections::RUN){

            req_from_mem->nb_read(req);

            regs.CR_reg = register_CR_command(regs.CR_reg, req);
            regs.SR_reg = register_SR_command(regs.SR_reg, req);
            regs.DR_reg = register_TX_command(regs.DR_reg, req);
            tx_temp.TX_temp_register = register_TX_command(regs.DR_reg, req);
            tx_temp.r_act = tx_action(tx_temp, req);





            TE_flag_out->set(align_flag(regs.CR_reg,TE_FLAG));
            RE_flag_out->set(align_flag(regs.CR_reg,RE_FLAG));
            Parity_control_TX->set(align_control(regs.CR_reg, PAR_CTRL_START));
            Parity_control_RX->set(align_control(regs.CR_reg, PAR_CTRL_START));
            Baudrate_control->set(align_control(regs.CR_reg,BAUD_CTRL_START));



            TX_flags_in->nb_read(tx_flag);




            TX_reg_to_shiftreg->nb_write(tx_temp);


            shiftreg_to_RX_reg->nb_read(regs2);


            regs.DR_reg = register_RX_event(regs.DR_reg, regs2);
            regs.SR_reg = manage_RX_flags(regs.SR_reg, regs2);
            regs.SR_reg = manage_TX_flags(tx_flag, regs.SR_reg);
            tx_temp.r_act = tx_no_action(tx_temp, tx_flag);


            if(check_interrupt(regs.SR_reg, regs.CR_reg) != 0) {

                regs.SR_reg = regs.SR_reg | IP_FLAG;
                interrupt->write(true);
            }






            resp_to_mem->nb_write(regs);

            req.req = ME_X;
            regs2.r_act = NA;
            tx_flag.txe_flag = NF;
            tx_flag.tc_flag = NF;






        }




        section = nextsection;

        wait(SC_ZERO_TIME);
    }
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

reg_action Control::tx_no_action(tx_data temp, tx_flag_values flags) const{
    if(flags.txe_flag == SET) return NA;
    else return temp.r_act;
}




unsigned int Control::manage_TX_flags(tx_flag_values flags, unsigned int SR_reg) const{

    if(flags.tc_flag == SET && ((SR_reg & TXE_FLAG) != 0 || flags.txe_flag == SET)) return SR_reg | TXE_FLAG | TC_FLAG;
    else if((SR_reg & TXE_FLAG) == 0 && flags.txe_flag == SET) return SR_reg | TXE_FLAG;
    else return SR_reg;

}

unsigned int Control::manage_RX_flags(unsigned int SR_reg1, reg_files reg_2) const {

    if(reg_2.r_act == RX_WR) return SR_reg1 | reg_2.SR_reg;
    else return SR_reg1;
}





unsigned int Control::register_RX_event(unsigned int DR_reg1, reg_files regs_2) const {

    if(regs_2.r_act == RX_WR){
        return (DR_reg1 & I_RX_MASK) | (regs_2.DR_reg & RX_MASK) ;
    }
    else return DR_reg1;


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


unsigned int Control::align_flag(unsigned int reg, unsigned int flag) const{


    if(flag == TE_FLAG){
        return reg & 1;
    }else if(flag == RE_FLAG){
        return (reg >> 1) & 1;
    }else return 0;

}

unsigned int Control::align_control(unsigned int reg, unsigned int ctrl) const {

    if(ctrl == PAR_CTRL_START){
        return (reg >> 8) & 3;
    }else if(ctrl == BAUD_CTRL_START){
        return (reg >> 16) & HALFWORDMASK;
    }else return 0;

}






#endif //UART_CONTROL_H
