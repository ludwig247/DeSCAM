//
// Created by ovsthus on 08.05.19.
//

#ifndef UART_RX_H
#define UART_RX_H



#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"





class RX : public sc_module {
public:

    SC_HAS_PROCESS(RX);

    enum Sections {IDLE, SCAN, RECEIVE, PARITY, STOP, INIT};
    Sections section, nextsection;

    reg_files regs;

    unsigned int bitcounter;   //SCAM insists on having these as int
    unsigned int shiftcounter; //----------------"------------------
    unsigned int RX_shiftreg;
    unsigned int RE_flag;
    unsigned int par_ctrl;
    bool trigg;
    bool RX_pin_value;

    bool fake; //ALL fake are to trick SCAM


    master_out<reg_files> shiftreg_to_RX_reg;
    shared_in<unsigned int> RE_flag_in;
    shared_in<unsigned int> Parity_control_in;
//    blocking_in<bool> baudrate_in;
    shared_in<bool> baudrate_in;
//    master_in<bool> fake_clk_in;

    master_in<bool> RX_pin;

    RX(sc_module_name name) :
            shiftreg_to_RX_reg("shiftreg_to_RX_reg"),
            RE_flag_in("RE_flag_in"),
            baudrate_in("baudrate_in"),
//            fake_clk_in("fake_clk_in"),
            Parity_control_in("Parity_control_in"),
            RX_pin("RX_pin"),
            bitcounter(0),
            shiftcounter(0),
            RX_shiftreg(0),
            par_ctrl(0),
            RE_flag(0),
            trigg(false),
            RX_pin_value(true),
            fake(false),
            section(Sections::INIT),
            nextsection(Sections::INIT)
    {
        SC_THREAD(fsm);
    }

    void fsm();
    unsigned int parity_check(unsigned int counter, unsigned int control, unsigned int trigg) const;
    unsigned int frame_check(unsigned int trigg) const;

};


void RX::fsm(){
    while(true) {

  //      std::cout << this->name() << "sucks dick" << std::endl;

        if(section == Sections::IDLE){

         //       fake_clk_in->read(fake);
            RE_flag_in->get(RE_flag);


            if(RE_flag != 0) {

                nextsection = Sections::SCAN;
            }else{
                nextsection = Sections::INIT;
            }

        }
        if(section == Sections::SCAN){


//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);


            RX_pin->read(RX_pin_value);

            RE_flag_in->get(RE_flag);



            if(trigg && (RX_pin_value == false) && RE_flag != 0) {


                nextsection = Sections::RECEIVE;
            }else if(RE_flag == 0) {
                nextsection = Sections::INIT;
            }



        }
        if(section == Sections::RECEIVE){

//            baudrate_in->read(trigg);
                        baudrate_in->get(trigg);

            RE_flag_in->get(RE_flag);
            Parity_control_in->get(par_ctrl);

            wait(SC_ZERO_TIME);
            if(trigg && RE_flag != 0) {
                RX_pin->read(RX_pin_value);
                RX_shiftreg = RX_shiftreg >> 1;

                if (RX_pin_value) {
                    bitcounter = bitcounter + 1;
                    RX_shiftreg =  RX_shiftreg | MSB;
                }
        
                shiftcounter = shiftcounter + 1;
                if (static_cast<int>(shiftcounter) == 8) {
                    if(par_ctrl != 0) nextsection = Sections::PARITY;
                    else nextsection = Sections::STOP;
                    shiftcounter = 0;
                }

            }else if(RE_flag == 0){
                nextsection = Sections::INIT;
            }
        }
        if(section == Sections::PARITY){

//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);

            RE_flag_in->get(RE_flag);
            Parity_control_in->get(par_ctrl);


            if(trigg && RE_flag != 0) {
                RX_pin->read(RX_pin_value);
                regs.SR_reg = regs.SR_reg | parity_check( bitcounter, par_ctrl , RX_pin_value );

                bitcounter = 0;

                nextsection = Sections::STOP;

            }else if(RE_flag == 0){
                nextsection = Sections::INIT;
            }
        }
        if(section == Sections::STOP){

//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);
            RE_flag_in->get(RE_flag);
            if(trigg && RE_flag != 0) {
                RX_pin->read(RX_pin_value);

               regs.SR_reg = regs.SR_reg | frame_check(RX_pin_value);



                regs.SR_reg = regs.SR_reg | RXNE_FLAG;
                regs.DR_reg = (RX_shiftreg << 8) & RX_MASK;
                regs.r_act = RX_WR;
                shiftreg_to_RX_reg->write(regs);
                RX_shiftreg = 0;
                regs.SR_reg = 0;
                regs.r_act = NA;


                nextsection = Sections::SCAN;

            }else if(RE_flag == 0){
                nextsection = Sections::INIT;
            }

        }
        if(section == Sections::INIT){
            bitcounter = 0;
            shiftcounter = 0;
            RX_shiftreg = 0;
            regs.SR_reg = 0;
            regs.r_act = NA;

            nextsection = Sections::IDLE;
        }





        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}


unsigned int RX::parity_check(unsigned int counter, unsigned int control, unsigned int trigg) const {

    if ((trigg == true) && ((counter % 2) != 0) && control == 2) return 0;
    else if ((trigg == false) && ((counter % 2) == 0)  && control == 2) return 0;
    else if ((trigg == false) && ((counter % 2) != 0)  && control == 1) return 0;
    else if ((trigg == true) && ((counter % 2) == 0)  && control == 1) return 0;
    else return PE_FLAG;

}

unsigned int RX::frame_check(unsigned int trigg) const{
    if(trigg == true) return 0;
    else return FE_FLAG;

}

#endif //UART_RX_H
