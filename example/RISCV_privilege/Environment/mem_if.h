#ifndef RISCV_ISA_MIF_H
#define RISCV_ISA_MIF_H

#include <stdint.h>
#include <iostream>
#include "systemc"
#include "Interfaces.h"
#include "Memory_Interfaces.h"
#include "Defines.h"

class Mif : public sc_module {
public:
    SC_HAS_PROCESS(Mif);
    uint8_t *mem;
    uint32_t size;

    //Ports
    blocking_in<CUtoME_IF> COtoIF_port; // read_instruction/load/store
    blocking_out<CUtoME_IF> IFtoME_port;
    blocking_out<CUtoME_IF> IFtoDTB_port;

    blocking_in<MEtoCU_IF> MEtoIF_port;
    blocking_in<MEtoCU_IF> DTBtoIF_port;

blocking_out<MEtoCU_IF> IFtoCO_port; // store/load done


    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    Mif(sc_module_name name) :
          COtoIF_port("COtoIF_port"),
          IFtoME_port("IFtoME_port"),
          IFtoDTB_port("IFtoDTB_port"),
MEtoIF_port("MEtoIF_port"),
DTBtoIF_port("DTBtoIF_port"),
IFtoCO_port("IFtoCO_port")

     {
        SC_THREAD(run); // register thread with kernel
    }

    void run(); // thread
};

void Mif::run() {
    while (true) {
        MEtoCP_data.loadedData = 0;

COtoIF_port->read(CPtoME_data);



if(CPtoME_data.addrIn >= DTB_ROM_START && CPtoME_data.addrIn < DTB_ROM_END){

IFtoDTB_port->write(CPtoME_data);

DTBtoIF_port->read(MEtoCP_data);

}
      
if(CPtoME_data.addrIn >= MEM_START_ADDR && CPtoME_data.addrIn < MEM_END_ADDR){



IFtoME_port->write(CPtoME_data);



if(CPtoME_data.req == ME_RD){
MEtoIF_port->read(MEtoCP_data);
}

}

if(CPtoME_data.req == ME_RD){
IFtoCO_port->write(MEtoCP_data);   
}

    }
}





#endif //RISCV_ISA_MIF_H
