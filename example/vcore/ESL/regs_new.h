#ifndef RISCV_REGS_H_
#define RISCV_REGS_H_

#include "systemc.h"
#include <iomanip>
#include "../../Interfaces/Interfaces.h"
#include "types.h"

class Regs_new : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Regs_new);

    Regs_new(sc_module_name name) :
            toRegsPort("regsInPort"),
            fromRegsPort("regsOutPort"),
            rec(false) {
        SC_THREAD(run);
    }

    slave_in<RegWrite> toRegsPort;
    slave_out<unsigned int[8]> fromRegsPort;

    RegWrite regfileWrite;
    unsigned int regfile[8]; // RegisterFile

    bool rec;

    void run(); // thread
};


void Regs_new::run() {

    while (true) {
        // return current date
        fromRegsPort->slave_write(regfile);

        wait(WAIT_TIME, SC_PS);
        toRegsPort->slave_read(regfileWrite, rec); // read request
        if (rec) {
            // write to regfile
            if (regfileWrite.dest == 0) {
                regfile[0] = regfileWrite.value;
            } else if (regfileWrite.dest == 1) {
                regfile[1] = regfileWrite.value;
            } else if (regfileWrite.dest == 2) {
                regfile[2] = regfileWrite.value;
            } else if (regfileWrite.dest == 3) {
                regfile[3] = regfileWrite.value;
            } else if (regfileWrite.dest == 4) {
                regfile[4] = regfileWrite.value;
            } else if (regfileWrite.dest == 5) {
                regfile[5] = regfileWrite.value;
            } else if (regfileWrite.dest == 6) {
                regfile[6] = regfileWrite.value;
            } else {
                regfile[7] = regfileWrite.value;
            }
        }
    }
}

#endif  // RISCV_REGS_H_