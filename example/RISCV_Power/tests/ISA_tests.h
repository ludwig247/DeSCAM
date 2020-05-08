// Created by tobias on 30.10.17.
//

#ifndef PROJECT_RISCV_TEST_H
#define PROJECT_RISCV_TEST_H


#include <gtest/gtest.h>
#include "../ESL/CPU_Interfaces.h"
#include "../ESL/Utilities.h"

TEST(InstrDecode,AddI){
    //ADDI rsd,rs1,imm
    //ADDI x5,x0,18
    unsigned int instr = 0x1200293;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::addI);
    ASSERT_EQ(decodedInstr.rd_addr,0x5);
    ASSERT_EQ(decodedInstr.rs1_addr,0x0);
    ASSERT_EQ(decodedInstr.imm,0x12);
}
TEST(InstrDecode,AndI){
    //ANDI rsd,rs1,imm
    //ANDI x10,x1,6
    unsigned int instr = 0x60F513;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::andI);
    ASSERT_EQ(decodedInstr.rd_addr,0xA);
    ASSERT_EQ(decodedInstr.rs1_addr,0x1);
    ASSERT_EQ(decodedInstr.imm,0x6);
}
TEST(InstrDecode,OrI){
    //ORI rsd,rs1,imm
    //ORI x2,x7,-1337
    unsigned int instr = 0xAC73E113;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::orI);
    ASSERT_EQ(decodedInstr.rd_addr,0x2);
    ASSERT_EQ(decodedInstr.rs1_addr,0x7);
    ASSERT_EQ(decodedInstr.imm,-1337);
}
TEST(InstrDecode, XorI){
    //ORI rsd,rs1,imm
    //ORI x5,x16,144
    unsigned int instr = 0x9084293;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::xorI);
    ASSERT_EQ(decodedInstr.rd_addr,0x5);
    ASSERT_EQ(decodedInstr.rs1_addr,0x10);
    ASSERT_EQ(decodedInstr.imm,144);

}

TEST(InstrDecode, Slti){
    //Slti rsd,rs1,imm
    //Slti x1,x23,8
    unsigned int instr = 0x8BA093;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sltI);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,23);
    ASSERT_EQ(decodedInstr.imm,8);
}

TEST(InstrDecode, Sltiu){
    //Sltiu rsd,rs1,imm
    //Sltiu x1,x23,8
    unsigned int instr = 0x8BB093;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sltIu);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,23);
    ASSERT_EQ(decodedInstr.imm,8);
    //Sltiu rsd,rs1,imm
    //Sltiu x1,x23,-8
    //-8 is 111111111000 as signed number and 4088 interpreted as unsigned number
    instr = 0xFF8BB093;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sltIu);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,23);
    ASSERT_EQ(decodedInstr.imm,-8); // ok
}

TEST(InstrDecode, Slli){
    //Slli rsd,rs1,imm
    //Slli x2,x3,13
    unsigned int instr = 0xD11193;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sllI);
    ASSERT_EQ(decodedInstr.rd_addr,3);
    ASSERT_EQ(decodedInstr.rs1_addr,2);
    ASSERT_EQ(decodedInstr.imm,13);

}


TEST(InstrDecode, Srli){
    //Slri rsd,rs1,imm
    //Slri x7,x30,30
    unsigned int instr = 0x1EF5393;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::srlI);
    ASSERT_EQ(decodedInstr.rd_addr,7);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.imm,30);
}

TEST(InstrDecode, sraI){
    //Srai rsd,rs1,imm
    //Srai x7,x30,30
    unsigned int instr = 0x41EF5393;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sraI);
    ASSERT_EQ(decodedInstr.rd_addr,7);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.imm,30);
}

TEST(InstrDecode, Add){
    //add rsd,rs1,imm
    //add $7,$30,$10

    unsigned int instr = 0x00AF03B3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::add);
    ASSERT_EQ(decodedInstr.rd_addr,7);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,10);
}


