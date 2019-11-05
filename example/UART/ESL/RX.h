//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_RX_H
#define UART_RX_H



#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"




class RX : public sc_module {
public:

    SC_HAS_PROCESS(RX);

    enum Sections {IDLE, SCAN, RECEIVE, STOP};
    Sections section, nextsection;

    rx_data regs;

    unsigned int RX_shiftreg;
    unsigned int RX_temp;

//    master_in<bool> fake_clk_in;



    bool fake; //ALL fake are to trick SCAM


    master_out<rx_data> rx_to_ctrl;

    master_in<unsigned int> RX_pin;

    RX(sc_module_name name) :
            rx_to_ctrl("RX_to_ctrl"),
//            fake_clk_in("fake_clk_in"),
            RX_pin("RX_pin"),

            RX_shiftreg(0),
            fake(false),
            section(Sections::IDLE),
            nextsection(Sections::IDLE)
    {
        SC_THREAD(fsm);
    }

    void fsm();
    unsigned int parity_check(unsigned int count, unsigned int parbit) const;
    unsigned int frame_check(unsigned int stopbit) const;
    unsigned int countones(unsigned int reg) const;


};


void RX::fsm(){
    while(true) {



        if(section == Sections::IDLE){

//            fake_clk_in->read(fake);



            nextsection = Sections::SCAN;


        }
        if(section == Sections::SCAN){


            RX_pin->read(RX_temp);

            if((RX_temp & INVERTED_STARTBIT) == 0){

                nextsection = Sections::RECEIVE;
            }


        }
        if(section == Sections::RECEIVE){
            RX_shiftreg = RX_temp;

//            fake_clk_in->read(fake);

            nextsection = Sections::STOP;
        }

        if(section == Sections::STOP){

//            fake_clk_in->read(fake);

            if (parity_check(countones(((RX_shiftreg >> 1) & BYTEMASK)), (RX_shiftreg & PARITYBIT)) == 0 && frame_check(RX_shiftreg & STOPBIT) == 0) {
                regs.SR_reg = RXNE_FLAG;
                regs.DR_reg = (RX_shiftreg << 7) & L1_BYTEMASK;
            }
            else {
                regs.SR_reg = parity_check(countones(((RX_shiftreg >> 1) & BYTEMASK)), (RX_shiftreg & PARITYBIT)) | frame_check(RX_shiftreg & STOPBIT);
                regs.DR_reg = (RX_shiftreg << 15) & L2_BYTEMASK;
            }


            rx_to_ctrl->write(regs);



            nextsection = Sections::SCAN;

        }






        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}


unsigned int RX::countones(unsigned int reg) const {

    return bits(reg); //very messy ITL without it.
}

unsigned int RX::parity_check(unsigned int count, unsigned int parbit) const {

    if ((parbit!= 0) && ((count % 2) != 0)) return 0;
    else if ((parbit == 0) && ((count % 2) == 0)) return 0;
    else return PE_FLAG;

}

unsigned int RX::frame_check(unsigned int stopbit) const{
    if(stopbit != 0) return 0;
    else return FE_FLAG;

}





#endif //UART_RX_H
