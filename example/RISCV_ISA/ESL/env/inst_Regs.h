#ifndef RISCV_REGS_H_
#define RISCV_REGS_H_

#include "systemc.h"
#include <iomanip>
#include "Interfaces.h"
#include "CPU_Interfaces.h"

//------------------------------------------------------------------------------------
class Regs : public sc_module {
public:

    //Constructor
unsigned int originState, operation;
    SC_HAS_PROCESS(Regs);

    Regs(sc_module_name name) :
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


void Regs::run() {
PowerEstimator::getInstance().initialize(name(), 33, {rec, reg_file_01, reg_file_02, reg_file_03, reg_file_04, reg_file_05, reg_file_06, reg_file_07, reg_file_08, reg_file_09, reg_file_10, reg_file_11, reg_file_12, reg_file_13, reg_file_14, reg_file_15, reg_file_16, reg_file_17, reg_file_18, reg_file_19, reg_file_20, reg_file_21, reg_file_22, reg_file_23, reg_file_24, reg_file_25, reg_file_26, reg_file_27, reg_file_28, reg_file_29, reg_file_30, reg_file_31, regfile.reg_file_01, regfile.reg_file_02, regfile.reg_file_03, regfile.reg_file_04, regfile.reg_file_05, regfile.reg_file_06, regfile.reg_file_07, regfile.reg_file_08, regfile.reg_file_09, regfile.reg_file_10, regfile.reg_file_11, regfile.reg_file_12, regfile.reg_file_13, regfile.reg_file_14, regfile.reg_file_15, regfile.reg_file_16, regfile.reg_file_17, regfile.reg_file_18, regfile.reg_file_19, regfile.reg_file_20, regfile.reg_file_21, regfile.reg_file_22, regfile.reg_file_23, regfile.reg_file_24, regfile.reg_file_25, regfile.reg_file_26, regfile.reg_file_27, regfile.reg_file_28, regfile.reg_file_29, regfile.reg_file_30, regfile.reg_file_31, regfileWrite.dst, regfileWrite.dstData});
operation = 0;
rec = false; reg_file_01 = 0; reg_file_02 = 0; reg_file_03 = 0; reg_file_04 = 0; reg_file_05 = 0; reg_file_06 = 0; reg_file_07 = 0; reg_file_08 = 0; reg_file_09 = 0; reg_file_10 = 0; reg_file_11 = 0; reg_file_12 = 0; reg_file_13 = 0; reg_file_14 = 0; reg_file_15 = 0; reg_file_16 = 0; reg_file_17 = 0; reg_file_18 = 0; reg_file_19 = 0; reg_file_20 = 0; reg_file_21 = 0; reg_file_22 = 0; reg_file_23 = 0; reg_file_24 = 0; reg_file_25 = 0; reg_file_26 = 0; reg_file_27 = 0; reg_file_28 = 0; reg_file_29 = 0; reg_file_30 = 0; reg_file_31 = 0; regfile.reg_file_01 = 0; regfile.reg_file_02 = 0; regfile.reg_file_03 = 0; regfile.reg_file_04 = 0; regfile.reg_file_05 = 0; regfile.reg_file_06 = 0; regfile.reg_file_07 = 0; regfile.reg_file_08 = 0; regfile.reg_file_09 = 0; regfile.reg_file_10 = 0; regfile.reg_file_11 = 0; regfile.reg_file_12 = 0; regfile.reg_file_13 = 0; regfile.reg_file_14 = 0; regfile.reg_file_15 = 0; regfile.reg_file_16 = 0; regfile.reg_file_17 = 0; regfile.reg_file_18 = 0; regfile.reg_file_19 = 0; regfile.reg_file_20 = 0; regfile.reg_file_21 = 0; regfile.reg_file_22 = 0; regfile.reg_file_23 = 0; regfile.reg_file_24 = 0; regfile.reg_file_25 = 0; regfile.reg_file_26 = 0; regfile.reg_file_27 = 0; regfile.reg_file_28 = 0; regfile.reg_file_29 = 0; regfile.reg_file_30 = 0; regfile.reg_file_31 = 0; regfileWrite.dst = 0; regfileWrite.dstData = 0; 
    while (true) {
        // return current data
        regfile.reg_file_01 = reg_file_01;
        regfile.reg_file_02 = reg_file_02;
        regfile.reg_file_03 = reg_file_03;
        regfile.reg_file_04 = reg_file_04;
        regfile.reg_file_05 = reg_file_05;
        regfile.reg_file_06 = reg_file_06;
        regfile.reg_file_07 = reg_file_07;
        regfile.reg_file_08 = reg_file_08;
        regfile.reg_file_09 = reg_file_09;
        regfile.reg_file_10 = reg_file_10;
        regfile.reg_file_11 = reg_file_11;
        regfile.reg_file_12 = reg_file_12;
        regfile.reg_file_13 = reg_file_13;
        regfile.reg_file_14 = reg_file_14;
        regfile.reg_file_15 = reg_file_15;
        regfile.reg_file_16 = reg_file_16;
        regfile.reg_file_17 = reg_file_17;
        regfile.reg_file_18 = reg_file_18;
        regfile.reg_file_19 = reg_file_19;
        regfile.reg_file_20 = reg_file_20;
        regfile.reg_file_21 = reg_file_21;
        regfile.reg_file_22 = reg_file_22;
        regfile.reg_file_23 = reg_file_23;
        regfile.reg_file_24 = reg_file_24;
        regfile.reg_file_25 = reg_file_25;
        regfile.reg_file_26 = reg_file_26;
        regfile.reg_file_27 = reg_file_27;
        regfile.reg_file_28 = reg_file_28;
        regfile.reg_file_29 = reg_file_29;
        regfile.reg_file_30 = reg_file_30;
        regfile.reg_file_31 = reg_file_31;

        fromRegsPort->slave_write(regfile);

PowerEstimator::getInstance().update(name(), operation, {rec, reg_file_01, reg_file_02, reg_file_03, reg_file_04, reg_file_05, reg_file_06, reg_file_07, reg_file_08, reg_file_09, reg_file_10, reg_file_11, reg_file_12, reg_file_13, reg_file_14, reg_file_15, reg_file_16, reg_file_17, reg_file_18, reg_file_19, reg_file_20, reg_file_21, reg_file_22, reg_file_23, reg_file_24, reg_file_25, reg_file_26, reg_file_27, reg_file_28, reg_file_29, reg_file_30, reg_file_31, regfile.reg_file_01, regfile.reg_file_02, regfile.reg_file_03, regfile.reg_file_04, regfile.reg_file_05, regfile.reg_file_06, regfile.reg_file_07, regfile.reg_file_08, regfile.reg_file_09, regfile.reg_file_10, regfile.reg_file_11, regfile.reg_file_12, regfile.reg_file_13, regfile.reg_file_14, regfile.reg_file_15, regfile.reg_file_16, regfile.reg_file_17, regfile.reg_file_18, regfile.reg_file_19, regfile.reg_file_20, regfile.reg_file_21, regfile.reg_file_22, regfile.reg_file_23, regfile.reg_file_24, regfile.reg_file_25, regfile.reg_file_26, regfile.reg_file_27, regfile.reg_file_28, regfile.reg_file_29, regfile.reg_file_30, regfile.reg_file_31, regfileWrite.dst, regfileWrite.dstData});
        wait(WAIT_TIME, SC_PS);
originState = 1;
        toRegsPort->slave_read(regfileWrite,rec); // read request
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if ((regfileWrite.dst == 1)) operation = 1;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if ((regfileWrite.dst == 2)) operation = 3;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if ((regfileWrite.dst == 3)) operation = 5;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if ((regfileWrite.dst == 4)) operation = 7;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if ((regfileWrite.dst == 5)) operation = 9;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if ((regfileWrite.dst == 6)) operation = 11;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if ((regfileWrite.dst == 7)) operation = 13;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if ((regfileWrite.dst == 8)) operation = 15;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if ((regfileWrite.dst == 9)) operation = 17;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if ((regfileWrite.dst == 10)) operation = 19;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if ((regfileWrite.dst == 11)) operation = 21;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if ((regfileWrite.dst == 12)) operation = 23;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if ((regfileWrite.dst == 13)) operation = 25;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if ((regfileWrite.dst == 14)) operation = 27;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if ((regfileWrite.dst == 15)) operation = 29;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if ((regfileWrite.dst == 16)) operation = 31;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if ((regfileWrite.dst == 17)) operation = 33;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if ((regfileWrite.dst == 18)) operation = 35;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if ((regfileWrite.dst == 19)) operation = 37;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if ((regfileWrite.dst == 20)) operation = 39;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if ((regfileWrite.dst == 21)) operation = 41;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if ((regfileWrite.dst == 22)) operation = 43;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if ((regfileWrite.dst == 23)) operation = 45;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if ((regfileWrite.dst == 24)) operation = 47;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if ((regfileWrite.dst == 25)) operation = 49;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if ((regfileWrite.dst == 26)) operation = 51;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if (not((regfileWrite.dst == 26))) if ((regfileWrite.dst == 27)) operation = 53;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if (not((regfileWrite.dst == 26))) if (not((regfileWrite.dst == 27))) if ((regfileWrite.dst == 28)) operation = 55;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if (not((regfileWrite.dst == 26))) if (not((regfileWrite.dst == 27))) if (not((regfileWrite.dst == 28))) if ((regfileWrite.dst == 29)) operation = 57;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if (not((regfileWrite.dst == 26))) if (not((regfileWrite.dst == 27))) if (not((regfileWrite.dst == 28))) if (not((regfileWrite.dst == 29))) if ((regfileWrite.dst == 30)) operation = 59;
if (originState == 1) if (rec) if ((regfileWrite.dst != 0)) if (not((regfileWrite.dst == 1))) if (not((regfileWrite.dst == 2))) if (not((regfileWrite.dst == 3))) if (not((regfileWrite.dst == 4))) if (not((regfileWrite.dst == 5))) if (not((regfileWrite.dst == 6))) if (not((regfileWrite.dst == 7))) if (not((regfileWrite.dst == 8))) if (not((regfileWrite.dst == 9))) if (not((regfileWrite.dst == 10))) if (not((regfileWrite.dst == 11))) if (not((regfileWrite.dst == 12))) if (not((regfileWrite.dst == 13))) if (not((regfileWrite.dst == 14))) if (not((regfileWrite.dst == 15))) if (not((regfileWrite.dst == 16))) if (not((regfileWrite.dst == 17))) if (not((regfileWrite.dst == 18))) if (not((regfileWrite.dst == 19))) if (not((regfileWrite.dst == 20))) if (not((regfileWrite.dst == 21))) if (not((regfileWrite.dst == 22))) if (not((regfileWrite.dst == 23))) if (not((regfileWrite.dst == 24))) if (not((regfileWrite.dst == 25))) if (not((regfileWrite.dst == 26))) if (not((regfileWrite.dst == 27))) if (not((regfileWrite.dst == 28))) if (not((regfileWrite.dst == 29))) if (not((regfileWrite.dst == 30))) operation = 61;
if (originState == 1) if (rec) if (not((regfileWrite.dst != 0))) operation = 63;

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
//------------------------------------------------------------------------------------
