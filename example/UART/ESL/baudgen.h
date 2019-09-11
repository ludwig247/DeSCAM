//
// Created by ovsthus on 12/9/18.
//

#ifndef UART_BAUDGEN_H
#define UART_BAUDGEN_H

#define BAUDRATE 10000

#include "systemc.h"
#include "Interfaces.h"







class baudgen : public sc_module {
public:

    SC_HAS_PROCESS(baudgen);

    slave_out<bool> rec_trigger;
    slave_out<bool> trans_trigger;

    unsigned int baudcounter = 0;





    baudgen(sc_module_name name) :
            rec_trigger("rec_trigger"),
            trans_trigger("trans_trigger")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};

void baudgen::fsm() {
    while (true) {

        baudcounter++;

        if(baudcounter >= BAUDRATE){
            baudcounter = 0;
            trans_trigger->nb_write(true);
            rec_trigger->nb_write(true);
        }else if(baudcounter % (BAUDRATE/8) == 0){
            trans_trigger->nb_write(false);
            rec_trigger->nb_write(false);
        }


        wait(SC_ZERO_TIME);
    }
}







#endif //UART_BAUDGEN_H
