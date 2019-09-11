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

#define CR_ADDRESS 1
#define SR_ADDRESS 2
#define RX_ADDRESS 3
#define TX_ADDRESS 4

#define TXE_FLAG 1
#define RXNE_FLAG 2
#define TC_FLAG 4

#define TE_FLAG 1
#define RE_FLAG 2
#define RXNEIE_FLAG 8
#define TCIE_FLAG 16
#define TXEIE_FLAG 32
#define PEIE_FLAG 64
#define FEIE_FLAG 128

struct MasterDummy : public sc_module {
public:

    //Out-port
    blocking_out <CUtoME_IF> bus_req;
    blocking_in <MEtoCU_IF> bus_resp;

CUtoME_IF req;
MEtoCU_IF resp;


    slave_in<bool> uart1_interrupt;
    slave_in<bool> uart2_interrupt;
    slave_in<bool> uart3_interrupt;
    slave_in<bool> uart4_interrupt;
    slave_in<bool> uart5_interrupt;


    unsigned int data1 = 1;
    unsigned int data2 = 1;

    unsigned int cnt = 0;

    unsigned int offset1 = 0;
    unsigned int lastoffset = 0;
    unsigned int offset2 = 8;
    unsigned int id1 = 1;
    unsigned int id2 = 2;

    unsigned int temp1;
    unsigned int temp2;


    bool u1_it =  false;
    bool u2_it = false;
    bool u3_it =  false;
    bool u4_it = false;
    bool u5_it =  false;

    bool init = true;
    //Constructor
    SC_HAS_PROCESS(MasterDummy);

    MasterDummy(sc_module_name name) :
            bus_req("bus_req"),
            bus_resp("bus_resp"),
            uart1_interrupt("uart1_interrupt"),
            uart2_interrupt("uart2_interrupt"),
            uart3_interrupt("uart3_interrupt"),
            uart4_interrupt("uart4_interrupt"),
            uart5_interrupt("uart5_interrupt")
            {
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {

            if(uart1_interrupt->nb_read(u1_it)){
                req.addrIn = RX_ADDRESS;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                std::cout << "uart1 read: " << resp.loadedData << std::endl;
            }

            if(uart2_interrupt->nb_read(u1_it)){
                req.addrIn = RX_ADDRESS + 8;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                std::cout << "uart2 read: " << resp.loadedData << std::endl;
            }
            if(uart3_interrupt->nb_read(u1_it)){
                req.addrIn = RX_ADDRESS + 16;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                std::cout << "uart3 read: " << resp.loadedData << std::endl;
            }
            if(uart4_interrupt->nb_read(u1_it)){
                req.addrIn = RX_ADDRESS + 24;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                std::cout << "uart4 read: " << resp.loadedData << std::endl;
            }
            if(uart5_interrupt->nb_read(u1_it)){
                req.addrIn = RX_ADDRESS + 32;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);
                std::cout << "uart5 read: " << resp.loadedData << std::endl;
            }


            if(init) {
                req.addrIn = CR_ADDRESS;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;

                bus_req->write(req);

                req.addrIn = CR_ADDRESS + 8;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;

                bus_req->write(req);

                req.addrIn = CR_ADDRESS + 16;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;

                bus_req->write(req);

                req.addrIn = CR_ADDRESS + 24;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;

                bus_req->write(req);


                req.addrIn = CR_ADDRESS + 32;
                req.dataIn = TE_FLAG | RE_FLAG | RXNEIE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
                req.req = ME_WR;

                bus_req->write(req);

//                req.addrIn = TX_ADDRESS + 24;
//                req.dataIn = 7; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
//                req.req = ME_WR;  //for now this has to be done manually
//
//                bus_req->write(req);

                init = false;
            }


            req.addrIn = SR_ADDRESS + offset1;
            req.dataIn = 0;
            req.req = ME_RD;

            bus_req->write(req);
            bus_resp->read(resp);

            if(lastoffset != offset1){
                req.addrIn = SR_ADDRESS + lastoffset;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);



                if(resp.loadedData & TC_FLAG && resp.loadedData & TXE_FLAG){
                    req.addrIn = TX_ADDRESS + offset1;
                    req.dataIn = cnt; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
                    req.req = ME_WR;  //for now this has to be done manually
                    cnt++;
                    bus_req->write(req);
                    std::cout << "uart" << (offset1/8)+1 << " writes " << cnt << std::endl;
                    lastoffset = offset1;

                }

            }else {


                if (resp.loadedData & TXE_FLAG) {
                    req.addrIn = TX_ADDRESS + offset1;
                    req.dataIn = cnt; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
                    req.req = ME_WR;  //for now this has to be done manually
                    cnt++;
                    bus_req->write(req);
                    std::cout << "uart" << (offset1 / 8) + 1 << " writes " << cnt << std::endl;


                }

            }

