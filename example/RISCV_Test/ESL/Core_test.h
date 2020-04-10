//
// Created by lukadejanovic on 20.3.18..
//

#ifndef PROJECT_CORE_TEST_H
#define PROJECT_CORE_TEST_H

#include <tlm.h>
#include <iostream>
#include "assert.h"
#include "systemc.h"
#include "Interfaces.h"
#include "Memory.h"
#include "TLM/Memory_tlm.h"
#include "TLM/TLM_bridge.h"

/* ##################
 * ###CORE###########
 * ##################
 * ADD YOUR CORE IMPLEMENTATION HERE
 */
#include "../../RISCV_ISA/Dino_test/EstimatePower/Core_new.h"
//#include "../../RISCV_Pipelined/ESL/Core.h"
//#include "../../RISCV_OLD/ESL/Core.h"
//#include "../../RISCV_ISA/ESL/Core.h"
//#include "../../RISCV_MS/ESL/Core.h"

// TLM = 1 -> using TLM bridge and TLM memory
// TLM = 0 -> SCAM interface only
#define TLM 0

class Core_test {
public:

    Core_test(string hex_file_path, string assembly_file_path, string log_file_path) {
        this->hex_file_path = hex_file_path;
        this->assembly_file_path = assembly_file_path;
        this->log_file_path = log_file_path;
    }

    // perform test
    void perform_test();

private:
    string hex_file_path;
    string assembly_file_path;
    string log_file_path;
};


