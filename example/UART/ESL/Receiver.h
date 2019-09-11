//
// Created by ovsthus on 18.01.19.
//

#ifndef UART_RECEIVER_H
#define UART_RECEIVER_H

#include "systemc.h"
#include "Interfaces.h"


#define MSB 128



class Receiver : public sc_module {
public:

    SC_HAS_PROCESS(Receiver);

    enum Sections {IDLE, SCAN, RECEIVE, PARITY, STOP};
    Sections section, nextsection;


    unsigned int bitcounter = 0;
    unsigned int shiftcounter = 0;
    unsigned int RX_shiftreg = 0;
    bool RE_flag = false;
    bool trigg = false;
    bool RX_pin_trigger = true;
    bool init = true;

    master_out<unsigned int> receive_data;
    master_in<bool> RE_flag_rec;
    master_out<bool> PE_flag_rec;
    master_out<bool> FE_flag_rec;
    master_in<bool> baudrate_in;

    shared_in<bool> RX_pin;

    Receiver(sc_module_name name) :
            receive_data("receive_data"),
            RE_flag_rec("RE_flag_rec"),
            PE_flag_rec("PE_flag_rec"),
            FE_flag_rec("FE_flag_rec"),
            baudrate_in("baudrate_in"),
            RX_pin("RX_pin")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void Receiver::fsm(){
    while(true) {


        RX_pin->get(RX_pin_trigger);





        if(section == Sections::IDLE){
            RE_flag_rec->read(RE_flag);

            if(RE_flag) nextsection = Sections::SCAN;


        }else if(section == Sections::SCAN){
            baudrate_in->read(trigg);




            if(RX_pin_trigger == false) {
                nextsection = Sections::RECEIVE;

            }else nextsection = Sections::IDLE;


        }else if(section == Sections::RECEIVE){
            baudrate_in->read(trigg);

            RX_shiftreg = RX_shiftreg >> 1;

            if (RX_pin_trigger) {
                bitcounter++;
                RX_shiftreg |= MSB;
            }


            if (++shiftcounter == 8) {
                nextsection = Sections::PARITY;
                shiftcounter = 0;
            } else nextsection = Sections::RECEIVE;

        }else if(section == Sections::PARITY){
            baudrate_in->read(trigg);

            if (RX_pin_trigger == true && bitcounter % 2) PE_flag_rec->write(true);
            else if (RX_pin_trigger == false && !(bitcounter % 2)) PE_flag_rec->write(true);
            else PE_flag_rec->write(false);

            bitcounter = 0;

            nextsection = Sections::STOP;

        }else if(section == Sections::STOP){
            baudrate_in->read(trigg);

            if (RX_pin_trigger) FE_flag_rec->write(false);
            else FE_flag_rec->write(true);

            receive_data->write(RX_shiftreg);
            RX_shiftreg = 0;
            nextsection = Sections::IDLE;

        }







        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}



#endif //UART_RECEIVER_H
