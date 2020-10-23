#ifndef RISCV_REGFILE_H_
#define RISCV_REGFILE_H_

#include "systemc.h"
#include <iomanip>
#include "Interfaces.h"
#include "CPU_Interfaces.h"


class Regfile : public sc_module {
public:

    //Constructor
    SC_HAS_PROCESS(Regfile);

    Regfile(sc_module_name name) :
            ISAtoRF_select1_port("ISAtoRF_select1_port"),
            RFtoISA_read1_port("RFtoISA_read1_port"),
            ISAtoRF_select2_port("ISAtoRF_select2_port"),
            RFtoISA_read2_port("RFtoISA_read2_port"),
            ISAtoRF_write_port("ISAtoRF_write_port"),
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
            requestReceived(false) {
        SC_THREAD(run);
    }

    // ports for communication with register file
    slave_in<ISAtoRF_select_t> ISAtoRF_select1_port;
    slave_out<RFtoISA_read_t> RFtoISA_read1_port;
    slave_in<ISAtoRF_select_t> ISAtoRF_select2_port;
    slave_out<RFtoISA_read_t> RFtoISA_read2_port;
    slave_in<ISAtoRF_write_t> ISAtoRF_write_port;

    // data for communication with register file
    ISAtoRF_select_t ISAtoRF_select1_data;
    RFtoISA_read_t RFtoISA_read1_data;
    ISAtoRF_select_t ISAtoRF_select2_data;
    RFtoISA_read_t RFtoISA_read2_data;
    ISAtoRF_write_t ISAtoRF_write_data;

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

    bool requestReceived;

    unsigned int readRegfile(
            unsigned int src,
            unsigned int reg_file_01,
            unsigned int reg_file_02,
            unsigned int reg_file_03,
            unsigned int reg_file_04,
            unsigned int reg_file_05,
            unsigned int reg_file_06,
            unsigned int reg_file_07,
            unsigned int reg_file_08,
            unsigned int reg_file_09,
            unsigned int reg_file_10,
            unsigned int reg_file_11,
            unsigned int reg_file_12,
            unsigned int reg_file_13,
            unsigned int reg_file_14,
            unsigned int reg_file_15,
            unsigned int reg_file_16,
            unsigned int reg_file_17,
            unsigned int reg_file_18,
            unsigned int reg_file_19,
            unsigned int reg_file_20,
            unsigned int reg_file_21,
            unsigned int reg_file_22,
            unsigned int reg_file_23,
            unsigned int reg_file_24,
            unsigned int reg_file_25,
            unsigned int reg_file_26,
            unsigned int reg_file_27,
            unsigned int reg_file_28,
            unsigned int reg_file_29,
            unsigned int reg_file_30,
            unsigned int reg_file_31
    ) const;

    void run(); // thread

    void log(); // log reg file
};


void Regfile::run() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
    while (true) {

        requestReceived = ISAtoRF_write_port->nb_read(ISAtoRF_write_data);

        if (requestReceived) {
            if (ISAtoRF_write_data.dst != 0) {
                // write to register
                if (ISAtoRF_write_data.dst == 1) {
                    reg_file_01 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 2) {
                    reg_file_02 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 3) {
                    reg_file_03 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 4) {
                    reg_file_04 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 5) {
                    reg_file_05 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 6) {
                    reg_file_06 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 7) {
                    reg_file_07 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 8) {
                    reg_file_08 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 9) {
                    reg_file_09 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 10) {
                    reg_file_10 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 11) {
                    reg_file_11 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 12) {
                    reg_file_12 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 13) {
                    reg_file_13 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 14) {
                    reg_file_14 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 15) {
                    reg_file_15 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 16) {
                    reg_file_16 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 17) {
                    reg_file_17 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 18) {
                    reg_file_18 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 19) {
                    reg_file_19 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 20) {
                    reg_file_20 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 21) {
                    reg_file_21 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 22) {
                    reg_file_22 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 23) {
                    reg_file_23 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 24) {
                    reg_file_24 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 25) {
                    reg_file_25 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 26) {
                    reg_file_26 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 27) {
                    reg_file_27 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 28) {
                    reg_file_28 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 29) {
                    reg_file_29 = ISAtoRF_write_data.dstData;
                } else if (ISAtoRF_write_data.dst == 30) {
                    reg_file_30 = ISAtoRF_write_data.dstData;
                } else {
                    reg_file_31 = ISAtoRF_write_data.dstData;
                }
#ifdef LOGTOFILE
                cout << "S5: @RF: Writing to register x" << dec << ISAtoRF_write_data.dst << " = 0x" << hex
                         << ISAtoRF_write_data.dstData << " = " << dec << ISAtoRF_data.dstData << "(dec)" << endl;
                    log();
#endif
            }
        }
        ISAtoRF_select1_port->nb_read(ISAtoRF_select1_data);
        RFtoISA_read1_data.data = readRegfile(ISAtoRF_select1_data.src,
                                         reg_file_01,
                                         reg_file_02,
                                         reg_file_03,
                                         reg_file_04,
                                         reg_file_05,
                                         reg_file_06,
                                         reg_file_07,
                                         reg_file_08,
                                         reg_file_09,
                                         reg_file_10,
                                         reg_file_11,
                                         reg_file_12,
                                         reg_file_13,
                                         reg_file_14,
                                         reg_file_15,
                                         reg_file_16,
                                         reg_file_17,
                                         reg_file_18,
                                         reg_file_19,
                                         reg_file_20,
                                         reg_file_21,
                                         reg_file_22,
                                         reg_file_23,
                                         reg_file_24,
                                         reg_file_25,
                                         reg_file_26,
                                         reg_file_27,
                                         reg_file_28,
                                         reg_file_29,
                                         reg_file_30,
                                         reg_file_31);
        RFtoISA_read1_port->nb_write(RFtoISA_read1_data);

        ISAtoRF_select2_port->nb_read(ISAtoRF_select2_data);
        RFtoISA_read2_data.data = readRegfile(ISAtoRF_select2_data.src,
                                         reg_file_01,
                                         reg_file_02,
                                         reg_file_03,
                                         reg_file_04,
                                         reg_file_05,
                                         reg_file_06,
                                         reg_file_07,
                                         reg_file_08,
                                         reg_file_09,
                                         reg_file_10,
                                         reg_file_11,
                                         reg_file_12,
                                         reg_file_13,
                                         reg_file_14,
                                         reg_file_15,
                                         reg_file_16,
                                         reg_file_17,
                                         reg_file_18,
                                         reg_file_19,
                                         reg_file_20,
                                         reg_file_21,
                                         reg_file_22,
                                         reg_file_23,
                                         reg_file_24,
                                         reg_file_25,
                                         reg_file_26,
                                         reg_file_27,
                                         reg_file_28,
                                         reg_file_29,
                                         reg_file_30,
                                         reg_file_31);
        RFtoISA_read2_port->nb_write(RFtoISA_read2_data);
    }
