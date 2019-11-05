//
// Created by Paulius Morkunas on 13.05.19.
//

#ifndef PROJECT_SIMPLIFIED_RISCV_ISA_H
#define PROJECT_SIMPLIFIED_RISCV_ISA_H


#include "systemc.h"
#include "../../../Interfaces/Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"

/// Opcodes
#define OPCODE_R    0x33 //0110011
#define OPCODE_I_I  0x13 //0010011
#define OPCODE_I_L  0x03 //0000011
#define OPCODE_I_J  0x67 //1100111
#define OPCODE_S    0x23 //0100011
#define OPCODE_B    0x63 //1100011
#define OPCODE_U1   0x37 //0110111
#define OPCODE_U2   0x17 //0010111
#define OPCODE_J    0x6F //1101111
#define OPCODE_I_M  0x0F //0001111
#define OPCODE_I_S  0x73 //1110011

#define OPCODE_J1 	OPCODE_J
#define OPCODE_J2 	OPCODE_I_J
#define OPCODE_L 	OPCODE_I_L
#define OPCODE_I 	OPCODE_I_I
#define OPCODE_SYS 	OPCODE_I_S

#define OPCODE_FIELD(x) ((x) & 0x7F)
#define FUNCT3_FIELD(x) (((x) >> 12) & 0x07)
#define FUNCT7_FIELD(x) (((x) >> 25) & 0x7F)
#define RS1_FIELD(x)    (((x) >> 15) & 0x1F)
#define RS2_FIELD(x)    (((x) >> 20) & 0x1F)
#define RD_FIELD(x)     (((x) >>  7) & 0x1F)
#define SIGN_FIELD(x)   (((x) >> 31) & 0x01)

#ifdef SC_SIMULATE
#define REGFILE(x) dummy // Needed by SystemC core test bench
#define PCREG dummy // Needed by SystemC core test bench
#endif

struct CUtoRF_IF {
    unsigned int dst;
    unsigned int dstData;
};

struct RFtoCU_IF {
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
};

class Core : public sc_module {
public:

    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    // Channel instantiation
    //master_out<CUtoRF_IF> CUtoRF_port;
    //master_in<RFtoCU_IF> RFtoCU_port;

#ifdef SC_SIMULATE
    uint32_t dummy; // Needed by SystemC core test bench
#else
    // Dummy output port to force wait states
    master_out<bool> dummyout;
#endif

    Core(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            //CUtoRF_port("CUtoRF_port"),
            //RFtoCU_port("RFtoCU_port"),
#ifndef SC_SIMULATE
            dummyout("dummyout"),
#endif
			nextsection(SEC_IF) {
        SC_THREAD(fsm);
    }

    CUtoME_IF COtoME_data;
    MEtoCU_IF MEtoCO_data;

    //CUtoRF_IF CUtoRF_data;
    //RFtoCU_IF RFtoCU_data;

    enum Sections { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Sections section, nextsection;

    void fsm() {
        while (true) {
			section = nextsection;
			if (section == SEC_IF) {
	            COtoME_data.req = ME_RD;
            	COtoME_data.mask = MT_W;
                COtoME_data.dataIn = 0; // Don't care
            	COtoME_port->write(COtoME_data);
				MEtoCO_port->read(MEtoCO_data);
                COtoME_data.addrIn = COtoME_data.addrIn + 4; // PC
				nextsection = SEC_DE;
			} else if (section == SEC_DE) {
#ifndef SC_SIMULATE
                    dummyout->write(false); // Dummy write to force wait state
#endif
				nextsection = SEC_EX;
			} else if (section == SEC_EX) {
#ifndef SC_SIMULATE
                dummyout->write(false); // Dummy write to force wait state
#endif
				nextsection = SEC_ME;
			} else if (section == SEC_ME) {
               if (OPCODE_FIELD(MEtoCO_data.loadedData) == OPCODE_L) {
                    COtoME_data.req = ME_WR;
                    COtoME_data.mask = MT_W;
                    COtoME_data.addrIn = 0; // Dummy value
                    COtoME_data.dataIn = 0; // Dummy value
                    COtoME_port->write(COtoME_data);
                    MEtoCO_port->read(MEtoCO_data);
                } else if (OPCODE_FIELD(MEtoCO_data.loadedData) == OPCODE_S) {
                    COtoME_data.req = ME_RD;
                    COtoME_data.mask = MT_W;
                    COtoME_data.addrIn = 0; // Dummy value
                    COtoME_data.dataIn = 0; // Don't care
                    COtoME_port->write(COtoME_data);
                } else {
#ifndef SC_SIMULATE
                   dummyout->write(false); // Dummy write to force wait state
#endif
                }
				nextsection = SEC_WB;
			} else if (section == SEC_WB) {
#ifndef SC_SIMULATE
                dummyout->write(false); // Dummy write to force wait state
#endif
				nextsection = SEC_IF;
			}
        }
    }
};

#endif //PROJECT_SIMPLIFIED_RISCV_ISA_H
