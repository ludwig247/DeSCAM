//
// Created by tobias on 09.03.17.
//

#ifndef PROJECT_INTERCONNECT_H
#define PROJECT_INTERCONNECT_H


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound_Bus.h"


struct Interconnect : public sc_module {
    //Sections
    enum Sections {
        IDLE, START, TRANSMITTING, DONE
    };
    Sections section;
    Sections nextsection;
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
    SC_HAS_PROCESS(Interconnect);

    Interconnect(sc_module_name name) :
            section(IDLE),
            nextsection(IDLE),
            master_input("master_input"),
            master_output("master_output"){
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == IDLE) {
                clk->read(clk_pulse);
                //std::cout << this->name() << " - IDLE" << std::endl;
                master_input->get(from_master);
                if (from_master.cyc == true && from_master.stb == true) {
                    nextsection = START;
                }
            }
            if (section == START) {
                //std::cout << this->name() << " - START addr" << from_master.addr << std::endl;
                nextsection = TRANSMITTING;
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
                    nextsection = DONE;
                }
            }
            if (section == TRANSMITTING) {
                //nextsection = DONE;
                from_master.data = 0;
                from_master.addr = 0;
                from_master.cyc = false;
                from_master.stb = false;
                from_master.we = false;
                clk->read(clk_pulse);
                //std::cout << this->name() << "- TRANSMITTING" << std::endl;
                if (slave_number == 0) {
                    slave_in0->get(to_master);
                    slave_number = 0;
                    if (to_master.ack == true) {
                        slave_out0->set(from_master);
                        nextsection = DONE;
                    }
                } else if (slave_number == 1) {
                    slave_in1->get(to_master);
                    slave_number = 1;
                    if (to_master.ack == true) {
                        slave_out1->set(from_master);
                        nextsection = DONE;
                    }
                } else if (slave_number == 2) {
                    slave_in2->get(to_master);
                    slave_number = 2;
                    if (to_master.ack == true) {
                        slave_out2->set(from_master);
                        nextsection = DONE;
                    }
                } else {
                    slave_in3->get(to_master);
                    slave_number = 3;
                    if (to_master.ack == true) {
                        slave_out3->set(from_master);
                        nextsection = DONE;
                    }
                }
            }
            if (section == DONE) {
                //Send response from slave to master
                master_output->set(to_master);

                //Wait until master has read the signals
                clk->read(clk_pulse);
                master_input->get(from_master);
                if (from_master.cyc == false && from_master.stb == false) {
                    //std::cout << this->name() << " - DONE " << std::endl;
                    to_master.ack = false;
                    to_master.err = false;
                    to_master.data = 0;
                    master_output->set(to_master);
                    nextsection = IDLE;
                }

            }
            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_INTERCONNECT_H