#pragma clang diagnostic pop
}

unsigned int Regfile::readRegfile(
        unsigned int src,
        unsigned int reg_file_01,
        unsigned int reg_file_02,
        unsigned int reg_file_03,
        unsigned int reg_file_04,
        unsigned int reg_file_05,
        unsigned int reg_file_06,
        unsigned int reg_file_07,
        unsigned int reg_file_08,
        unsigned int reg_file_09,
        unsigned int reg_file_10,
        unsigned int reg_file_11,
        unsigned int reg_file_12,
        unsigned int reg_file_13,
        unsigned int reg_file_14,
        unsigned int reg_file_15,
        unsigned int reg_file_16,
        unsigned int reg_file_17,
        unsigned int reg_file_18,
        unsigned int reg_file_19,
        unsigned int reg_file_20,
        unsigned int reg_file_21,
        unsigned int reg_file_22,
        unsigned int reg_file_23,
        unsigned int reg_file_24,
        unsigned int reg_file_25,
        unsigned int reg_file_26,
        unsigned int reg_file_27,
        unsigned int reg_file_28,
        unsigned int reg_file_29,
        unsigned int reg_file_30,
        unsigned int reg_file_31
) const {
    if (src == 0) {
        return 0;
    } else if (src == 1) {
        return reg_file_01;
    } else if (src == 2) {
        return reg_file_02;
    } else if (src == 3) {
        return reg_file_03;
    } else if (src == 4) {
        return reg_file_04;
    } else if (src == 5) {
        return reg_file_05;
    } else if (src == 6) {
        return reg_file_06;
    } else if (src == 7) {
        return reg_file_07;
    } else if (src == 8) {
        return reg_file_08;
    } else if (src == 9) {
        return reg_file_09;
    } else if (src == 10) {
        return reg_file_10;
    } else if (src == 11) {
        return reg_file_11;
    } else if (src == 12) {
        return reg_file_12;
    } else if (src == 13) {
        return reg_file_13;
    } else if (src == 14) {
        return reg_file_14;
    } else if (src == 15) {
        return reg_file_15;
    } else if (src == 16) {
        return reg_file_16;
    } else if (src == 17) {
        return reg_file_17;
    } else if (src == 18) {
        return reg_file_18;
    } else if (src == 19) {
        return reg_file_19;
    } else if (src == 20) {
        return reg_file_20;
    } else if (src == 21) {
        return reg_file_21;
    } else if (src == 22) {
        return reg_file_22;
    } else if (src == 23) {
        return reg_file_23;
    } else if (src == 24) {
        return reg_file_24;
    } else if (src == 25) {
        return reg_file_25;
    } else if (src == 26) {
        return reg_file_26;
    } else if (src == 27) {
        return reg_file_27;
    } else if (src == 28) {
        return reg_file_28;
    } else if (src == 29) {
        return reg_file_29;
    } else if (src == 30) {
        return reg_file_30;
    } else {
        return reg_file_31;
    }
}

void Regfile::log() {

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
            cout << left << s.str();
        } else {
            cout << left << setw(18) << s.str();
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
            cout << left << s.str();
        } else {
            cout << left << setw(18) << s.str();
        }

        s.str("");
    }

    cout << string(143, '-') << endl;
}

#endif  // RISCV_REGFILE_H_