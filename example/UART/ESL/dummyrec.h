//
// Created by ovsthus on 1/23/19.
//

#ifndef UART_DUMMYREC_H
#define UART_DUMMYREC_H

#include "systemc.h"
#include "Interfaces.h"


#define MSB 128
#define STARTVALID 4


class dummyrec : public sc_module {
public:

    SC_HAS_PROCESS(dummyrec);

    enum Sections {IDLE, SCAN, RECEIVE, PARITY, STOP, FINISH};
    Sections section, nextsection;


    unsigned int bitcounter = 0;
    unsigned int shiftcounter = 0;
    unsigned int RX_shiftreg = 0;
    unsigned int scanstart = 0;
    unsigned int next_state;
    bool RE_flag = false;
    bool trigg = false;
    bool RX_pin_trigger = true;
    bool init = true;
    bool valid = false;
    bool enabled = false;

    master_out<unsigned int> receive_data;
    master_in<bool> RE_flag_rec;
    master_out<bool> PE_flag_rec;
    master_out<bool> FE_flag_rec;
    master_in<bool> baudrate_in;

    shared_in<bool> RX_pin;

    dummyrec(sc_module_name name) :
            receive_data("receive_data"),
            RE_flag_rec("RE_flag_rec"),
            PE_flag_rec("PE_flag_rec"),
            FE_flag_rec("FE_flag_rec"),
            baudrate_in("baudrate_in"),
            RX_pin("RX_pin"),
            section(Sections::IDLE),
            nextsection(Sections::IDLE)


    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void dummyrec::fsm(){
    while(true) {

        section = nextsection;

        if(section == Sections::IDLE){
            RE_flag_rec->read(RE_flag);

            if(RE_flag) {
                nextsection = Sections::FINISH;
                next_state = 2;
                enabled = true;
            }


        }else if(section == Sections::SCAN){
            baudrate_in->read(trigg);

            if(RX_pin_trigger == false) ++scanstart;
            else scanstart = 0;

            if(scanstart >= STARTVALID) valid = true;


            if(valid && trigg) {
                valid = false;
                scanstart = 0;
                nextsection = Sections::FINISH;
                next_state = 3;
            }else {
                nextsection = Sections::FINISH;
                next_state = 1;
            }

        }else if(section == Sections::RECEIVE){
            baudrate_in->read(trigg);

            if(trigg) {
                RX_shiftreg = RX_shiftreg >> 1;

                if (RX_pin_trigger) {
                    ++bitcounter;
                    RX_shiftreg = RX_shiftreg | 128;
                }

                ++shiftcounter;
                if (shiftcounter == 8) {
                    nextsection = Sections::FINISH;
                    next_state = 4;
                    shiftcounter = 0;
                } else{
                    nextsection = Sections::FINISH;
                    next_state = 3;
                }

            }
        }else if(section == Sections::PARITY){
            baudrate_in->read(trigg);

            if(trigg) {
                if (RX_pin_trigger == true && (bitcounter % 2) PE_flag_rec->write(true);
                else if (RX_pin_trigger == false && !(bitcounter % 2)) PE_flag_rec->write(true);
                else PE_flag_rec->write(false);

                bitcounter = 0;

                nextsection = Sections::FINISH;
                next_state = 5;
            }
        }else if(section == Sections::STOP){
            baudrate_in->read(trigg);
            if(trigg) {
                if (RX_pin_trigger) FE_flag_rec->write(false);
                else FE_flag_rec->write(true);

                receive_data->write(RX_shiftreg);
                RX_shiftreg = 0;
                nextsection = Sections::FINISH;
                next_state = 1;
            }
        }else if(section == Sections::FINISH){

            RX_pin->get(RX_pin_trigger);

            if(RE_flag == false && enabled == true){
                nextsection = Sections::IDLE;
                RX_shiftreg = 0;
                scanstart = 0;
                valid = false;
                bitcounter = 0;
                shiftcounter = 0;
                PE_flag_rec->write(false);
                FE_flag_rec->write(false);
                enabled = false;
            }

            if(next_state == 1){
                nextsection = Sections::IDLE;
            }else if(next_state == 2){
                nextsection = Sections::SCAN;
            }else if(next_state == 3){
                nextsection = Sections::RECEIVE;
            }else if(next_state == 4){
                nextsection = Sections::PARITY;
            }else if(next_state == 5){
                nextsection = Sections::STOP;
            }

        }





        wait(SC_ZERO_TIME);
    }
}



#endif //UART_DUMMYREC_H
