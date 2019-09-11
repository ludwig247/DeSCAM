//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Core Local Interrupter (CLINT)
 * Used to generate Software and Timer Interrupts
 * - Contains the RISC-V mtime and mtimecmp memory mapped CSRs
 * - The msip memory mapped CSR can be used to generate Machine Software Interrupts. This register can be accessed by remote harts
 *      to provide machine-mode interprocessor interrupt (privileged V1.10, P.29). FIXME: can be removed in our implementation
 */

#ifndef PROJECT_CLINT_H
#define PROJECT_CLINT_H

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#include "systemc.h"
#include "Interfaces.h"
#include "Defines.h"
#ifdef NOSCAM
#include "../../RISCV_commons/Memory_Interfaces.h"
#endif

/**
 * \remark: writing to the mip controller happens with a blocking interface to insure nothing happens in a time
 * granulity smaller than the core tick (one instruction FULL excution). by "FULL" we are considering some special
 * instructions like "ecall" which might have a lot of communication with the memory while still acting like a single instruction.
 */




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

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

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


class CLINT_Timer : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_Timer);

    CLINT_Timer(sc_module_name name) :
            toMemory_L("toMemory_L"),
            toMemory_H("toMemory_H"),
            toTimerStatus_L("toTimerStatus_L"),
            toTimerStatus_H("toTimerStatus_H"),
            mtimeL(0),
            mtimeH(0)
            {
        SC_THREAD(run);
    }

    slave_out<unsigned int> toMemory_L;
    slave_out<unsigned int> toMemory_H;
    slave_out<unsigned int> toTimerStatus_L;
    slave_out<unsigned int> toTimerStatus_H;

    unsigned int mtimeL;
    unsigned int mtimeH;

    void run() {
        while (true) {
            toMemory_L->nb_write(mtimeL);
            toMemory_H->nb_write(mtimeH);
            toTimerStatus_L->nb_write(mtimeL);
            toTimerStatus_H->nb_write(mtimeH);

            ++mtimeL;
            if (mtimeL == 0)
                ++mtimeH;
        }
    }
};


class CLINT_TimerStatus : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_TimerStatus);

    CLINT_TimerStatus(sc_module_name name) :
            fromTimer_L("fromTimer_L"),
            fromTimer_H("fromTimer_H"),
            fromMemory_timecmp_L("fromMemory_timecmp_L"),
            fromMemory_timecmp_H("fromMemory_timecmp_H"),
            MTIP_port("MTIP_port"),
            mtimeL_data(0),
            mtimeH_data(0),
            mtimecmpL_data(0x7FFFFFFF),
            mtimecmpH_data(0x7FFFFFFF) {
        SC_THREAD(run);
    }

    master_in<unsigned int> fromTimer_L;
    master_in<unsigned int> fromTimer_H;
    slave_in<unsigned int> fromMemory_timecmp_L;
    slave_in<unsigned int> fromMemory_timecmp_H;

    slave_out<bool> MTIP_port;

    unsigned int mtimeL_data;
    unsigned int mtimeH_data;
    unsigned int mtimecmpL_data;
    unsigned int mtimecmpH_data;

    void run() {
        while (true) {
            fromTimer_L->read(mtimeL_data);
            fromTimer_H->read(mtimeH_data);

            fromMemory_timecmp_L->nb_read(mtimecmpL_data);
            fromMemory_timecmp_H->nb_read(mtimecmpH_data);

//            if ((mtimeL_data >= mtimecmpL_data)) {
            if ((mtimeL_data >= mtimecmpL_data) && (mtimeH_data >= mtimecmpH_data)) {
                MTIP_port->nb_write(true);
            } else {
                MTIP_port->nb_write(false);
            }
        }
    }
};


class CLINT_SipStatus : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(CLINT_SipStatus);

    CLINT_SipStatus(sc_module_name name) :
            fromMemory_sip("fromMemory_sip"),
            MSIP_port("MSIP_port"),
            msip_data(0),
            rec(false) {
        SC_THREAD(run);
    }

    slave_in<unsigned int> fromMemory_sip;

    slave_out<bool> MSIP_port;

    unsigned int msip_data;
    bool rec;

    void run() {
        while (true) {
            fromMemory_sip->nb_read(msip_data);

            if (msip_data > 0) {
                MSIP_port->nb_write(true);
            } else {
                MSIP_port->nb_write(false);
            }
        }
    }
};

#ifndef NOSCAM
class CLINT : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(CLINT);

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done
    slave_out<bool> MSIP_port;
    slave_out<bool> MTIP_port;

    MasterSlave<unsigned int> Timer_Memory_L_Channel;
    MasterSlave<unsigned int> Timer_Memory_H_Channel;
    MasterSlave<unsigned int> Timer_Status_L_Channel;
    MasterSlave<unsigned int> Timer_Status_H_Channel;

    MasterSlave<unsigned int> Memory_SIP_Channel;
    MasterSlave<unsigned int> Memory_Status_L_Channel;
    MasterSlave<unsigned int> Memory_Status_H_Channel;



    CLINT_Memory clint_memory;
    CLINT_Timer clint_timer;
    CLINT_TimerStatus clint_timerStatus;
    CLINT_SipStatus clint_sipStatus;

    CLINT(sc_module_name name) :
            clint_memory("clint_memory"),
            clint_timer("clint_timer"),
            clint_timerStatus("clint_timerStatus"),
            clint_sipStatus("clint_sipStatus"),
            Timer_Memory_L_Channel("Timer_Memory_L_Channel"),
            Timer_Memory_H_Channel("Timer_Memory_H_Channel"),
            Timer_Status_L_Channel("Timer_Status_L_Channel"),
            Timer_Status_H_Channel("Timer_Status_H_Channel"),
            Memory_SIP_Channel("Memory_SIP_Channel"),
            Memory_Status_L_Channel("Memory_Status_L_Channel"),
            Memory_Status_H_Channel("Memory_Status_H_Channel"),
            MSIP_port("MSIP_port"),
            MTIP_port("MTIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port") {

        clint_memory.fromTimer_L(Timer_Memory_L_Channel);
        clint_memory.fromTimer_H(Timer_Memory_H_Channel);
        clint_memory.toSipStatus(Memory_SIP_Channel);
        clint_memory.toTimerStatus_L(Memory_Status_L_Channel);
        clint_memory.toTimerStatus_H(Memory_Status_H_Channel);

        clint_timer.toMemory_L(Timer_Memory_L_Channel);
        clint_timer.toMemory_H(Timer_Memory_H_Channel);
        clint_timer.toTimerStatus_L(Timer_Status_L_Channel);
        clint_timer.toTimerStatus_H(Timer_Status_H_Channel);

        clint_timerStatus.fromTimer_L(Timer_Status_L_Channel);
        clint_timerStatus.fromTimer_H(Timer_Status_H_Channel);
        clint_timerStatus.fromMemory_timecmp_L(Memory_Status_L_Channel);
        clint_timerStatus.fromMemory_timecmp_H(Memory_Status_H_Channel);

        clint_sipStatus.fromMemory_sip(Memory_SIP_Channel);

        clint_memory.COtoME_port(COtoME_port);
        clint_memory.MEtoCO_port(MEtoCO_port);
        clint_timerStatus.MTIP_port(MTIP_port);
        clint_sipStatus.MSIP_port(MSIP_port);
    }

};
#endif

#endif  // PROJECT_CLINT_H