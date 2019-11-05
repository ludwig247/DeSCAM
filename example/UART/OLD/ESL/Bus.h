//
// Created by ludwig on 30.01.17.
//
#include "Interfaces.h"
#include "systemc.h"
#include "Memory_Interfaces.h"


#ifndef PROJECT_BUS_H
#define PROJECT_BUS_H

struct Bus : public sc_module {

    //In-port
    blocking_in<CUtoME_IF> master_in;
    blocking_in<MEtoCU_IF> slave_in0;
//    blocking_in<MEtoCU_IF> slave_in1;
//    blocking_in<MEtoCU_IF> slave_in2;
//    blocking_in<MEtoCU_IF> slave_in3;
//    blocking_in<MEtoCU_IF> slave_in4;



    //Out-por
    blocking_out<MEtoCU_IF> master_out;
    blocking_out<CUtoME_IF> slave_out0;
//    blocking_out<CUtoME_IF> slave_out1;
//    blocking_out<CUtoME_IF> slave_out2;
//    blocking_out<CUtoME_IF> slave_out3;
//    blocking_out<CUtoME_IF> slave_out4;


    //Variables
    CUtoME_IF req;
    MEtoCU_IF resp;

    //Constructor
    SC_HAS_PROCESS(Bus);

    Bus(sc_module_name name) :
            master_in("master_in"),
            master_out("master_out"),
            slave_out0("slave_out0"),
//            slave_out1("slave_out1"),
//            slave_out2("slave_out2"),
//            slave_out3("slave_out3"),
//            slave_out4("slave_out4"),
            slave_in0("slave_in0")
//            slave_in1("slave_in1")
//            slave_in2("slave_in2"),
//            slave_in3("slave_in3"),
//            slave_in4("slave_in4")
            {
        SC_THREAD(fsm);
    }


    void fsm() {

        while (true) {
            /*
            0 - 7  HEAT
            8 - 15 MIX
            16 - 23 TEMP_TOP
            24 - 31 TEMP_BOT
             */
            master_in->read(req);

//            if(SINGLE_READ == req.trans_type){
//                req.data = 0;
//            }
//
            if  (req.addrIn >= 0 && req.addrIn < 12) {
                slave_out0->write(req);
                if(req.req == ME_RD){
                    slave_in0->read(resp);
                }

            }
//            else if (req.addrIn >= 12 && req.addrIn < 24) {
//                req.addrIn = req.addrIn - 12;
//                slave_out1->write(req);
//                if(req.req == ME_RD){
//                    slave_in1->read(resp);
//                }
//            }
//            else if (req.addrIn >= 16 && req.addrIn < 24) {
//                req.addrIn = req.addrIn - 16;
//                slave_out2->write(req);
//                if(req.req == ME_RD) {
//                    slave_in2->read(resp);
//                }
//            }
//            else if (req.addrIn >= 24 && req.addrIn < 32) {
//                req.addrIn = req.addrIn - 24;
//                slave_out3->write(req);
//                if(req.req == ME_RD) {
//                    slave_in3->read(resp);
//                }
//            } else if (req.addrIn >= 32 && req.addrIn < 40) {
//                req.addrIn = req.addrIn - 32;
//                slave_out4->write(req);
//                if(req.req == ME_RD) {
//                    slave_in4->read(resp);
//                }
//            }
            else {
                resp.loadedData = 0;
            }
//            if(SINGLE_WRITE== req.trans_type){
//                resp.data = 0;
//            }

            if(req.req == ME_RD) {
                master_out->write(resp);
            }

            wait(SC_ZERO_TIME);
        }
    }
};


#endif //PROJECT_BUS_H
