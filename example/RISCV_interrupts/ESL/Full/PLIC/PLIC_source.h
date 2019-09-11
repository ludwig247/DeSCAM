//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_PLIC_SOURCE_H
#define PROJECT_PLIC_SOURCE_H

#include "systemc.h"
#include "Interfaces.h"
#include <scv.h>

class TheUNKNOWN : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(TheUNKNOWN);

    TheUNKNOWN(sc_module_name name) :
            rand_Int("rand_Int"),
            IntSig_1("IntSig_1"),
            IntSig_2("IntSig_2") {
        scv_bag<bool> field_dist;
        field_dist.add(false, 1000000);
        field_dist.add(true, 1);
        rand_Int->set_mode(field_dist);
        SC_THREAD(run);
    }

    master_out<bool> IntSig_1;
    master_out<bool> IntSig_2;

    scv_smart_ptr<bool> rand_Int;

    void run() {
        while (true) {
            rand_Int->next();
            if (*rand_Int) {
//                std::cout << "interrupt from external 1\n";
                IntSig_1->write(true);
            } else
                IntSig_1->write(false);


            rand_Int->next();
            if (*rand_Int) {
//                std::cout << "interrupt from external 2\n";
                IntSig_2->write(true);
            } else
                IntSig_2->write(false);
        }
    }
};

#endif //PROJECT_PLIC_SOURCE_H
