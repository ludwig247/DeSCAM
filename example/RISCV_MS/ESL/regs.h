#ifndef PROJECT_REGS_H
#define PROJECT_REGS_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"


class Regs : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Regs);

    Regs(sc_module_name name) :
            CtlToRegs_port("mem_in"),
            RegsToCtl_port("mem_out"),
            rec(false),
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
            reg_file_31(0){
        SC_THREAD(run);
    }

    slave_in<CtlToRegs_IF> CtlToRegs_port;
    slave_out<RegsToCtl_IF> RegsToCtl_port;

    CtlToRegs_IF CtlToRegs_data;
    RegsToCtl_IF RegsToCtl_data;

    // thread
    void run();

    // log reg file
    void log();

    bool rec;

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

};


void Regs::run() {

    while (true) {

        // read request
        rec = CtlToRegs_port->nb_read(CtlToRegs_data);

        if (rec) {
            if (CtlToRegs_data.req == CtlToRegs_IF::REG_RD) {

                // read from regfile
                if        (CtlToRegs_data.src1 ==  0) {
                    RegsToCtl_data.contents1 = 0;
                } else if (CtlToRegs_data.src1 ==  1){
                    RegsToCtl_data.contents1 = reg_file_01;
                } else if (CtlToRegs_data.src1 ==  2){
                    RegsToCtl_data.contents1 = reg_file_02;
                } else if (CtlToRegs_data.src1 ==  3){
                    RegsToCtl_data.contents1 = reg_file_03;
                } else if (CtlToRegs_data.src1 ==  4){
                    RegsToCtl_data.contents1 = reg_file_04;
                } else if (CtlToRegs_data.src1 ==  5){
                    RegsToCtl_data.contents1 = reg_file_05;
                } else if (CtlToRegs_data.src1 ==  6){
                    RegsToCtl_data.contents1 = reg_file_06;
                } else if (CtlToRegs_data.src1 ==  7){
                    RegsToCtl_data.contents1 = reg_file_07;
                } else if (CtlToRegs_data.src1 ==  8){
                    RegsToCtl_data.contents1 = reg_file_08;
                } else if (CtlToRegs_data.src1 ==  9){
                    RegsToCtl_data.contents1 = reg_file_09;
                } else if (CtlToRegs_data.src1 == 10){
                    RegsToCtl_data.contents1 = reg_file_10;
                } else if (CtlToRegs_data.src1 == 11){
                    RegsToCtl_data.contents1 = reg_file_11;
                } else if (CtlToRegs_data.src1 == 12){
                    RegsToCtl_data.contents1 = reg_file_12;
                } else if (CtlToRegs_data.src1 == 13){
                    RegsToCtl_data.contents1 = reg_file_13;
                } else if (CtlToRegs_data.src1 == 14){
                    RegsToCtl_data.contents1 = reg_file_14;
                } else if (CtlToRegs_data.src1 == 15){
                    RegsToCtl_data.contents1 = reg_file_15;
                } else if (CtlToRegs_data.src1 == 16){
                    RegsToCtl_data.contents1 = reg_file_16;
                } else if (CtlToRegs_data.src1 == 17){
                    RegsToCtl_data.contents1 = reg_file_17;
                } else if (CtlToRegs_data.src1 == 18){
                    RegsToCtl_data.contents1 = reg_file_18;
                } else if (CtlToRegs_data.src1 == 19){
                    RegsToCtl_data.contents1 = reg_file_19;
                } else if (CtlToRegs_data.src1 == 20){
                    RegsToCtl_data.contents1 = reg_file_20;
                } else if (CtlToRegs_data.src1 == 21){
                    RegsToCtl_data.contents1 = reg_file_21;
                } else if (CtlToRegs_data.src1 == 22){
                    RegsToCtl_data.contents1 = reg_file_22;
                } else if (CtlToRegs_data.src1 == 23){
                    RegsToCtl_data.contents1 = reg_file_23;
                } else if (CtlToRegs_data.src1 == 24){
                    RegsToCtl_data.contents1 = reg_file_24;
                } else if (CtlToRegs_data.src1 == 25){
                    RegsToCtl_data.contents1 = reg_file_25;
                } else if (CtlToRegs_data.src1 == 26){
                    RegsToCtl_data.contents1 = reg_file_26;
                } else if (CtlToRegs_data.src1 == 27){
                    RegsToCtl_data.contents1 = reg_file_27;
                } else if (CtlToRegs_data.src1 == 28){
                    RegsToCtl_data.contents1 = reg_file_28;
                } else if (CtlToRegs_data.src1 == 29){
                    RegsToCtl_data.contents1 = reg_file_29;
                } else if (CtlToRegs_data.src1 == 30){
                    RegsToCtl_data.contents1 = reg_file_30;
                } else if (CtlToRegs_data.src1 == 31){
                    RegsToCtl_data.contents1 = reg_file_31;
                }

                if        (CtlToRegs_data.src2 ==  0) {
                    RegsToCtl_data.contents2 = 0;
                } else if (CtlToRegs_data.src2 ==  1){
                    RegsToCtl_data.contents2 = reg_file_01;
                } else if (CtlToRegs_data.src2 ==  2){
                    RegsToCtl_data.contents2 = reg_file_02;
                } else if (CtlToRegs_data.src2 ==  3){
                    RegsToCtl_data.contents2 = reg_file_03;
                } else if (CtlToRegs_data.src2 ==  4){
                    RegsToCtl_data.contents2 = reg_file_04;
                } else if (CtlToRegs_data.src2 ==  5){
                    RegsToCtl_data.contents2 = reg_file_05;
                } else if (CtlToRegs_data.src2 ==  6){
                    RegsToCtl_data.contents2 = reg_file_06;
                } else if (CtlToRegs_data.src2 ==  7){
                    RegsToCtl_data.contents2 = reg_file_07;
                } else if (CtlToRegs_data.src2 ==  8){
                    RegsToCtl_data.contents2 = reg_file_08;
                } else if (CtlToRegs_data.src2 ==  9){
                    RegsToCtl_data.contents2 = reg_file_09;
                } else if (CtlToRegs_data.src2 == 10){
                    RegsToCtl_data.contents2 = reg_file_10;
                } else if (CtlToRegs_data.src2 == 11){
                    RegsToCtl_data.contents2 = reg_file_11;
                } else if (CtlToRegs_data.src2 == 12){
                    RegsToCtl_data.contents2 = reg_file_12;
                } else if (CtlToRegs_data.src2 == 13){
                    RegsToCtl_data.contents2 = reg_file_13;
                } else if (CtlToRegs_data.src2 == 14){
                    RegsToCtl_data.contents2 = reg_file_14;
                } else if (CtlToRegs_data.src2 == 15){
                    RegsToCtl_data.contents2 = reg_file_15;
                } else if (CtlToRegs_data.src2 == 16){
                    RegsToCtl_data.contents2 = reg_file_16;
                } else if (CtlToRegs_data.src2 == 17){
                    RegsToCtl_data.contents2 = reg_file_17;
                } else if (CtlToRegs_data.src2 == 18){
                    RegsToCtl_data.contents2 = reg_file_18;
                } else if (CtlToRegs_data.src2 == 19){
                    RegsToCtl_data.contents2 = reg_file_19;
                } else if (CtlToRegs_data.src2 == 20){
                    RegsToCtl_data.contents2 = reg_file_20;
                } else if (CtlToRegs_data.src2 == 21){
                    RegsToCtl_data.contents2 = reg_file_21;
                } else if (CtlToRegs_data.src2 == 22){
                    RegsToCtl_data.contents2 = reg_file_22;
                } else if (CtlToRegs_data.src2 == 23){
                    RegsToCtl_data.contents2 = reg_file_23;
                } else if (CtlToRegs_data.src2 == 24){
                    RegsToCtl_data.contents2 = reg_file_24;
                } else if (CtlToRegs_data.src2 == 25){
                    RegsToCtl_data.contents2 = reg_file_25;
                } else if (CtlToRegs_data.src2 == 26){
                    RegsToCtl_data.contents2 = reg_file_26;
                } else if (CtlToRegs_data.src2 == 27){
                    RegsToCtl_data.contents2 = reg_file_27;
                } else if (CtlToRegs_data.src2 == 28){
                    RegsToCtl_data.contents2 = reg_file_28;
                } else if (CtlToRegs_data.src2 == 29){
                    RegsToCtl_data.contents2 = reg_file_29;
                } else if (CtlToRegs_data.src2 == 30){
                    RegsToCtl_data.contents2 = reg_file_30;
                } else if (CtlToRegs_data.src2 == 31){
                    RegsToCtl_data.contents2 = reg_file_31;
                }


    /*
    #ifndef NDEBUG
                cout << "@Reg: Reading registers x" << dec << CtlToRegs_data.src1 << " , x" << CtlToRegs_data.src1 << endl;
                //log();  // print regfile
    #endif
    */


            } else if (CtlToRegs_data.req == CtlToRegs_IF::REG_WR) {

                if (CtlToRegs_data.dst == 1) {
                    reg_file_01 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 2) {
                    reg_file_02 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 3) {
                    reg_file_03 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 4) {
                    reg_file_04 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 5) {
                    reg_file_05 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 6) {
                    reg_file_06 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 7) {
                    reg_file_07 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 8) {
                    reg_file_08 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 9) {
                    reg_file_09 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 10) {
                    reg_file_10 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 11) {
                    reg_file_11 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 12) {
                    reg_file_12 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 13) {
                    reg_file_13 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 14) {
                    reg_file_14 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 15) {
                    reg_file_15 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 16) {
                    reg_file_16 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 17) {
                    reg_file_17 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 18) {
                    reg_file_18 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 19) {
                    reg_file_19 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 20) {
                    reg_file_20 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 21) {
                    reg_file_21 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 22) {
                    reg_file_22 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 23) {
                    reg_file_23 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 24) {
                    reg_file_24 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 25) {
                    reg_file_25 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 26) {
                    reg_file_26 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 27) {
                    reg_file_27 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 28) {
                    reg_file_28 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 29) {
                    reg_file_29 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 30) {
                    reg_file_30 = CtlToRegs_data.dst_data;
                } else if (CtlToRegs_data.dst == 31) {
                    reg_file_31 = CtlToRegs_data.dst_data;
                }
            }

                /*
         #ifndef NDEBUG
                         cout << "@Reg: Writing to register x" << dec << CtlToRegs_data.dst << " = 0x" << hex
                              << CtlToRegs_data.dst_data << "(hex)=" << dec << CtlToRegs_data.dst_data << "(dec)" << endl;
                         log();  // print regfile
         #endif
                  */



        }

        // return read data
        RegsToCtl_port->nb_write(RegsToCtl_data);

    }

}

