//
// Created by ovsthus on 03.06.19.
//

#ifndef MMU_MMU_H
#define MMU_MMU_H

#define ACC_FAULT 1
#define PAGE_FAULT 2


#define GET_MPP(x)   (((x) >> 11) & 0x00000003)

#define PAGESIZE 12 //4096
#define LEVELS 2
#define PTESIZE 4

#define BARE 0
#define SV32 1



#define GET_SATP_PPN(x) (((x) << PAGESIZE) & static_cast<unsigned int>(0xFFFFF000))  //Hardwire upper 2 bits to 0
#define SATP_MODE(x) (((x) >> 31) & 0x00000001)

#define PTE_PPN_0 0x000FFC00
#define PTE_PPN   0x3FFFFC00 //mask away upper two bits because we only use 32 bits for address range
#define ALIGN_PPN(x) (((x) << 2) & static_cast<unsigned int>(0xFFFFF000))
#define ALIGN_PPN_1(x) (((x) << 2) & static_cast<unsigned int>(0xFFC00000))
#define ALIGN_PPN_0(x) (((x) << 2) & 0x003FF000)
#define VPN_0(x) ((x) & 0x003FF000)
#define OFFSET(x) ((x) & 0x00000FFF)


#define GET_VPN_1(x) (((x) >> 22) & 0x000003FF)
#define GET_VPN_0(x) (((x) >> 12) & 0x000003FF)


#define PTE_V 0x00000001
#define PTE_R 0x00000002
#define PTE_W 0x00000004
#define PTE_X 0x00000008
#define PTE_U 0x00000010
#define PTE_G 0x00000020
#define PTE_A 0x00000040
#define PTE_D 0x00000080

#include "systemc.h"
#include "Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"
#include "Defines.h"
#include "CPU_Interfaces.h"
#include "CSR.h"

using namespace std;

class MMU : public sc_module{
public:

    SC_HAS_PROCESS(MMU);

MMU_in vm_request;
MMU_return returndata;
CUtoME_IF mem_req;
MEtoCU_IF mem_resp;

unsigned int lr_sc_addr;
unsigned int ptbase;
unsigned int pt_addr;
unsigned int phys_addr;
unsigned int pte;
unsigned int i;
int start;

enum Sections{REQUEST, PTE_FETCH, PTE_DECODE, PMA, MEMORY_OP, RESPONSE};

Sections section, nextsection;

blocking_in<MMU_in> isa_mmu;
blocking_in<MEtoCU_IF> mem_mmu;

blocking_out<MMU_return> mmu_isa;
blocking_out<CUtoME_IF> mmu_mem;

    MMU(sc_module_name name) :
            isa_mmu("isa_mmu"),
            mem_mmu("mem_mmu"),
            mmu_isa("mmu_isa"),
            mmu_mem("mmu_mem"),
           section(Sections::REQUEST),
       nextsection(Sections::REQUEST)
    {
        SC_THREAD(fsm);
    }

    void fsm();

    unsigned int errorType(MMUaccessType accesstype, unsigned int exception) const;
    unsigned int PMA_check(unsigned int addr, unsigned int prv, MMUaccessType type) const;
    unsigned int PTE_fault_check(unsigned int pte, unsigned int mstatus, unsigned int prv, unsigned int levels, MMUaccessType accesstype) const;


};

