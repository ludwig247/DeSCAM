//
// Created by tobias on 09.03.17.
//

#ifndef PROJECT_SLAVEAGENT_H
#define PROJECT_SLAVEAGENT_H
#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"
#include "../../../example/Whishbone/ESL/env/Compound_Bus.h"
//#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "/import/lab/users/hesselberg/Simon_repo/DeSCAM/tests/Print_ITL_Tests/TestCases/Types.h"



struct SlaveAgent : public sc_module {
    //Sections
    enum Phases {
        IDLE, READ, WRITE,DONE
    };
    Phases phase;
    Phases nextphase;

    //clock
    master_in<bool> clk;
    bool clk_pulse;

    //Communication between Master and Agent
    blocking_in<bus_resp_t> slave_to_agent;
    blocking_out<bus_req_t> agent_to_slave;

    //Communication on BUSM
    shared_in<master_signals> bus_to_agent;
    shared_out<slave_signals> agent_to_bus;

    //Variables
    bus_req_t agent_to_slave_req;
    bus_resp_t slave_to_agent_resp;

    slave_signals wb_out;
    master_signals wb_in;

    //Constructor
    SC_HAS_PROCESS(SlaveAgent);

    SlaveAgent(sc_module_name name) {
        SC_THREAD(fsm)
    }

    void fsm() {
        nextphase = IDLE;
        while (true) {
            phase = nextphase;
            if (phase == IDLE) {
//                std::cout << this->name() << " - SLAVE IDLE"  << std::endl;
                clk->master_read(clk_pulse);
                this->bus_to_agent->get(wb_in);

                if (wb_in.cyc == true && wb_in.stb == true && wb_in.we == false) {
                    nextphase = READ;
                } else if (wb_in.cyc == true && wb_in.stb == true && wb_in.we == true) {
                    nextphase = WRITE;
                }
            }
            else if (phase == READ) {
//                std::cout << this->name() << " - SLAVE READ" << std::endl;
                agent_to_slave_req.trans_type = SINGLE_READ;
                agent_to_slave_req.addr = wb_in.addr;
                agent_to_slave_req.data = 0;
                agent_to_slave->write(agent_to_slave_req);
                slave_to_agent->read(slave_to_agent_resp);
                nextphase = DONE;
            }
            else if (phase == WRITE) {
//                std::cout << this->name() << " - SLAVE WRITE " << std::endl;
                agent_to_slave_req.trans_type = SINGLE_WRITE;
                agent_to_slave_req.addr = wb_in.addr;
                agent_to_slave_req.data = wb_in.data;

                agent_to_slave->write(agent_to_slave_req);
                slave_to_agent->read(slave_to_agent_resp);
                slave_to_agent_resp.data = 0;
                nextphase = DONE;
            }
            else if (phase == DONE) {
//                std::cout << this->name() << " - SLAVE DONE " << std::endl;
                clk->master_read(clk_pulse);
                bus_to_agent->get(wb_in);

                if(wb_in.cyc == false && wb_in.stb == false){
                    wb_out.ack = false;
                    wb_out.err = false;
                    wb_out.data = 0;
                    nextphase = IDLE;
                }else{
                    wb_out.ack = true;
                    wb_out.err = slave_to_agent_resp.ack != OK;
                    wb_out.data = 0;
                    //Is read? -> put data on bus
                    if (wb_in.we == false) {
                        wb_out.data = slave_to_agent_resp.data;
                    }
                }
                agent_to_bus->set(wb_out);
            }
//            wait(WAIT_TIME, SC_PS);
//            wait(SC_ZERO_TIME);
        }
    }
};

#endif //PROJECT_SLAVEAGENT_H
