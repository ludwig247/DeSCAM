//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 11/22/18.
//

#ifndef PROJECT_CLINT_MEMORY_H
#define PROJECT_CLINT_MEMORY_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
#include "Interfaces.h"
#include "../../../../RISCV_commons/Memory_Interfaces.h"
#include "../../../../RISCV_commons/Defines.h"


class CLINT_Memory : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_Memory);

    CLINT_Memory(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            fromTimer_L("fromTimer_L"),
            fromTimer_H("fromTimer_H"),
            toTimerStatus_L("toTimerStatus_L"),
            toTimerStatus_H("toTimerStatus_H"),
            toSipStatus("toSipStatus"),
            mtimeL_data(0),
            mtimeH_data(0),
            mtimecmpL(0x7FFFFFFF),
            mtimecmpH(0x7FFFFFFF),
            msip_data(0) {
        SC_THREAD(run);
    }

    blocking_in<CUtoME_IF> COtoME_port;
    blocking_out<MEtoCU_IF> MEtoCO_port;

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    master_out<unsigned int> toSipStatus;

    master_in<unsigned int> fromTimer_L;
    master_in<unsigned int> fromTimer_H;
    master_out<unsigned int> toTimerStatus_L;
    master_out<unsigned int> toTimerStatus_H;

    unsigned int msip_data;

    unsigned int mtimeL_data;
    unsigned int mtimeH_data;
    unsigned int mtimecmpL;
    unsigned int mtimecmpH;

    void run() {
        while (true) {
            /// start with a memory request
            MEtoCP_data.loadedData = 0;
            COtoME_port->read(CPtoME_data); //Wait for next request

            /// get the most recent values from other parts
            fromTimer_L->read(mtimeL_data);
            fromTimer_H->read(mtimeH_data);

            if (CPtoME_data.addrIn < CLINT_START_ADDR && CPtoME_data.addrIn > CLINT_END_ADDR) {
#ifndef NOSCAM
                cout << "@CLINT: Accessing out of bound. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }

            if (CPtoME_data.req == ME_RD) { // LOAD
                if (CPtoME_data.addrIn == CLINT_msip_ADDR) {
                    MEtoCP_data.loadedData = msip_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR) {
                    MEtoCP_data.loadedData = mtimecmpL;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR + 4) {
                    MEtoCP_data.loadedData = mtimecmpH;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == CLINT_mtime_ADDR) {
                    MEtoCP_data.loadedData = mtimeL_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else if (CPtoME_data.addrIn == CLINT_mtime_ADDR + 4) {
                    MEtoCP_data.loadedData = mtimeH_data;
                    MEtoCO_port->write(MEtoCP_data);
                } else {
#ifndef NOSCAM
                    cout << "@CLINT: Unauthorized read. Terminating!" << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else if (CPtoME_data.req == ME_WR) {
                if (CPtoME_data.addrIn == CLINT_msip_ADDR) {
                    msip_data = CPtoME_data.dataIn;
                    toSipStatus->write(msip_data);
                } else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR) {
                    mtimecmpL = CPtoME_data.dataIn;
                    toTimerStatus_L->write(mtimecmpL);
                } else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR + 4) {
                    mtimecmpH = CPtoME_data.dataIn;
                    toTimerStatus_H->write(mtimecmpH);
                } else {
#ifndef NOSCAM
                    cout << "@CLINT: Unauthorized write. Terminating!" << endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
#endif
                }
            } else {
#ifndef NOSCAM
                throw std::logic_error(std::string("@CLINT: Undefined memory's req value."));
#endif
            }
        }
    }
};


#endif //PROJECT_CLINT_MEMORY_H
