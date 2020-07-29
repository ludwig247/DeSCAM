#ifndef RISCV_REGS_H_
#define RISCV_REGS_H_

#include "systemc.h"
#include <iomanip>
#include "../../Interfaces/Interfaces.h"
#include "CPU_Interfaces.h"

class Regs_new : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Regs_new);

    Regs_new(sc_module_name name) :
            toRegsPort("regsInPort"),
            fromRegsPort("regsOutPort"),
            reg_file_01(0),
            reg_file_02(0),
            reg_file_03(0),
            reg_file_04(0),
            reg_file_05(0),
            reg_file_06(0),
            reg_file_07(0),
            reg_file_08(0),
            reg_file_09(0),
            reg_file_10(0),
            reg_file_11(0),
            reg_file_12(0),
            reg_file_13(0),
            reg_file_14(0),
            reg_file_15(0),
            reg_file_16(0),
            reg_file_17(0),
            reg_file_18(0),
            reg_file_19(0),
            reg_file_20(0),
            reg_file_21(0),
            reg_file_22(0),
            reg_file_23(0),
            reg_file_24(0),
            reg_file_25(0),
            reg_file_26(0),
            reg_file_27(0),
            reg_file_28(0),
            reg_file_29(0),
            reg_file_30(0),
            reg_file_31(0),
            rec(false)
    {
        SC_THREAD(run);
    }

    slave_in<RegfileWriteType> toRegsPort;
    slave_out<RegfileType> fromRegsPort;

    RegfileWriteType regfileWrite;
    RegfileType regfile; // RegisterFile

    // register file data
    unsigned int reg_file_01 = 0;
    unsigned int reg_file_02 = 0;
    unsigned int reg_file_03 = 0;
    unsigned int reg_file_04 = 0;
    unsigned int reg_file_05 = 0;
    unsigned int reg_file_06 = 0;
    unsigned int reg_file_07 = 0;
    unsigned int reg_file_08 = 0;
    unsigned int reg_file_09 = 0;
    unsigned int reg_file_10 = 0;
    unsigned int reg_file_11 = 0;
    unsigned int reg_file_12 = 0;
    unsigned int reg_file_13 = 0;
    unsigned int reg_file_14 = 0;
    unsigned int reg_file_15 = 0;
    unsigned int reg_file_16 = 0;
    unsigned int reg_file_17 = 0;
    unsigned int reg_file_18 = 0;
    unsigned int reg_file_19 = 0;
    unsigned int reg_file_20 = 0;
    unsigned int reg_file_21 = 0;
    unsigned int reg_file_22 = 0;
    unsigned int reg_file_23 = 0;
    unsigned int reg_file_24 = 0;
    unsigned int reg_file_25 = 0;
    unsigned int reg_file_26 = 0;
    unsigned int reg_file_27 = 0;
    unsigned int reg_file_28 = 0;
    unsigned int reg_file_29 = 0;
    unsigned int reg_file_30 = 0;
    unsigned int reg_file_31 = 0;

    bool rec;

    void run(); // thread
};


void Regs_new::run() {

    while (true) {
        // return current data
        regfile.regfile[0] = reg_file_01;
        regfile.regfile[1] = reg_file_02;
        regfile.regfile[2] = reg_file_03;
        regfile.regfile[3] = reg_file_04;
        regfile.regfile[4] = reg_file_05;
        regfile.regfile[5] = reg_file_06;
        regfile.regfile[6] = reg_file_07;
        regfile.regfile[7] = reg_file_08;
        regfile.regfile[8] = reg_file_09;
        regfile.regfile[9] = reg_file_10;
        regfile.regfile[10] = reg_file_11;
        regfile.regfile[11] = reg_file_12;
        regfile.regfile[12] = reg_file_13;
        regfile.regfile[13] = reg_file_14;
        regfile.regfile[14] = reg_file_15;
        regfile.regfile[15] = reg_file_16;
        regfile.regfile[16] = reg_file_17;
        regfile.regfile[17] = reg_file_18;
        regfile.regfile[18] = reg_file_19;
        regfile.regfile[19] = reg_file_20;
        regfile.regfile[20] = reg_file_21;
        regfile.regfile[21] = reg_file_22;
        regfile.regfile[22] = reg_file_23;
        regfile.regfile[23] = reg_file_24;
        regfile.regfile[24] = reg_file_25;
        regfile.regfile[25] = reg_file_26;
        regfile.regfile[26] = reg_file_27;
        regfile.regfile[27] = reg_file_28;
        regfile.regfile[28] = reg_file_29;
        regfile.regfile[29] = reg_file_30;
        regfile.regfile[30] = reg_file_31;

        fromRegsPort->slave_write(regfile);

        wait(WAIT_TIME, SC_PS);
        toRegsPort->slave_read(regfileWrite,rec); // read request

        if (rec) {
            if (regfileWrite.dst != 0) {
                // write to regfile
                if (regfileWrite.dst == 1) {
                    reg_file_01 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 2) {
                    reg_file_02 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 3) {
                    reg_file_03 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 4) {
                    reg_file_04 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 5) {
                    reg_file_05 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 6) {
                    reg_file_06 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 7) {
                    reg_file_07 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 8) {
                    reg_file_08 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 9) {
                    reg_file_09 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 10) {
                    reg_file_10 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 11) {
                    reg_file_11 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 12) {
                    reg_file_12 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 13) {
                    reg_file_13 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 14) {
                    reg_file_14 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 15) {
                    reg_file_15 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 16) {
                    reg_file_16 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 17) {
                    reg_file_17 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 18) {
                    reg_file_18 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 19) {
                    reg_file_19 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 20) {
                    reg_file_20 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 21) {
                    reg_file_21 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 22) {
                    reg_file_22 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 23) {
                    reg_file_23 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 24) {
                    reg_file_24 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 25) {
                    reg_file_25 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 26) {
                    reg_file_26 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 27) {
                    reg_file_27 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 28) {
                    reg_file_28 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 29) {
                    reg_file_29 = regfileWrite.dstData;
                } else if (regfileWrite.dst == 30) {
                    reg_file_30 = regfileWrite.dstData;
                } else {
                    reg_file_31 = regfileWrite.dstData;
                }
            }
        }
    }
}

#endif  // RISCV_REGS_H_