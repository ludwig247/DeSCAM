//
// Created by tobias on 09.03.17.
//

#ifndef PROJECT_INTERCONNECT_H
#define PROJECT_INTERCONNECT_H


#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"
#include "../../../example/Whishbone/ESL/env/Compound_Bus.h"


struct Interconnect_new : public sc_module {
    //Sections
    enum Phases {
        IDLE, START, TRANSMITTING, DONE
    };
    Phases phase;
    Phases nextphase;
    //clock
    master_in<bool> clk;
    bool clk_pulse;

    //Master
    shared_in<master_signals> master_input;
    shared_out<slave_signals> master_output;

    //Slaves
    shared_in<slave_signals> slave_in0;
    shared_in<slave_signals> slave_in1;
    shared_in<slave_signals> slave_in2;
    shared_in<slave_signals> slave_in3;

    shared_out<master_signals> slave_out0;
    shared_out<master_signals> slave_out1;
    shared_out<master_signals> slave_out2;
    shared_out<master_signals> slave_out3;

    //Variables
    master_signals from_master;

    slave_signals to_master;
    int slave_number;
    //Constructor
    SC_HAS_PROCESS(Interconnect_new);

    Interconnect_new(sc_module_name name) :
            master_input("master_input"),
            master_output("master_output"){
        SC_THREAD(fsm)
    }

    void fsm() {
        nextphase = IDLE;
        while (true) {
            phase = nextphase;
            if (phase == IDLE) {
//                std::cout << this->name() << " - IDLE" << std::endl;
                clk->master_read(clk_pulse);
                master_input->get(from_master);
                if (from_master.cyc == true && from_master.stb == true) {
                    nextphase = START;
                }
            }
            else if (phase == START) {
//                std::cout << this->name() << " - START addr" << from_master.addr << std::endl;
                nextphase = TRANSMITTING;
                if (from_master.addr >= 0 && from_master.addr < 8) {
                    slave_out0->set(from_master);
                    slave_number = 0;
                } else if (from_master.addr >= 8 && from_master.addr < 16) {
                    from_master.addr = from_master.addr - 8;
                    slave_out1->set(from_master);
                    slave_number = 1;
                } else if (from_master.addr >= 16 && from_master.addr < 24) {
                    from_master.addr = from_master.addr - 16;
                    slave_out2->set(from_master);
                    slave_number = 2;
                } else if (from_master.addr >= 24 && from_master.addr < 32) {
                    from_master.addr = from_master.addr - 24;
                    slave_out3->set(from_master);
                    slave_number = 3;
                } else {
                    to_master.ack = true;
                    to_master.data = 0;
                    to_master.err = false;
                    nextphase = DONE;
                }
            }
            else if (phase == TRANSMITTING) {
                //nextphase = DONE;
                from_master.data = 0;
                from_master.addr = 0;
                from_master.cyc = false;
                from_master.stb = false;
                from_master.we = false;
//                std::cout << this->name() << "- TRANSMITTING: " << slave_number << " - ack=" << to_master.ack << std::endl;
                clk->master_read(clk_pulse);
                if (slave_number == 0) {
                    slave_in0->get(to_master);
                    slave_number = 0;
                    if (to_master.ack == true) {
                        slave_out0->set(from_master);
                        nextphase = DONE;
                    }
                } else if (slave_number == 1) {
                    slave_in1->get(to_master);
                    slave_number = 1;
                    if (to_master.ack == true) {
                        slave_out1->set(from_master);
                        nextphase = DONE;
                    }
                } else if (slave_number == 2) {
                    slave_in2->get(to_master);
                    slave_number = 2;
                    if (to_master.ack == true) {
                        slave_out2->set(from_master);
                        nextphase = DONE;
                    }
                } else {
                    slave_in3->get(to_master);
                    slave_number = 3;
                    if (to_master.ack == true) {
                        slave_out3->set(from_master);
                        nextphase = DONE;
                    }
                }
            }
            else if (phase == DONE) {
                //Send response from slave to master
                master_output->set(to_master);

//                std::cout << this->name() << " - DONE " << std::endl;
                //Wait until master has read the signals
                clk->master_read(clk_pulse);
                master_input->get(from_master);
                if (from_master.cyc == false && from_master.stb == false) {
                    //std::cout << this->name() << " - DONE " << std::endl;
                    to_master.ack = false;
                    to_master.err = false;
                    to_master.data = 0;
                    master_output->set(to_master);
                    nextphase = IDLE;
                }

            }
//            wait(WAIT_TIME, SC_PS);
//            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_INTERCONNECT_H
