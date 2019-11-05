//
// Created by tobias on 05.01.18.
//

#ifndef PROJECT_CLK_H
#define PROJECT_CLK_H

struct Clk : public sc_module {
public:

    //Out-port
    slave_out<bool> clk1;
    slave_out<bool> clk2;
    slave_out<bool> clk3;
    slave_out<bool> clk4;
    slave_out<bool> clk5;
    slave_out<bool> clk6;
    Clk(sc_module_name name) :
            clk1("clk1"),
            clk2("clk2"),
            clk3("clk3"),
            clk4("clk4"),
            clk5("clk5"),
            clk6("clk6"){
        SC_THREAD(fsm);
    }
    SC_HAS_PROCESS(Clk);

    //Constructor


    void fsm() {
        while (true) {
            clk1->nb_write(true);
            clk2->nb_write(true);
            clk3->nb_write(true);
            clk4->nb_write(true);
            clk5->nb_write(true);
            clk6->nb_write(true);
            wait(SC_ZERO_TIME);
        }
    }
};



#endif //PROJECT_CLK_H
