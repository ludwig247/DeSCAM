//
// Created by ovsthus on 6/21/19.
//

#ifndef UART_EXTERNALDUMMY_H
#define UART_EXTERNALDUMMY_H



#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"
#include "Memory_Interfaces.h"
#include <assert.h>


class ExternalDummy : public sc_module {
public:

    SC_HAS_PROCESS(ExternalDummy);



 slave_in<bool> rx_pin;
 slave_out<bool> tx_pin;

 bool rx_trigg;
 bool tx_trigg;

 unsigned int cntrl = 1;

 unsigned int run_;

bool start_out = false;
bool parity_out = false;
bool stop_out = false;
int cnt_out = 0;
 
bool start_in = false;
bool parity_in = false;
bool stop_in = false;
int cnt_in = 0;
unsigned int bitcount = 0;

unsigned int buffer;

 enum Sections {init, run};
Sections section, nextsection;


    ExternalDummy(sc_module_name name) :
        rx_pin("rx_pin"),
        tx_pin("tx_pin"),
        tx_trigg(true),
        section(Sections::init)
    {
        SC_THREAD(fsm);
    }


    void fsm();

    unsigned int parity_check(unsigned int counter, unsigned int control, unsigned int trigg) const;

};


void ExternalDummy::fsm(){
    while(true) {

//std::cout << this->name() << "sucks dick" << std::endl;

        if(section == Sections::init){

            tx_pin->nb_write(true);
            nextsection = Sections::run;
        }

        if(section == Sections::run) {




            if(rx_pin->nb_read(rx_trigg)){

                if(stop_in == true){


                    assert(rx_trigg == true);
                    stop_in = false;
                    start_in = false;
                    cnt_in = 0;
                    buffer = 0;
                    bitcount = 0;
                }

                if(parity_in == true){


                    assert(parity_check(bitcount, cntrl, rx_trigg) == 0);
                    stop_in = true;
                    parity_in = false;
                }


                if(start_in == true && cnt_in < 8){
                    buffer = buffer >> 1;
                    if(rx_trigg == true){
                        buffer = (buffer | 128);
                        bitcount++;
                    }


                    if(++cnt_in == 8){
                        parity_in = true;
                    }
                }


                if(rx_trigg == false && start_in == false){
                    start_in = true;
                }

                
                //-----------------------------------------------------//


                if(stop_out){
                    tx_trigg = true;
                    start_out = false;
                    stop_out = false;
                    cnt_out = 9;

                }


                if(parity_out){
                    tx_trigg = true;
                    stop_out = true;
                    parity_out = false;
                }


                if(start_out && (cnt_out < 8)){
                    tx_trigg = true;

                    if(++cnt_out == 8){
                        parity_out = true;
                    }
                }



                if(!start_out && cnt_out != 9){
                    tx_trigg = false;
                    start_out = true;
                }

                if(cnt_out == 9){
                    cnt_out = 0;
                }

                tx_pin->nb_write(tx_trigg);



                
                
            }



        }

        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}

unsigned int ExternalDummy::parity_check(unsigned int counter, unsigned int control, unsigned int trigg) const {

    if ((trigg == true) && ((counter % 2) != 0) && control == 2) return 0;
    else if ((trigg == false) && ((counter % 2) == 0)  && control == 2) return 0;
    else if ((trigg == false) && ((counter % 2) != 0)  && control == 1) return 0;
    else if ((trigg == true) && ((counter % 2) == 0)  && control == 1) return 0;
    else return 1;

}


#endif //UART_EXTERNALDUMMY_H
