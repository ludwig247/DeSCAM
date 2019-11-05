//
// Created by ovsthus on 22.07.19.
//

#ifndef UART_TRANCEIVER_H
#define UART_TRANCEIVER_H




#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"
#include "Memory_Interfaces.h"

#define bits(x) ((x & 1) + ((x >> 1) & 1) + ((x >> 2) & 1) + ((x >> 3) & 1) + ((x >> 4) & 1) + ((x >> 5) & 1)+ ((x >> 6) & 1) + ((x >> 7) & 1))


class Tranceiver : public sc_module {
public:

    SC_HAS_PROCESS(Tranceiver);


    enum Sections{initialize, run};

    Sections section, nextsection;

    unsigned int tx_buffer;
    unsigned int rx_buffer;


    bool tx_complete;
    bool buffer_empty;


    bool req;

    reg_files regs;


    CUtoME_IF request;

    blocking_in<CUtoME_IF> from_mem_if;
    blocking_out<reg_files> to_mem_if;

    master_out<unsigned int> data_out;
    master_in<unsigned int> data_in;

    master_out<bool> interrupt_out;

    Tranceiver(sc_module_name name) :
            from_mem_if("from_mem_if"),
            to_mem_if("to_mem_if"),
            data_out("data_out"),
            data_in("data_in"),
            interrupt_out("interrupt_out"),
            tx_complete(false),
            buffer_empty(true),
            section(Sections::initialize), //need this for ESL, optimized away by SCAM
            tx_buffer(0x7FF),
            rx_buffer(0x7FF)
    {
        SC_THREAD(fsm);
    }


    void fsm();


     unsigned int check_interrupt(unsigned int SR1_reg, unsigned int SR2_reg, unsigned int CR2_reg) const;
     unsigned int registerop(unsigned int reg, unsigned int addr, unsigned int data, ME_AccessType rw, ME_MaskType mt, unsigned int tag) const;
    unsigned int updateSr1(unsigned int rx_buff, unsigned int SR1) const;
    unsigned int updateRx(unsigned int rx, unsigned int rx_buff) const;
    unsigned int updateSr3(unsigned int sr3, unsigned int rx_buff) const;
    unsigned int countones(unsigned int reg) const;

};


void Tranceiver::fsm(){
    while(true) {
//        std::cout << this->name() << " does shit" << std::endl;


if(section == Sections::initialize){
    regs.CR1 = 0;
    regs.CR2 = 0;
    regs.CR3 = 0;
    regs.SR1 = 0;
    regs.SR2 = 0;
    regs.SR3 = 0;
    regs.TX = 0;
    regs.RX = 0;

    nextsection = Sections::run;
}



if(section == Sections::run) {

    req = from_mem_if->nb_read(request);

    if (check_interrupt(regs.SR1, regs.SR2, regs.CR2) != 0) {


        if(regs.SR2 == 0) {
            interrupt_out->write(true);
        }

        regs.SR2 = regs.SR2 | (regs.SR1 & regs.CR2); //update interrupt pending flags

    }

//    if(tx_complete && (regs.SR1 & TXNE_FLAG) != 0){
//        tx_complete = false;
//        regs.SR1 = regs.SR1 | TC_FLAG;
//    }
//
//
//    if(!buffer_empty){
//        buffer_empty = true;
//        tx_complete = true;
//        tx_buffer = 0xFFF;
//    }

    data_out->write(tx_buffer);

    if ((regs.SR1 & TXNE_FLAG) != 0) {
        regs.SR1 = regs.SR1 & ((-TXNE_FLAG) - 1);
        tx_buffer = (regs.TX << 1) | TX_STOP_BIT;

//      buffer_empty = false;
        if ((countones(regs.TX) % 2) != 0) tx_buffer = tx_buffer | TX_PARITY_BIT;

    } else{
        tx_buffer = 0x7FF;
    }






    regs.SR1 = updateSr1(rx_buffer, regs.SR1);
    regs.RX = updateRx(regs.RX, rx_buffer);
    regs.SR3 = updateSr3(regs.SR3, rx_buffer);

    data_in->read(rx_buffer);










    if (req) {

        regs.CR1 = registerop(regs.CR1, request.addrIn, request.dataIn, request.req, request.mask, CR1_addr);
        regs.CR2 = registerop(regs.CR2, request.addrIn, request.dataIn, request.req, request.mask, CR2_addr);
        regs.CR3 = registerop(regs.CR3, request.addrIn, request.dataIn, request.req, request.mask, CR3_addr);
        regs.SR1 = registerop(regs.SR1, request.addrIn, request.dataIn, request.req, request.mask, SR1_addr);
        regs.SR2 = registerop(regs.SR2, request.addrIn, request.dataIn, request.req, request.mask, SR2_addr);
        regs.SR3 = registerop(regs.SR3, request.addrIn, request.dataIn, request.req, request.mask, SR3_addr);
        regs.TX = registerop(regs.TX, request.addrIn, request.dataIn, request.req, request.mask, TX_addr);
        regs.RX = registerop(regs.RX, request.addrIn, request.dataIn, request.req, request.mask, RX_addr);

    }






    to_mem_if->nb_write(regs);


}


section = nextsection;

        wait(SC_ZERO_TIME);
    }
}

unsigned int Tranceiver::countones(unsigned int reg) const {

    return bits(reg); //very messy ITL without it.
}