void MMU::fsm(){
    while(true){

        if(section == Sections::REQUEST){
            isa_mmu->read(vm_request);



            if((vm_request.mstatus & MSTATUS_MPRV) != 0 && vm_request.accesstype != FETCH){
                vm_request.prv = GET_MPP(vm_request.mstatus);
            }


            pt_addr = GET_SATP_PPN(vm_request.satp) + (GET_VPN_1(vm_request.v_addr) * PTESIZE); //decode page table base address
            returndata.exception = PMA_check(pt_addr,  vm_request.prv, vm_request.accesstype);  //ensure the base address does not violate PMA restrictions
            i = 1; //one remaining level to the page table pointer

            if(((vm_request.prv == MachineMode) || SATP_MODE(vm_request.satp) == BARE) && vm_request.exception_in == 0){
                phys_addr = vm_request.v_addr; //no translation for M-mode or translation mode = BARE
                nextsection = Sections::PMA;
            }else if(vm_request.prv != MachineMode && returndata.exception == 0 && vm_request.exception_in == 0){
                nextsection = Sections::PTE_FETCH;
            }else{
                nextsection = Sections::RESPONSE;
            }
        }

      if(section == Sections::PTE_FETCH) {

          mem_req.addrIn = pt_addr;
          mem_req.req = ME_RD;
          mem_req.mask = MT_W;
          mem_req.dataIn = 0;

          mmu_mem->write(mem_req); //fetch page table entry
          mem_mmu->read(mem_resp);

          pte = mem_resp.loadedData;

          returndata.exception = PTE_fault_check(pte, vm_request.mstatus, vm_request.prv, i, vm_request.accesstype); //Check for page faults


          if(returndata.exception == 0) {
              nextsection = Sections::PTE_DECODE;
          }else{
              nextsection = Sections::RESPONSE;
          }
      }


     if(section == Sections::PTE_DECODE){

         if(((pte & PTE_R) == 0) && ((pte & PTE_X) == 0)){ //pte is a pointer to next level in page table
             i = 0;
             pt_addr = ALIGN_PPN(pte) + (GET_VPN_0(vm_request.v_addr)*PTESIZE);
             nextsection = Sections::PTE_FETCH;


         }else{

             if(i>0) {
                 phys_addr = ALIGN_PPN_1(pte) | VPN_0(vm_request.v_addr) | OFFSET(vm_request.v_addr); //superpage


             }else{
                 phys_addr = ALIGN_PPN(pte) | OFFSET(vm_request.v_addr);

             }

             nextsection = Sections::PMA;
         }

     }

     if(section == Sections::PMA){

         returndata.exception = PMA_check(phys_addr, vm_request.prv, vm_request.accesstype);

         if(returndata.exception == 0){
             nextsection = Sections::MEMORY_OP;
         }else{
             nextsection = Sections::RESPONSE;
#ifndef SCAM
            std::cout << "PMA err: " << std::hex << phys_addr << std::endl;
#endif
         }

     }


        if(section == Sections::MEMORY_OP){




            if(vm_request.accesstype == STORE){

if(vm_request.lrsc != SC || (vm_request.lrsc == SC && lr_sc_addr == phys_addr && vm_request.reset_lrsc == 0)){ //if atomic store conditional -> check if store is valid

if(vm_request.lrsc == SC){
lr_sc_addr = 0; //release reservation on address
}


                mem_req.addrIn = phys_addr;
                mem_req.req = ME_WR;
                mem_req.mask = vm_request.mask;
                mem_req.dataIn = vm_request.data;

                mmu_mem->write(mem_req);
returndata.sc_success = 1;
}else{
returndata.sc_success = 0;
}


            }else{

if(vm_request.lrsc == LR){
lr_sc_addr = phys_addr; //put reservation on physical address (for atomic load reserved)
}
         

                mem_req.addrIn = phys_addr;
                mem_req.req = ME_RD;
                mem_req.mask = vm_request.mask;
                mem_req.dataIn = 0;

                mmu_mem->write(mem_req);
                mem_mmu->read(mem_resp);
                returndata.data = mem_resp.loadedData;


            }



            nextsection = Sections::RESPONSE;
        }




       if(section == Sections::RESPONSE){



           returndata.exception = errorType(vm_request.accesstype, returndata.exception); //decode generic exception cause
          if(vm_request.exception_in != 0) returndata.exception = vm_request.exception_in;

           mmu_isa->write(returndata);

           nextsection = Sections::REQUEST;
       }




       section = nextsection;
        wait(SC_ZERO_TIME);
    }

}


