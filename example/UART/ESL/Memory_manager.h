//
// Created by ovsthus on 8/6/19.
//

#ifndef UART_MEMORY_MANAGER_H
#define UART_MEMORY_MANAGER_H




#include "systemc.h"
#include "Interfaces.h"
#include "compound.h"
#include "Memory_Interfaces.h"



class Memory_manager : public sc_module {
public:

    SC_HAS_PROCESS(Memory_manager);



    reg_files regs;


    CUtoME_IF request;
    MEtoCU_IF response;



    blocking_in<CUtoME_IF> bus_to_mem_man;
    blocking_out<MEtoCU_IF> mem_man_to_bus;
    master_out<CUtoME_IF> mem_man_to_ctrl;
    master_in<reg_files> ctrl_to_mem_man;

    Memory_manager(sc_module_name name) :
            bus_to_mem_man("bus_to_mem_man"),
            mem_man_to_bus("mem_man_to_bus"),
            mem_man_to_ctrl("mem_man_to_ctrl"),
            ctrl_to_mem_man("ctrl_to_mem_man")
    {
        SC_THREAD(fsm);
    }


    void fsm();






    unsigned int response_data(reg_files reg, CUtoME_IF req) const;


};


void Memory_manager::fsm(){
    while(true) {

        bus_to_mem_man->read(request);
        mem_man_to_ctrl->write(request);

        if(request.req == ME_RD){
            ctrl_to_mem_man->read(regs);
            response.loadedData = response_data(regs, request);
            mem_man_to_bus->write(response);

        }





        wait(SC_ZERO_TIME);
    }
}




unsigned int Memory_manager::response_data(reg_files reg, CUtoME_IF req) const{

    if(req.addrIn == CR_ADDRESS){ //Need this structure for SCAM not to ignore MT_W completely
        if(req.mask == MT_W) {
            return reg.CR_reg;
        }else if(req.mask == MT_H || req.mask == MT_HU){
            return reg.CR_reg & HALFWORDMASK;
        }else{
            return 0;
        }
    }else if(req.addrIn == (CR_ADDRESS + 2) && (req.mask == MT_H || req.mask == MT_HU)){
        return (reg.CR_reg >> 16) & HALFWORDMASK;
    }else if(req.addrIn >= CR_ADDRESS && req.addrIn < SR_ADDRESS && (req.mask == MT_B || req.mask == MT_BU)){
        return (reg.CR_reg >> (req.addrIn*8)) & BYTEMASK;
    }else if(req.addrIn == SR_ADDRESS){
        if(req.mask == MT_W) {
            return reg.SR_reg;
        }else if(req.mask == MT_H || req.mask == MT_HU){
            return reg.SR_reg & HALFWORDMASK;
        }else{
            return 0;
        }
    }else if(req.addrIn == (SR_ADDRESS + 2)  && (req.mask == MT_H || req.mask == MT_HU)){
        return (reg.SR_reg >> 16) & HALFWORDMASK;
    }else if(req.addrIn >= SR_ADDRESS && req.addrIn < DR_ADDRESS && (req.mask == MT_B || req.mask == MT_BU)){
        return (reg.SR_reg >> ((req.addrIn-4)*8)) & BYTEMASK;
    }else if(req.addrIn == DR_ADDRESS){
        if(req.mask == MT_W) {
            return reg.DR_reg;
        }else if(req.mask == MT_H || req.mask == MT_HU){
            return reg.DR_reg & HALFWORDMASK;
        }else{
            return 0;
        }
    }else if(req.addrIn == (DR_ADDRESS + 2) && (req.mask == MT_H || req.mask == MT_HU)){
        return (reg.DR_reg >> 16) & HALFWORDMASK;
    }else if(req.addrIn >= DR_ADDRESS && req.addrIn < (DR_ADDRESS + 4) && (req.mask == MT_B || req.mask == MT_BU)){
        return (reg.DR_reg >> ((req.addrIn-8)*8)) & BYTEMASK;
    }else {
        return 0;
    }

}



#endif //UART_MEMORY_MANAGER_H