TEST(InstrDecode, Sub){
    //sub rsd,rs1,imm
    //sub $7,$30,$10

    unsigned int instr = 0x40AF03B3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sub);
    ASSERT_EQ(decodedInstr.rd_addr,7);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,10);
}


TEST(InstrDecode, Sll){
    //sub rsd,rs1,imm
    //sub $1,$2,$3

    unsigned int instr = 0x003110B3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sll);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,2);
    ASSERT_EQ(decodedInstr.rs2_addr,3);
}

TEST(InstrDecode, Slt){
    //sub rsd,rs1,imm
    //sub $1,$2,$3

    unsigned int instr = 0x003120B3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::slt);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,2);
    ASSERT_EQ(decodedInstr.rs2_addr,3);
}

TEST(InstrDecode, Sltu){
    //sltu rsd,rs1,imm
    //sltu $1,$2,$3

    unsigned int instr = 0x003130B3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sltu);
    ASSERT_EQ(decodedInstr.rd_addr,1);
    ASSERT_EQ(decodedInstr.rs1_addr,2);
    ASSERT_EQ(decodedInstr.rs2_addr,3);
}

TEST(InstrDecode, Xor){
    //xor rsd,rs1,imm
    //xor $31,$30,$29

    unsigned int instr = 0x01DF4FB3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::Xor);
    ASSERT_EQ(decodedInstr.rd_addr,31);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,29);
}

TEST(InstrDecode, srl){
    //srl rsd,rs1,imm
    //srl  $31,$30,$29

    unsigned int instr = 0x01DF5FB3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::srl);
    ASSERT_EQ(decodedInstr.rd_addr,31);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,29);
}

TEST(InstrDecode, sra){
    //sra rsd,rs1,imm
    //sra  $31,$30,$29

    unsigned int instr = 0x41DF5FB3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::sra);
    ASSERT_EQ(decodedInstr.rd_addr,31);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,29);
}

TEST(InstrDecode, Or){
    //or rsd,rs1,imm
    //or  $31,$30,$29

    unsigned int instr = 0x01DF6FB3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::Or);
    ASSERT_EQ(decodedInstr.rd_addr,31);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,29);
}

TEST(InstrDecode, And){
    //and rsd,rs1,imm
    //and $31,$30,$29

    unsigned int instr = 0x01DF7FB3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,R);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::And);
    ASSERT_EQ(decodedInstr.rd_addr,31);
    ASSERT_EQ(decodedInstr.rs1_addr,30);
    ASSERT_EQ(decodedInstr.rs2_addr,29);
}


TEST(InstrDecode, beq){
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0xE02086E3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::beq);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,-500);

    instr = 0x1E208A63;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::beq);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,500);
}

TEST(InstrDecode, bne){
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0xE02096E3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bne);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,-500);

    instr = 0x1E209A63;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bne);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,500);
}

TEST(InstrDecode, blt){
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0xE020C6E3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::blt);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,-500);

    instr = 0x1E20CA63;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::blt);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,500);
}

TEST(InstrDecode, Bge){
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x4020D063;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bge);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,1024);

    instr = 0xC020D0E3;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bge);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,-1024);
}


TEST(InstrDecode, Bltu) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x4020E063;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: bltu);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.rs2_addr, 2);
    ASSERT_EQ(decodedInstr.imm, 1024);

    instr = 0x0020E0E3;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bltu);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,2048);
}

TEST(InstrDecode, Bgeu) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x0020F0E3;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: bgeu);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.rs2_addr, 2);
    ASSERT_EQ(decodedInstr.imm, 2048);

    instr = 0x4020FCE3;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,B);
    ASSERT_EQ(decodedInstr.instrType,InstrType ::bgeu);
    ASSERT_EQ(decodedInstr.rs1_addr,1);
    ASSERT_EQ(decodedInstr.rs2_addr,2);
    ASSERT_EQ(decodedInstr.imm,3096);
}