unsigned int MMU::errorType(MMUaccessType accesstype, unsigned int exception) const{


        if (accesstype == FETCH && exception == ACC_FAULT) return EXCEPTION | EXC_INSTR_ACC_FAULT;
        else if (accesstype == LOAD && exception == ACC_FAULT) return EXCEPTION | EXC_LOAD_ACC_FAULT;
        else if (accesstype == STORE && exception == ACC_FAULT) return EXCEPTION | EXC_STORE_AMO_ACC_FAULT;
        else if (accesstype == FETCH && exception == PAGE_FAULT) return EXCEPTION | EXC_INSTR_PAGE_FAULT;
        else if (accesstype == LOAD && exception == PAGE_FAULT) return EXCEPTION | EXC_LOAD_PAGE_FAULT;
        else if (accesstype == STORE && exception == PAGE_FAULT) return EXCEPTION | EXC_STORE_AMO_PAGE_FAULT;
        else return 0;

}

unsigned int MMU::PMA_check(unsigned int addr, unsigned int prv, MMUaccessType type) const {

    if(addr >= MEM_START_ADDR && addr < MEM_END_ADDR){
       return 0;
    }else if(addr >= DTB_ROM_START && addr < DTB_ROM_END && prv == MachineMode && type != STORE){
       return 0;
    }else if(addr >= UART_BASE && addr < UART_END && prv == MachineMode){  //The bootloader handles all system calls so this is restricted to machine mode, if there are issues with this consider to expand this restriction
       return 0;
    }else if(addr >= CLINT_START_ADDR && addr < CLINT_END_ADDR && prv == MachineMode){
       return 0;
    }else if(addr >= PLIC_START_ADDR && addr < PLIC_END_ADDR && prv == MachineMode){
        return 0;
    }else{
        return ACC_FAULT;
    }


}

unsigned int MMU::PTE_fault_check(unsigned int pte, unsigned int mstatus, unsigned int prv, unsigned int levels, MMUaccessType accesstype) const{

    if(((pte & PTE_V) == 0) || (((pte & PTE_R ) == 0) && ((pte & PTE_W) != 0))){
        return PAGE_FAULT;

    }else if(((pte & PTE_R) == 0) && ((pte & PTE_X) == 0) && (levels == 0)){

        return PAGE_FAULT;
    }else if(((pte & PTE_U) != 0) && ((mstatus & MSTATUS_SUM) == 0) && (prv == SupervisorMode)){

        return PAGE_FAULT;
    }else if(((pte & PTE_U) == 0) && (prv != SupervisorMode) && ((pte & PTE_X) != 0 || (pte & PTE_R) != 0)){

        return PAGE_FAULT;
    }else if(levels > 0 && (pte & PTE_PPN_0) != 0 && ((pte & PTE_X) != 0 || (pte & PTE_R) != 0)){

        return PAGE_FAULT;
    }else{

        if(accesstype == LOAD){
            if(((mstatus & MSTATUS_MXR) != 0) && (((pte & PTE_R) != 0) || ((pte & PTE_X) != 0)) && ((pte & PTE_A) != 0)) {
                return 0;
            }else if(((mstatus & MSTATUS_MXR) == 0) && ((pte & PTE_R) != 0) && ((pte & PTE_A) != 0)){
                return 0;
            }else if(((pte & PTE_X) == 0) && ((pte & PTE_R) == 0)){
              return 0;
                }else{
                return PAGE_FAULT;

            }


        }else if(accesstype == STORE){
            if(((pte & PTE_W) != 0) && ((pte & PTE_D) != 0) && ((pte & PTE_A) != 0)){
                return 0;
            }else if(((pte & PTE_X) == 0) && ((pte & PTE_R) == 0)){
              return 0;
                }else{
                return PAGE_FAULT;

            }
        }else if(accesstype == FETCH){
            if(((pte & PTE_X) != 0) && ((pte & PTE_A) != 0)){
                return 0;
            }else if(((pte & PTE_X) == 0) && ((pte & PTE_R) == 0)){
              return 0;
                }else{
                return PAGE_FAULT;

            }
        }else{
            return 0;
        }



    }


}

#endif //MMU_MMU_H
