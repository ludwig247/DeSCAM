//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

/*
 * Platform Level Interrupt Controller (PLIC)
 * Used to prioritizes and distributes global interrupts
 */

#ifndef PROJECT_PLIC_H
#define PROJECT_PLIC_H

#define SCAM 0

#include "systemc.h"
#include "Interfaces.h"
#include "../Defines.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"

class PLIC : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(PLIC);

    PLIC(sc_module_name name) :
            MEIP_port("MEIP_port"),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            Priority_reg(0),
            Pending_reg(0),
            Interrupt_enables(0),
            Threshold(0),
            ClaimComplete(0) {
        SC_THREAD(manage_memory);
        SC_THREAD(run);
    }

    blocking_in<CUtoME_IF> COtoME_port; // load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF CPtoME_data;
    MEtoCU_IF MEtoCP_data;
    slave_out<bool> MEIP_port;
    unsigned int Priority_reg;
    unsigned int Pending_reg;
    unsigned int Interrupt_enables;
    unsigned int Threshold;
    unsigned int ClaimComplete;

    void run(); // thread
    void manage_memory();

};

void PLIC::run() {
    while (true) {
        // set external interrupt status
        if (Priority_reg > Threshold) {
            MEIP_port->nb_write(1);
        } else {
            MEIP_port->nb_write(0);
        }
    }
}

void PLIC::manage_memory() {
    while (true) {
        MEtoCP_data.loadedData = 0;

        COtoME_port->read(CPtoME_data); //Wait for next request

        if (CPtoME_data.addrIn < PLIC_START_ADDR && CPtoME_data.addrIn > PLIC_END_ADDR) {
#if SCAM == 0
            cout << "@PLIC: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
#endif
        }

        if (CPtoME_data.req == ME_RD) { // LOAD
            if (CPtoME_data.addrIn == PLIC_Priority_ADDR)
                MEtoCP_data.loadedData = Priority_reg;
            else if (CPtoME_data.addrIn == PLIC_Pending_ADDR)
                MEtoCP_data.loadedData = Pending_reg;
            else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR)
                MEtoCP_data.loadedData = Interrupt_enables;
            else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR)
                MEtoCP_data.loadedData = Threshold;
            else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR)
                MEtoCP_data.loadedData = ClaimComplete;
            else {
#if SCAM == 0
                cout << "@PLIC: Unauthorized read. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
            MEtoCO_port->write(MEtoCP_data);
        } else if (CPtoME_data.req == ME_WR) {
            if (CPtoME_data.addrIn == PLIC_Priority_ADDR)
                Priority_reg = CPtoME_data.dataIn;
            else if (CPtoME_data.addrIn == PLIC_Pending_ADDR)
                Pending_reg = CPtoME_data.dataIn;
            else if (CPtoME_data.addrIn == PLIC_Interrupt_Enables_ADDR)
                Interrupt_enables = CPtoME_data.dataIn;
            else if (CPtoME_data.addrIn == PLIC_Threshold_ADDR)
                Threshold = CPtoME_data.dataIn;
            else if (CPtoME_data.addrIn == PLIC_Claim_Complete_ADDR)
                ClaimComplete = CPtoME_data.dataIn;
            else {
#if SCAM == 0
                cout << "@PLIC: Unauthorized write. Terminating!" << endl;
                sc_stop();
                wait(SC_ZERO_TIME);
#endif
            }
        } else {
#if SCAM == 0
            throw std::logic_error(std::string("@PLIC: Undefined memory's req value."));
#endif
        }
    }
}

#endif  // PROJECT_PLIC_H