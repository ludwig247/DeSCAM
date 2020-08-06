#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"

#define OPCODE_U1  0x37 //0110111
#define OPCODE_U2  0x17 //0010111
#define OPCODE_J   0x6F //1101111
#define OPCODE_I_J 0x67 //1100111
#define OPCODE_B   0x63 //1100011
#define OPCODE_I_L 0x03 //0000011
#define OPCODE_S   0x23 //0100011
#define OPCODE_I_I 0x13 //0010011
#define OPCODE_R   0x33 //0110011
#define OPCODE_I_S 0x73 //1110011

#define OPCODE_FIELD(x) ((x) & 0x7F)
#define FUNCT3_FIELD(x) (((x) >> 12) & 0x07)
#define FUNCT7_FIELD(x) (((x) >> 25) & 0x7F)
#define RS1_FIELD(x)    (((x) >> 15) & 0x1F)
#define RS2_FIELD(x)    (((x) >> 20) & 0x1F)
#define RD_FIELD(x)     (((x) >> 7) & 0x1F)
#define SIGN_FIELD(x)   (((x) >> 31) & 0x1)

#define IMM_U_FIELD(x)      ((x) & static_cast<unsigned int>(0xFFFFF000))
#define POS_IMM_I_FIELD(x)  ((x) >> 20)
#define POS_IMM_S_FIELD(x)  ((((x) >> 20) & 0xFE0) | (((x) >> 7) & 0x1F))
#define POS_IMM_B_FIELD(x)  ((((x) << 4) & 0x800) | (((x) >> 20) & 0x7E0) | (((x) >> 7) & 0x1E))
#define POS_IMM_J_FIELD(x)  (((x) & 0xFF000) | (((x) >> 9) & 0x800) | (((x) >> 20) & 0x7FE))
#define NEG_IMM_I_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_I_FIELD(x))
#define NEG_IMM_S_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_S_FIELD(x))
#define NEG_IMM_B_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_B_FIELD(x))
#define NEG_IMM_J_FIELD(x)  (static_cast<unsigned int>(0xFFF00000) | POS_IMM_J_FIELD(x))

enum EncType {
	ENC_X,
	ENC_U,
	ENC_J,
	ENC_I_J,
	ENC_B,
	ENC_I_L,
	ENC_S,
	ENC_I_I,
	ENC_R,
};

enum InstrType {
	INSTR_LUI,
	//INSTR_JAL,
	//INSTR_JALR,
	INSTR_BGE,
	INSTR_LW,
	INSTR_SW,
	INSTR_ADDI,
	INSTR_SLLI,
	INSTR_SRLI,
	INSTR_ADD,
	INSTR_SUB,
	INSTR_OR,
};

enum ALUfuncType {
	ALU_COPY1,
	ALU_SLT,
	ALU_ADD,
	ALU_SLL,
	ALU_SRL,
	ALU_SUB,
	ALU_OR,
};