TEST(InstrDecode, Lb) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x40008103;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lb);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm, 1024);

    instr = 0xC0008103;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType, InstrType ::lb);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm,-1024);
}

TEST(InstrDecode, Lh) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x40009103;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lh);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm, 1024);

    instr = 0xC0009103;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lh);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm,-1024);
}

TEST(InstrDecode, Lw) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x4000A103;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lw);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm, 1024);

    instr = 0xC000A103;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lw);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm,-1024);
}


TEST(InstrDecode, Lbu) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x7E80C103;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType, InstrType ::lbu);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm, 2024);

    instr = 0x7DC0C103;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lbu);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm,2012);
}

TEST(InstrDecode, Lhu) {
    //beq rs1,rs2,imm
    //beq $1,$2,-500

    unsigned int instr = 0x7E80D103;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lhu);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1);
    ASSERT_EQ(decodedInstr.imm, 2024);

    instr = 0x3F40D103;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType, InstrType ::lhu);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    ASSERT_EQ(decodedInstr.rs1_addr, 1) << "Failes because";
    ASSERT_EQ(decodedInstr.imm,1012);
}

TEST(InstrDecode, LUI) {
    unsigned int instr = 0x00400137;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,U);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: lui);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    //Assuming shifting is already done
    ASSERT_EQ(decodedInstr.imm, 4194304);
}


TEST(InstrDecode, auipc) {
    unsigned int instr = 0x00409117;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,U);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: auipc);
    ASSERT_EQ(decodedInstr.rd_addr, 2);
    //Assuming shifting is already done
    ASSERT_EQ(decodedInstr.imm, 4231168);
}


TEST(InstrDecode, jal) {
    unsigned int instr = 0x4000026F;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,J);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: jal);
    ASSERT_EQ(decodedInstr.rd_addr, 4);
    ASSERT_EQ(decodedInstr.imm, 1024);
}

TEST(InstrDecode, Jalr) {
    unsigned int instr = 0x40018267;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType, InstrType ::jalr);
    ASSERT_EQ(decodedInstr.rd_addr, 4);
    ASSERT_EQ(decodedInstr.rs1_addr, 3);
    ASSERT_EQ(decodedInstr.imm, 1024);

    instr = 0xC0018267;
    //SETUP instruction
    decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,I);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: jalr);
    ASSERT_EQ(decodedInstr.rd_addr, 4);
    ASSERT_EQ(decodedInstr.rs1_addr, 3);
    ASSERT_EQ(decodedInstr.imm, -1024);
}


TEST(InstrDecode, Sb) {
    unsigned int instr = 0x02320023;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,S);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: sb);
    ASSERT_EQ(decodedInstr.rs1_addr, 4);
    ASSERT_EQ(decodedInstr.rs2_addr, 3);
    //TODO: rvi.py warning ... 2 byte alignment? Not important.
    ASSERT_EQ(decodedInstr.imm, 32);
}


TEST(InstrDecode, Sh) {
    unsigned int instr = 0x10321023;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,S);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: sh);
    ASSERT_EQ(decodedInstr.rs1_addr, 4);
    ASSERT_EQ(decodedInstr.rs2_addr, 3);
    ASSERT_EQ(decodedInstr.imm, 256);
}
TEST(InstrDecode, Sw) {
    unsigned int instr = 0xF0322023;
    //SETUP instruction
    DecodedInstr decodedInstr = decode_instruction(instr);
    ASSERT_EQ(decodedInstr.encType,S);
    ASSERT_EQ(decodedInstr.instrType,InstrType :: sw);
    ASSERT_EQ(decodedInstr.rs1_addr, 4);
    ASSERT_EQ(decodedInstr.rs2_addr, 3);
    ASSERT_EQ(decodedInstr.imm, -256);
}


#endif //PROJECT_RISCV_TEST_H