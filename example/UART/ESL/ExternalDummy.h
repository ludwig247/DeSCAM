//
// Created by ovsthus on 8/6/19.
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



    slave_in<unsigned int> rx_pin;
    slave_out<unsigned int> tx_pin;

    enum Sections {run1, run2, run3, run4, run5, run6};
    Sections section, nextsection;


    unsigned int rx_trigg;
    unsigned int tx_trigg;



    unsigned int value;
    int cnt = 0;



    ExternalDummy(sc_module_name name) :
            rx_pin("rx_pin"),
            tx_pin("tx_pin"),
            tx_trigg(0xFFFF),
            section(Sections::run1),
            nextsection(Sections::run1)
    {
        SC_THREAD(fsm);
    }


    void fsm();



};


void ExternalDummy::fsm(){
    while(true) {



        if(section == Sections::run1) {


            if (rx_pin->nb_read(rx_trigg)) {

                assert((rx_trigg & INVERTED_STARTBIT) == 0 && "startbit should be zero");

                value = ((rx_trigg >> 1) & BYTEMASK);

                assert(value == 255 && "wrong value received by ext at run1");
                assert((rx_trigg & PARITYBIT) == 0 && "With even parity we should not see parity bit here");
                assert((rx_trigg & STOPBIT) != 0 && "There should have been a stopbit here");


                nextsection = Sections::run2;


            }
        }

            if(section == Sections::run2) {


                if (rx_pin->nb_read(rx_trigg)) {

                    assert((rx_trigg & INVERTED_STARTBIT) == 0 && "startbit should be zero");

                    value = ((rx_trigg >> 1) & BYTEMASK);
                    assert(value == 1 && "wrong value received by ext at run2");
                    assert((rx_trigg & PARITYBIT) != 0 && "With even parity we should see parity bit here");
                    assert((rx_trigg & STOPBIT) != 0 && "There should have been a stopbit here");


                    nextsection = Sections::run3;


                }

            }

                if(section == Sections::run3) {


                    if (rx_pin->nb_read(rx_trigg)) {

                        assert((rx_trigg & INVERTED_STARTBIT) == 0 && "startbit should be zero");

                        value = ((rx_trigg >> 1) & BYTEMASK);
                        std::cout << "EXT reads: " << value << std::endl;
                        assert(value == 170 && "wrong value received by ext at run1");
                        assert((rx_trigg & PARITYBIT) == 0 && "With even parity we should not see parity bit here");
                        assert((rx_trigg & STOPBIT) != 0 && "There should have been a stopbit here");


                        nextsection = Sections::run4;


                    }
                }



                if(section == Sections::run4){
                    if(cnt == 0) { // need to delay for a few cycles on systemlevel due to uarts statemachine.
                        tx_trigg = (87 << 1) | PARITYBIT | STOPBIT; //shifted left to add 0 to start of bitstream
                        tx_pin->nb_write(tx_trigg);
                    }
                    if(cnt++ == 32) { //delay for extra cycles to allow time for read and write of SR and CR respectively (extra cycles due to systemc scheduler)
                        nextsection = Sections::run5;
                        cnt = 0;
                    }
                }


        if(section == Sections::run5){
            if(cnt == 0) {
                tx_trigg = (15 << 1) | PARITYBIT | STOPBIT; //adding parity bit to 15 should result in parity error
                tx_pin->nb_write(tx_trigg);
            }
            if(cnt++ == 32) {
                nextsection = Sections::run6;
                cnt = 0;
            }
        }

        if(section == Sections::run6){
            if(cnt == 0) {
                tx_trigg = (248 << 1) | PARITYBIT; //a frame without stop bit should result in frame error
                tx_pin->nb_write(tx_trigg);
            }
            if(cnt++ == 32) {
                nextsection = Sections::run1;
                cnt = 0;
            }
        }




        section = nextsection;

        wait(SC_ZERO_TIME);
    }
}




#endif //UART_EXTERNALDUMMY_H
