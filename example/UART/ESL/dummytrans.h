//
// Created by ovsthus on 1/23/19.
//

#ifndef UART_DUMMYTRANS_H
#define UART_DUMMYTRANS_H

#include "systemc.h"
#include "Interfaces.h"

#define LSB 1


class dummytrans : public sc_module {
public:

    enum Sections {RECEIVE_DATA, START, SEND, PARITY, STOP, FINISH};

    Sections section, nextsection;

    SC_HAS_PROCESS(dummytrans);

    unsigned int TX_shiftreg = 0;
    unsigned int shiftcounter = 0;
    unsigned int bitcounter = 0;
    unsigned int next_state;

    bool TE_flag = false;
    bool trigg;
    bool TX_pin_trigger = true;
    bool init = true;
    bool enabled = false;


    master_in<unsigned int> transfer_data;
    master_out<bool> TXE_flag_trans;
    master_out<bool> TC_flag_trans;
    master_in<bool> TE_flag_trans;
    master_in<bool> baudrate_in;
    shared_out<bool> TX_pin;


    dummytrans(sc_module_name name) :
            transfer_data("transfer_data"),
            TXE_flag_trans("TXE_flag_trans"),
            TC_flag_trans("TC_flag_trans"),
            TE_flag_trans("TE_flag_trans"),
            baudrate_in("baudrate_in"),
            TX_pin("TX_pin"),
            nextsection(Sections::RECEIVE_DATA),
            section(Sections::RECEIVE_DATA)

    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void dummytrans::fsm(){
    while(true) {



        if(section == Sections::RECEIVE_DATA){

            if(init) {
                TX_pin->set(TX_pin_trigger); //tentative solution to initial value of TX_pin being false
                init = false;
            }
            TE_flag_trans->read(TE_flag);
            transfer_data->read(TX_shiftreg);
            TXE_flag_trans->write(true);
            TC_flag_trans->write(false);



            if(TE_flag) {
                nextsection = Sections::FINISH;
                next_state = 2;
                enabled = true;
            }


        }else if(section == Sections::START){
            baudrate_in->read(trigg);

            if(trigg) {
                TX_pin_trigger = false;

                nextsection = Sections::FINISH;
                next_state = 3;
            }
        }else if(section == Sections::SEND){
            baudrate_in->read(trigg);

            if(trigg) {
                if (TX_shiftreg & LSB) {
                    bitcounter++;
                    TX_pin_trigger = true;
                } else TX_pin_trigger = false;


                TX_shiftreg = TX_shiftreg >> 1;


                if (++shiftcounter == 8) {
                    nextsection = Sections::FINISH;
                    next_state = 4;
                    shiftcounter = 0;
                } else {
                    nextsection = Sections::FINISH;
                    next_state = 3;
                }

            }
        }else if(section == Sections::PARITY){
            baudrate_in->read(trigg);

            if(trigg) {
                if (bitcounter % 2) TX_pin_trigger = false; //We use even parity
                else TX_pin_trigger = true;

                bitcounter = 0;


                nextsection = Sections::FINISH;
                next_state = 5;

            }

        }else if(section == Sections::STOP){
            baudrate_in->read(trigg);
            if(trigg) {
                TX_pin_trigger = true;

                TC_flag_trans->write(true);

                nextsection = Sections::FINISH;
                next_state = 1;


            }



        }else if(section == Sections::FINISH){


            if(TE_flag == false && enabled == true){
                TX_pin_trigger = true;
                bitcounter = 0;
                TX_shiftreg = 0;
                shiftcounter = 0;
                TC_flag_trans->write(false);
                TXE_flag_trans->write(true);
                enabled = false;
            }


            TX_pin->set(TX_pin_trigger);

            if(next_state == 1){
                nextsection = Sections::RECEIVE_DATA;
            }else if(next_state == 2){
                nextsection = Sections::START;
            }else if(next_state == 3){
                nextsection = Sections::SEND;
            }else if(next_state == 4){
                nextsection = Sections::PARITY;
            }else if(next_state == 5){
                nextsection = Sections::STOP;
            }






        }


        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}




#endif //UART_DUMMYTRANS_H