            if(cnt >= 255){

                req.addrIn = SR_ADDRESS + offset1;
                req.dataIn = 0;
                req.req = ME_RD;

                bus_req->write(req);
                bus_resp->read(resp);

                if (resp.loadedData & TXE_FLAG) {
                    req.addrIn = TX_ADDRESS + offset1;
                    req.dataIn = 255; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
                    req.req = ME_WR;  //for now this has to be done manually
                    bus_req->write(req);
                    std::cout << "uart" << (offset1 / 8) + 1 << " writes endline" << std::endl;

                    offset1 = offset1 + 8;
                    if(offset1 > 32) offset1 = 0;
                    if(offset1 == 0) cnt = 2;
                    if(offset1 == 8) cnt = 1;
                    if(offset1 == 16) cnt = 5;
                    if(offset1 == 32) cnt = 3;
                    if(offset1 == 24) cnt = 4;




                }


                }






//
//
//            if(data1 > 255) data1 = 0;
//
//            if(data2 > 255) data2 = 0;
//
////            if(uart1_interrupt->nb_read(u1_it)){}
////
////            if(uart2_interrupt->nb_read(u2_it)){}
//
//
//            if(++data2 == 50){
//                temp1 = offset1;
//                temp2 = id1;
//                offset1 = offset2;
//                id1 = id2;
//                offset2 = temp1;
//                id2 = temp2;
//                data2 = 0;
//                init = true;
//
//            }
//
//
//
//
//            if(init) {
//
//                req.addrIn = CR_ADDRESS + offset2;
//                req.dataIn = TE_FLAG; // | RE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
//                req.req = ME_WR;
//
//                bus_req->write(req);
//
//                req.addrIn = CR_ADDRESS + offset1;
//                req.dataIn = RE_FLAG; // | TE_FLAG; //  | TE_FLAG; // | RXNEIE_FLAG | TXEIE_FLAG | TCIE_FLAG| PEIE_FLAG | FEIE_FLAG;
//                req.req = ME_WR;
//
//                bus_req->write(req);
//
//
//
//
//                req.addrIn = TX_ADDRESS + offset2;
//                req.dataIn = 255; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
//                req.req = ME_WR;  //for now this has to be done manually
//
//                bus_req->write(req);
//
//
//                std::cout << "uart" << id2 << " init: " << req.dataIn << std::endl;
//
//
//                init = false;
//
////                req.addrIn = TX_ADDRESS + offset1;
////                req.dataIn = 255; //sending idle line is reccomended so receiver doesnt risk interpreting mid transmission as start of transmission
////                req.req = ME_WR;  //for now this has to be done manually
////
////                bus_req->write(req);
////
////
////                std::cout << "uart" << id1 << " init: " << req.dataIn << std::endl;
//
//
//            }
//
//
//
//    req.addrIn = SR_ADDRESS + offset1;
//    req.dataIn = 0;
//    req.req = ME_RD;
//
//    bus_req->write(req);
//    bus_resp->read(resp);
//
//
//
//
////    if (resp.loadedData & TC_FLAG && resp.loadedData & TXE_FLAG) {
////        req.addrIn = TX_ADDRESS + offset1;
////        req.dataIn = data2;
////        req.req = ME_WR;
////
////        bus_req->write(req);
////
////        data2++; // = data + 1;
////
////        }
//
//        if (resp.loadedData & RXNE_FLAG) {
//            req.addrIn = RX_ADDRESS + offset1;
//            req.dataIn = 0;
//            req.req = ME_RD;
//
//            bus_req->write(req);
//            bus_resp->read(resp);
//            std::cout << "uart" << id1 << " read: " << resp.loadedData << std::endl;
//        }
//
//
//
//
//
//    req.addrIn = SR_ADDRESS + offset2;
//    req.dataIn = 0;
//    req.req = ME_RD;
//
//    bus_req->write(req);
//    bus_resp->read(resp);
//
////            uart2_interrupt->nb_read(u2_it) uart1_interrupt->nb_read(u1_it)
//    if (resp.loadedData & TC_FLAG && resp.loadedData & TXE_FLAG) {
//        req.addrIn = TX_ADDRESS + offset2;
//        req.dataIn = data1;//data;
//        req.req = ME_WR;
//
//        bus_req->write(req);
//
//        data1++; // = data + 1;
////         cnt++;
//    }
//
////    if (resp.loadedData & RXNE_FLAG) {
////        req.addrIn = RX_ADDRESS + offset2;
////        req.dataIn = 0;
////        req.req = ME_RD;
////
////        bus_req->write(req);
////        bus_resp->read(resp);
////        std::cout << "uart" << id2 << " read: " << resp.loadedData << std::endl;
////    }
////
//


            wait(SC_ZERO_TIME);
        }
    }
};

#endif //UART_MASTERDUMMY_H

#pragma clang diagnostic pop