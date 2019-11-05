//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_MASTERDUMMY_H
#define UART_MASTERDUMMY_H


#include "systemc.h"
#include "Memory_Interfaces.h"
#include "Interfaces.h"
#include <stdlib.h>
#include "compound.h"
#include <assert.h>
//#include <stdio.h>


struct MasterDummy : public sc_module {
public:

    //Out-port
    blocking_out <CUtoME_IF> bus_req;
    blocking_in <MEtoCU_IF> bus_resp;

    CUtoME_IF req;
    MEtoCU_IF resp;


    slave_in<bool> uart1_interrupt;


enum Sections {run1, run2, run3, run4, run5, run6};
Sections section, nextsection;

    unsigned int round_cnt = 0;
    unsigned int cnt2 = 0;


    unsigned int resp_stored;

    bool u1_it =  false;



    bool init = true;
    //Constructor
    SC_HAS_PROCESS(MasterDummy);

    MasterDummy(sc_module_name name) :
            bus_req("bus_req"),
            bus_resp("bus_resp"),
            uart1_interrupt("uart1_interrupt"),
            section(Sections::run1)

    {
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {


            if(section == Sections::run1 && init){

                req.addrIn = CR_ADDRESS; //on systemlevel the TE/RE flags are enabled and baudrate = sysclk is implicitly.
                req.dataIn =  TCIE_FLAG; //enable interrupts on transfer complete flag (requires TX register to not be loaded with new value before transfer is completed)
                req.req = ME_WR;
                req.mask = MT_W;

                bus_req->write(req);


                req.addrIn = TX_ADDRESS;
                req.dataIn = 255; //testing some corner values
                req.req = ME_WR;
                req.mask = MT_BU; //this can in reality be anything but MT_X as the upper three bytes are read only

                bus_req->write(req);


                init = false;
            }

            if(section == Sections::run2 && init){

                req.addrIn = TX_ADDRESS;
                req.dataIn = 1;
                req.req = ME_WR;
                req.mask = MT_BU; //this can in reality be anything but MT_X as the upper three bytes are read only

                bus_req->write(req);


                init = false;
            }

            if(section == Sections::run3 && init){

                req.addrIn = CR_ADDRESS;
                req.dataIn =  TXEIE_FLAG; //enable interrupts on empty TX register
                req.req = ME_WR;
                req.mask = MT_W;

                bus_req->write(req);




                init = false;
            }





            if(uart1_interrupt->nb_read(u1_it)) {


                req.addrIn = SR_ADDRESS;
                req.dataIn = 0;
                req.mask = MT_W;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);


                resp_stored = resp.loadedData;

                if(section == Sections::run1) {
                    assert((resp_stored & TC_FLAG) != 0 && "Error TC flag not set when it should be"); //reading from address 5 register clears certain flags (TC, FE, PE)
                    nextsection = Sections::run2;
                    init = true;
                }
                if(section == Sections::run2) {
                    assert((resp_stored & TC_FLAG) != 0 && "Error TC flag not set when it should be"); //reading from address 5 register clears certain flags (TC, FE, PE)
                    nextsection = Sections::run3;
                    init = true;
                }
                if(section == Sections::run3) {
                    assert((resp_stored & TXE_FLAG) != 0 && "Error TC flag not set when it should be"); //reading from address 5 register clears certain flags (TC, FE, PE)

                    req.addrIn = CR_ADDRESS;
                    req.dataIn =  RXNEIE_FLAG; //enable interrupts on received data;
                    req.req = ME_WR;
                    req.mask = MT_W;

                    bus_req->write(req);

                    req.addrIn = TX_ADDRESS;
                    req.dataIn = 170;
                    req.req = ME_WR;
                    req.mask = MT_BU;

                    bus_req->write(req);


                    nextsection = Sections::run4;

                }

                if(section == Sections::run4){
                    assert((resp_stored & RXNE_FLAG) != 0 && "RXNE flag should be set when error free data is received");
                    assert(((resp_stored & FE_FLAG) == 0 && (resp_stored & PE_FLAG) == 0)&& "Should be no errors here");

                    req.addrIn = DR_ADDRESS;
                    req.dataIn = 0;
                    req.mask = MT_W;
                    req.req = ME_RD;

                    bus_req->write(req);
                    bus_resp->read(resp);
                    resp.loadedData = resp.loadedData >> 8;


                    assert((resp.loadedData & BYTEMASK) == 87 && "correct value should be stored in RX");
                    resp.loadedData = resp.loadedData >> 8;
                    assert((resp.loadedData & BYTEMASK) != 87 && "correct value should not be stored in fault register");


                    req.addrIn = CR_ADDRESS;
                    req.dataIn =  PEIE_FLAG; //enable interrupts on parity error;
                    req.req = ME_WR;
                    req.mask = MT_W;

                    bus_req->write(req);

                    nextsection = Sections::run5;

                }

                if(section == Sections::run5){
                    assert((resp_stored & RXNE_FLAG) == 0 && "RXNE flag should not be set when erroneous data is received");
                    assert((resp_stored & PE_FLAG) != 0 && "Parity error flag should be set");

                    req.addrIn = DR_ADDRESS;
                    req.dataIn = 0;
                    req.mask = MT_W;
                    req.req = ME_RD;

                    bus_req->write(req);
                    bus_resp->read(resp);
                    resp.loadedData = resp.loadedData >> 8;


                    assert((resp.loadedData & BYTEMASK) != 15 && "incorrect value should not be stored in RX");
                    resp.loadedData = resp.loadedData >> 8;
                    assert((resp.loadedData & BYTEMASK) == 15 && "incorrect value should be stored in fault register");


                    req.addrIn = CR_ADDRESS;
                    req.dataIn =  FEIE_FLAG; //enable interrupts on frame error;
                    req.req = ME_WR;
                    req.mask = MT_W;

                    bus_req->write(req);

                    nextsection = Sections::run6;

                }

                if(section == Sections::run6){
                    assert((resp_stored & RXNE_FLAG) == 0 && "RXNE flag should not be set when erroneous data is received");
                    assert((resp_stored & FE_FLAG) != 0 && "frame error flag should be set");

                    req.addrIn = DR_ADDRESS;
                    req.dataIn = 0;
                    req.mask = MT_W;
                    req.req = ME_RD;

                    bus_req->write(req);
                    bus_resp->read(resp);
                    resp.loadedData = resp.loadedData >> 8;


                    assert((resp.loadedData & BYTEMASK) != 248 && "incorrect value should not be stored in RX");
                    resp.loadedData = resp.loadedData >> 8;
                    assert((resp.loadedData & BYTEMASK) == 248 && "incorrect value should be stored in fault register");


                    init = true;
                    nextsection = Sections::run1;

                    if(round_cnt++ >= 6){
                        sc_stop();
                    }



                }


                req.addrIn = SR_ADDRESS;
                req.dataIn = 0;
                req.mask = MT_B; // clearing interrupt pending bit
                req.req = ME_WR;

                bus_req->write(req);


            }


section = nextsection;



            wait(SC_ZERO_TIME);
        }
    }
};


#endif //UART_MASTERDUMMY_H