void Core_test::perform_test() {

    ifstream hex_file;
    ifstream assembly_file;
    ofstream log_file;

    open_hex_file(hex_file_path, hex_file);

    // extract file name from path
    string test_case = hex_file_path.substr(hex_file_path.find_last_of("/\\") + 1);

    cout << endl << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Running test for hex file: '" << test_case << "' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;

#ifdef LOGTOFILE
    open_log_file(log_file_path, log_file);

    string logfile_name = log_file_path.substr(log_file_path.find_last_of("/\\") + 1);

    cout << "Output redirected to log file: " << logfile_name << endl;

    streambuf *console_buffer =  cout.rdbuf(log_file.rdbuf());

    assembly_file.open(assembly_file_path);
    if (assembly_file.is_open()) {
        cout << "Assembly file:" << endl;
        cout << assembly_file.rdbuf();
        cout << endl;
    } else {
        cout << "Can't open assembly file with path: " << assembly_file_path << endl;
        exit(0);
    }
#endif

#if TLM == 0

    // Component instantiations
    Core CO("CO");
    Memory ME("ME", &hex_file, &log_file);

    // Channel instantiation
    Blocking<CUtoME_IF> COtoME_channel("COtoME_channel");
    Blocking<MEtoCU_IF> MEtoCO_channel("MEtoCO_channel");

    // Port binding:
    CO.COtoME_port(COtoME_channel);
    ME.COtoME_port(COtoME_channel);
    ME.MEtoCO_port(MEtoCO_channel);
    CO.MEtoCO_port(MEtoCO_channel);

#elif TLM == 1

    // Component instantiation
    Core CO("CO");
    Memory_tlm ME("ME_TLM", &hex_file, &log_file);
    TLM_bridge BR("TLM_BR");

    // SCAM Channel instantiation (connecting to TLM bridge)
    Blocking<CUtoME_IF> COtoBR_channel("COtoBR_channel");
    Blocking<MEtoCU_IF> BRtoCO_channel("BRtoCO_channel");

    // Bind SCAM interface
    CO.COtoME_port(COtoBR_channel);
    BR.COtoBR_port(COtoBR_channel);
    CO.MEtoCO_port(BRtoCO_channel);
    BR.BRtoCO_port(BRtoCO_channel);

    // Bind TLM interface
    ME.memorySocket.bind(BR.bridgeSocket);

#endif


#ifdef LOGTOFILE
    // initial log
    if (TLM == 0) {
        std::cout << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Testing without TLM bridge~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;
    } else {
        std::cout << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Testing with TLM bridge~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;
    }

    cout << "Initial core state:" << endl;
    ME.log();
    CO.RF.log();
#endif

    // Start simulation.. simulation ends with sc_stop() call
    sc_start();

#ifdef LOGTOFILE
    // final log and testing
    std::cout << endl << "Final core state:" << endl;
    ME.log();
    CO.RF.log();
#endif

    // used for testing
    unsigned int reg_file[32] = {
            0,
            CO.RF.reg_file_01,
            CO.RF.reg_file_02,
            CO.RF.reg_file_03,
            CO.RF.reg_file_04,
            CO.RF.reg_file_05,
            CO.RF.reg_file_06,
            CO.RF.reg_file_07,
            CO.RF.reg_file_08,
            CO.RF.reg_file_09,
            CO.RF.reg_file_10,
            CO.RF.reg_file_11,
            CO.RF.reg_file_12,
            CO.RF.reg_file_13,
            CO.RF.reg_file_14,
            CO.RF.reg_file_15,
            CO.RF.reg_file_16,
            CO.RF.reg_file_17,
            CO.RF.reg_file_18,
            CO.RF.reg_file_19,
            CO.RF.reg_file_20,
            CO.RF.reg_file_21,
            CO.RF.reg_file_22,
            CO.RF.reg_file_23,
            CO.RF.reg_file_24,
            CO.RF.reg_file_25,
            CO.RF.reg_file_26,
            CO.RF.reg_file_27,
            CO.RF.reg_file_28,
            CO.RF.reg_file_29,
            CO.RF.reg_file_30,
            CO.RF.reg_file_31
    };

    //////////////////// Programs ///////////////////////
    if (test_case == "fibonacci.hex") {

        // test for N = 9, for different N modify accordingly
        int N = 9;
        int first = 0, second = 1, res, next;

        for (int i = 1; i < N; i++) {
            next = first + second;
            first = second;
            second = next;
        }
        res = next;

        assert(reg_file[3] == res && "fibonacci.hex [FAILED]"); // holds N-th fibonacci number
        assert(reg_file[5] == N && "fibonacci.hex [FAILED]");   // holds N

    } else if (test_case == "multiplication.hex") {

        // test for 11 * 12, for different different numbers modify accordingly
        int a = 11;
        int b = 12;
        int ans = a * b;
        int is_neg = ans < 0 ? 1 : 0;

        assert(reg_file[3] == is_neg && "multiplication.hex [FAILED]"); // is_neg
        assert(reg_file[5] == ans && "multiplication.hex [FAILED]");    // result

    } else if (test_case == "push_pop.hex") {

        // test for value = 1345 = 0x541
        int value = 0x541;
        int stack_pointer_init = 0x40;
        int stack_pointer_after_push = stack_pointer_init + 4;

        assert(reg_file[30] == stack_pointer_init && "push_pop.hex [FAILED]");   // stack_pointer
        assert(ME.mem[stack_pointer_after_push] == (value & 0xFF) && "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 1] == ((value >> 8) & 0xFF) && "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 2] == ((value >> 16) & 0xFF) && "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 3] == ((value >> 24) & 0xFF) && "push_pop.hex [FAILED]");
        assert(reg_file[3] == value && "push_pop.hex [FAILED]");   // push register
        assert(reg_file[4] == value && "push_pop.hex [FAILED]");   // pop = push register

    } else if (test_case == "recursive_sum.hex") {

        // test for N = 9, for different N modify accordingly
        int N = 9;
        int stack_pointer_init = 0x100;
        int ans = (N * (N + 1)) / 2;

        assert(reg_file[30] == stack_pointer_init && "recursive_sum.hex [FAILED]");
        assert(reg_file[29] == ans && "recursive_sum.hex [FAILED]");

    } else if (test_case == "store.hex") {

        int adr1 = 0x80;
        int adr2 = 0x9C;
        
        assert(reg_file[1] == adr1 && "store.hex [FAILED]");
        assert(reg_file[2] == adr2 && "store.hex [FAILED]");
        assert(reg_file[20] == 5 << 12 && "store.hex [FAILED]");
        assert(reg_file[21] == 12 && "store.hex [FAILED]");
        assert(reg_file[22] == 16 + (100 << 12) && "store.hex [FAILED]");
        assert(reg_file[5] == 352 && "store.hex[FAILED]");
        assert(reg_file[6] == 55 && "store.hex [FAILED]");
        assert(reg_file[7] == 1 && "store.hex [FAILED]");
        assert(reg_file[8] == 3 && "store.hex [FAILED]");
        assert(reg_file[9] == -1 && "store.hex [FAILED]");
        assert(reg_file[10] == 129 && "store.hex [FAILED]");
        assert(reg_file[11] == -100 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 0] == 0x03 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 1] == 0x01 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 2] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 3] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 4] == 0x37 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 5] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 6] == 0x01 && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 0] == 0xFF && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 1] == 0xFF && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 2] == 0xFF && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 3] == 0xFF && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 4] == 0x81 && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 5] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 6] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 7] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 8] == 0x9C && "store.hex [FAILED]");
        assert(ME.mem[adr2 + 9] == 0xFF && "store.hex [FAILED]");
        assert(reg_file[31] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[29] == 0x0000FFFF && "store.hex [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[27] == 0x000000FF && "store.hex [FAILED]");
        assert(reg_file[26] == 0xFFFFFF81 && "store.hex [FAILED]");
        assert(reg_file[25] == 0x00000081 && "store.hex [FAILED]");
        
        //////////////////// Pipeline ///////////////////////
    } else if (test_case == "test_1.hex") {

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

    } else if (test_case == "test_2.hex") {

        int adr = 0x180;

        assert(reg_file[01] == 0x18 && "test_2.hex [FAILED]");
        assert(reg_file[02] == 0x20 && "test_2.hex [FAILED]");
        assert(reg_file[03] == 0x18 && "test_2.hex [FAILED]");
        assert(reg_file[04] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[05] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[06] == adr && "test_2.hex [FAILED]");
        assert(reg_file[07] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[8] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[9] == 0x2C && "test_2.hex [FAILED]");
        assert(reg_file[10] == 0x44 && "test_2.hex [FAILED]");
        assert(reg_file[11] == 0x88 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 0] == 0x18 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 1] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 2] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 3] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[14] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 4] == 0x20 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 5] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 6] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 7] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[12] == 0xAC && "test_2.hex [FAILED]");
        assert(ME.mem[adr +  8] == 0x88 && "test_2.hex [FAILED]");
        assert(ME.mem[adr +  9] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 10] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 11] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[17] == 0x11 && "test_2.hex [FAILED]");
        assert(reg_file[18] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[19] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 12] == 0x44 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 13] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 14] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 15] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[13] == 0xD4 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 16] == 0x44 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 17] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 18] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 19] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[20] == 0x38 && "test_2.hex [FAILED]");
        assert(reg_file[21] == 0x70 && "test_2.hex [FAILED]");
        assert(reg_file[22] == 0xE4 && "test_2.hex [FAILED]");
        assert(reg_file[25] == 0xA8 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 20] == 0x44 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 21] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 22] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 23] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[26] == 0xFC && "test_2.hex [FAILED]");
        assert(reg_file[27] == 0x150 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 24] == 0x44 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 25] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 26] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[adr + 27] == 0x00 && "test_2.hex [FAILED]");
        assert(reg_file[28] == 0x154 && "test_2.hex [FAILED]");
        assert(reg_file[29] == 0x118 && "test_2.hex [FAILED]");
        assert(reg_file[30] == 0x230 && "test_2.hex [FAILED]");

    } else if (test_case == "test_3.hex") {

        int adr = 0x180;

        assert(reg_file[01] == 0x180 && "test_3.hex [FAILED]");
        assert(reg_file[02] == 0x24 && "test_3.hex [FAILED]");
        assert(reg_file[03] == 0x3C && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 0] == 0x24 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 1] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 2] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 3] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 4] == 0x3C && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 5] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 6] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 7] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[04] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[05] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[06] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[07] == 0x3C && "test_3.hex [FAILED]");
        assert(reg_file[8] == 0x78 && "test_3.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[11] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[12] == 0x60 && "test_3.hex [FAILED]");
        assert(ME.mem[adr +  8] == 0x60 && "test_3.hex [FAILED]");
        assert(ME.mem[adr +  9] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 10] == 0x00 && "test_3.hex [FAILED]");
        assert(ME.mem[adr + 11] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[13] == 0xC0 && "test_3.hex [FAILED]");
        assert(reg_file[14] == 0x54 && "test_3.hex [FAILED]");
        assert(reg_file[16] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[17] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[18] == 0x00 && "test_3.hex [FAILED]");
        assert(reg_file[19] == 0xFC && "test_3.hex [FAILED]");
        assert(reg_file[20] == 0x60 && "test_3.hex [FAILED]");
        assert(ME.mem[0x88] == 0x60 && "test_2.hex [FAILED]");
        assert(ME.mem[0x89] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[0x8A] == 0x00 && "test_2.hex [FAILED]");
        assert(ME.mem[0x8B] == 0x00 && "test_2.hex [FAILED]");

        //////////////////// ENC_R ///////////////////////
    } else if (test_case == "add.hex") {
        assert(reg_file[5] == 0x8A && "add.hex [FAILED]");
        assert(reg_file[6] == 0x76 && "add.hex [FAILED]");
        assert(reg_file[7] == 0x80 && "add.hex [FAILED]");
        assert(reg_file[8] == 0x80 && "add.hex [FAILED]");
        assert(reg_file[9] == 0x100 && "add.hex [FAILED]");
        assert(reg_file[10] == 0xFFFFFF8A && "add.hex [FAILED]");
        assert(reg_file[11] == 0xFFFFFF76 && "add.hex [FAILED]");
        assert(reg_file[12] == 0xFFFFFF80 && "add.hex [FAILED]");
        assert(reg_file[13] == 0xFFFFFF80 && "add.hex [FAILED]");
        assert(reg_file[14] == -256 && "add.hex [FAILED]");
    } else if (test_case == "sub.hex") {
        assert(reg_file[5] == 0x76 && "sub.hex [FAILED]");
        assert(reg_file[6] == 0x8A && "sub.hex [FAILED]");
        assert(reg_file[7] == 0x80 && "sub.hex [FAILED]");
        assert(reg_file[8] == 0xFFFFFF80 && "sub.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "sub.hex [FAILED]");
        assert(reg_file[10] == 0xFFFFFF76 && "sub.hex [FAILED]");
        assert(reg_file[11] == 0xFFFFFF8A && "sub.hex [FAILED]");
        assert(reg_file[12] == 0xFFFFFF80 && "sub.hex [FAILED]");
        assert(reg_file[13] == 0x80 && "sub.hex [FAILED]");
        assert(reg_file[14] == 0x00 && "sub.hex [FAILED]");
    } else if (test_case == "sll.hex") {
        assert(reg_file[4] == 0x10 && "sll.hex [FAILED]");
        assert(reg_file[5] == 0x40 && "sll.hex [FAILED]");
        assert(reg_file[6] == 0x40 && "sll.hex [FAILED]");
        assert(reg_file[7] == 0x00 && "sll.hex [FAILED]");
    } else if (test_case == "slt.hex") {
        assert(reg_file[3] == 0x01 && "slt.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "slt.hex [FAILED]");
        assert(reg_file[5] == 0x00 && "slt.hex [FAILED]");
        assert(reg_file[6] == 0x01 && "slt.hex [FAILED]");
        assert(reg_file[7] == 0x01 && "slt.hex [FAILED]");
        assert(reg_file[8] == 0x01 && "slt.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "slt.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "slt.hex [FAILED]");
    } else if (test_case == "sltu.hex") {
        assert(reg_file[3] == 0x01 && "sltu.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "sltu.hex [FAILED]");
        assert(reg_file[5] == 0x01 && "sltu.hex [FAILED]");
        assert(reg_file[6] == 0x01 && "sltu.hex [FAILED]");
        assert(reg_file[7] == 0x00 && "sltu.hex [FAILED]");
        assert(reg_file[8] == 0x00 && "sltu.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "sltu.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "sltu.hex [FAILED]");
    } else if (test_case == "xor.hex") {
        assert(reg_file[4] == 0x00 && "xor.hex [FAILED]");
        assert(reg_file[5] == 0x03 && "xor.hex [FAILED]");
        assert(reg_file[6] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[7] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[8] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "xor.hex [FAILED]");
    } else if (test_case == "srl.hex") {
        assert(reg_file[5] == 0x20 && "srl.hex [FAILED]");
        assert(reg_file[6] == 0x02 && "srl.hex [FAILED]");
        assert(reg_file[7] == 0x00 && "srl.hex [FAILED]");
        assert(reg_file[8] == 0x40 && "srl.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "srl.hex [FAILED]");
    } else if (test_case == "sra.hex") {
        assert(reg_file[7] == 0x20 && "sra.hex [FAILED]");
        assert(reg_file[8] == 0x01 && "sra.hex [FAILED]");
        assert(reg_file[9] == 0x01 && "sra.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "sra.hex [FAILED]");
        assert(reg_file[11] == 0xFFFFFFEF && "sra.hex [FAILED]");
        assert(reg_file[12] == 0xFFFFFFFF && "sra.hex [FAILED]");
        assert(reg_file[13] == 0xFFFFFFFF && "sra.hex [FAILED]");
        assert(reg_file[14] == 0x00 && "sra.hex [FAILED]");
    } else if (test_case == "or.hex") {
        assert(reg_file[1] == 0x07 && "or.hex [FAILED]");
        assert(reg_file[5] == 0x07 && "or.hex [FAILED]");
        assert(reg_file[6] == 0x0F && "or.hex [FAILED]");
        assert(reg_file[7] == 0x07 && "or.hex [FAILED]");
        assert(reg_file[8] == 0x0F && "or.hex [FAILED]");
        assert(reg_file[9] == 0x0F && "or.hex [FAILED]");
        assert(reg_file[10] == 0x01 && "or.hex [FAILED]");
        assert(reg_file[11] == 0x01 && "or.hex [FAILED]");
    } else if (test_case == "and.hex") {
        assert(reg_file[1] == 0x07 && "and.hex [FAILED]");
        assert(reg_file[5] == 0x01 && "and.hex [FAILED]");
        assert(reg_file[6] == 0x07 && "and.hex [FAILED]");
        assert(reg_file[7] == 0x07 && "and.hex [FAILED]");
        assert(reg_file[8] == 0x00 && "and.hex [FAILED]");
        assert(reg_file[9] == 0x08 && "and.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "and.hex [FAILED]");
        assert(reg_file[11] == 0x00 && "and.hex [FAILED]");

        //////////////////// ENC_I_I ///////////////////////
    } else if (test_case == "addi.hex") {
        assert(reg_file[1] == 0x80 && "addi.hex [FAILED]");
        assert(reg_file[2] == 0x80 && "addi.hex [FAILED]");
        assert(reg_file[3] == 0x8a && "addi.hex [FAILED]");
        assert(reg_file[4] == 0x76 && "addi.hex [FAILED]");
        assert(reg_file[5] == 0xffffff80 && "addi.hex [FAILED]");
        assert(reg_file[6] == 0xffffff80 && "addi.hex [FAILED]");
        assert(reg_file[7] == 0xffffff8a && "addi.hex [FAILED]");
        assert(reg_file[8] == 0xffffff76 && "addi.hex [FAILED]");
    } else if (test_case == "slli.hex") {
        assert(reg_file[2] == 0x10 && "slli.hex [FAILED]");
        assert(reg_file[3] == 0x40 && "slli.hex [FAILED]");
        assert(reg_file[4] == 0x40 && "slli.hex [FAILED]");
    } else if (test_case == "slti.hex") {
        assert(reg_file[3] == 0x01 && "slti.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "slti.hex [FAILED]");
        assert(reg_file[5] == 0x00 && "slti.hex [FAILED]");
        assert(reg_file[6] == 0x01 && "slti.hex [FAILED]");
        assert(reg_file[7] == 0x01 && "slti.hex [FAILED]");
        assert(reg_file[8] == 0x01 && "slti.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "slti.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "slti.hex [FAILED]");
    } else if (test_case == "sltiu.hex") {
        assert(reg_file[3] == 0x01 && "sltiu.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "sltiu.hex [FAILED]");
        assert(reg_file[5] == 0x01 && "sltiu.hex [FAILED]");
        assert(reg_file[6] == 0x01 && "sltiu.hex [FAILED]");
        assert(reg_file[7] == 0x00 && "sltiu.hex [FAILED]");
        assert(reg_file[8] == 0x00 && "sltiu.hex [FAILED]");
        assert(reg_file[9] == 0x00 && "sltiu.hex [FAILED]");
        assert(reg_file[10] == 0x00 && "sltiu.hex [FAILED]");
    } else if (test_case == "xori.hex") {
        assert(reg_file[2] == 0x00 && "xori.hex [FAILED]");
        assert(reg_file[3] == 0x03 && "xori.hex [FAILED]");
        assert(reg_file[4] == 0xFFFFFFF8 && "xori.hex [FAILED]");
        assert(reg_file[5] == 0xFFFFFFF8 && "xori.hex [FAILED]");
    } else if (test_case == "srli.hex") {
        assert(reg_file[2] == 0x20 && "srli.hex [FAILED]");
        assert(reg_file[3] == 0x02 && "srli.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "srli.hex [FAILED]");
        assert(reg_file[5] == 0x40 && "srli.hex [FAILED]");
    } else if (test_case == "srai.hex") {
        assert(reg_file[3] == 0x20 && "srai.hex [FAILED]");
        assert(reg_file[4] == 0x01 && "srai.hex [FAILED]");
        assert(reg_file[5] == 0xFFFFFFEF && "srai.hex [FAILED]");
        assert(reg_file[6] == 0xFFFFFFFF && "srai.hex [FAILED]");
    } else if (test_case == "ori.hex") {
        assert(reg_file[1] == 0x07 && "ori.hex [FAILED]");
        assert(reg_file[2] == 0x0F && "ori.hex [FAILED]");
        assert(reg_file[3] == 0x0F && "ori.hex [FAILED]");
        assert(reg_file[4] == 0xFFFFFFFF && "ori.hex [FAILED]");
    } else if (test_case == "andi.hex") {
        assert(reg_file[3] == 0x01 && "andi.hex [FAILED]");
        assert(reg_file[4] == 0x07 && "andi.hex [FAILED]");
        assert(reg_file[5] == 0x00 && "andi.hex [FAILED]");
        assert(reg_file[6] == 0x08 && "andi.hex [FAILED]");

        //////////////////// ENC_I_L ///////////////////////
    } else if (test_case == "lb.hex") {
        assert(reg_file[31] == 0x00000001 && "lb.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "lb.hex [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lb.hex [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFC && "lb.hex [FAILED]");
    } else if (test_case == "lh.hex") {
        assert(reg_file[31] == 0x00000201 && "lh.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFEFF && "lh.hex [FAILED]");
        assert(reg_file[29] == 0xFFFFFF04 && "lh.hex [FAILED]");
    } else if (test_case == "lw.hex") {
        assert(reg_file[31] == 0x04030201 && "lw.hex [FAILED]");
        assert(reg_file[30] == 0xFCFDFEFF && "lw.hex [FAILED]");
        assert(reg_file[29] == 0xFEFF0403 && "lw.hex [FAILED]");
    } else if (test_case == "lbu.hex") {
        assert(reg_file[31] == 0x00000001 && "lbu.hex [FAILED]");
        assert(reg_file[30] == 0x000000FF && "lbu.hex [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lbu.hex [FAILED]");
        assert(reg_file[28] == 0x000000FC && "lbu.hex [FAILED]");
    } else if (test_case == "lhu.hex") {
        assert(reg_file[31] == 0x00000201 && "lhu.hex [FAILED]");
        assert(reg_file[30] == 0x0000FEFF && "lhu.hex [FAILED]");
        assert(reg_file[29] == 0x0000FF04 && "lhu.hex [FAILED]");

        //////////////////// ENC_I_J ///////////////////////
    } else if (test_case == "jalr.hex") {
        assert(reg_file[31] == 0x00 && "jalr.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "jalr.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "jalr.hex [FAILED]");
        assert(reg_file[1] == 0x10 && "jalr.hex [FAILED]");
        assert(reg_file[2] == 0x38 && "jalr.hex [FAILED]");

        //////////////////// ENC_S ///////////////////////
    } else if (test_case == "sb.hex") {
        assert(ME.mem[0x80] == 0x60 && "sb.hex [FAILED]");
        assert(ME.mem[0x81] == 0x37 && "sb.hex [FAILED]");
        assert(ME.mem[0x86] == 0x01 && "sb.hex [FAILED]");
        assert(ME.mem[0x9C] == 0xF3 && "sb.hex [FAILED]");
        assert(ME.mem[0x9B] == 0xF3 && "sb.hex [FAILED]");
    } else if (test_case == "sh.hex") {
        assert(ME.mem[0x80] == 0x60 && "sh.hex [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sh.hex [FAILED]");
        assert(ME.mem[0x7E] == 0xF3 && "sh.hex [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sh.hex [FAILED]");
        assert(ME.mem[0x9C] == 0x01 && "sh.hex [FAILED]");
        assert(ME.mem[0x9D] == 0x00 && "sh.hex [FAILED]");
        assert(ME.mem[0x9E] == 0x37 && "sh.hex [FAILED]");
        assert(ME.mem[0x9F] == 0x00 && "sh.hex [FAILED]");
    } else if (test_case == "sw.hex") {
        assert(ME.mem[0x80] == 0x60 && "sw.hex [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sw.hex [FAILED]");
        assert(ME.mem[0x82] == 0x00 && "sw.hex [FAILED]");
        assert(ME.mem[0x83] == 0x00 && "sw.hex [FAILED]");
        assert(ME.mem[0x7C] == 0xF3 && "sw.hex [FAILED]");
        assert(ME.mem[0x7D] == 0xFF && "sw.hex [FAILED]");
        assert(ME.mem[0x7E] == 0xFF && "sw.hex [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sw.hex [FAILED]");
        assert(ME.mem[0x84] == 0x01 && "sw.hex [FAILED]");
        assert(ME.mem[0x85] == 0x00 && "sw.hex [FAILED]");
        assert(ME.mem[0x86] == 0x00 && "sw.hex [FAILED]");
        assert(ME.mem[0x87] == 0x00 && "sw.hex [FAILED]");

        //////////////////// ENC_B ///////////////////////
    } else if (test_case == "beq.hex") {
        assert(reg_file[31] == 0x00 && "beq.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "beq.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "beq.hex [FAILED]");
    } else if (test_case == "bne.hex") {
        assert(reg_file[31] == 0x0F && "bne.hex [FAILED]");
        assert(reg_file[30] == 0x00 && "bne.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "bne.hex [FAILED]");
    } else if (test_case == "blt.hex") {
        assert(reg_file[31] == 0x00 && "blt.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "blt.hex [FAILED]");
        assert(reg_file[29] == 0x00 && "blt.hex [FAILED]");
    } else if (test_case == "bge.hex") {
        assert(reg_file[31] == 0x00 && "bge.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "bge.hex [FAILED]");
        assert(reg_file[29] == 0x00 && "bge.hex [FAILED]");
        assert(reg_file[28] == 0x0F && "bge.hex [FAILED]");
    } else if (test_case == "bltu.hex") {
        assert(reg_file[31] == 0x00 && "bltu.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "bltu.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "bltu.hex [FAILED]");
        assert(reg_file[28] == 0x00 && "bltu.hex [FAILED]");
    } else if (test_case == "bgeu.hex") {
        assert(reg_file[31] == 0x0F && "bgeu.hex [FAILED]");
        assert(reg_file[30] == 0x00 && "bgeu.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "bgeu.hex [FAILED]");
        assert(reg_file[28] == 0x0F && "bgeu.hex [FAILED]");

        //////////////////// ENC_U ///////////////////////
    } else if (test_case == "lui.hex") {
        assert(reg_file[1] == 0x5000 && "lui.hex [FAILED]");
        assert(reg_file[2] == 0x1F000 && "lui.hex [FAILED]");
        //assert(reg_file[3] == 0xFFFFF000 && "lui.hex [FAILED]");
        assert(reg_file[4] == 0x00 && "lui.hex [FAILED]");
    } else if (test_case == "auipc.hex") {
        assert(reg_file[1] == 0x00 && "auipc.hex [FAILED]");
        assert(reg_file[2] == 0x8004 && "auipc.hex [FAILED]");
        assert(reg_file[3] == 0x08 && "auipc.hex [FAILED]");
        assert(reg_file[4] == 0x100C && "auipc.hex [FAILED]");

        //////////////////// ENC_J///////////////////////
    } else if (test_case == "jal.hex") {
        assert(reg_file[31] == 0x00 && "jal.hex [FAILED]");
        assert(reg_file[30] == 0x0F && "jal.hex [FAILED]");
        assert(reg_file[29] == 0x0F && "jal.hex [FAILED]");
        assert(reg_file[28] == 0x0F && "jal.hex [FAILED]");
        assert(reg_file[1] == 0x14 && "jal.hex [FAILED]");
        assert(reg_file[2] == 0x20 && "jal.hex [FAILED]");

    } else {

        cout << "Tests for test case: '" << test_case << "':" << " [DOES NOT EXIST]" << endl;

        log_file.close(); // close log_file
        hex_file.close(); // close hex_file
        return;
    }

    cout << "Tests for test case: '" << test_case << "':" << " [PASSED]" << endl;

    log_file.close(); // close log_file
    hex_file.close(); // close hex_file

//    CO.isa.operationsCounter();
};


#endif //PROJECT_CORE_TEST_H