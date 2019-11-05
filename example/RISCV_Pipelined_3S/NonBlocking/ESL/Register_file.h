//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 29 Jan, 2019
//

#ifndef PROJECT_REGISTER_FILE_H
#define PROJECT_REGISTER_FILE_H

#include <iomanip>
#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"


class Register_file : public sc_module {
public:

    SC_HAS_PROCESS(Register_file);

    Register_file(sc_module_name name) :
            CUtoRF_port("CUtoRF_port"),
            RFtoCU_port("RFtoCU_port"),
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

    slave_in<CUtoRF_IF> CUtoRF_port;
    slave_out<RFtoCU_IF> RFtoCU_port;

    CUtoRF_IF CUtoRF_data;
    RFtoCU_IF RFtoCU_data;

    // register file data
    unsigned int reg_file_01;
    unsigned int reg_file_02;
    unsigned int reg_file_03;
    unsigned int reg_file_04;
    unsigned int reg_file_05;
    unsigned int reg_file_06;
    unsigned int reg_file_07;
    unsigned int reg_file_08;
    unsigned int reg_file_09;
    unsigned int reg_file_10;
    unsigned int reg_file_11;
    unsigned int reg_file_12;
    unsigned int reg_file_13;
    unsigned int reg_file_14;
    unsigned int reg_file_15;
    unsigned int reg_file_16;
    unsigned int reg_file_17;
    unsigned int reg_file_18;
    unsigned int reg_file_19;
    unsigned int reg_file_20;
    unsigned int reg_file_21;
    unsigned int reg_file_22;
    unsigned int reg_file_23;
    unsigned int reg_file_24;
    unsigned int reg_file_25;
    unsigned int reg_file_26;
    unsigned int reg_file_27;
    unsigned int reg_file_28;
    unsigned int reg_file_29;
    unsigned int reg_file_30;
    unsigned int reg_file_31;

    bool rec;

    void run(); // thread

    void log(); // log reg file
};


void Register_file::run() {

    while (true) {

        RFtoCU_data.reg_file_01 = reg_file_01;
        RFtoCU_data.reg_file_02 = reg_file_02;
        RFtoCU_data.reg_file_03 = reg_file_03;
        RFtoCU_data.reg_file_04 = reg_file_04;
        RFtoCU_data.reg_file_05 = reg_file_05;
        RFtoCU_data.reg_file_06 = reg_file_06;
        RFtoCU_data.reg_file_07 = reg_file_07;
        RFtoCU_data.reg_file_08 = reg_file_08;
        RFtoCU_data.reg_file_09 = reg_file_09;
        RFtoCU_data.reg_file_10 = reg_file_10;
        RFtoCU_data.reg_file_11 = reg_file_11;
        RFtoCU_data.reg_file_12 = reg_file_12;
        RFtoCU_data.reg_file_13 = reg_file_13;
        RFtoCU_data.reg_file_14 = reg_file_14;
        RFtoCU_data.reg_file_15 = reg_file_15;
        RFtoCU_data.reg_file_16 = reg_file_16;
        RFtoCU_data.reg_file_17 = reg_file_17;
        RFtoCU_data.reg_file_18 = reg_file_18;
        RFtoCU_data.reg_file_19 = reg_file_19;
        RFtoCU_data.reg_file_20 = reg_file_20;
        RFtoCU_data.reg_file_21 = reg_file_21;
        RFtoCU_data.reg_file_22 = reg_file_22;
        RFtoCU_data.reg_file_23 = reg_file_23;
        RFtoCU_data.reg_file_24 = reg_file_24;
        RFtoCU_data.reg_file_25 = reg_file_25;
        RFtoCU_data.reg_file_26 = reg_file_26;
        RFtoCU_data.reg_file_27 = reg_file_27;
        RFtoCU_data.reg_file_28 = reg_file_28;
        RFtoCU_data.reg_file_29 = reg_file_29;
        RFtoCU_data.reg_file_30 = reg_file_30;
        RFtoCU_data.reg_file_31 = reg_file_31;

        RFtoCU_port->nb_write(RFtoCU_data);

        rec = CUtoRF_port->nb_read(CUtoRF_data);

        if (rec) {

            if (CUtoRF_data.dst != 0) {

                if (CUtoRF_data.dst == 1) {
                    reg_file_01 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 2) {
                    reg_file_02 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 3) {
                    reg_file_03 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 4) {
                    reg_file_04 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 5) {
                    reg_file_05 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 6) {
                    reg_file_06 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 7) {
                    reg_file_07 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 8) {
                    reg_file_08 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 9) {
                    reg_file_09 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 10) {
                    reg_file_10 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 11) {
                    reg_file_11 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 12) {
                    reg_file_12 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 13) {
                    reg_file_13 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 14) {
                    reg_file_14 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 15) {
                    reg_file_15 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 16) {
                    reg_file_16 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 17) {
                    reg_file_17 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 18) {
                    reg_file_18 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 19) {
                    reg_file_19 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 20) {
                    reg_file_20 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 21) {
                    reg_file_21 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 22) {
                    reg_file_22 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 23) {
                    reg_file_23 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 24) {
                    reg_file_24 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 25) {
                    reg_file_25 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 26) {
                    reg_file_26 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 27) {
                    reg_file_27 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 28) {
                    reg_file_28 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 29) {
                    reg_file_29 = CUtoRF_data.dstData;
                } else if (CUtoRF_data.dst == 30) {
                    reg_file_30 = CUtoRF_data.dstData;
                } else {
                    reg_file_31 = CUtoRF_data.dstData;
                }

#ifdef LOGTOFILE
                cout << "S5: @RF: Writing to register x" << dec << CUtoRF_data.dst << " = 0x" << hex
                     << CUtoRF_data.dstData << "(hex) = " << dec << CUtoRF_data.dstData << "(dec)" << endl;
                log();  // print regfile
#endif
            }
        }
    }
}


