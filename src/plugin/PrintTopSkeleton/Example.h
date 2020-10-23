//
// Created by ludwig on 10.10.17.
//

#ifndef PROJECT_SLAVEDAVEBAVE_H_H
#define PROJECT_SLAVEDAVEBAVE_H_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


struct global_compound_type {
    unsigned w;
    bool b;
};

enum global_enum {
    A, B
};
enum class global_enum_class {
    M, N
};


struct GlobalLocal : public sc_module {
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    //Constructor

    SC_HAS_PROCESS(GlobalLocal);

    GlobalLocal(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    enum local_enum {
        X, Y
    };
    enum class local_enum_class {
        D, E
    };

    struct local_compound_type {
        int x;
        bool y;
        global_enum fest;
    };

    local_enum le;
    local_enum_class lec;

    global_enum ge;
    global_enum_class gec;

    int int_var;
    bool bool_var;
    int local_array[5];

    global_compound_type gct;
    local_compound_type lct;

    void fsm() {
        while (true) {
            b_in->read(int_var);
            int_var = int_var + 1;
            if (le == X) {
                local_array[0] = int_var + 1;
            } else if (lec == local_enum_class::D) {
                local_array[1] = int_var + 1;
            } else if (ge == A) {
                local_array[1] = local_array[2];
            } else if (gec == global_enum_class::M) {
                local_array[4] = 0;
                gct.w = 5;
            }
            local_array[1] = local_array[0];
            b_out->write(int_var);

        }
    }
};


#endif //PROJECT_SLAVEDAVEBAVE_H_H
