// Created By M.I.Alkoudsi on 14.05.2019
#ifndef PROJECT_PAPER_H
#define PROJECT_PAPER_H
//Enum Datatype
#include "systemc.h"
#include "Interfaces.h"

struct S {
    int d = 1;
    bool f = true;
}; //the initialization won't be considered here by the tool

struct Example : public sc_module {
    //Constructor
    SC_CTOR(Example) :
            sec(false) {SC_THREAD(fsm)};

    //Ports
    blocking_in<int> b_in;
    master_out<int> m_out;
    blocking_out<S> s_out;
    blocking_out<int> f_out;
    //Variables
    int x;
    bool y;
    int z;
    int cnt;
    bool sec;
    S s; //initialization here won't be considered here as well
    int Array[5];

    //! the tool generates double initialization stmts on CFG for each element inside struct, why?
    void fsm() {
        x = 3;//the initialization will be considered here by the tool as new stmts in the CFG following the reset sequence
        Array[2] = 10;
        //s = {2 , true};
        while (true) {

            if (sec == false) {
                b_in->nb_read(z);
                //  s.f = true;
                sec = true;
                cnt = 3;
                //s.d = 2;
                if (x > 3) {
                    m_out->write(s.d);
                    f_out->nb_write(Array[2]);
                } else {
                    m_out->write(x - 2);
                    s_out->nb_write(s);

                }
            } else if (sec == true) {
                y = !y;
                if (y == true) z = z * x;
                else z = z + x;
                --cnt;
                m_out->write(z - 2 + x);
                if (cnt == 0) sec = false;
            }


        }
    }

};

#endif //PROJECT_PAPER_H


