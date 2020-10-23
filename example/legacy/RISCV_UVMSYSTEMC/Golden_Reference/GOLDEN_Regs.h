#ifndef GOLDEN_RISCV_REGS_H_
#define GOLDEN_RISCV_REGS_H_

#include "systemc.h"
#include "Interfaces.h"
#include "GOLDEN_CPU_Interfaces.h"


class G_Regs : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(G_Regs);

    G_Regs(sc_module_name name) :
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
            rec(false) {
        SC_THREAD(run);
    }

    slave_in<G_RegfileWriteType> toRegsPort;
    slave_out<G_RegfileType> fromRegsPort;

    G_RegfileWriteType regfileWrite;
    G_RegfileType regfile; // RegisterFile

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

    void run() {

        while (true) {

            // return current data
            regfile.G_reg_file_01 = reg_file_01;
            regfile.G_reg_file_02 = reg_file_02;
            regfile.G_reg_file_03 = reg_file_03;
            regfile.G_reg_file_04 = reg_file_04;
            regfile.G_reg_file_05 = reg_file_05;
            regfile.G_reg_file_06 = reg_file_06;
            regfile.G_reg_file_07 = reg_file_07;
            regfile.G_reg_file_08 = reg_file_08;
            regfile.G_reg_file_09 = reg_file_09;
            regfile.G_reg_file_10 = reg_file_10;
            regfile.G_reg_file_11 = reg_file_11;
            regfile.G_reg_file_12 = reg_file_12;
            regfile.G_reg_file_13 = reg_file_13;
            regfile.G_reg_file_14 = reg_file_14;
            regfile.G_reg_file_15 = reg_file_15;
            regfile.G_reg_file_16 = reg_file_16;
            regfile.G_reg_file_17 = reg_file_17;
            regfile.G_reg_file_18 = reg_file_18;
            regfile.G_reg_file_19 = reg_file_19;
            regfile.G_reg_file_20 = reg_file_20;
            regfile.G_reg_file_21 = reg_file_21;
            regfile.G_reg_file_22 = reg_file_22;
            regfile.G_reg_file_23 = reg_file_23;
            regfile.G_reg_file_24 = reg_file_24;
            regfile.G_reg_file_25 = reg_file_25;
            regfile.G_reg_file_26 = reg_file_26;
            regfile.G_reg_file_27 = reg_file_27;
            regfile.G_reg_file_28 = reg_file_28;
            regfile.G_reg_file_29 = reg_file_29;
            regfile.G_reg_file_30 = reg_file_30;
            regfile.G_reg_file_31 = reg_file_31;

            fromRegsPort->nb_write(regfile);

            rec = toRegsPort->nb_read(regfileWrite); // read request

            if (rec) {

                if (regfileWrite.G_dst != 0) {

                    // write to regfile
                    if (regfileWrite.G_dst == 1) {
                        reg_file_01 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 2) {
                        reg_file_02 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 3) {
                        reg_file_03 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 4) {
                        reg_file_04 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 5) {
                        reg_file_05 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 6) {
                        reg_file_06 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 7) {
                        reg_file_07 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 8) {
                        reg_file_08 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 9) {
                        reg_file_09 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 10) {
                        reg_file_10 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 11) {
                        reg_file_11 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 12) {
                        reg_file_12 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 13) {
                        reg_file_13 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 14) {
                        reg_file_14 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 15) {
                        reg_file_15 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 16) {
                        reg_file_16 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 17) {
                        reg_file_17 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 18) {
                        reg_file_18 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 19) {
                        reg_file_19 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 20) {
                        reg_file_20 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 21) {
                        reg_file_21 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 22) {
                        reg_file_22 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 23) {
                        reg_file_23 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 24) {
                        reg_file_24 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 25) {
                        reg_file_25 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 26) {
                        reg_file_26 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 27) {
                        reg_file_27 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 28) {
                        reg_file_28 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 29) {
                        reg_file_29 = regfileWrite.G_dstData;
                    } else if (regfileWrite.G_dst == 30) {
                        reg_file_30 = regfileWrite.G_dstData;
                    } else {
                        reg_file_31 = regfileWrite.G_dstData;
                    }
                }
            }
        }
    }

};
#endif  // GOLDEN_RISCV_REGS_H_