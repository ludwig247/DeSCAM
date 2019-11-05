//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_TX_H
#define UART_TX_H


#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"





class TX : public sc_module {
public:


    enum Sections {IDLE, START, SEND, STOP};
    Sections section, nextsection;

    SC_HAS_PROCESS(TX);

    tx_data regs;




    unsigned int TX_shiftreg;


//    master_in<bool> fake;
    bool fake_;
    master_in<tx_data> tx_from_ctrl;



    master_out<unsigned int> TX_flags_out;







    master_out<unsigned int> TX_pin;


    TX(sc_module_name name) :
            tx_from_ctrl("TX_from_ctrl"),
            TX_flags_out("TX_flags_out"),
            TX_pin("TX_pin"),
            TX_shiftreg(0),
            fake_(false),
//            fake("fake"),
            nextsection(Sections::IDLE),
            section(Sections::IDLE)

    {
        SC_THREAD(fsm);
    }

    void fsm();

};






void TX::fsm() {
    while (true) {


//              std::cout << this->name() << "sucks dick" << std::endl;

        if (section == Sections::IDLE) {

            // fake->read(fake_);
wait(SC_ZERO_TIME);

            tx_from_ctrl->read(regs);


            if (regs.r_act == TX_WR) {

                TX_shiftreg = regs.tx_reg & BUFFERMASK;
                TX_flags_out->write(txe);


                nextsection = Sections::START;
            }


        }
        if (section == Sections::START) {

//            fake->read(fake_);

            nextsection = Sections::SEND;

        }
        if (section == Sections::SEND) {


            TX_pin->write(TX_shiftreg);

            nextsection = Sections::STOP;

        }


        if (section == Sections::STOP) {
            //   fake->read(fake_);




            TX_flags_out->write(tc);


            nextsection = Sections::IDLE;


        }

section = nextsection;
    }
}



#endif //UART_TX_H
