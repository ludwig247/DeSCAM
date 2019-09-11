//
// Created by tobias on 09.03.17.
//

#ifndef PROJECT_MASTERAGENT_H
#define PROJECT_MASTERAGENT_H

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "Compound_Bus.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"


struct MasterAgent : public sc_module {
    //Sections
    enum Sections {
        IDLE, READ, WRITE, WAITING, DONE
    };
    Sections section;
    Sections nextsection;
    //CLK
    master_in<bool> clk;
    bool clk_pulse;

    //Communication between Master and Agent
    blocking_in<bus_req_t> master_to_agent;
    blocking_out <bus_resp_t> agent_to_master;

    //Communication on BUS
    shared_in<slave_signals> bus_to_agent;
    shared_out<master_signals> agent_to_bus;

    //Variables
    bus_req_t agent_to_bus_req;
    bus_resp_t agent_to_bus_resp;

    master_signals wb_out;
    slave_signals wb_in;

    //Constructor
    SC_HAS_PROCESS(MasterAgent);

    MasterAgent(sc_module_name name) :
            section(IDLE),
            nextsection(IDLE){
        SC_THREAD(fsm);
    }

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == IDLE) {
//                std::cout << this->name() << " - IDLE" << std::endl;
                this->master_to_agent->read(agent_to_bus_req);

                if(agent_to_bus_req.trans_type == SINGLE_READ){
                    nextsection = READ;
                }
                else nextsection = WRITE;
            }
            if (section == READ) {
//                std::cout << this->name() << " - READ" << std::endl;
                wb_out.addr = agent_to_bus_req.addr;
                wb_out.data = 0;
                wb_out.we = false;
                wb_out.cyc = true;
                wb_out.stb = true;
                agent_to_bus->set(wb_out);
                nextsection = WAITING;
            }
            if (section == WRITE) {
//                std::cout << this->name() << " - WRITE " << std::endl;
                wb_out.addr = agent_to_bus_req.addr;
                wb_out.data = agent_to_bus_req.data;
                wb_out.we = true;
                wb_out.cyc = true;
                wb_out.stb = true;
                agent_to_bus->set(wb_out);
                nextsection = WAITING;
            }
            if (section == WAITING) {
//                std::cout << this->name() << " - WAIT " << std::endl;
                clk->read(clk_pulse);
                bus_to_agent->get(wb_in);
                if(wb_in.ack == true){
                    agent_to_bus_resp.ack = OK;

                    if(agent_to_bus_req.trans_type == SINGLE_READ  ) {
                        agent_to_bus_resp.data = wb_in.data;
                    }
                    if(wb_in.err == true) {
                        agent_to_bus_resp.ack = ERR;
                    }
                    wb_out.addr = 0;
                    wb_out.data = 0;
                    wb_out.we = false;
                    wb_out.cyc = false;
                    wb_out.stb = false;

                    agent_to_bus->set(wb_out);
                    nextsection = DONE;
                }
            }
            if(section == DONE){
//                std::cout << this->name() << " - DONE " << std::endl;
                clk->read(clk_pulse);
                bus_to_agent->get(wb_in);
                if(wb_in.ack == false){
                    agent_to_master->write(agent_to_bus_resp);
                    nextsection = IDLE;
                }

            }
            wait(SC_ZERO_TIME);
        }
    }


};


#endif //PROJECT_MASTERAGENT_H
