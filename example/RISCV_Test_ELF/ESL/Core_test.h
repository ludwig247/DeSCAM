//
// Created by lukadejanovic on 20.3.18..
//

#ifndef PROJECT_CORE_TEST_H
#define PROJECT_CORE_TEST_H


#include <tlm.h>
#include <iostream>
#include "assert.h"
#include "systemc.h"
//#include "Interfaces.h"
#include "../../Interfaces/Interfaces.h"
#include "Core_include.h"
#include "Memory_Interfaces.h"

#include "ELFstyle/options.h"
#include "ELFstyle/elf_loader.h"

#ifndef REGFILE
#error "REGFILE has to be defined in the included core. Example: #define REGFILE(x) innerCore.RF.reg_file_##x"
#endif

#ifndef PCREG
#error "PCREG has to be defined in the included core. Example: #define PCREG innerCore.isa.pcReg"
#endif

class Core_test {
public:

    Core_test(int argc, char **argv) {
        this->argc = argc;
        this->argv = argv;
    }

    // perform test
    void perform_test();

private:
//    void regfile_log(Core* CO);
    int argc; char **argv;
};


void Core_test::perform_test() {

    Options opt = parse_command_line_arguments(argc, argv);
    ELFLoader loader(opt.input_program.c_str());
    // extract file name from path
    std::string test_case = opt.input_program;
    size_t f1 = test_case.find_last_of("/");
    test_case = test_case.substr(f1+1, test_case.length());

    std::cout << endl << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Running test for elf file: '" << test_case << "' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;

    // Component instantiations
    Core CO("CO");
//    G_Core CO("CO");
    Memory ME("ME", opt.mem_size);
    loader.load_executable_image(ME.mem, ME.size, opt.mem_start_addr);
    CO.PCREG = loader.get_entrypoint();
    CO.REGFILE(02) = loader.get_memory_end() - 4; // stack pointer
    // Channel instantiation
    Blocking<CUtoME_IF> COtoME_channel("COtoME_channel");
    Blocking<MEtoCU_IF> MEtoCO_channel("MEtoCO_channel");

    // Port binding:
    CO.COtoME_port(COtoME_channel);
    ME.COtoME_port(COtoME_channel);
    ME.MEtoCO_port(MEtoCO_channel);
    CO.MEtoCO_port(MEtoCO_channel);

    // Start simulation.. simulation ends with sc_stop() call
    sc_start();

    // used for testing
    unsigned int reg_file[32] = {
            0,
            CO.REGFILE(01),
            CO.REGFILE(02),
            CO.REGFILE(03),
            CO.REGFILE(04),
            CO.REGFILE(05),
            CO.REGFILE(06),
            CO.REGFILE(07),
            CO.REGFILE(08),
            CO.REGFILE(09),
            CO.REGFILE(10),
            CO.REGFILE(11),
            CO.REGFILE(12),
            CO.REGFILE(13),
            CO.REGFILE(14),
            CO.REGFILE(15),
            CO.REGFILE(16),
            CO.REGFILE(17),
            CO.REGFILE(18),
            CO.REGFILE(19),
            CO.REGFILE(20),
            CO.REGFILE(21),
            CO.REGFILE(22),
            CO.REGFILE(23),
            CO.REGFILE(24),
            CO.REGFILE(25),
            CO.REGFILE(26),
            CO.REGFILE(27),
            CO.REGFILE(28),
            CO.REGFILE(29),
            CO.REGFILE(30),
            CO.REGFILE(31)
    };

    if (test_case == "fibonacci.elf") {

        // test for N = 9, for different N modify accordingly
        int N = 9;
        int first = 0, second = 1, res, next;
        for (int i = 1; i < N; i++) {
            next = first + second;
            first = second;
            second = next;
        }
        res = next;
        assert(reg_file[3] == res && "fibonacci.elf [FAILED]"); // holds N-th fibonacci number
        assert(reg_file[5] == N && "fibonacci.elf [FAILED]");   // holds N

    } else if (test_case == "multiplication.elf") {

        // test for 11 * 12, for different different numbers modify accordingly
        int a = 11;
        int b = 12;
        int ans = a * b;
        int is_neg = ans < 0 ? 1 : 0;
        assert(reg_file[3] == is_neg && "multiplication.elf [FAILED]");   // is_neg
        assert(reg_file[5] == ans && "multiplication.elf [FAILED]");      // result

    } else if (test_case == "push_pop.elf") {

        // test for value = 1345 = 0x541
        int value = 0x541;
        int stack_pointer_init = 0x40;
        int stack_pointer_after_push = stack_pointer_init + 4;
        assert(reg_file[30] == stack_pointer_init && "push_pop.elf [FAILED]");   // stack_pointer
        assert(ME.mem[stack_pointer_after_push] == (value & 0xFF) && "push_pop.elf [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 1] == ((value >> 8) & 0xFF) && "push_pop.elf [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 2] == ((value >> 16) & 0xFF) && "push_pop.elf [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 3] == ((value >> 24) & 0xFF) && "push_pop.elf [FAILED]");
        assert(reg_file[3] == value && "push_pop.elf [FAILED]");   // push register
        assert(reg_file[4] == value && "push_pop.elf [FAILED]");   // pop = push register

    } else if (test_case == "recursive_sum.elf") {

        // test for N = 9, for different N modify accordingly
        int N = 9;
        int stack_pointer_init = 0x100;
        int ans = (N * (N + 1)) / 2;
        assert(reg_file[30] == stack_pointer_init && "recursive_sum.elf [FAILED]");
        assert(reg_file[29] == ans && "recursive_sum.elf [FAILED]");

    } else if (test_case == "JB.elf") {
        assert(reg_file[01] == 0x18 && "JB.elf [FAILED]");
        assert(reg_file[02] == 0x20 && "JB.elf [FAILED]");
        assert(reg_file[03] == 0x18 && "JB.elf [FAILED]");
        assert(reg_file[04] == 0x00 && "JB.elf [FAILED]");
        assert(reg_file[05] == 0x00 && "JB.elf [FAILED]");
        assert(reg_file[06] == 0x180 && "JB.elf [FAILED]");
        assert(reg_file[07] == 0x00 && "JB.elf [FAILED]");
        assert(reg_file[8] == 0x00 && "JB.elf [FAILED]");
        assert(reg_file[9] == 0x2C && "JB.elf [FAILED]");
        assert(reg_file[10] == 0x44 && "JB.elf [FAILED]");
        assert(reg_file[11] == 0x88 && "JB.elf [FAILED]");
        assert(ME.mem[0x180] == 0x18 && "JB.elf [FAILED]");
        assert(reg_file[14] == 0x00 && "JB.elf [FAILED]");
        assert(ME.mem[0x184] == 0x20 && "JB.elf [FAILED]");
        assert(reg_file[12] == 0xAC && "JB.elf [FAILED]");
        assert(ME.mem[0x188] == 0x88 && "JB.elf [FAILED]");
        assert(reg_file[17] == 0x11 && "JB.elf [FAILED]");
        assert(reg_file[18] == 0x00 && "JB.elf [FAILED]");
        assert(reg_file[19] == 0x00 && "JB.elf [FAILED]");
        assert(ME.mem[0x18C] == 0x44 && "JB.elf [FAILED]");
        assert(reg_file[13] == 0xD4 && "JB.elf [FAILED]");
        assert(ME.mem[0x190] == 0x44 && "JB.elf [FAILED]");
        assert(reg_file[20] == 0x38 && "JB.elf [FAILED]");
        assert(reg_file[21] == 0x70 && "JB.elf [FAILED]");
        assert(reg_file[22] == 0xE4 && "JB.elf [FAILED]");
        assert(reg_file[25] == 0xA8 && "JB.elf [FAILED]");
        assert(ME.mem[0x194] == 0x44 && "JB.elf [FAILED]");
        assert(reg_file[26] == 0xFC && "JB.elf [FAILED]");
        assert(reg_file[27] == 0x150 && "JB.elf [FAILED]");
        assert(ME.mem[0x198] == 0x44 && "JB.elf [FAILED]");
        assert(reg_file[28] == 0x154 && "JB.elf [FAILED]");
        assert(reg_file[29] == 0x118 && "JB.elf [FAILED]");
        assert(reg_file[30] == 0x230 && "JB.elf [FAILED]");

    } else if (test_case == "store.elf") {

        int adr1 = 0x80;
        int adr2 = 0x9C;

        assert(reg_file[1] == adr1 && "store.elf [FAILED]");
        assert(reg_file[2] == adr2 && "store.elf [FAILED]");
        assert(reg_file[20] == 5 << 12 && "store.elf [FAILED]");
        assert(reg_file[21] == 12 && "store.elf [FAILED]");
        assert(reg_file[22] == 16 + (100 << 12) && "store.elf [FAILED]");
        assert(reg_file[5] == 352 && "store.elf[FAILED]");
        assert(reg_file[6] == 55 && "store.elf [FAILED]");
        assert(reg_file[7] == 1 && "store.elf [FAILED]");
        assert(reg_file[8] == 3 && "store.elf [FAILED]");
        assert(reg_file[9] == -1 && "store.elf [FAILED]");
        assert(reg_file[10] == 129 && "store.elf [FAILED]");
        assert(reg_file[11] == -100 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 0] == 0x03 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 1] == 0x01 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 2] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 3] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 4] == 0x37 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 5] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr1 + 6] == 0x01 && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 0] == 0xFF && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 1] == 0xFF && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 2] == 0xFF && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 3] == 0xFF && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 4] == 0x81 && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 5] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 6] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 7] == 0x00 && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 8] == 0x9C && "store.elf [FAILED]");
        assert(ME.mem[adr2 + 9] == 0xFF && "store.elf [FAILED]");
        assert(reg_file[31] == 0xFFFFFFFF && "store.elf [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "store.elf [FAILED]");
        assert(reg_file[29] == 0x0000FFFF && "store.elf [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFF && "store.elf [FAILED]");
        assert(reg_file[27] == 0x000000FF && "store.elf [FAILED]");
        assert(reg_file[26] == 0xFFFFFF81 && "store.elf [FAILED]");
        assert(reg_file[25] == 0x00000081 && "store.elf [FAILED]");

        //////////////////// Pipeline ///////////////////////
    } else if (test_case == "test_1.elf") {

        int adr = 0x100;

        assert(reg_file[5] == 0x100 && "test_1 [FAILED]");
        assert(reg_file[6] == 0x2C && "test_1 [FAILED]");
        assert(ME.mem[adr + 0] == 0x2C && "test_1 [FAILED]");
        assert(ME.mem[adr + 1] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 2] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 3] == 0x00 && "test_1 [FAILED]");
        assert(reg_file[1] == 0x01 && "test_1 [FAILED]");
        assert(reg_file[2] == 0x02 && "test_1 [FAILED]");
        assert(reg_file[3] == 0x04 && "test_1 [FAILED]");
        assert(reg_file[4] == 0x04 && "test_1 [FAILED]");
        assert(reg_file[7] == 0xFC && "test_1 [FAILED]");
        assert(reg_file[8] == 0x2C && "test_1 [FAILED]");
        assert(reg_file[9] == 0x30 && "test_1 [FAILED]");
        assert(reg_file[10] == 0x108 && "test_1 [FAILED]");
        assert(reg_file[11] == 0x104 && "test_1 [FAILED]");
        assert(ME.mem[adr + 4] == 0x04 && "test_1 [FAILED]");
        assert(ME.mem[adr + 5] == 0x01 && "test_1 [FAILED]");
        assert(ME.mem[adr + 6] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 7] == 0x00 && "test_1 [FAILED]");
        assert(reg_file[12] == 0x108 && "test_1 [FAILED]");
        assert(reg_file[13] == 0x2C && "test_1 [FAILED]");
        assert(reg_file[14] == 0x58 && "test_1 [FAILED]");
        assert(reg_file[15] == 0x2C && "test_1 [FAILED]");
        assert(reg_file[16] == 0x68 && "test_1 [FAILED]");
        assert(ME.mem[adr + 8] == 0x68 && "test_1 [FAILED]");
        assert(ME.mem[adr + 9] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 10] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 11] == 0x00 && "test_1 [FAILED]");
        assert(reg_file[17] == 0x68 && "test_1 [FAILED]");
        assert(reg_file[18] == 0x104 && "test_1 [FAILED]");
        assert(ME.mem[adr + 12] == 0x04 && "test_1 [FAILED]");
        assert(ME.mem[adr + 13] == 0x01 && "test_1 [FAILED]");
        assert(ME.mem[adr + 14] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 15] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 16] == 0x68 && "test_1 [FAILED]");
        assert(ME.mem[adr + 17] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 18] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 19] == 0x00 && "test_1 [FAILED]");
        assert(reg_file[19] == 0x84 && "test_1 [FAILED]");
        assert(reg_file[20] == 0x108 && "test_1 [FAILED]");
        assert(reg_file[21] == 0x8C && "test_1 [FAILED]");
        assert(reg_file[22] == 0x8C && "test_1 [FAILED]");
        assert(reg_file[23] == 0x94 && "test_1 [FAILED]");
        assert(ME.mem[adr + 20] == 0x94 && "test_1 [FAILED]");
        assert(ME.mem[adr + 21] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 22] == 0x00 && "test_1 [FAILED]");
        assert(ME.mem[adr + 23] == 0x00 && "test_1 [FAILED]");
        assert(reg_file[24] == 0x9C && "test_1 [FAILED]");
        assert(reg_file[25] == 0x94 && "test_1 [FAILED]");
        assert(reg_file[26] == 0xA4 && "test_1 [FAILED]");
        assert(reg_file[27] == 0xAC && "test_1 [FAILED]");
        assert(reg_file[28] == 0xBC && "test_1 [FAILED]");
        assert(reg_file[29] == 0xC4 && "test_1 [FAILED]");
        assert(reg_file[30] == 0x188 && "test_1 [FAILED]");
        assert(reg_file[31] == 0xC8 && "test_1 [FAILED]");

    } else if (test_case == "test_2.elf") {

        int adr = 0x180;

        assert(reg_file[01] == 0x18 && "test_2.elf [FAILED]");
        assert(reg_file[02] == 0x20 && "test_2.elf [FAILED]");
        assert(reg_file[03] == 0x18 && "test_2.elf [FAILED]");
        assert(reg_file[04] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[05] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[06] == adr && "test_2.elf [FAILED]");
        assert(reg_file[07] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[8] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[9] == 0x2C && "test_2.elf [FAILED]");
        assert(reg_file[10] == 0x44 && "test_2.elf [FAILED]");
        assert(reg_file[11] == 0x88 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 0] == 0x18 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 1] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 2] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 3] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[14] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 4] == 0x20 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 5] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 6] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 7] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[12] == 0xAC && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 8] == 0x88 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 9] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 10] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 11] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[17] == 0x11 && "test_2.elf [FAILED]");
        assert(reg_file[18] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[19] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 12] == 0x44 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 13] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 14] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 15] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[13] == 0xD4 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 16] == 0x44 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 17] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 18] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 19] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[20] == 0x38 && "test_2.elf [FAILED]");
        assert(reg_file[21] == 0x70 && "test_2.elf [FAILED]");
        assert(reg_file[22] == 0xE4 && "test_2.elf [FAILED]");
        assert(reg_file[25] == 0xA8 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 20] == 0x44 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 21] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 22] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 23] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[26] == 0xFC && "test_2.elf [FAILED]");
        assert(reg_file[27] == 0x150 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 24] == 0x44 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 25] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 26] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[adr + 27] == 0x00 && "test_2.elf [FAILED]");
        assert(reg_file[28] == 0x154 && "test_2.elf [FAILED]");
        assert(reg_file[29] == 0x118 && "test_2.elf [FAILED]");
        assert(reg_file[30] == 0x230 && "test_2.elf [FAILED]");

    } else if (test_case == "test_3.elf") {

        int adr = 0x180;

        assert(reg_file[01] == 0x180 && "test_3.elf [FAILED]");
        assert(reg_file[02] == 0x24 && "test_3.elf [FAILED]");
        assert(reg_file[03] == 0x3C && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 0] == 0x24 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 1] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 2] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 3] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 4] == 0x3C && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 5] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 6] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 7] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[04] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[05] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[06] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[07] == 0x3C && "test_3.elf [FAILED]");
        assert(reg_file[8] == 0x78 && "test_3.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[11] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[12] == 0x60 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 8] == 0x60 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 9] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 10] == 0x00 && "test_3.elf [FAILED]");
        assert(ME.mem[adr + 11] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[13] == 0xC0 && "test_3.elf [FAILED]");
        assert(reg_file[14] == 0x54 && "test_3.elf [FAILED]");
        assert(reg_file[16] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[17] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[18] == 0x00 && "test_3.elf [FAILED]");
        assert(reg_file[19] == 0xFC && "test_3.elf [FAILED]");
        assert(reg_file[20] == 0x60 && "test_3.elf [FAILED]");
        assert(ME.mem[0x88] == 0x60 && "test_2.elf [FAILED]");
        assert(ME.mem[0x89] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[0x8A] == 0x00 && "test_2.elf [FAILED]");
        assert(ME.mem[0x8B] == 0x00 && "test_2.elf [FAILED]");

        //////////////////// ENC_R ///////////////////////
    } else if (test_case == "add.elf") {
        assert(reg_file[5] == 0x8A && "add.elf [FAILED]");
        assert(reg_file[6] == 0x76 && "add.elf [FAILED]");
        assert(reg_file[7] == 0x80 && "add.elf [FAILED]");
        assert(reg_file[8] == 0x80 && "add.elf [FAILED]");
        assert(reg_file[9] == 0x100 && "add.elf [FAILED]");
        assert(reg_file[10] == 0xFFFFFF8A && "add.elf [FAILED]");
        assert(reg_file[11] == 0xFFFFFF76 && "add.elf [FAILED]");
        assert(reg_file[12] == 0xFFFFFF80 && "add.elf [FAILED]");
        assert(reg_file[13] == 0xFFFFFF80 && "add.elf [FAILED]");
        assert(reg_file[14] == -256 && "add.elf [FAILED]");
    } else if (test_case == "sub.elf") {
        assert(reg_file[5] == 0x76 && "sub.elf [FAILED]");
        assert(reg_file[6] == 0x8A && "sub.elf [FAILED]");
        assert(reg_file[7] == 0x80 && "sub.elf [FAILED]");
        assert(reg_file[8] == 0xFFFFFF80 && "sub.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "sub.elf [FAILED]");
        assert(reg_file[10] == 0xFFFFFF76 && "sub.elf [FAILED]");
        assert(reg_file[11] == 0xFFFFFF8A && "sub.elf [FAILED]");
        assert(reg_file[12] == 0xFFFFFF80 && "sub.elf [FAILED]");
        assert(reg_file[13] == 0x80 && "sub.elf [FAILED]");
        assert(reg_file[14] == 0x00 && "sub.elf [FAILED]");
    } else if (test_case == "sll.elf") {
        assert(reg_file[4] == 0x10 && "sll.elf [FAILED]");
        assert(reg_file[5] == 0x40 && "sll.elf [FAILED]");
        assert(reg_file[6] == 0x40 && "sll.elf [FAILED]");
        assert(reg_file[7] == 0x00 && "sll.elf [FAILED]");
    } else if (test_case == "slt.elf") {
        assert(reg_file[3] == 0x01 && "slt.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "slt.elf [FAILED]");
        assert(reg_file[5] == 0x00 && "slt.elf [FAILED]");
        assert(reg_file[6] == 0x01 && "slt.elf [FAILED]");
        assert(reg_file[7] == 0x01 && "slt.elf [FAILED]");
        assert(reg_file[8] == 0x01 && "slt.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "slt.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "slt.elf [FAILED]");
    } else if (test_case == "sltu.elf") {
        assert(reg_file[3] == 0x01 && "sltu.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "sltu.elf [FAILED]");
        assert(reg_file[5] == 0x01 && "sltu.elf [FAILED]");
        assert(reg_file[6] == 0x01 && "sltu.elf [FAILED]");
        assert(reg_file[7] == 0x00 && "sltu.elf [FAILED]");
        assert(reg_file[8] == 0x00 && "sltu.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "sltu.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "sltu.elf [FAILED]");
    } else if (test_case == "xor.elf") {
        assert(reg_file[4] == 0x00 && "xor.elf [FAILED]");
        assert(reg_file[5] == 0x03 && "xor.elf [FAILED]");
        assert(reg_file[6] == 0xFFFFFFF8 && "xor.elf [FAILED]");
        assert(reg_file[7] == 0xFFFFFFF8 && "xor.elf [FAILED]");
        assert(reg_file[8] == 0xFFFFFFF8 && "xor.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "xor.elf [FAILED]");
    } else if (test_case == "srl.elf") {
        assert(reg_file[5] == 0x20 && "srl.elf [FAILED]");
        assert(reg_file[6] == 0x02 && "srl.elf [FAILED]");
        assert(reg_file[7] == 0x00 && "srl.elf [FAILED]");
        assert(reg_file[8] == 0x40 && "srl.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "srl.elf [FAILED]");
    } else if (test_case == "sra.elf") {
        assert(reg_file[7] == 0x20 && "sra.elf [FAILED]");
        assert(reg_file[8] == 0x01 && "sra.elf [FAILED]");
        assert(reg_file[9] == 0x01 && "sra.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "sra.elf [FAILED]");
        assert(reg_file[11] == 0xFFFFFFEF && "sra.elf [FAILED]");
        assert(reg_file[12] == 0xFFFFFFFF && "sra.elf [FAILED]");
        assert(reg_file[13] == 0xFFFFFFFF && "sra.elf [FAILED]");
        assert(reg_file[14] == 0x00 && "sra.elf [FAILED]");
    } else if (test_case == "or.elf") {
        assert(reg_file[1] == 0x07 && "or.elf [FAILED]");
        assert(reg_file[5] == 0x07 && "or.elf [FAILED]");
        assert(reg_file[6] == 0x0F && "or.elf [FAILED]");
        assert(reg_file[7] == 0x07 && "or.elf [FAILED]");
        assert(reg_file[8] == 0x0F && "or.elf [FAILED]");
        assert(reg_file[9] == 0x0F && "or.elf [FAILED]");
        assert(reg_file[10] == 0x01 && "or.elf [FAILED]");
        assert(reg_file[11] == 0x01 && "or.elf [FAILED]");
    } else if (test_case == "and.elf") {
        assert(reg_file[1] == 0x07 && "and.elf [FAILED]");
        assert(reg_file[5] == 0x01 && "and.elf [FAILED]");
        assert(reg_file[6] == 0x07 && "and.elf [FAILED]");
        assert(reg_file[7] == 0x07 && "and.elf [FAILED]");
        assert(reg_file[8] == 0x00 && "and.elf [FAILED]");
        assert(reg_file[9] == 0x08 && "and.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "and.elf [FAILED]");
        assert(reg_file[11] == 0x00 && "and.elf [FAILED]");

        //////////////////// ENC_I_I ///////////////////////
    } else if (test_case == "addi.elf") {
        assert(reg_file[1] == 0x80 && "addi.elf [FAILED]");
        assert(reg_file[2] == 0x80 && "addi.elf [FAILED]");
        assert(reg_file[3] == 0x8a && "addi.elf [FAILED]");
        assert(reg_file[4] == 0x76 && "addi.elf [FAILED]");
        assert(reg_file[5] == 0xffffff80 && "addi.elf [FAILED]");
        assert(reg_file[6] == 0xffffff80 && "addi.elf [FAILED]");
        assert(reg_file[7] == 0xffffff8a && "addi.elf [FAILED]");
        assert(reg_file[8] == 0xffffff76 && "addi.elf [FAILED]");
    } else if (test_case == "slli.elf") {
        assert(reg_file[2] == 0x10 && "slli.elf [FAILED]");
        assert(reg_file[3] == 0x40 && "slli.elf [FAILED]");
        assert(reg_file[4] == 0x40 && "slli.elf [FAILED]");
    } else if (test_case == "slti.elf") {
        assert(reg_file[3] == 0x01 && "slti.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "slti.elf [FAILED]");
        assert(reg_file[5] == 0x00 && "slti.elf [FAILED]");
        assert(reg_file[6] == 0x01 && "slti.elf [FAILED]");
        assert(reg_file[7] == 0x01 && "slti.elf [FAILED]");
        assert(reg_file[8] == 0x01 && "slti.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "slti.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "slti.elf [FAILED]");
    } else if (test_case == "sltiu.elf") {
        assert(reg_file[3] == 0x01 && "sltiu.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "sltiu.elf [FAILED]");
        assert(reg_file[5] == 0x01 && "sltiu.elf [FAILED]");
        assert(reg_file[6] == 0x01 && "sltiu.elf [FAILED]");
        assert(reg_file[7] == 0x00 && "sltiu.elf [FAILED]");
        assert(reg_file[8] == 0x00 && "sltiu.elf [FAILED]");
        assert(reg_file[9] == 0x00 && "sltiu.elf [FAILED]");
        assert(reg_file[10] == 0x00 && "sltiu.elf [FAILED]");
    } else if (test_case == "xori.elf") {
        assert(reg_file[2] == 0x00 && "xori.elf [FAILED]");
        assert(reg_file[3] == 0x03 && "xori.elf [FAILED]");
        assert(reg_file[4] == 0xFFFFFFF8 && "xori.elf [FAILED]");
        assert(reg_file[5] == 0xFFFFFFF8 && "xori.elf [FAILED]");
    } else if (test_case == "srli.elf") {
        assert(reg_file[2] == 0x20 && "srli.elf [FAILED]");
        assert(reg_file[3] == 0x02 && "srli.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "srli.elf [FAILED]");
        assert(reg_file[5] == 0x40 && "srli.elf [FAILED]");
    } else if (test_case == "srai.elf") {
        assert(reg_file[3] == 0x20 && "srai.elf [FAILED]");
        assert(reg_file[4] == 0x01 && "srai.elf [FAILED]");
        assert(reg_file[5] == 0xFFFFFFEF && "srai.elf [FAILED]");
        assert(reg_file[6] == 0xFFFFFFFF && "srai.elf [FAILED]");
    } else if (test_case == "ori.elf") {
        assert(reg_file[1] == 0x07 && "ori.elf [FAILED]");
        assert(reg_file[2] == 0x0F && "ori.elf [FAILED]");
        assert(reg_file[3] == 0x0F && "ori.elf [FAILED]");
        assert(reg_file[4] == 0xFFFFFFFF && "ori.elf [FAILED]");
    } else if (test_case == "andi.elf") {
        assert(reg_file[3] == 0x01 && "andi.elf [FAILED]");
        assert(reg_file[4] == 0x07 && "andi.elf [FAILED]");
        assert(reg_file[5] == 0x00 && "andi.elf [FAILED]");
        assert(reg_file[6] == 0x08 && "andi.elf [FAILED]");

        //////////////////// ENC_I_L ///////////////////////
    } else if (test_case == "lb.elf") {
        assert(reg_file[31] == 0x00000001 && "lb.elf [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "lb.elf [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lb.elf [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFC && "lb.elf [FAILED]");
    } else if (test_case == "lh.elf") {
        assert(reg_file[31] == 0x00000201 && "lh.elf [FAILED]");
        assert(reg_file[30] == 0xFFFFFEFF && "lh.elf [FAILED]");
        assert(reg_file[29] == 0xFFFFFF04 && "lh.elf [FAILED]");
    } else if (test_case == "lw.elf") {
        assert(reg_file[31] == 0x04030201 && "lw.elf [FAILED]");
        assert(reg_file[30] == 0xFCFDFEFF && "lw.elf [FAILED]");
        assert(reg_file[29] == 0xFEFF0403 && "lw.elf [FAILED]");
    } else if (test_case == "lbu.elf") {
        assert(reg_file[31] == 0x00000001 && "lbu.elf [FAILED]");
        assert(reg_file[30] == 0x000000FF && "lbu.elf [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lbu.elf [FAILED]");
        assert(reg_file[28] == 0x000000FC && "lbu.elf [FAILED]");
    } else if (test_case == "lhu.elf") {
        assert(reg_file[31] == 0x00000201 && "lhu.elf [FAILED]");
        assert(reg_file[30] == 0x0000FEFF && "lhu.elf [FAILED]");
        assert(reg_file[29] == 0x0000FF04 && "lhu.elf [FAILED]");

        //////////////////// ENC_I_J ///////////////////////
    } else if (test_case == "jalr.elf") {
        assert(reg_file[31] == 0x00 && "jalr.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "jalr.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "jalr.elf [FAILED]");
        assert(reg_file[1] == 0x10 && "jalr.elf [FAILED]");
        assert(reg_file[2] == 0x38 && "jalr.elf [FAILED]");

        //////////////////// ENC_S ///////////////////////
    } else if (test_case == "sb.elf") {
        assert(ME.mem[0x80] == 0x60 && "sb.elf [FAILED]");
        assert(ME.mem[0x81] == 0x37 && "sb.elf [FAILED]");
        assert(ME.mem[0x86] == 0x01 && "sb.elf [FAILED]");
        assert(ME.mem[0x9C] == 0xF3 && "sb.elf [FAILED]");
        assert(ME.mem[0x9B] == 0xF3 && "sb.elf [FAILED]");
    } else if (test_case == "sh.elf") {
        assert(ME.mem[0x80] == 0x60 && "sh.elf [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sh.elf [FAILED]");
        assert(ME.mem[0x7E] == 0xF3 && "sh.elf [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sh.elf [FAILED]");
        assert(ME.mem[0x9C] == 0x01 && "sh.elf [FAILED]");
        assert(ME.mem[0x9D] == 0x00 && "sh.elf [FAILED]");
        assert(ME.mem[0x9E] == 0x37 && "sh.elf [FAILED]");
        assert(ME.mem[0x9F] == 0x00 && "sh.elf [FAILED]");
    } else if (test_case == "sw.elf") {
        assert(ME.mem[0x80] == 0x60 && "sw.elf [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sw.elf [FAILED]");
        assert(ME.mem[0x82] == 0x00 && "sw.elf [FAILED]");
        assert(ME.mem[0x83] == 0x00 && "sw.elf [FAILED]");
        assert(ME.mem[0x7C] == 0xF3 && "sw.elf [FAILED]");
        assert(ME.mem[0x7D] == 0xFF && "sw.elf [FAILED]");
        assert(ME.mem[0x7E] == 0xFF && "sw.elf [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sw.elf [FAILED]");
        assert(ME.mem[0x84] == 0x01 && "sw.elf [FAILED]");
        assert(ME.mem[0x85] == 0x00 && "sw.elf [FAILED]");
        assert(ME.mem[0x86] == 0x00 && "sw.elf [FAILED]");
        assert(ME.mem[0x87] == 0x00 && "sw.elf [FAILED]");

        //////////////////// ENC_B ///////////////////////
    } else if (test_case == "beq.elf") {
        assert(reg_file[31] == 0x00 && "beq.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "beq.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "beq.elf [FAILED]");
    } else if (test_case == "bne.elf") {
        assert(reg_file[31] == 0x0F && "bne.elf [FAILED]");
        assert(reg_file[30] == 0x00 && "bne.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "bne.elf [FAILED]");
    } else if (test_case == "blt.elf") {
        assert(reg_file[31] == 0x00 && "blt.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "blt.elf [FAILED]");
        assert(reg_file[29] == 0x00 && "blt.elf [FAILED]");
    } else if (test_case == "bge.elf") {
        assert(reg_file[31] == 0x00 && "bge.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "bge.elf [FAILED]");
        assert(reg_file[29] == 0x00 && "bge.elf [FAILED]");
        assert(reg_file[28] == 0x0F && "bge.elf [FAILED]");
    } else if (test_case == "bltu.elf") {
        assert(reg_file[31] == 0x00 && "bltu.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "bltu.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "bltu.elf [FAILED]");
        assert(reg_file[28] == 0x00 && "bltu.elf [FAILED]");
    } else if (test_case == "bgeu.elf") {
        assert(reg_file[31] == 0x0F && "bgeu.elf [FAILED]");
        assert(reg_file[30] == 0x00 && "bgeu.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "bgeu.elf [FAILED]");
        assert(reg_file[28] == 0x0F && "bgeu.elf [FAILED]");

        //////////////////// ENC_U ///////////////////////
    } else if (test_case == "lui.elf") {
        assert(reg_file[1] == 0x5000 && "lui.elf [FAILED]");
        assert(reg_file[2] == 0x1F000 && "lui.elf [FAILED]");
        //assert(reg_file[3] == 0xFFFFF000 && "lui.elf [FAILED]");
        assert(reg_file[4] == 0x00 && "lui.elf [FAILED]");
    } else if (test_case == "auipc.elf") {
        assert(reg_file[1] == 0x00 && "auipc.elf [FAILED]");
        assert(reg_file[2] == 0x8004 && "auipc.elf [FAILED]");
        assert(reg_file[3] == 0x08 && "auipc.elf [FAILED]");
        assert(reg_file[4] == 0x100C && "auipc.elf [FAILED]");

        //////////////////// ENC_J///////////////////////
    } else if (test_case == "jal.elf") {
        assert(reg_file[31] == 0x00 && "jal.elf [FAILED]");
        assert(reg_file[30] == 0x0F && "jal.elf [FAILED]");
        assert(reg_file[29] == 0x0F && "jal.elf [FAILED]");
        assert(reg_file[28] == 0x0F && "jal.elf [FAILED]");
        assert(reg_file[1] == 0x14 && "jal.elf [FAILED]");
        assert(reg_file[2] == 0x20 && "jal.elf [FAILED]");

    } else if (test_case == "Fibonacci.elf") { // for Programs/Fibonacci_c/Fibonacci.elf

        int n = 1000;//Enter the number of terms of Fibonacci series you want (no smaller than 10)
        int numbers[n];
        int c, first = 0, second = 1, next;
        for (c = 0; c < n; c++) {
            if (c <= 1)
                next = c;
            else {
                next = first + second;
                first = second;
                second = next;
            }
            numbers[c] = next;
        }
        assert(reg_file[18] == numbers[n - 10] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[19] == numbers[n - 9] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[20] == numbers[n - 8] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[21] == numbers[n - 7] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[22] == numbers[n - 6] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[23] == numbers[n - 5] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[24] == numbers[n - 4] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[25] == numbers[n - 3] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[26] == numbers[n - 2] && "Fibonacci_cpp.elf [FAILED]");
        assert(reg_file[27] == numbers[n - 1] && "Fibonacci_cpp.elf [FAILED]");

    } else if (test_case == "BubbleSort.elf") { // for Programs/BubbleSort_c/BubbleSort.elf

        int n = 50; // number of entries in the array
        int numbers[n];
        int i;
        for (i = 0; i < n; i++)
            numbers[i] = i + 1;
        assert(reg_file[18] == numbers[n - 10] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[19] == numbers[n - 9] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[20] == numbers[n - 8] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[21] == numbers[n - 7] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[22] == numbers[n - 6] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[23] == numbers[n - 5] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[24] == numbers[n - 4] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[25] == numbers[n - 3] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[26] == numbers[n - 2] && "BubbleSort_cpp.elf [FAILED]");
        assert(reg_file[27] == numbers[n - 1] && "BubbleSort_cpp.elf [FAILED]");

    } else if (test_case == "Prime.elf") { // for Programs/Prime_c/Prime.elf

        int n = 1000;
        int i;
        int prime_count = 0;
        int max_cnt = 10; //How many primes should be computed?
        int numbers[max_cnt];
        int isPrime = 0;
        while (prime_count < max_cnt) {
            isPrime = 0;
            for (i = 2; i <= n / 2; ++i) {
                if (n % i == 0) {
                    isPrime = 1;
                    break;
                }
            }
            if (isPrime == 0) {
                numbers[prime_count] = n;
                ++prime_count;
            }
            n = n + 1;
        }
        assert(reg_file[18] == numbers[0] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[19] == numbers[1] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[20] == numbers[2] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[21] == numbers[3] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[22] == numbers[4] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[23] == numbers[5] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[24] == numbers[6] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[25] == numbers[7] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[26] == numbers[8] && "Prime_cpp.elf [FAILED]");
        assert(reg_file[27] == numbers[9] && "Prime_cpp.elf [FAILED]");

    } else if (test_case == "Timer_NO_ECALL.elf") {

        assert(reg_file[31] == 5 && "Timer_NO_ECALL.elf [FAILED]");

    } else if (test_case == "Timer.elf") {

        assert(reg_file[31] == 5 && "Timer.elf [FAILED]");

    } else if (test_case == "PrintMessage.elf") {

        assert(reg_file[30] == 5 && "PrintMessage.elf [FAILED]");
        assert(reg_file[31] == 6 && "PrintMessage.elf [FAILED]");

    } else {

        cout << "Tests for test case: '" << test_case << "':" << " [DOES NOT EXIST]" << endl;
        return;
    }

    cout << "Tests for test case: '" << test_case << "':" << " [PASSED]" << endl;
}


/*
void Core_test::regfile_log(Core* CO) {

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
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(01);
                break;
            case 2:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(02);
                break;
            case 3:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(03);
                break;
            case 4:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(04);
                break;
            case 5:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(05);
                break;
            case 6:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(06);
                break;
            case 7:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(07) << endl;
                break;
            case 8:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(08);
                break;
            case 9:
                s << dec << "RF[0" << i << "] 0x" << hex << CO->REGFILE(09);
                break;
            case 10:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(10);
                break;
            case 11:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(11);
                break;
            case 12:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(12);
                break;
            case 13:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(13);
                break;
            case 14:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(14);
                break;
            case 15:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(15) << endl;
                break;
            case 16:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(16);
                break;
            case 17:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(17);
                break;
            case 18:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(18);
                break;
            case 19:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(19);
                break;
            case 20:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(20);
                break;
            case 21:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(21);
                break;
            case 22:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(22);
                break;
            case 23:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(23) << endl;
                break;
            case 24:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(24);
                break;
            case 25:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(25);
                break;
            case 26:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(26);
                break;
            case 27:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(27);
                break;
            case 28:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(28);
                break;
            case 29:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(29);
                break;
            case 30:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(30);
                break;
            case 31:
                s << dec << "RF[" << i << "] 0x" << hex << CO->REGFILE(31) << endl;
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

    cout << "Register File Content (Dec):" << endl;

    cout << string(143, '-') << endl;

    for (int i = 0; i < 32; i++) {
        switch (i) {
            case 0:
                s << dec << "RF[00]   0";
                break;
            case 1:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(01);
                break;
            case 2:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(02);
                break;
            case 3:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(03);
                break;
            case 4:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(04);
                break;
            case 5:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(05);
                break;
            case 6:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(06);
                break;
            case 7:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(07) << endl;
                break;
            case 8:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(08);
                break;
            case 9:
                s << dec << "RF[0" << i << "]   " << CO->REGFILE(09);
                break;
            case 10:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(10);
                break;
            case 11:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(11);
                break;
            case 12:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(12);
                break;
            case 13:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(13);
                break;
            case 14:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(14);
                break;
            case 15:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(15) << endl;
                break;
            case 16:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(16);
                break;
            case 17:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(17);
                break;
            case 18:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(18);
                break;
            case 19:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(19);
                break;
            case 20:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(20);
                break;
            case 21:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(21);
                break;
            case 22:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(22);
                break;
            case 23:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(23) << endl;
                break;
            case 24:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(24);
                break;
            case 25:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(25);
                break;
            case 26:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(26);
                break;
            case 27:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(27);
                break;
            case 28:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(28);
                break;
            case 29:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(29);
                break;
            case 30:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(30);
                break;
            case 31:
                s << dec << "RF[" << i << "]   " << CO->REGFILE(31) << endl;
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
*/


#endif //PROJECT_CORE_TEST_H