unsigned int Tranceiver::updateRx(unsigned int rx , unsigned int rx_buff) const{

    if((rx_buffer & RX_START_BIT) == 0) {

        if (((countones(rx_buff >> 2) & BYTEMASK) % 2) == 0 && (rx_buff & RX_PARITY_BIT) == 0 &&
            (rx_buff & RX_STOP_BIT) != 0) {
            return (rx_buff >> 2) & BYTEMASK;
        } else if (((countones(rx_buff >> 2) & BYTEMASK) % 2) != 0 && (rx_buff & RX_PARITY_BIT) != 0 &&
                   (rx_buff & RX_STOP_BIT) != 0) {
            return (rx_buff >> 2) & BYTEMASK;
        } else {
            return rx;
        }

    }else return rx;

}


unsigned int Tranceiver::updateSr3(unsigned int sr3, unsigned int rx_buff) const{

    if((rx_buffer & RX_START_BIT) == 0){

        if(((countones(rx_buff >> 2) & BYTEMASK) % 2) == 0 && (rx_buff & RX_PARITY_BIT) == 0 && (rx_buff & RX_STOP_BIT) != 0) {
            return sr3;
        }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) != 0 && (rx_buff & RX_PARITY_BIT) != 0 && (rx_buff & RX_STOP_BIT) != 0){
            return sr3;
        }else{
            return (rx_buff >> 2) & BYTEMASK;
        }
    }else return sr3;

}


unsigned int Tranceiver::registerop(unsigned int reg, unsigned int addr, unsigned int data, ME_AccessType rw, ME_MaskType mt, unsigned int tag) const{

    if(rw == ME_WR && (mt == MT_B || mt == MT_BU)){
        if(addr == tag){
            return data & BYTEMASK;
        }else if(addr == TX_addr && tag == SR1_addr){
            return reg | TXNE_FLAG;
        }else return reg;
    }else if(rw == ME_WR && (mt == MT_H || mt == MT_HU)){
        return 0;
//        if(tag >= addr  && (tag - addr) <= 1 && (tag-addr) >= 0){
//            return (data >> 8*(addr-tag)) & BYTEMASK;
//        }else if(addr == TX_addr && tag == SR1_addr){
//            return reg | TXNE_FLAG;
//        }else{
//            return reg;
//        }
    }else if(rw == ME_WR && mt == MT_W){
        return 0;
//        if(tag >= addr  && (tag - addr) <= 3 && (tag-addr) >= 0){
//            return (data >> 8*(addr-tag)) & BYTEMASK;
//        }else if(addr == TX_addr && tag == SR1_addr){
//            return reg | TXNE_FLAG;
//        }else{
//            return reg;
//        }
    }else if(rw == ME_RD){
        if(addr == RX_addr && tag == SR1_addr){

            return reg & (-RXNE_FLAG -1);
        }else return reg;

    }else return reg;


}



unsigned int Tranceiver::updateSr1(unsigned int rx_buff, unsigned int SR1) const{

    if((rx_buffer & RX_START_BIT) == 0){

    if(((countones(rx_buff >> 2) & BYTEMASK) % 2) == 0 && (rx_buff & RX_PARITY_BIT) == 0 && (rx_buff & RX_STOP_BIT) != 0) {
        return SR1 | RXNE_FLAG;
    }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) != 0 && (rx_buff & RX_PARITY_BIT) != 0 && (rx_buff & RX_STOP_BIT) != 0){
        return SR1 | RXNE_FLAG;
    }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) == 0 && (rx_buff & RX_PARITY_BIT) == 0 && (rx_buff & RX_STOP_BIT) == 0) {
        return SR1 | FE_FLAG;
    }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) != 0 && (rx_buff & RX_PARITY_BIT) != 0 && (rx_buff & RX_STOP_BIT) == 0){
        return SR1 | FE_FLAG;
    }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) != 0 && (rx_buff & RX_PARITY_BIT) == 0 && (rx_buff & RX_STOP_BIT) != 0){
        return SR1 | PE_FLAG;
    }else if(((countones(rx_buff >> 2) & BYTEMASK) % 2) == 0 && (rx_buff & RX_PARITY_BIT) != 0 && (rx_buff & RX_STOP_BIT) != 0){
        return SR1 | PE_FLAG;
    }else{
        return SR1 | PE_FLAG | FE_FLAG;
    }
    }else return SR1;


}



unsigned int Tranceiver::check_interrupt(unsigned int SR1_reg, unsigned int SR2_reg, unsigned int CR2_reg) const {



        if ((CR2_reg & RXNEIE_FLAG) != 0 && (SR1_reg & RXNE_FLAG) != 0 && (SR2_reg & RXNE_pending) == 0){
            return 1;
        }else if((CR2_reg & TXNEIE_FLAG) != 0 && (SR1_reg & TXNE_FLAG) != 0 && (SR2_reg & TXNE_pending) == 0){//Overriding IP bit for this flag has uncertain results, should work in RTL but breaks ESL simulation
            return 1;
        }else if((CR2_reg & TCIE_FLAG) != 0 && (SR1_reg & TC_FLAG) != 0 && (SR2_reg & TC_pending) == 0){
            return 1;
        }else if((CR2_reg & PEIE_FLAG) != 0 && (SR1_reg & PE_FLAG) != 0 && (SR2_reg & PE_pending) == 0){
            return 1;
        }else if((CR2_reg & FEIE_FLAG) != 0 && (SR1_reg & FE_FLAG) != 0 && (SR2_reg & FE_pending) == 0){
            return 1;
        }else return 0;




}



#endif //UART_TRANCEIVER_H
