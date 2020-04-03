//
// Created by ludwig on 30.01.17.
//
#include "../../../Interfaces/Interfaces.h"
#include "systemc.h"

#include "../../../SingleMasterMultiSlave/ESL/Compound.h"

#ifndef PROJECT_BUS_H
#define PROJECT_BUS_H

struct Bus_new : public sc_module {

    //In-port
    blocking_in<bus_req_t> master_in;
    blocking_in<bus_resp_t> slave_in0;
    blocking_in<bus_resp_t> slave_in1;
    blocking_in<bus_resp_t> slave_in2;
    blocking_in<bus_resp_t> slave_in3;


    //Out-por
    blocking_out<bus_resp_t> master_out;
    blocking_out<bus_req_t> slave_out0;
    blocking_out<bus_req_t> slave_out1;
    blocking_out<bus_req_t> slave_out2;
    blocking_out<bus_req_t> slave_out3;

    //Variables
    bus_req_t req;
    bus_resp_t resp;

    int foo;

    //Constructor
unsigned int operations[24];
unsigned int originState;
    SC_HAS_PROCESS(Bus_new);

    Bus_new(sc_module_name name) :
            master_in("master_in"),
            master_out("master_out"),
            slave_out0("slave_out0"),
            slave_out1("slave_out1"),
            slave_out2("slave_out2"),
            slave_out3("slave_out3"),
            slave_in0("slave_in0"),
            slave_in1("slave_in1"),
            slave_in2("slave_in2"),
            slave_in3("slave_in3") {
        SC_THREAD(fsm);
    }


    void fsm() {
/*State 0*/
originState = 0;
        while (true) {
            /*
            0 - 7  HEAT
            8 - 15 MIX
            16 - 23 TEMP_TOP
            24 - 31 TEMP_BOT
             */
if (originState == 4)
operations[14]++;
if (originState == 0)
operations[0]++;
/*State 1*/            master_in->read(req);
originState = 1;
//	    std::cout << "req addrs:" << req.addr << std::endl;
//	    std::cout << "req data:" << req.data << std::endl;
//	    std::cout << "req mode:" << req.trans_type << std::endl;

            if(SINGLE_READ == req.trans_type){
                req.data = 0;
            }

            if  (req.addr >= 0 && req.addr < 8) {
if (originState == 1)
if (((req.addr >= 0) and (req.addr < 8)))
if (not((SINGLE_READ == req.trans_type)))
operations[6]++;
if (originState == 1)
if (((req.addr >= 0) and (req.addr < 8)))
if ((SINGLE_READ == req.trans_type))
operations[1]++;
/*State 2*/                slave_out0->write(req);
originState = 2;
if (originState == 2)
operations[11]++;
/*State 3*/                slave_in0->read(resp);
originState = 3;
            }

            else if (req.addr >= 8 && req.addr < 16) {
                req.addr = req.addr - 8;
if (originState == 1)
if (((req.addr >= 8) and (req.addr < 16)))
if (not(((req.addr >= 0) and (req.addr < 8))))
if (not((SINGLE_READ == req.trans_type)))
operations[7]++;
if (originState == 1)
if (((req.addr >= 8) and (req.addr < 16)))
if (not(((req.addr >= 0) and (req.addr < 8))))
if ((SINGLE_READ == req.trans_type))
operations[2]++;
/*State 5*/                slave_out1->write(req);
originState = 5;
if (originState == 5)
operations[15]++;
/*State 6*/                slave_in1->read(resp);
originState = 6;
            }
            else if (req.addr >= 16 && req.addr < 24) {
                req.addr = req.addr - 16;
if (originState == 1)
if (((req.addr >= 16) and (req.addr < 24)))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if (not((SINGLE_READ == req.trans_type)))
operations[8]++;
if (originState == 1)
if (((req.addr >= 16) and (req.addr < 24)))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if ((SINGLE_READ == req.trans_type))
operations[3]++;
/*State 7*/                slave_out2->write(req);
originState = 7;
if (originState == 7)
operations[18]++;
/*State 8*/                slave_in2->read(resp);
originState = 8;
            }
            else if (req.addr >= 24 && req.addr < 32) {
                req.addr = req.addr - 24;
if (originState == 1)
if (((req.addr >= 24) and (req.addr < 32)))
if (not(((req.addr >= 16) and (req.addr < 24))))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if (not((SINGLE_READ == req.trans_type)))
operations[9]++;
if (originState == 1)
if (((req.addr >= 24) and (req.addr < 32)))
if (not(((req.addr >= 16) and (req.addr < 24))))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if ((SINGLE_READ == req.trans_type))
operations[4]++;
/*State 9*/                slave_out3->write(req);
originState = 9;
if (originState == 9)
operations[21]++;
/*State 10*/                slave_in3->read(resp);
originState = 10;
            }
            else {
//                resp.ack = OK;
//                resp.data = 0;
            }
            if(SINGLE_WRITE== req.trans_type){
                resp.data = 0;
            }
if (originState == 10)
if (not((SINGLE_WRITE == req.trans_type)))
operations[23]++;
if (originState == 10)
if ((SINGLE_WRITE == req.trans_type))
operations[22]++;
if (originState == 8)
if (not((SINGLE_WRITE == req.trans_type)))
operations[20]++;
if (originState == 8)
if ((SINGLE_WRITE == req.trans_type))
operations[19]++;
if (originState == 6)
if (not((SINGLE_WRITE == req.trans_type)))
operations[17]++;
if (originState == 6)
if ((SINGLE_WRITE == req.trans_type))
operations[16]++;
if (originState == 3)
if (not((SINGLE_WRITE == req.trans_type)))
operations[13]++;
if (originState == 3)
if ((SINGLE_WRITE == req.trans_type))
operations[12]++;
if (originState == 1)
if ((SINGLE_WRITE == req.trans_type))
if (not(((req.addr >= 24) and (req.addr < 32))))
if (not(((req.addr >= 16) and (req.addr < 24))))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if (not((SINGLE_READ == req.trans_type)))
operations[10]++;
if (originState == 1)
if (not((SINGLE_WRITE == req.trans_type)))
if (not(((req.addr >= 24) and (req.addr < 32))))
if (not(((req.addr >= 16) and (req.addr < 24))))
if (not(((req.addr >= 8) and (req.addr < 16))))
if (not(((req.addr >= 0) and (req.addr < 8))))
if ((SINGLE_READ == req.trans_type))
operations[5]++;
/*State 4*/            master_out->write(resp);
originState = 4;

            //wait(SC_ZERO_TIME);
        }
    }

    void operationsCounter()  {
        for(int i = 0; i < 24; i++)
            std::cout << "Operation " << i << ":" << operations[i] << std::endl;
    }
};


#endif //PROJECT_BUS_H
