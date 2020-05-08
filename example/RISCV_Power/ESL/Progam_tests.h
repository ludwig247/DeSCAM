//
// Created by lukadejanovic on 22.1.18.
//

#ifndef PROJECT_PROGAM_TESTS_H
#define PROJECT_PROGAM_TESTS_H


#include <iostream>
#include <array>
#include "assert.h"

using namespace std;

class Program_tests {
public:

    Program_tests(string program, unsigned char *memory, int *reg_file) {
        this->program = program;
        this->memory = memory;
        this->reg_file = reg_file;
    }

    // perform tests
    void test();


private:
    string program;
    unsigned char *memory;
    int *reg_file;
};

void Program_tests::test() {

    cout << endl << "Initiating memory and register file test for program '" << program << "'" << endl;


    if (program == "fibonacci") {
        // test for N = 9, for different N modify accordingly
        int N = 9;
        int first = 0, second = 1, res, next;

        for (int i = 1; i < N; i++) {
            next = first + second;
            first = second;
            second = next;
        }
        res = next;

        // assertions
        assert(reg_file[3] == res && "fibonacci"); // holds N-th fibonacci number
        assert(reg_file[5] == N && "fibonacci");   // holds N

    } else if (program == "multiplication") {
        // test for 11 * 12, for different different numbers modify accordingly
        int a = 11;
        int b = 12;
        int ans = a * b;
        int is_neg = ans < 0 ? 1 : 0;

        assert(reg_file[3] == is_neg && "multiplication");   // is_neg
        assert(reg_file[5] == ans && "multiplication");      // result

    } else if (program == "push_pop") {
        // test for value = 1345 = 0x541
        int value = 0x541;
        int stack_pointer_init = 0x40;
        int stack_pointer_after_push = stack_pointer_init + 4;

        assert(reg_file[30] == stack_pointer_init && "push_pop");   // stack_pointer

        assert(memory[stack_pointer_after_push] == (value & 0xFF) && "push_pop");
        assert(memory[stack_pointer_after_push + 1] == ((value >> 8) & 0xFF) && "push_pop");
        assert(memory[stack_pointer_after_push + 2] == ((value >> 16) & 0xFF) && "push_pop");
        assert(memory[stack_pointer_after_push + 3] == ((value >> 24) & 0xFF) && "push_pop");

        assert(reg_file[3] == value && "push_pop");   // push register
        assert(reg_file[4] == value && "push_pop");   // pop = push register


    } else if (program == "recursive_sum") {
        // test for N = 9, for different N modify accordingly
        int N = 9;
        int stack_pointer_init = 0x100;
        int ans = (N * (N + 1)) / 2;

        assert(reg_file[30] == stack_pointer_init && "recursive_sum");
        assert(reg_file[29] == ans && "recursive_sum");

    } else if (program == "store") {
        // manual values

        //addi $1,$0,128		 # address 0x80
        //addi $2,$0,156		 # address 0x9C
        int adr1 = 0x80;
        int adr2 = 0x9C;
        assert(reg_file[1] == adr1 && "store");
        assert(reg_file[2] == adr2 && "store");

        // lui   $20,5          # $20 = 5 << 12
        // auipc $21,0          # $21 = PC
        // auipc $22,100	    # $22 = PC + (100 >> 12)
        assert(reg_file[20] == 5 << 12 && "store");
        assert(reg_file[21] == 12 && "store");
        assert(reg_file[22] == 16 + (100 << 12) && "store");

        // addi  $5,$0,352 	     # 0x160 imm
        // addi  $6,$0,55 		 # 0x37 imm
        // addi  $7,$0,1		 # 0x1 imm
        // addi  $8,$0,3		 # 0x3 imm
        assert(reg_file[5] == 352 && "store");
        assert(reg_file[6] == 55 && "store");
        assert(reg_file[7] == 1 && "store");
        assert(reg_file[8] == 3 && "store");

        // addi  $9,$0,-1		 # 0xFFFFFFFF imm
        // addi  $10,$0,129	     # 0x81 imm
        // addi  $11,$0,-100	 # 0xFFFFFF9C imm
        assert(reg_file[9] == -1 && "store");
        assert(reg_file[10] == 129 && "store");
        assert(reg_file[11] == -100 && "store");

        // sw    $1,$5,0  		 # mem[0x80] = 0x160
        // sh    $1,$6,4		 # mem[0x84] = 0x37
        // sb    $1,$7,6 		 # mem[0x86] = 0x1
        // sb    $1,$8,0 		 # mem[0x80] = 0x3
        assert(memory[adr1 + 0] == 0x03 && "store");
        assert(memory[adr1 + 1] == 0x01 && "store");
        assert(memory[adr1 + 2] == 0x00 && "store");
        assert(memory[adr1 + 3] == 0x00 && "store");
        assert(memory[adr1 + 4] == 0x37 && "store");
        assert(memory[adr1 + 5] == 0x00 && "store");
        assert(memory[adr1 + 6] == 0x01 && "store");

        // sw    $2,$9,0		 # mem[0x9C] = 0xFFFFFFFF
        // sw    $2,$10,4		 # mem[0xA0] = 0x81
        // sh    $2,$11,8 		 # mem[0xA4] = 0xFF9C
        assert(memory[adr2 + 0] == 0xFF && "store");
        assert(memory[adr2 + 1] == 0xFF && "store");
        assert(memory[adr2 + 2] == 0xFF && "store");
        assert(memory[adr2 + 3] == 0xFF && "store");
        assert(memory[adr2 + 4] == 0x81 && "store");
        assert(memory[adr2 + 5] == 0x00 && "store");
        assert(memory[adr2 + 6] == 0x00 && "store");
        assert(memory[adr2 + 7] == 0x00 && "store");
        assert(memory[adr2 + 8] == 0x9C && "store");
        assert(memory[adr2 + 9] == 0xFF && "store");


        // lw    $31,$2,0     	 # R31 = mem[0x9C] = 0xFFFFFFFF
        // lh    $30,$2,0     	 # R30 = mem[0x9C] = 0xFFFFFFFF
        // lhu   $29,$2,0     	 # R29 = mem[0x9C] = 0x0000FFFF
        // lb    $28,$2,0     	 # R28 = mem[0x9C] = 0xFFFFFFFF
        // lbu   $27,$2,0     	 # R27 = mem[0x9C] = 0x000000FF
        assert(reg_file[31] == 0xFFFFFFFF && "store");
        assert(reg_file[30] == 0xFFFFFFFF && "store");
        assert(reg_file[29] == 0x0000FFFF && "store");
        assert(reg_file[28] == 0xFFFFFFFF && "store");
        assert(reg_file[27] == 0x000000FF && "store");

        // lb    $26,$2,4     	 # R26 = mem[0xA0] = 0xFFFFFF81
        // lbu   $25,$2,4     	 # R25 = mem[0xA0] = 0x00000081
        assert(reg_file[26] == 0xFFFFFF81 && "store");
        assert(reg_file[25] == 0x00000081 && "store");

    } else {

        cout << endl << "Test for program '" << program << "' doesn't exist!" << endl;
        return;
    }

    cout << endl << "Tests for program '" << program << "' passed!" << endl;

}


#endif //PROJECT_PROGAM_TESTS_H
