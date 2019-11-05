//
// Created by ovsthus on 18.01.19.
//

#ifndef UART_REQ_HANDLER_H
#define UART_REQ_HANDLER_H

#define CR_ADDRESS 1
#define SR_ADDRESS 2
#define RX_ADDRESS 3
#define TX_ADDRESS 4


#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"





class Req_handler : public sc_module {
public:

    SC_HAS_PROCESS(Req_handler);

    CUtoME_IF uart_in;
    MEtoCU_IF uart_out;

    blocking_in<CUtoME_IF> request;
    blocking_out<MEtoCU_IF> response;
    master_out<unsigned int> CR_write;
    master_in<unsigned int> CR_read;
    master_out<unsigned int> SR_write;
    master_in<unsigned int> SR_read;
    master_out<unsigned int> TX_write;
    master_in<unsigned int> RX_read;
    master_out<bool> RXNE_false;

    Req_handler(sc_module_name name) :
           request("request"),
           response("response"),
           CR_write("CR_write"),
           CR_read("CR_read"),
           SR_write("SR_write"),
           SR_read("SR_read"),
           TX_write("TX_write"),
           RX_read("RX_read"),
           RXNE_false("RXNE_false")
    {
        SC_THREAD(fsm);
    }

    void fsm();

};


void Req_handler::fsm(){
    while(true) {

         uart_out.loadedData = 0;
         request->read(uart_in);

         if(uart_in.addrIn == CR_ADDRESS){
            if(uart_in.req == ME_RD){
                CR_read->read(uart_out.loadedData);
            }else if(uart_in.req == ME_WR){
                CR_write->write(uart_in.dataIn);
            }

         }else if(uart_in.addrIn == SR_ADDRESS){
             if(uart_in.req == ME_RD){
                 SR_read->read(uart_out.loadedData);
             }else if(uart_in.req == ME_WR){
                 SR_write->write(uart_in.dataIn);
             }
         }else if(uart_in.addrIn == RX_ADDRESS){
             if(uart_in.req == ME_RD){
                 RX_read->read(uart_out.loadedData);
                 RXNE_false->write(false);
             }
         }else if(uart_in.addrIn == TX_ADDRESS){
             if(uart_in.req == ME_WR){
                 TX_write->write(uart_in.dataIn);
             }
         }

         if(uart_in.req == ME_RD) {
             response->write(uart_out);
         }
        wait(SC_ZERO_TIME);
    }
}




#endif //UART_REQ_HANDLER_H
