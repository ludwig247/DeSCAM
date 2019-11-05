//
// Created by ovsthus on 18.01.19.
//

#ifndef UART_TRANSMITTER_H
#define UART_TRANSMITTER_H

#include "systemc.h"
#include "Interfaces.h"

#define LSB 1


class Transmitter : public sc_module {
public:

    enum Sections {RECEIVE_DATA, START, SEND, PARITY, STOP};

    Sections section, nextsection;

    SC_HAS_PROCESS(Transmitter);

    unsigned int TX_shiftreg = 0;
    unsigned int shiftcounter = 0;
    unsigned int bitcounter = 0;

    bool TE_flag = false;
    bool trigg;
    bool TX_pin_trigger = true;
    bool init = true;



    master_in<unsigned int> transfer_data;
    master_out<bool> TXE_flag_trans;
    master_out<bool> TC_flag_trans;
    master_in<bool> TE_flag_trans;
    master_in<bool> baudrate_in;
    shared_out<bool> TX_pin;


    Transmitter(sc_module_name name) :
            transfer_data("transfer_data"),
            TXE_flag_trans("TXE_flag_trans"),
            TC_flag_trans("TC_flag_trans"),
            TE_flag_trans("TE_flag_trans"),
            baudrate_in("baudrate_in"),
            TX_pin("TX_pin")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void Transmitter::fsm(){
    while(true) {

        if(init) {
            TX_pin->set(TX_pin_trigger); //tentative solution to initial value of TX_pin being false
            init = false;
        }



        if(section == Sections::RECEIVE_DATA){

            TE_flag_trans->read(TE_flag);
            transfer_data->read(TX_shiftreg);
            TXE_flag_trans->write(true);
            TC_flag_trans->write(false);



            if(TE_flag) nextsection = Sections::START;

            nextsection = Sections::START;
        }else if(section == Sections::START){
            baudrate_in->read(trigg);

            TX_pin_trigger = false;

            nextsection = Sections::SEND;
        }else if(section == Sections::SEND){
            baudrate_in->read(trigg);


            if(TX_shiftreg & LSB){
                bitcounter++;
                TX_pin_trigger = true;
            }else TX_pin_trigger = false;



            TX_shiftreg = TX_shiftreg >> 1;


            if(++shiftcounter == 8){
                nextsection = Sections::PARITY;
                shiftcounter = 0;
            }else nextsection = Sections::SEND;



        }else if(section == Sections::PARITY){
            baudrate_in->read(trigg);


            if(bitcounter % 2) TX_pin_trigger = false; //We use even parity
            else TX_pin_trigger = true;

            bitcounter = 0;




            nextsection = Sections::STOP;



        }else if(section == Sections::STOP){
            baudrate_in->read(trigg);

            TX_pin_trigger = true;

            TC_flag_trans->write(true);

            nextsection = Sections::RECEIVE_DATA;






        }




        TX_pin->set(TX_pin_trigger);
        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}



#endif //UART_TRANSMITTER_H
