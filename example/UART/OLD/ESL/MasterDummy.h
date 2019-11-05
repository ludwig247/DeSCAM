//
// Created by ovsthus on 11/28/18.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
#ifndef UART_MASTERDUMMY_H
#define UART_MASTERDUMMY_H

#include "systemc.h"
#include "Memory_Interfaces.h"
#include "Interfaces.h"
#include <stdlib.h>
#include "compound.h"
//#include <stdio.h>


struct MasterDummy : public sc_module {
public:

    //Out-port
    blocking_out <CUtoME_IF> bus_req;
    blocking_in <MEtoCU_IF> bus_resp;

CUtoME_IF req;
MEtoCU_IF resp;


    slave_in<bool> uart1_interrupt;
//    slave_in<bool> uart2_interrupt;





    unsigned int cnt = 0;
    unsigned int cnt2 = 0;


    unsigned int resp_stored;

    bool u1_it =  false;
    bool u2_it = false;


    bool init = true;
    //Constructor
    SC_HAS_PROCESS(MasterDummy);

    MasterDummy(sc_module_name name) :
            bus_req("bus_req"),
            bus_resp("bus_resp"),
            uart1_interrupt("uart1_interrupt")
//            uart2_interrupt("uart2_interrupt")
            {
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {



            if(uart1_interrupt->nb_read(u1_it)){
                std::cout << "uart1 interrupt handler" << std::endl;
                req.addrIn = SR_ADDRESS;
                req.dataIn = 0;
                req.mask = MT_W;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                resp_stored = resp.loadedData;

                if(resp_stored & PE_FLAG) std::cout << "uart1 PARITY ERROR"<< std::endl;
                else if(resp_stored & FE_FLAG) std::cout << "uart1 FRAME ERROR"<< std::endl;


                if(resp_stored & RXNE_FLAG) {
                    req.addrIn = RX_ADDRESS;
                    req.dataIn = 0;
                    req.mask = MT_BU;
                    req.req = ME_RD;

                    bus_req->write(req);
                    bus_resp->read(resp);
                    std::cout << "uart1 reads: " << resp.loadedData << std::endl;
                }

                if(resp_stored & TC_FLAG) {
                    req.addrIn = TX_ADDRESS;
                    req.dataIn = cnt++;
                    req.mask = MT_BU;
                    req.req = ME_WR;

                    bus_req->write(req);
                    std::cout << "uart1 sends: " << cnt - 1 << std::endl;
                }


                req.addrIn = SR_ADDRESS;
                req.dataIn = I_IP;
                req.mask = MT_W;
                req.req = ME_WR;

                bus_req->write(req);

            }

//            if(uart2_interrupt->nb_read(u2_it)){
//                std::cout << "uart2 interrupt handler" << std::endl;
//                req.addrIn = SR_ADDRESS + 12;
//                req.dataIn = 0;
//                req.mask = MT_W;
//                req.req = ME_RD;
//
//                bus_req->write(req);
//                bus_resp->read(resp);
//                resp_stored = resp.loadedData;
//
//                if(resp_stored & PE_FLAG) std::cout << "uart2 PARITY ERROR"<< std::endl;
//                else if(resp_stored & FE_FLAG) std::cout << "uart2 FRAME ERROR"<< std::endl;
//
//                    if(resp_stored & RXNE_FLAG) {
//                    req.addrIn = RX_ADDRESS + 12;
//                    req.dataIn = 0;
//                    req.mask = MT_BU;
//                    req.req = ME_RD;
//
//                    bus_req->write(req);
//                    bus_resp->read(resp);
//                    std::cout << "uart2 reads: " << resp.loadedData << std::endl;
//                }
//
//                if(resp_stored & TC_FLAG) {
//                    req.addrIn = TX_ADDRESS + 12;
//                    req.dataIn = cnt++;
//                    req.mask = MT_BU;
//                    req.req = ME_WR;
//
//                    bus_req->write(req);
//                    std::cout << "uart2 sends: " << cnt << std::endl;
//                }
//
//                req.addrIn = SR_ADDRESS + 12;
//                req.dataIn = I_IP;
//                req.mask = MT_W;
//                req.req = ME_WR;
//
//                bus_req->write(req);
//
//            }


            if(init) {
                req.addrIn = CR_ADDRESS;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG | TCIE_FLAG | ODD_PARITY; //| TCIE_FLAG; // | RXNEIE_FLAG |  | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;
                req.mask = MT_W;

                bus_req->write(req);

//                req.addrIn = CR_ADDRESS + 12;
//                req.dataIn = RE_FLAG | TCIE_FLAG |RXNEIE_FLAG | ODD_PARITY; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
//                req.req = ME_WR;
//                req.mask = MT_W;
//
//                bus_req->write(req);
//
//
                req.addrIn = TX_ADDRESS;
                req.dataIn = 255;
                req.req = ME_WR;
                req.mask = MT_BU;

                bus_req->write(req);







                init = false;
            }





if(cnt >= 255){
    cnt = 0;
    cnt2 = cnt2 + 300;
}




            wait(SC_ZERO_TIME);
        }
    }
};

#endif //UART_MASTERDUMMY_H

#pragma clang diagnostic pop