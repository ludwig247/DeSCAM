//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_OSR_TESTING_H
#define OPTIMIZER_OSR_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"


struct Test_Module0 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    int op,x;

    //Constructor
    SC_HAS_PROCESS(Test_Module0);

    Test_Module0(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<int> op_in;
    blocking_in<int> b_in;
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            op_in->read(op);
            b_in->read(x);
            if (op == 0) {
                b_out->write(x * 4);
            } else if (op == 1) {
                b_out->write(x * 15);
            } else if (op == 2) {
                b_out->write(x * 3);
            } else if (op == 3){
                b_out->write(x * 6);
            } else if (op == 4){
                b_out->write(x * -2);
            } else if (op == 5){
                b_out->write(x * -6);
            } else if (op == 6) {
                b_out->write(4 * x);
            } else if (op == 7) {
                b_out->write(3 * x);
            } else if (op == 8) {
                b_out->write(5 * x);
            } else if (op == 9){
                b_out->write(6 * x);
            } else if (op == 10){
                b_out->write(-2 * x);
            } else if (op == 11){
                b_out->write(x * 0);
            } else if (op == 12) {
                b_out->write(x / 8);
            } else if (op == 13){
                b_out->write(x / 6);
            } else if (op == 14){
                b_out->write(4 / x);
            } else if (op == 15){
                b_out->write(x / 1);
            } else if (op == 16) {
                b_out->write(x % 16);
            } else if (op == 17){
                b_out->write(x % 6);
            } else if (op == 18){
                b_out->write(8 % x);
            } else if (op == 19){
                b_out->write(x % 1);
            } else {
                b_out->write(x);
            }
        }
    }
};

struct Test_Module1 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;
    unsigned int op,x;

    //Constructor
    SC_HAS_PROCESS(Test_Module1);

    Test_Module1(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //ports
    blocking_in<unsigned int> op_in;
    blocking_in<unsigned int> b_in;
    blocking_out<unsigned int> b_out;

    void fsm() {
        while (true) {
            op_in->read(op);
            b_in->read(x);
            if (op == 0) {
                b_out->write(x * 4);
            } else if (op == 1) {
                b_out->write(x * 15);
            } else if (op == 2) {
                b_out->write(x * 3);
            } else if (op == 3){
                b_out->write(x * 6);
            } else if (op == 4){
                b_out->write(x * -2);
            } else if (op == 5){
                b_out->write(x * -6);
            } else if (op == 6) {
                b_out->write(4 * x);
            } else if (op == 7) {
                b_out->write(3 * x);
            } else if (op == 8) {
                b_out->write(5 * x);
            } else if (op == 9){
                b_out->write(6 * x);
            } else if (op == 10){
                b_out->write(-2 * x);
            } else if (op == 11){
                b_out->write(x * 0);
            } else if (op == 12) {
                b_out->write(x / 8);
            } else if (op == 13){
                b_out->write(x / 6);
            } else if (op == 14){
                b_out->write(4 / x);
            } else if (op == 15){
                b_out->write(x / 1);
            } else if (op == 16) {
                b_out->write(x % 16);
            } else if (op == 17){
                b_out->write(x % 6);
            } else if (op == 18){
                b_out->write(8 % x);
            } else if (op == 19){
                b_out->write(x % 1);
            } else {
                b_out->write(x);
            }
        }
    }
};


#endif //OPTIMIZER_OSR_TESTING_H


