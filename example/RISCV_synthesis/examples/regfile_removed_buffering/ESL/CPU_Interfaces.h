#ifndef RISCV_CPU_INTERFACES_H
#define RISCV_CPU_INTERFACES_H

#include "Memory_Interfaces.h"

struct RegfileWriteType {
    unsigned int dst;
    unsigned int dstData;
};
struct RegfileType {
	unsigned int reg_file_01;
	unsigned int reg_file_02;
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
};

#endif // RISCV_CPU_INTERFACES_H