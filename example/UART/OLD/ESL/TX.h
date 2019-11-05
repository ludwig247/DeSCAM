//
// Created by ovsthus on 08.05.19.
//

#ifndef UART_TX_H
#define UART_TX_H

#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"




class TX : public sc_module {
public:


    enum Sections {IDLE, START, SEND, PARITY, STOP, INIT};
    Sections section, nextsection;

    SC_HAS_PROCESS(TX);

    tx_data regs;
    tx_flag_values tx_flag;


    unsigned int TX_shiftreg;
    unsigned int shiftcounter;
    unsigned int bitcounter;
    unsigned int par_ctrl;

    unsigned int TE_flag;
    bool trigg;


    master_in<tx_data> TX_reg_to_shiftreg;


    master_out<tx_flag_values> TX_flags_out;



    shared_in<unsigned int> TE_flag_in;
    shared_in<unsigned int> Parity_control_in;
//    blocking_in<bool> baudrate_in;
    shared_in<bool> baudrate_in;
    master_out<bool> TX_pin;


    TX(sc_module_name name) :
            TX_reg_to_shiftreg("TX_reg_to_shiftreg"),
            TX_flags_out("TX_flags_out"),
            TE_flag_in("TE_flag_in"),
            Parity_control_in("Parity_control_in"),
            baudrate_in("baudrate_in"),
            TX_pin("TX_pin"),
            TX_shiftreg(0),
            shiftcounter(0),
            bitcounter(0),
            par_ctrl(0),
            TE_flag(0),
            trigg(false),
            nextsection(Sections::INIT),
            section(Sections::INIT)

    {
        SC_THREAD(fsm);
    }

    void fsm();
unsigned int parity_bit(unsigned int control, unsigned int counter) const;

};






void TX::fsm(){
    while(true) {


  //      std::cout << this->name() << "sucks dick" << std::endl;

        if(section == Sections::IDLE){



            TX_reg_to_shiftreg->read(regs);

            TE_flag_in->get(TE_flag);


            if(TE_flag != 0 && regs.r_act == TX_WR) {

                tx_flag.txe_flag = SET;
                tx_flag.tc_flag = RESET;
                TX_flags_out->write(tx_flag);
                TX_shiftreg = regs.TX_temp_register;

                nextsection = Sections::START;
            }else if(TE_flag == 0){
                nextsection = Sections::INIT;
            }



        }
        if(section == Sections::START){

//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);

            TE_flag_in->get(TE_flag);

            if(trigg && TE_flag!= 0) {



                TX_pin->write(false);
  
                nextsection = Sections::SEND;

            }else if(TE_flag == 0){
                nextsection = Sections::INIT;
            }


        }
        if(section == Sections::SEND){

//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);

            TE_flag_in->get(TE_flag);
            Parity_control_in->get(par_ctrl);

            if(trigg && TE_flag != 0) {

                if ((TX_shiftreg & LSB) != 0) {
                    bitcounter = bitcounter + 1;
                    TX_pin->write(true);
                } else TX_pin->write(false);


                TX_shiftreg = TX_shiftreg >> 1;

                shiftcounter = shiftcounter + 1;
                if (shiftcounter == 8) {

                    if(par_ctrl != 0) nextsection = Sections::PARITY;
                    else nextsection = Sections::STOP;
                    shiftcounter = 0;
                }
            }else if(TE_flag == 0){
                nextsection = Sections::INIT;
            }

        }
        if(section == Sections::PARITY){

//            baudrate_in->read(trigg);
            baudrate_in->get(trigg);

            TE_flag_in->get(TE_flag);
            Parity_control_in->get(par_ctrl);

            if(trigg && TE_flag != 0) {

              if(parity_bit(par_ctrl, bitcounter) != 0) TX_pin->write(true);
              else TX_pin->write(false);
                bitcounter = 0;


                nextsection = Sections::STOP;


            }else if(TE_flag == 0){
                nextsection = Sections::INIT;
            }

        }
        if(section == Sections::STOP){

//            baudrate_in->read(trigg);
                        baudrate_in->get(trigg);

            TE_flag_in->get(TE_flag);
            if(trigg && TE_flag != 0) {



                TX_pin->write(true);
                tx_flag.txe_flag = NF;
                tx_flag.tc_flag = SET;


                TX_flags_out->write(tx_flag);


                nextsection = Sections::IDLE;



            }else if(TE_flag == 0){
                nextsection = Sections::INIT;
            }





        }
        if(section == Sections::INIT){
            bitcounter = 0;
            shiftcounter = 0;
            TX_pin->write(true);
            TX_shiftreg = 0;
            nextsection = Sections::IDLE;


        }

        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}

unsigned int TX::parity_bit(unsigned int control, unsigned int counter) const {

    if((counter % 2) != 0 && control == 2) return 1;
    else if((counter % 2) == 0 && control == 1) return 1;
    else return 0;
}

#endif //UART_TX_H
