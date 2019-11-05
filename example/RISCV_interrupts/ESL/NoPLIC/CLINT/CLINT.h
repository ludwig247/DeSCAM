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
#include "../../../../RISCV_commons/Memory_Interfaces.h"
#include "../../../../RISCV_commons/Defines.h"
#include "CLINT_Memory.h"
#include "CLINT_Timer.h"
#include "CLINT_TimerStatus.h"
#include "CLINT_SoftwareStatus.h"

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

#else

int sc_main(int, char **) {

    CLINT_Memory clint_memory("clint_memory");
    CLINT_Timer clint_timer("clint_timer");
    CLINT_TimerStatus clint_timerStatus("clint_timerStatus");
    CLINT_SipStatus clint_sipStatus("clint_sipStatus");

    blocking_in<CUtoME_IF> COtoME_port;
    blocking_out<MEtoCU_IF> MEtoCO_port;
    slave_out<bool> MSIP_port;
    slave_out<bool> MTIP_port;

    MasterSlave<unsigned int> Timer_Memory_L_Channel("Timer_Memory_L_Channel");
    MasterSlave<unsigned int> Timer_Memory_H_Channel("Timer_Memory_H_Channel");
    MasterSlave<unsigned int> Timer_Status_L_Channel("Timer_Status_L_Channel");
    MasterSlave<unsigned int> Timer_Status_H_Channel("Timer_Status_H_Channel");

    MasterSlave<unsigned int> Memory_SIP_Channel("Memory_SIP_Channel");
    MasterSlave<unsigned int> Memory_Status_L_Channel("Memory_Status_L_Channel");
    MasterSlave<unsigned int> Memory_Status_H_Channel("Memory_Status_H_Channel");

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

    sc_start();

}

#endif

#endif  // PROJECT_CLINT_H