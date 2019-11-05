//
// Created by ovsthus on 12/9/18.
//

#ifndef UART_BAUDGEN_H
#define UART_BAUDGEN_H



#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"






class baudgen : public sc_module {
public:

    SC_HAS_PROCESS(baudgen);

    shared_out<bool> rec_trigger;
    shared_out<bool> trans_trigger;
    shared_in<unsigned int> baudrate_control;


//    master_in<bool> fake_clk2;



    unsigned int clock_div;

    unsigned int baudcounter;


    bool trigg;
    bool fake;


   enum Sections{INIT, RUN};

   Sections section, nextsection;

    baudgen(sc_module_name name) :
            rec_trigger("rec_trigger"),
            trans_trigger("trans_trigger"),
            baudrate_control("baudrate_control"),
            baudcounter(0),
            clock_div(0),
            trigg(false),
            fake(false),
            section(Sections::INIT),
            nextsection(Sections::INIT)
//            fake_clk2("fake_clk2")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};

void baudgen::fsm() {
    while (true) {


        if(section == Sections::INIT) {



//            fake_clk2->read(fake);

            baudrate_control->get(clock_div);

            if((clock_div & HALFWORDMASK) == 0){
                trigg = true;
                baudcounter = 0;
            }else{
                trigg = false;
                baudcounter = 1;
            }



            nextsection = Sections::RUN;
        }



if(section == Sections::RUN) {



//    fake_clk2->read(fake);

    baudrate_control->get(clock_div);

    rec_trigger->set(trigg);
    trans_trigger->set(trigg);


    if((clock_div & HALFWORDMASK) == baudcounter){
        trigg = true;
        baudcounter = 0;
    }else{
        trigg = false;
        baudcounter = baudcounter + 1;
    }






    nextsection = Sections::RUN;
}

section = nextsection;
        wait(SC_ZERO_TIME);
    }
}




#endif //UART_BAUDGEN_H