class ISA : public sc_module {
public:
	SC_HAS_PROCESS(ISA);
	ISA(sc_module_name name) :
			MEtoCO_port("MEtoCO_port"),
			COtoME_port("COtoME_port"),
			ISAtoRF_port("ISAtoRF_port"),
			RFtoISA_port("RFtoISA_port"),
			section(fetch),
			nextsection(fetch),
			pcReg(0) {
		SC_THREAD(run);
	}
	// ports for communication with memory/decoder
	blocking_out<CUtoME_IF> COtoME_port;
	blocking_in<MEtoCP_IF> MEtoCO_port;
	// ports for communication with register file
	master_in<RegfileType> RFtoISA_port;
	master_out<RegfileWriteType> ISAtoRF_port;
	// data for communication with memory
	CUtoME_IF toMemoryData;
	MEtoCP_IF fromMemoryData;
	// data for communication with register file
	RegfileWriteType toRegsData;
	RegfileType fromRegsData;
	// ISA sections
	enum Sections {
		fetch,  // fetch next instruction from memory
		execute // decode the fetched instruction and do all the manipulations till writing back to the register file
	};
	Sections section, nextsection;
	// Other control signals:
	unsigned int encodedInstr;
	unsigned int pcReg;
	unsigned int aluOp1;
	unsigned int aluOp2;
	unsigned int aluResult;
	void run();
	//Decoding functions
	EncType getEncType(unsigned int encodedInstr) const;
	InstrType getInstrType(unsigned int encodedInstr) const;
	unsigned int getImmediate(unsigned int encodedInstr) const;
	ME_MaskType getMemoryMask(InstrType instr) const;
	ALUfuncType getALUfunc(InstrType instr) const;
	unsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;
	unsigned int getBranchResult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const;
	unsigned int readRegfile(unsigned int src, RegfileType fromRegsData) const;
};
void ISA::run() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
	while (true) {
		if (section == Sections::fetch) {
			toMemoryData.req = ME_RD;
			toMemoryData.mask = MT_W;
			toMemoryData.addrIn = pcReg;
			toMemoryData.dataIn = 0;
			COtoME_port->write(toMemoryData);
			MEtoCO_port->read(fromMemoryData);
			encodedInstr = fromMemoryData.loadedData;
#ifdef SC_SIMULATE
			/// Terminating instruction EBREAK
			if (fromMemoryData.loadedData == 0x100073) {
				std::cout << "Terminating instruction (EBREAK)" << std::endl;
				sc_stop();
				wait(SC_ZERO_TIME);
			}
#endif
			nextsection = Sections::execute;
		} else if (section == Sections::execute) {
			if (getEncType(encodedInstr) == ENC_U) {
				aluOp1 = getImmediate(encodedInstr);
				aluOp2 = pcReg;
				aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);
				toRegsData.dst = RD_FIELD(encodedInstr);
				toRegsData.dstData = aluResult;
				ISAtoRF_port->write(toRegsData);
				pcReg = pcReg + 4;
			} else if (getEncType(encodedInstr) == ENC_J) {
				toRegsData.dst = RD_FIELD(encodedInstr);
				toRegsData.dstData = pcReg + 4;
				ISAtoRF_port->write(toRegsData);
				pcReg = pcReg + getImmediate(encodedInstr);
			} else if (getEncType(encodedInstr) == ENC_I_J) {
				RFtoISA_port->read(fromRegsData);
				toRegsData.dst = RD_FIELD(encodedInstr);
				toRegsData.dstData = pcReg + 4;
				ISAtoRF_port->write(toRegsData);
				pcReg = readRegfile(RS1_FIELD(encodedInstr), fromRegsData) + getImmediate(encodedInstr);
			} else if (getEncType(encodedInstr) == ENC_B) {
				RFtoISA_port->read(fromRegsData);
				aluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);
				aluOp2 = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);
				aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);
				pcReg = getBranchResult(encodedInstr, aluResult, pcReg);
			} else if (getEncType(encodedInstr) == ENC_I_L) {
				RFtoISA_port->read(fromRegsData);
				aluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);
				aluOp2 = getImmediate(encodedInstr);
				aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);
				toMemoryData.req = ME_RD;
				toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr));
				toMemoryData.addrIn = aluResult;
				toMemoryData.dataIn = 0;
				toRegsData.dst = RD_FIELD(encodedInstr);
				COtoME_port->write(toMemoryData);
				MEtoCO_port->read(fromMemoryData);
				toRegsData.dstData = fromMemoryData.loadedData;
				ISAtoRF_port->write(toRegsData);
				pcReg = pcReg + 4;
			} else if (getEncType(encodedInstr) == ENC_S) {
				RFtoISA_port->read(fromRegsData);
				aluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);
				aluOp2 = getImmediate(encodedInstr);
				aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);
				toMemoryData.req = ME_WR;
				toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr));
				toMemoryData.addrIn = aluResult;
				toMemoryData.dataIn = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);
				COtoME_port->write(toMemoryData);
				pcReg = pcReg + 4;
			} else if (getEncType(encodedInstr) == ENC_I_I) {
				RFtoISA_port->read(fromRegsData);
				aluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);
				aluOp2 = getImmediate(encodedInstr);
				aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);
				toRegsData.dst = RD_FIELD(encodedInstr);
				toRegsData.dstData = aluResult;
				ISAtoRF_port->write(toRegsData);
				pcReg = pcReg + 4;
			} else if (getEncType(encodedInstr) == ENC_R) {
				RFtoISA_port->read(fromRegsData);
				aluOp1 = readRegfile(RS1_FIELD(encodedInstr), fromRegsData);
				aluOp2 = readRegfile(RS2_FIELD(encodedInstr), fromRegsData);
				aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);
				toRegsData.dst = RD_FIELD(encodedInstr);
				toRegsData.dstData = aluResult;
				ISAtoRF_port->write(toRegsData);
				pcReg = pcReg + 4;
			} else {
				pcReg = pcReg + 4;
			}
			nextsection = Sections::fetch;
		}
		section = nextsection;
	}
#pragma clang diagnostic pop
}

EncType ISA::getEncType(unsigned int encodedInstr) const {
	if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
		return ENC_R;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
		return ENC_I_I;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
		return ENC_I_L;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
		return ENC_I_J;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
		return ENC_S;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
		return ENC_B;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
		return ENC_J;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
		return ENC_U;
	} else {
		return ENC_X;
	}
}

InstrType ISA::getInstrType(unsigned int encodedInstr) const {
	if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
		if (FUNCT3_FIELD(encodedInstr) == 0x6) {
			return INSTR_OR;
		} else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00) {
			return INSTR_ADD;
		} else {
			return INSTR_SUB;
		}
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
		if (FUNCT3_FIELD(encodedInstr) == 0x0) {
			return INSTR_ADDI;
		} else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
			return INSTR_SLLI;
		} else {
			return INSTR_SRLI;
		}
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
		return INSTR_LW;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
		return INSTR_SW;
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
		return INSTR_BGE;
	} else {
		return INSTR_LUI;
	}
}

