//
// Created by tobias on 05.01.18.
//

#ifndef PROJECT_CLK_H
#define PROJECT_CLK_H

#include "systemc.h"
#include "../../Interfaces_new/Interfaces.h"

struct Clk_new : public sc_module {
public:

    //Out-port
    slave_out<bool> clk1;
    slave_out<bool> clk2;
    slave_out<bool> clk3;
    slave_out<bool> clk4;
    slave_out<bool> clk5;
    slave_out<bool> clk6;
    Clk_new(sc_module_name name) :
            clk1("clk1"),
            clk2("clk2"),
            clk3("clk3"),
            clk4("clk4"),
            clk5("clk5"),
            clk6("clk6"){
        SC_THREAD(fsm)
    }
    SC_HAS_PROCESS(Clk_new);

    void fsm() {
        while (true) {
            clk1->slave_write(true);
            clk2->slave_write(true);
            clk3->slave_write(true);
            clk4->slave_write(true);
            clk5->slave_write(true);
            clk6->slave_write(true);
            wait(WAIT_TIME, SC_PS);
        }
    }
};



#endif //PROJECT_CLK_H
