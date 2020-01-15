//
// Created by mi-alkoudsi 09.12.19
//

#ifndef OPTIMIZER_FO_TESTING_H
#define OPTIMIZER_FO_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"

enum operationType {
    ADD, SUB, MUL, DIV, MOD
};

#define num 8

struct Test_Module0 : public sc_module {
    int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    operationType opType; //if no variable declared here the tool generates an error because the data type won't be found in the model datatypes

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y == 0x1) {
                b_out->write(getResult(ADD, 20, 10));
            } else if (y == 0x2) {
                b_out->write(getResult(ADD, x, 10));
            } else if (y == 0x3) {
                b_out->write(getResult(SUB, 20, 10));
            } else if (y == 0x4) {
                b_out->write(getResult(MUL, x, 15));
            } else if (y == 0x5) {
                b_out->write(getResult(MUL, 17, x));
            } else if (y == 0x6) {
                b_out->write(getResult(DIV, x, 4));
            } else if (y == 0x7) {
                b_out->write(getResult(MOD, x, num));
            } else{}
        }
    }

    int add(int arg1, int arg2) const {
        return arg1 + arg2;
    }

    int sub(int arg1, int arg2) const {
        return arg1 - arg2;
    }

    int mul(int arg1, int arg2) const {
        return arg1 * arg2;
    }

    int div(int arg1, int arg2) const {
        return arg1 / arg2;
    }

    int mod(int arg1, int arg2) const {
        return arg1 % arg2;
    }

    int getResult(operationType oper, int arg1, int arg2) const {
        if (oper == ADD) return add(arg1, arg2);
        else if (oper == SUB) return sub(arg1, arg2);
        else if (oper == MUL) return mul(arg1, arg2);
        else if (oper == DIV) return div(arg1, arg2);
        else if (oper == MOD) return mod(arg1, arg2);
        else return 0;
    }
};

#endif //OPTIMIZER_FO_TESTING_H