unsigned int ISA::getImmediate(unsigned int encodedInstr) const {
	if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
		return IMM_U_FIELD(encodedInstr);
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
		if (SIGN_FIELD(encodedInstr) == 0) {
			return POS_IMM_S_FIELD(encodedInstr);
		} else {
			return NEG_IMM_S_FIELD(encodedInstr);
		}
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
		if (SIGN_FIELD(encodedInstr) == 0) {
			return POS_IMM_B_FIELD(encodedInstr);
		} else {
			return NEG_IMM_B_FIELD(encodedInstr);
		}
	} else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
		if (SIGN_FIELD(encodedInstr) == 0) {
			return POS_IMM_J_FIELD(encodedInstr);
		} else {
			return NEG_IMM_J_FIELD(encodedInstr);
		}
	} else {
		if (SIGN_FIELD(encodedInstr) == 0) {
			return POS_IMM_I_FIELD(encodedInstr);
		} else {
			return NEG_IMM_I_FIELD(encodedInstr);
		}
	}
}

ALUfuncType ISA::getALUfunc(InstrType instr) const {
	if (instr == INSTR_LUI) {
		return ALU_COPY1;
	} else if (instr == INSTR_BGE) {
		return ALU_SLT;
	} else if (instr == INSTR_LW || instr == INSTR_SW || instr == INSTR_ADDI || instr == INSTR_ADD) {
		return ALU_ADD;
	} else if (instr == INSTR_SLLI) {
		return ALU_SLL;
	} else if (instr == INSTR_SRLI) {
		return ALU_SRL;
	} else if (instr == INSTR_SUB) {
		return ALU_SUB;
	} else {
		return ALU_OR;
	}
}

ME_MaskType ISA::getMemoryMask(InstrType instr) const {
	return MT_W;
}

unsigned int ISA::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {
	if (aluFunction == ALU_COPY1) {
		return operand1;
	} else if (aluFunction == ALU_SLT) {
		if (static_cast<int>(operand1) < static_cast<int>(operand2)) {
			return 1;
		} else {
			return 0;
		}
	} else if (aluFunction == ALU_ADD) {
		return operand1 + operand2;
	} else if (aluFunction == ALU_SLL) {
		return operand1 << (operand2 & 0x1F);
	} else if (aluFunction == ALU_SRL) {
		return operand1 >> (operand2 & 0x1F);
	} else if (aluFunction == ALU_SUB) {
		return operand1 - operand2;
	} else {
		return operand1 | operand2;
	}
}

unsigned int ISA::readRegfile(unsigned int src, RegfileType fromRegsData) const {
	if (src == 0) {
		return 0;
	} else if (src == 1) {
		return fromRegsData.reg_file_01;
	} else if (src == 2) {
		return fromRegsData.reg_file_02;
	} else if (src == 6) {
		return fromRegsData.reg_file_06;
	} else if (src == 7) {
		return fromRegsData.reg_file_07;
	} else if (src == 8) {
		return fromRegsData.reg_file_08;
	} else if (src == 9) {
		return fromRegsData.reg_file_09;
	} else if (src == 10) {
		return fromRegsData.reg_file_10;
	} else if (src == 11) {
		return fromRegsData.reg_file_11;
	} else if (src == 12) {
		return fromRegsData.reg_file_12;
	} else if (src == 13) {
		return fromRegsData.reg_file_13;
	} else if (src == 14) {
		return fromRegsData.reg_file_14;
	} else if (src == 15) {
		return fromRegsData.reg_file_15;
	} else if (src == 16) {
		return fromRegsData.reg_file_16;
	} else if (src == 17) {
		return fromRegsData.reg_file_17;
	} else if (src == 18) {
		return fromRegsData.reg_file_18;
	} else if (src == 19) {
		return fromRegsData.reg_file_19;
	} else if (src == 20) {
		return fromRegsData.reg_file_20;
	} else if (src == 21) {
		return fromRegsData.reg_file_21;
	} else if (src == 22) {
		return fromRegsData.reg_file_22;
	} else if (src == 23) {
		return fromRegsData.reg_file_23;
	} else if (src == 24) {
		return fromRegsData.reg_file_24;
	} else if (src == 25) {
		return fromRegsData.reg_file_25;
	} else if (src == 26) {
		return fromRegsData.reg_file_26;
	} else {
		return fromRegsData.reg_file_27;
	}
}

unsigned int ISA::getBranchResult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {
	if ((getInstrType(encodedInstr) == INSTR_BGE) && aluResult == 0) {
		return pcReg + getImmediate(encodedInstr);
	} else {
		return pcReg + 4;
	}
}

#endif //RISCV_ISA_H_
