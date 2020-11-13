//
// Created by mi-alkoudsi 10.12.19
//

#ifndef OPTIMIZER_ARB_TESTING_H
#define OPTIMIZER_ARB_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"

enum operationType {
    ADD, SUB, MUL, DIV, MOD
};

struct Test_Module0 : public sc_module {

    unsigned int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
           b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<unsigned int> b_in;
    blocking_out<unsigned int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y > 0) {
                x = 10;
            } else {
                x = 0;
            }
            b_out->write(x);
        }
    }
};

struct Test_Module1 : public sc_module {

    int x, y;

    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
            b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if (y > 0) {
                x = 5;
            } else {
                x = -5;
            }
            b_out->write(x);
        }
    }
};

struct Test_Module2 : public sc_module {

    int x, y, z;

    //Constructor
    SC_HAS_PROCESS(Test_Module2);

    Test_Module2(sc_module_name
    name):  b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if(y == 5){
                z = 1;
            }else{
                z = 2;
            }
            if (y > 0) {
                x = 5 + z;
            } else {
                x = -5;
            }
            b_out->write(x);
        }
    }
};

struct Test_Module3 : public sc_module {

    int x, y, z;
    //Constructor
    SC_HAS_PROCESS(Test_Module3);

    Test_Module3(sc_module_name
                 name):  b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if(y == 5){
                z = 1;
            }else{
                z = 2;
            }
            if (y > 0) {
                x = 5;
            } else {
                x = -5;
            }
            b_out->write(x+z);
        }
    }
};

struct Test_Module4 : public sc_module {

    int x, y, z;
    operationType op;

    //Constructor
    SC_HAS_PROCESS(Test_Module4);

    Test_Module4(sc_module_name
                 name):  b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            if(y == 5){
                z = getResult(DIV,18,2);
            }else{
                z = getResult(ADD,10,5);
            }
            if (y > 0) {
                x = 5 + z;
            } else {
                x = z;
            }
            b_out->write(x);
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

struct Test_Module5 : public sc_module {

    int x, y, z;
    //Constructor
    SC_HAS_PROCESS(Test_Module5);

    Test_Module5(sc_module_name
                 name):  b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            b_in->read(y);
            z = getResult(y,2, 2);
            if (z == 0) {
                x = 5;
            } else {
                x = -5;
            }
            b_out->write(x+z);
        }
    }
    int getResult(int opCode, int arg1, int arg2) const{
        if(opCode == 0){
            return arg1 + arg2;
        }else{
            return arg1 - arg2;
        }
    }
};

enum Mode {FORWARDS,BACKWARDS};

struct Test_Module6 : public sc_module {

    int x;
    Mode mode;
    //Constructor
    SC_HAS_PROCESS(Test_Module6);

    Test_Module6(sc_module_name
                 name): b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_out<int> b_out;

    void fsm() {
        x = 0;
        mode = Mode::FORWARDS;
        while (true) {
            b_out->write(x);
            if(mode == Mode::FORWARDS){
            x = x + 1;
            if (x == 15) {
                x = 0;
                mode = Mode::BACKWARDS;
            }
        } else if (mode == Mode::BACKWARDS) {
                x = x - 1;
                if (x == -15) {
                    x = 0;
                    mode = Mode::FORWARDS;
                }
            }
        }
    }
};

struct Test_Module7 : public sc_module {

    int x;
    //Constructor
    SC_HAS_PROCESS(Test_Module7);

    Test_Module7(sc_module_name
                 name): b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_out<int> b_out;

    void fsm() {
        x = 0;
        while (true) {
            b_out->write(x);
            if (x < 10) {
                x = x + 1;
            }else{
                x = 0;
            }
        }
    }
};

struct Test_Module8 : public sc_module {

    int x;
    //Constructor
    SC_HAS_PROCESS(Test_Module8);

    Test_Module8(sc_module_name
                 name): b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_out<int> b_out;

    void fsm() {
        x = 20;
        while (true) {
            b_out->write(x);
            if (x > 10) {
                x = x + 1;
            } else {
                x = x - 1;
            }
        }
    }
};

struct Test_Module9 : public sc_module {

    int x;
    bool y;
    //Constructor
    SC_HAS_PROCESS(Test_Module9);

    Test_Module9(sc_module_name
                 name): b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_out<int> b_out;
    blocking_in<int> b_in;

    void fsm() {
        x = 0;
        while (true) {
            x = incrementReset(x);
            b_out->write(x);
        }
    }
    int incrementReset(int arg) const {
        if(arg < 10){
            return arg + 1;
        }else{
            return 0;
        }
    }
};


struct Test_Module10 : public sc_module {

    int x;
    bool y;
    //Constructor
    SC_HAS_PROCESS(Test_Module10);

    Test_Module10(sc_module_name
                 name): b_in("b_in"), b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_out<int> b_out;
    blocking_in<bool> b_in;

    void fsm() {
        while (true) {
            b_in->read(y);
            x = incrementDecrement(y,x);
            b_out->write(x);
        }
    }
    int incrementDecrement(bool increment, int arg) const{
        if(increment){
            return arg + 1;
        }else{
            return arg - 1;
        }
    }
};
#endif //OPTIMIZER_ARB_TESTING_H


