//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Core Local Interruptor (CLINT)
 * Used to generate Software and Timer Interrupts
 * - Contains the RISC-V mtime and mtimecmp memory mapped CSRs
 * - The msip memory mapped CSR can be used to generate Machine Software Interrupts. This register can be accessed by remote harts
 *      to provide machine-mode interprocessor interrupt (privileged V1.10, P.29). FIXME: can be removed in our implementation
 */

#ifndef PROJECT_CLINT_H
#define PROJECT_CLINT_H

#define CLINT_START_ADDR    0x02000000
#define CLINT_END_ADDR      0x0200ffff
#define CLINT_msip_ADDR     0x02000000
#define CLINT_mtimecmp_ADDR 0x02004000
#define CLINT_mtime_ADDR    0x0200BFF8

#include "systemc.h"
#include "Interfaces.h"
#include "Memory_Interfaces.h"

class CLINT : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(CLINT);

    CLINT(sc_module_name name) :
            MSIP_port("MSIP_port"),
            MTIP_port("MTIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            msip(0),
            mtimeSmall(0),
            mtime(0),
            mtimecmp(0xFFFFFFFFFFFFFFFF) {
        SC_THREAD(manage_memory);
        SC_THREAD(run_msip);
        SC_THREAD(run_mtip);
#ifdef SC_SIMULATE
        SC_THREAD(incrementTimer);
#endif
    }

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;

    slave_out<bool> MSIP_port;
    slave_out<bool> MTIP_port;
    uint32_t msip;
    uint64_t mtimeSmall;
    uint64_t mtime;
    uint64_t mtimecmp;

    void run_msip(); // thread
    void run_mtip(); // thread
    void manage_memory();

#ifdef SC_SIMULATE

    void incrementTimer();

#endif
};

/**
 * \remark: writing to the mip controller happens with a blocking interface to insure nothing happens in a time
 * granulity smaller than the core tick (one instruction FULL excution). by "FULL" we are considering some special
 * instructions like "ecall" which might have a lot of communication with the memory while still acting like a single instruction.
 */

void CLINT::run_msip() {
    while (true) {
        // set software interrupt status
        if (msip > 0) {
            MSIP_port->nb_write(1);
        } else {
            MSIP_port->nb_write(0);
        }
    }
}

void CLINT::run_mtip() {
    while (true) {
        // set timer interrupt status
        if (mtime >= mtimecmp) {
            MTIP_port->nb_write(1);
        } else {
            MTIP_port->nb_write(0);
        }
    }
}

void CLINT::manage_memory() {
    while (true) {
        MEtoCP_data.loadedData = 0;

        COtoME_port->read(CPtoME_data); //Wait for next request

        if (CPtoME_data.addrIn < CLINT_START_ADDR && CPtoME_data.addrIn > CLINT_END_ADDR) {
#ifdef SC_SIMULATE
            cout << "@CLINT: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
#endif
        }

        if (CPtoME_data.req == ME_RD) { // LOAD
            if (CPtoME_data.addrIn == CLINT_msip_ADDR)
                MEtoCP_data.loadedData = msip;
            else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR)
                MEtoCP_data.loadedData = (unsigned int) ((0x00000000FFFFFFFF & mtimecmp) >> 0);
            else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR + 4)
                MEtoCP_data.loadedData = (unsigned int) ((0xFFFFFFFF00000000 & mtimecmp) >> 32);
            else if (CPtoME_data.addrIn == CLINT_mtime_ADDR)
                MEtoCP_data.loadedData = (unsigned int) ((0x00000000FFFFFFFF & mtime) >> 0);
            else if (CPtoME_data.addrIn == CLINT_mtime_ADDR + 4)
                MEtoCP_data.loadedData = (unsigned int) ((0xFFFFFFFF00000000 & mtime) >> 32);
            else {
#ifdef SC_SIMULATE
                cout << "@CLINT: Unauthorized read. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
            MEtoCO_port->write(MEtoCP_data);
        } else if (CPtoME_data.req == ME_WR) {
            if (CPtoME_data.addrIn == CLINT_msip_ADDR)
                msip = CPtoME_data.dataIn;
            else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR) {
                mtimecmp = mtimecmp & 0xFFFFFFFF00000000;
                mtimecmp = mtimecmp | ((0x00000000FFFFFFFF & (uint64_t) CPtoME_data.dataIn) << 0);
            } else if (CPtoME_data.addrIn == CLINT_mtimecmp_ADDR + 4) {
                mtimecmp = mtimecmp & 0x00000000FFFFFFFF;
                mtimecmp = mtimecmp | ((0x00000000FFFFFFFF & (uint64_t) CPtoME_data.dataIn) << 32);
            } else {
#ifdef SC_SIMULATE
                cout << "@CLINT: Unauthorized write. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
        } else {
#ifdef SC_SIMULATE
            throw std::logic_error(std::string("@CLINT: Undefined memory's req value."));
#endif
        }
    }
}

#ifdef SC_SIMULATE
void CLINT::incrementTimer() {
    while (true) {
        mtime++;
        wait(SC_ZERO_TIME);
    }
}
#endif

#endif  // PROJECT_CLINT_H