void Register_file::log() {

    stringstream s;

    cout << string(143, '-') << endl;

    cout << "Register File Content (Hex):" << endl;

    cout << string(143, '-') << endl;

    for (int i = 0; i < 32; i++) {
        switch (i) {
            case 0:
                s << dec << "RF[00] 0x0";
                break;
            case 1:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_01;
                break;
            case 2:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_02;
                break;
            case 3:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_03;
                break;
            case 4:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_04;
                break;
            case 5:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_05;
                break;
            case 6:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_06;
                break;
            case 7:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_07 << endl;
                break;
            case 8:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_08;
                break;
            case 9:
                s << dec << "RF[0" << i << "] 0x" << hex << reg_file_09;
                break;
            case 10:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_10;
                break;
            case 11:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_11;
                break;
            case 12:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_12;
                break;
            case 13:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_13;
                break;
            case 14:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_14;
                break;
            case 15:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_15 << endl;
                break;
            case 16:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_16;
                break;
            case 17:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_17;
                break;
            case 18:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_18;
                break;
            case 19:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_19;
                break;
            case 20:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_20;
                break;
            case 21:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_21;
                break;
            case 22:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_22;
                break;
            case 23:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_23 << endl;
                break;
            case 24:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_24;
                break;
            case 25:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_25;
                break;
            case 26:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_26;
                break;
            case 27:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_27;
                break;
            case 28:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_28;
                break;
            case 29:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_29;
                break;
            case 30:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_30;
                break;
            case 31:
                s << dec << "RF[" << i << "] 0x" << hex << reg_file_31 << endl;
                break;
            default:
                s << "Error!";
        }

        if (i == 7 || i == 15 || i == 23 || i == 31) {
            cout << left  << s.str();
        } else {
            cout << left << std::setw(18) << s.str();
        }

        s.str("");
    }

    cout << string(143, '-') << endl;

    cout << "Register File Content (Dec):" << endl;

    cout << string(143, '-') << endl;

    for (int i = 0; i < 32; i++) {
        switch (i) {
            case 0:
                s << dec << "RF[00]   0";
                break;
            case 1:
                s << dec << "RF[0" << i << "]   " << reg_file_01;
                break;
            case 2:
                s << dec << "RF[0" << i << "]   " << reg_file_02;
                break;
            case 3:
                s << dec << "RF[0" << i << "]   " << reg_file_03;
                break;
            case 4:
                s << dec << "RF[0" << i << "]   " << reg_file_04;
                break;
            case 5:
                s << dec << "RF[0" << i << "]   " << reg_file_05;
                break;
            case 6:
                s << dec << "RF[0" << i << "]   " << reg_file_06;
                break;
            case 7:
                s << dec << "RF[0" << i << "]   " << reg_file_07 << endl;
                break;
            case 8:
                s << dec << "RF[0" << i << "]   " << reg_file_08;
                break;
            case 9:
                s << dec << "RF[0" << i << "]   " << reg_file_09;
                break;
            case 10:
                s << dec << "RF[" << i << "]   " << reg_file_10;
                break;
            case 11:
                s << dec << "RF[" << i << "]   " << reg_file_11;
                break;
            case 12:
                s << dec << "RF[" << i << "]   " << reg_file_12;
                break;
            case 13:
                s << dec << "RF[" << i << "]   " << reg_file_13;
                break;
            case 14:
                s << dec << "RF[" << i << "]   " << reg_file_14;
                break;
            case 15:
                s << dec << "RF[" << i << "]   " << reg_file_15 << endl;
                break;
            case 16:
                s << dec << "RF[" << i << "]   " << reg_file_16;
                break;
            case 17:
                s << dec << "RF[" << i << "]   " << reg_file_17;
                break;
            case 18:
                s << dec << "RF[" << i << "]   " << reg_file_18;
                break;
            case 19:
                s << dec << "RF[" << i << "]   " << reg_file_19;
                break;
            case 20:
                s << dec << "RF[" << i << "]   " << reg_file_20;
                break;
            case 21:
                s << dec << "RF[" << i << "]   " << reg_file_21;
                break;
            case 22:
                s << dec << "RF[" << i << "]   " << reg_file_22;
                break;
            case 23:
                s << dec << "RF[" << i << "]   " << reg_file_23 << endl;
                break;
            case 24:
                s << dec << "RF[" << i << "]   " << reg_file_24;
                break;
            case 25:
                s << dec << "RF[" << i << "]   " << reg_file_25;
                break;
            case 26:
                s << dec << "RF[" << i << "]   " << reg_file_26;
                break;
            case 27:
                s << dec << "RF[" << i << "]   " << reg_file_27;
                break;
            case 28:
                s << dec << "RF[" << i << "]   " << reg_file_28;
                break;
            case 29:
                s << dec << "RF[" << i << "]   " << reg_file_29;
                break;
            case 30:
                s << dec << "RF[" << i << "]   " << reg_file_30;
                break;
            case 31:
                s << dec << "RF[" << i << "]   " << reg_file_31 << endl;
                break;
            default:
                s << "Error!";
        }

        if (i == 7 || i == 15 || i == 23 || i == 31) {
            cout << left  << s.str();
        } else {
            cout << left << setw(18) << s.str();
        }

        s.str("");
    }

    cout << string(143, '-') << endl;
}


#endif  // PROJECT_REGISTER_FILE_H