void Regs::log() {

    stringstream s;

    cout << string(32 * 14, '-') << endl;

    s << dec;
    for (int i = 0; i < 32; i++) {
        s << "REG x" << i;
        cout << left << setw(14) << s.str();
        s.str("");
    }

    cout << endl;

    s << hex;
    for (int i = 0; i < 32; i++) {

        switch (i) {
            case 0:
                s << "0x" << 0x0;
                break;
            case 1:
                s << "0x" << reg_file_01;
                break;
            case 2:
                s << "0x" << reg_file_02;
                break;
            case 3:
                s << "0x" << reg_file_03;
                break;
            case 4:
                s << "0x" << reg_file_04;
                break;
            case 5:
                s << "0x" << reg_file_05;
                break;
            case 6:
                s << "0x" << reg_file_06;
                break;
            case 7:
                s << "0x" << reg_file_07;
                break;
            case 8:
                s << "0x" << reg_file_08;
                break;
            case 9:
                s << "0x" << reg_file_09;
                break;
            case 10:
                s << "0x" << reg_file_10;
                break;
            case 11:
                s << "0x" << reg_file_11;
                break;
            case 12:
                s << "0x" << reg_file_12;
                break;
            case 13:
                s << "0x" << reg_file_13;
                break;
            case 14:
                s << "0x" << reg_file_14;
                break;
            case 15:
                s << "0x" << reg_file_15;
                break;
            case 16:
                s << "0x" << reg_file_16;
                break;
            case 17:
                s << "0x" << reg_file_17;
                break;
            case 18:
                s << "0x" << reg_file_18;
                break;
            case 19:
                s << "0x" << reg_file_19;
                break;
            case 20:
                s << "0x" << reg_file_20;
                break;
            case 21:
                s << "0x" << reg_file_21;
                break;
            case 22:
                s << "0x" << reg_file_22;
                break;
            case 23:
                s << "0x" << reg_file_23;
                break;
            case 24:
                s << "0x" << reg_file_24;
                break;
            case 25:
                s << "0x" << reg_file_25;
                break;
            case 26:
                s << "0x" << reg_file_26;
                break;
            case 27:
                s << "0x" << reg_file_27;
                break;
            case 28:
                s << "0x" << reg_file_28;
                break;
            case 29:
                s << "0x" << reg_file_29;
                break;
            case 30:
                s << "0x" << reg_file_30;
                break;
            case 31:
                s << "0x" << reg_file_31;
                break;
            default:
                s << "Error!";
        }

        cout << left << setw(14) << s.str();
        s.str("");
    }


    cout << endl;

    s << dec;
    for (int i = 0; i < 32; i++) {
        switch (i) {
            case 0:
                s << 0;
                break;
            case 1:
                s << reg_file_01;
                break;
            case 2:
                s << reg_file_02;
                break;
            case 3:
                s << reg_file_03;
                break;
            case 4:
                s << reg_file_04;
                break;
            case 5:
                s << reg_file_05;
                break;
            case 6:
                s << reg_file_06;
                break;
            case 7:
                s << reg_file_07;
                break;
            case 8:
                s << reg_file_08;
                break;
            case 9:
                s << reg_file_09;
                break;
            case 10:
                s << reg_file_10;
                break;
            case 11:
                s << reg_file_11;
                break;
            case 12:
                s << reg_file_12;
                break;
            case 13:
                s << reg_file_13;
                break;
            case 14:
                s << reg_file_14;
                break;
            case 15:
                s << reg_file_15;
                break;
            case 16:
                s << reg_file_16;
                break;
            case 17:
                s << reg_file_17;
                break;
            case 18:
                s << reg_file_18;
                break;
            case 19:
                s << reg_file_19;
                break;
            case 20:
                s << reg_file_20;
                break;
            case 21:
                s << reg_file_21;
                break;
            case 22:
                s << reg_file_22;
                break;
            case 23:
                s << reg_file_23;
                break;
            case 24:
                s << reg_file_24;
                break;
            case 25:
                s << reg_file_25;
                break;
            case 26:
                s << reg_file_26;
                break;
            case 27:
                s << reg_file_27;
                break;
            case 28:
                s << reg_file_28;
                break;
            case 29:
                s << reg_file_29;
                break;
            case 30:
                s << reg_file_30;
                break;
            case 31:
                s << reg_file_31;
                break;
            default:
                s << "Error!";
        }
        cout << left << setw(14) << s.str();
        s.str("");
    }

    cout << endl;
    cout << string(32 * 14, '-') << endl;
}
#endif