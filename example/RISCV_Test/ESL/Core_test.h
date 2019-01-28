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
//#include "../../RISCV_Pipelined/ESL/Core.h"
#include "../../RISCV/ESL/Core.h"
//#include "../../RISCV_ISA/ESL/Core.h"
//#include "../../RISCV_MS/ESL/Core.h"

// TLM = 1 -> using TLM bridge and TLM memory
// TLM = 0 -> SCAM interface only
#define TLM 0

class Core_test {
public:

    Core_test(string test_case_path, string assembly_file_path, string log_file_path) {
        this->test_case_path = test_case_path;
        this->assembly_file_path = assembly_file_path;
        this->log_file_path = log_file_path;
    }

    // perform test
    void perform_test();

private:
    string test_case_path;
    string assembly_file_path;
    string log_file_path;
};

void Core_test::perform_test() {

    ifstream hex_file;
    ifstream assembly_file;
    ofstream log_file;

    open_hex_file(test_case_path, hex_file);

    // extract file name from path
    string test_case = test_case_path.substr(test_case_path.find_last_of("/\\") + 1);

    cout << endl << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Running test for hex file: '" << test_case << "' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;

#ifdef LOGTOFILE
    open_log_file(log_file_path, log_file);

    string logfile_name = log_file_path.substr(log_file_path.find_last_of("/\\") + 1);
    std::cout << logfile_name << std::endl;

    cout << "Output redirected to log file: " << logfile_name << endl;

    streambuf *console_buffer =  cout.rdbuf(log_file.rdbuf());

    assembly_file.open(assembly_file_path);
    if (assembly_file.is_open()) {
        cout << "Assembly file:" << endl;
        cout << assembly_file.rdbuf();
        cout << endl;
    } else {
        cout << "Can't open the file " << assembly_file_path << endl;
        exit(0);
    }
#endif

#if TLM == 0

    // Component instantiations
    Core CO("CO");
    Memory ME("ME", &hex_file, &log_file);

    // Channel instantiation
    Blocking<CUtoME_IF> COtoME_channel("COtoME_channel");
    Blocking<MEtoCP_IF> MEtoCO_channel("MEtoCO_channel");

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
    Blocking<MEtoCP_IF> BRtoCO_channel("BRtoCO_channel");

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

        assert(reg_file[3] == is_neg && "multiplication.hex [FAILED]");   // is_neg
        assert(reg_file[5] == ans && "multiplication.hex [FAILED]");      // result

    } else if (test_case == "push_pop.hex") {
        // test for value = 1345 = 0x541
        int value = 0x541;
        int stack_pointer_init = 0x40;
        int stack_pointer_after_push = stack_pointer_init + 4;

        assert(reg_file[30] == stack_pointer_init && "push_pop.hex [FAILED]");   // stack_pointer

        assert(ME.mem[stack_pointer_after_push] == (value & 0xFF) && "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 1] == ((value >> 8) & 0xFF) && "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 2] == ((value >> 16) & 0xFF) &&
               "push_pop.hex [FAILED]");
        assert(ME.mem[stack_pointer_after_push + 3] == ((value >> 24) & 0xFF) &&
               "push_pop.hex [FAILED]");

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
        // manual values

        //addi $1,$0,128		 # address 0x80
        //addi $2,$0,156		 # address 0x9C
        int adr1 = 0x80;
        int adr2 = 0x9C;
        assert(reg_file[1] == adr1 && "store.hex [FAILED]");
        assert(reg_file[2] == adr2 && "store.hex [FAILED]");

        // lui   $20,5          # $20 = 5 << 12
        // auipc $21,0          # $21 = PC
        // auipc $22,100	    # $22 = PC + (100 >> 12)
        assert(reg_file[20] == 5 << 12 && "store.hex [FAILED]");
        assert(reg_file[21] == 12 && "store.hex [FAILED]");
        assert(reg_file[22] == 16 + (100 << 12) && "store.hex [FAILED]");

        // addi  $5,$0,352 	     # 0x160 imm
        // addi  $6,$0,55 		 # 0x37 imm
        // addi  $7,$0,1		 # 0x1 imm
        // addi  $8,$0,3		 # 0x3 imm
        assert(reg_file[5] == 352 && "store.hex[FAILED]");
        assert(reg_file[6] == 55 && "store.hex [FAILED]");
        assert(reg_file[7] == 1 && "store.hex [FAILED]");
        assert(reg_file[8] == 3 && "store.hex [FAILED]");

        // addi  $9,$0,-1		 # 0xFFFFFFFF imm
        // addi  $10,$0,129	     # 0x81 imm
        // addi  $11,$0,-100	 # 0xFFFFFF9C imm
        assert(reg_file[9] == -1 && "store.hex [FAILED]");
        assert(reg_file[10] == 129 && "store.hex [FAILED]");
        assert(reg_file[11] == -100 && "store.hex [FAILED]");

        // sw    $1,$5,0  		 # mem[0x80] = 0x160
        // sh    $1,$6,4		 # mem[0x84] = 0x37
        // sb    $1,$7,6 		 # mem[0x86] = 0x1
        // sb    $1,$8,0 		 # mem[0x80] = 0x3
        assert(ME.mem[adr1 + 0] == 0x03 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 1] == 0x01 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 2] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 3] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 4] == 0x37 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 5] == 0x00 && "store.hex [FAILED]");
        assert(ME.mem[adr1 + 6] == 0x01 && "store.hex [FAILED]");

        // sw    $2,$9,0		 # mem[0x9C] = 0xFFFFFFFF
        // sw    $2,$10,4		 # mem[0xA0] = 0x81
        // sh    $2,$11,8 		 # mem[0xA4] = 0xFF9C
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

        // lw    $31,$2,0     	 # R31 = mem[0x9C] = 0xFFFFFFFF
        // lh    $30,$2,0     	 # R30 = mem[0x9C] = 0xFFFFFFFF
        // lhu   $29,$2,0     	 # R29 = mem[0x9C] = 0x0000FFFF
        // lb    $28,$2,0     	 # R28 = mem[0x9C] = 0xFFFFFFFF
        // lbu   $27,$2,0     	 # R27 = mem[0x9C] = 0x000000FF
        assert(reg_file[31] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[29] == 0x0000FFFF && "store.hex [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFF && "store.hex [FAILED]");
        assert(reg_file[27] == 0x000000FF && "store.hex [FAILED]");

        // lb    $26,$2,4     	 # R26 = mem[0xA0] = 0xFFFFFF81
        // lbu   $25,$2,4     	 # R25 = mem[0xA0] = 0x00000081
        assert(reg_file[26] == 0xFFFFFF81 && "store.hex [FAILED]");
        assert(reg_file[25] == 0x00000081 && "store.hex [FAILED]");

    } else if (test_case == "testing.hex") {

        int adr1 = 0x100;

        //addi  $5,$0,256			 	# $5 = address 0x100
        //addi  $6,$0,44	 			# $6 = 0x2C
        //sw    $5,$6,0  			 	# mem[0x100] = 0x2C
        assert(reg_file[5] == 0x100 && "testing");
        assert(reg_file[6] == 0x2C && "testing");
        assert(ME.mem[adr1 + 0] == 0x2C && "testing");
        assert(ME.mem[adr1 + 1] == 0x00 && "testing");
        assert(ME.mem[adr1 + 2] == 0x00 && "testing");
        assert(ME.mem[adr1 + 3] == 0x00 && "testing");

        //addi  $1,$0,1		    	 	# $1 = 0x01
        //add   $2,$1,$1	 		 	# $2 = 0x02
        //add   $3,$2,$2   	     	 	# $3 = 0x04							            # 01  	# EX1_1  # EX2_2
        //addi  $4,$3,0		    		# $4 = 0x04							            # 02  	# EX1_1
        //sub   $7,$5,$4	    		# $7 = 0xFC
        //lw    $8,$7,4		    		# $8 = 0x2C						            	# 03	# EX1_1
        //add   $9,$8,$4     	 		# $9 = 0x30
        assert(reg_file[1] == 0x01 && "testing");
        assert(reg_file[2] == 0x02 && "testing");
        assert(reg_file[3] == 0x04 && "testing");
        assert(reg_file[4] == 0x04 && "testing");
        assert(reg_file[7] == 0xFC && "testing");
        assert(reg_file[8] == 0x2C && "testing");
        assert(reg_file[9] == 0x30 && "testing");

        //addi  $10,$5,8			 	# $10 = 0x108
        //sub   $11,$10,$4	        	# $11 = 0x104
        //sw    $11,$11,0				# mem[0x104] = 0x104       			            # 05	# EX1_1  # MEM_1
        //add   $12,$11,$4	            # $12 = 0x108	                # 02 # STALL_1	# 06    # ID1_1  # ID2_1
        assert(reg_file[10] == 0x108 && "testing");
        assert(reg_file[11] == 0x104 && "testing");
        assert(ME.mem[adr1 + 4] == 0x04 && "testing");
        assert(ME.mem[adr1 + 5] == 0x01 && "testing");
        assert(ME.mem[adr1 + 6] == 0x00 && "testing");
        assert(ME.mem[adr1 + 7] == 0x00 && "testing");
        assert(reg_file[12] == 0x108 && "testing");

        //lw    $13,$5,0				# $13 = 0x2C
        //add   $14,$13,$13	    		# $14 = 0x58 (0x2C + 0x2C)		# 05 # STALL_3	# 13	# EX1_2  # EX2_2
        //lw    $15,$5,0				# $15 = 0x2C
        //addi  $16,$15,60	    		# $16 = 0x68				    # 06 # STALL_4	# 14	# EX1_2
        //sw    $11,$16,4				# mem[0x108] = 0x68
        //lw    $17,$11,0				# $17 = mem[0x104] = 0x104
        //lw    $17,$17,4				# $17 = mem[0x108] = 0x68		# 07 # STALL_4	# 15	# EX1_2
        assert(reg_file[13] == 0x2C && "testing");
        assert(reg_file[14] == 0x58 && "testing");
        assert(reg_file[15] == 0x2C && "testing");
        assert(reg_file[16] == 0x68 && "testing");
        assert(ME.mem[adr1 + 8] == 0x68 && "testing");
        assert(ME.mem[adr1 + 9] == 0x00 && "testing");
        assert(ME.mem[adr1 + 10] == 0x00 && "testing");
        assert(ME.mem[adr1 + 11] == 0x00 && "testing");
        assert(reg_file[17] == 0x68 && "testing");

        //lw    $18,$11,0	    		# $18 = mem[0x104] = 0x104
        //sw    $18,$18,8				# mem[0x10C] = 0x104			# 09 # STALL_5	# 17	# ID1_4  # ID2_4
        //lw    $18,$11,4				# $18 = mem[0x108] = 0x68
        //sw    $11,$18,12	    		# mem[0x110] = 0x68			  	 	        	#*17	         #*MEM_2
        //lw    $18,$11,0				# $18 = mem[0x104] = 0x104
        assert(reg_file[18] == 0x104 && "testing");
        assert(ME.mem[adr1 + 12] == 0x04 && "testing");
        assert(ME.mem[adr1 + 13] == 0x01 && "testing");
        assert(ME.mem[adr1 + 14] == 0x00 && "testing");
        assert(ME.mem[adr1 + 15] == 0x00 && "testing");
        assert(ME.mem[adr1 + 16] == 0x68 && "testing");
        assert(ME.mem[adr1 + 17] == 0x00 && "testing");
        assert(ME.mem[adr1 + 18] == 0x00 && "testing");
        assert(ME.mem[adr1 + 19] == 0x00 && "testing");

        //jal   $19,R		    		# $19 = 0x84
        assert(reg_file[19] == 0x84 && "testing");

        //add   $20,$19,$19	    		# $20 = 0x108 (0x84 + 0x84)		    			# 31	# ID1_3  # ID2_3
        //jal   $21,I_I		    		# $21 = 0x8C
        assert(reg_file[20] == 0x108 && "testing");
        assert(reg_file[21] == 0x8C && "testing");

        //addi  $22,$21,0				# $22 = 0x8C						        	# 32	# ID1_3
        //jal   $23,S		    		# $23 = 0x94
        assert(reg_file[22] == 0x8C && "testing");
        assert(reg_file[23] == 0x94 && "testing");

        //sw    $23,$23,128	    		# mem[114] = 0x94						        # 35	# ID1_3  # ID2_3
        //jal   $24,I_L		    		# $24 = 0x9C
        assert(ME.mem[adr1 + 20] == 0x94 && "testing");
        assert(ME.mem[adr1 + 21] == 0x00 && "testing");
        assert(ME.mem[adr1 + 22] == 0x00 && "testing");
        assert(ME.mem[adr1 + 23] == 0x00 && "testing");
        assert(reg_file[24] == 0x9C && "testing");

        //lw    $25,$24,120	    		# $25 = 0x94							        # 34	# ID1_3
        //jal   $26,B		    		# $26 = 0xA4
        assert(reg_file[25] == 0x94 && "testing");
        assert(reg_file[26] == 0xA4 && "testing");

        //jal   $27,I_J		       		# $27 = 0xAC
        assert(reg_file[27] == 0xAC && "testing");

        //addi  $28,$27,16	    		# $28 = 0xBC
        //jalr  $0,$28,0
        //addi  $29,$28,8		    	# $29 = 0xC4
        //jalr  $30,$29,0			 	# $30 = 0xC4
        //add   $30,$30,$30	    	 	# $30 = 0x188 (0xC4 + 0xC4)
        assert(reg_file[28] == 0xBC && "testing");
        assert(reg_file[29] == 0xC4 && "testing");
        assert(reg_file[30] == 0x188 && "testing");

        //auipc $31,0		           	# $31 = 0xC8
        assert(reg_file[31] == 0xC8 && "testing");

    } else if (test_case == "addi.hex") { // reg-imm start
        assert(reg_file[1] == 128 && "addi.hex [FAILED]");
        assert(reg_file[2] == 128 && "addi.hex [FAILED]");
        assert(reg_file[3] == 138 && "addi.hex [FAILED]");
        assert(reg_file[4] == 118 && "addi.hex [FAILED]");

        assert(reg_file[5] == -128 && "addi.hex [FAILED]");
        assert(reg_file[6] == -128 && "addi.hex [FAILED]");
        assert(reg_file[7] == -118 && "addi.hex [FAILED]");
        assert(reg_file[8] == -138 && "addi.hex [FAILED]");
    } else if (test_case == "andi.hex") {
        assert(reg_file[3] == 0x1 && "andi.hex [FAILED]");
        assert(reg_file[4] == 0x7 && "andi.hex [FAILED]");
        assert(reg_file[5] == 0x0 && "andi.hex [FAILED]");
        assert(reg_file[6] == 0x8 && "andi.hex [FAILED]");
    } else if (test_case == "ori.hex") {
        assert(reg_file[1] == 0x7 && "ori.hex [FAILED]");
        assert(reg_file[2] == 0xF && "ori.hex [FAILED]");
        assert(reg_file[3] == 0xF && "ori.hex [FAILED]");
        assert(reg_file[4] == 0xFFFFFFFF && "ori.hex [FAILED]");
    } else if (test_case == "xori.hex") {
        assert(reg_file[2] == 0x0 && "xori.hex [FAILED]");
        assert(reg_file[3] == 0x3 && "xori.hex [FAILED]");
        assert(reg_file[4] == 0xFFFFFFF8 && "xori.hex [FAILED]");
        assert(reg_file[5] == 0xFFFFFFF8 && "xori.hex [FAILED]");
    } else if (test_case == "slli.hex") {
        assert(reg_file[2] == 0x10 && "slli.hex [FAILED]");
        assert(reg_file[3] == 0x40 && "slli.hex [FAILED]");
        assert(reg_file[4] == 0x40 && "slli.hex [FAILED]");
    } else if (test_case == "srli.hex") {
        assert(reg_file[2] == 0x20 && "srli.hex [FAILED]");
        assert(reg_file[3] == 0x02 && "srli.hex [FAILED]");
        assert(reg_file[4] == 0x0 && "srli.hex [FAILED]");
        assert(reg_file[5] == 0x40 && "srli.hex [FAILED]");
    } else if (test_case == "srai.hex") {
        assert(reg_file[3] == 0x20 && "srai.hex [FAILED]");
        assert(reg_file[4] == 0x1 && "srai.hex [FAILED]");
        assert(reg_file[5] == 0xFFFFFFEF && "srai.hex [FAILED]");
        assert(reg_file[6] == 0xFFFFFFFF && "srai.hex [FAILED]");
    } else if (test_case == "lui.hex") {
        assert(reg_file[1] == 0x5000 && "lui.hex [FAILED]");
        assert(reg_file[2] == 0x1F000 && "lui.hex [FAILED]");
        assert(reg_file[3] == 0xFFFFF000 && "lui.hex [FAILED]");
        assert(reg_file[4] == 0x0 && "lui.hex [FAILED]");
    } else if (test_case == "auipc.hex") {
        assert(reg_file[1] == 0x0 && "auipc.hex [FAILED]");
        assert(reg_file[2] == 0x8004 && "auipc.hex [FAILED]");
        assert(reg_file[3] == 0x8 && "auipc.hex [FAILED]");
        assert(reg_file[4] == 0x100C && "auipc.hex [FAILED]");
    } else if (test_case == "slti.hex") {
        assert(reg_file[3] == 1 && "slti.hex [FAILED]");
        assert(reg_file[4] == 0 && "slti.hex [FAILED]");
        assert(reg_file[5] == 0 && "slti.hex [FAILED]");
        assert(reg_file[6] == 1 && "slti.hex [FAILED]");
        assert(reg_file[7] == 1 && "slti.hex [FAILED]");
        assert(reg_file[8] == 1 && "slti.hex [FAILED]");
        assert(reg_file[9] == 0 && "slti.hex [FAILED]");
        assert(reg_file[10] == 0 && "slti.hex [FAILED]");
    } else if (test_case == "sltiu.hex") {
        assert(reg_file[3] == 1 && "sltiu.hex [FAILED]");
        assert(reg_file[4] == 0 && "sltiu.hex [FAILED]");
        assert(reg_file[5] == 1 && "sltiu.hex [FAILED]");
        assert(reg_file[6] == 1 && "sltiu.hex [FAILED]");
        assert(reg_file[7] == 0 && "sltiu.hex [FAILED]");
        assert(reg_file[8] == 0 && "sltiu.hex [FAILED]");
        assert(reg_file[9] == 0 && "sltiu.hex [FAILED]");
        assert(reg_file[10] == 0 && "sltiu.hex [FAILED]");
    } else if (test_case == "add.hex") {  // reg-reg start
        assert(reg_file[5] == 138 && "add.hex [FAILED]");
        assert(reg_file[6] == 118 && "add.hex [FAILED]");
        assert(reg_file[7] == 128 && "add.hex [FAILED]");
        assert(reg_file[8] == 128 && "add.hex [FAILED]");
        assert(reg_file[9] == 256 && "add.hex [FAILED]");

        assert(reg_file[10] == -118 && "add.hex [FAILED]");
        assert(reg_file[11] == -138 && "add.hex [FAILED]");
        assert(reg_file[12] == -128 && "add.hex [FAILED]");
        assert(reg_file[13] == -128 && "add.hex [FAILED]");
        assert(reg_file[14] == -256 && "add.hex [FAILED]");
    } else if (test_case == "sub.hex") {
        assert(reg_file[5] == 118 && "sub.hex [FAILED]");
        assert(reg_file[6] == 138 && "sub.hex [FAILED]");
        assert(reg_file[7] == 128 && "sub.hex [FAILED]");
        assert(reg_file[8] == -128 && "sub.hex [FAILED]");
        assert(reg_file[9] == 0 && "sub.hex [FAILED]");

        assert(reg_file[10] == -138 && "sub.hex [FAILED]");
        assert(reg_file[11] == -118 && "sub.hex [FAILED]");
        assert(reg_file[12] == -128 && "sub.hex [FAILED]");
        assert(reg_file[13] == 128 && "sub.hex [FAILED]");
        assert(reg_file[14] == 0 && "sub.hex [FAILED]");
    } else if (test_case == "and.hex") {
        assert(reg_file[1] == 0x7 && "and.hex [FAILED]");
        assert(reg_file[5] == 0x1 && "and.hex [FAILED]");
        assert(reg_file[6] == 0x7 && "and.hex [FAILED]");
        assert(reg_file[7] == 0x7 && "and.hex [FAILED]");
        assert(reg_file[8] == 0x0 && "and.hex [FAILED]");
        assert(reg_file[9] == 0x8 && "and.hex [FAILED]");
        assert(reg_file[10] == 0x0 && "and.hex [FAILED]");
        assert(reg_file[11] == 0x0 && "and.hex [FAILED]");
    } else if (test_case == "or.hex") {
        assert(reg_file[1] == 0x7 && "or.hex [FAILED]");
        assert(reg_file[5] == 0x7 && "or.hex [FAILED]");
        assert(reg_file[6] == 0xF && "or.hex [FAILED]");
        assert(reg_file[7] == 0x7 && "or.hex [FAILED]");
        assert(reg_file[8] == 0xF && "or.hex [FAILED]");
        assert(reg_file[9] == 0xF && "or.hex [FAILED]");
        assert(reg_file[10] == 0x1 && "or.hex [FAILED]");
        assert(reg_file[11] == 0x1 && "or.hex [FAILED]");
    } else if (test_case == "xor.hex") {
        assert(reg_file[4] == 0x0 && "xor.hex [FAILED]");
        assert(reg_file[5] == 0x3 && "xor.hex [FAILED]");
        assert(reg_file[6] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[7] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[8] == 0xFFFFFFF8 && "xor.hex [FAILED]");
        assert(reg_file[9] == 0x0 && "xor.hex [FAILED]");
    } else if (test_case == "sll.hex") {
        assert(reg_file[4] == 0x10 && "sll.hex [FAILED]");
        assert(reg_file[5] == 0x40 && "sll.hex [FAILED]");
        assert(reg_file[6] == 0x40 && "sll.hex [FAILED]");
        assert(reg_file[7] == 0x0 && "sll.hex [FAILED]");
    } else if (test_case == "srl.hex") {
        assert(reg_file[5] == 0x20 && "srl.hex [FAILED]");
        assert(reg_file[6] == 0x02 && "srl.hex [FAILED]");
        assert(reg_file[7] == 0x0 && "srl.hex [FAILED]");
        assert(reg_file[8] == 0x40 && "srl.hex [FAILED]");
        assert(reg_file[9] == 0x0 && "srl.hex [FAILED]");
    } else if (test_case == "sra.hex") {
        assert(reg_file[7] == 0x20 && "sra.hex [FAILED]");
        assert(reg_file[8] == 0x1 && "sra.hex [FAILED]");
        assert(reg_file[9] == 0x1 && "sra.hex [FAILED]");
        assert(reg_file[10] == 0x0 && "sra.hex [FAILED]");

        assert(reg_file[11] == 0xFFFFFFEF && "sra.hex [FAILED]");
        assert(reg_file[12] == 0xFFFFFFFF && "sra.hex [FAILED]");
        assert(reg_file[13] == 0xFFFFFFFF && "sra.hex [FAILED]");
        assert(reg_file[14] == 0x0 && "sra.hex [FAILED]");
    } else if (test_case == "slt.hex") {
        assert(reg_file[3] == 1 && "slt.hex [FAILED]");
        assert(reg_file[4] == 0 && "slt.hex [FAILED]");
        assert(reg_file[5] == 0 && "slt.hex [FAILED]");
        assert(reg_file[6] == 1 && "slt.hex [FAILED]");
        assert(reg_file[7] == 1 && "slt.hex [FAILED]");
        assert(reg_file[8] == 1 && "slt.hex [FAILED]");
        assert(reg_file[9] == 0 && "slt.hex [FAILED]");
        assert(reg_file[10] == 0 && "slt.hex [FAILED]");
    } else if (test_case == "sltu.hex") {
        assert(reg_file[3] == 1 && "sltu.hex [FAILED]");
        assert(reg_file[4] == 0 && "sltu.hex [FAILED]");
        assert(reg_file[5] == 1 && "sltu.hex [FAILED]");
        assert(reg_file[6] == 1 && "sltu.hex [FAILED]");
        assert(reg_file[7] == 0 && "sltu.hex [FAILED]");
        assert(reg_file[8] == 0 && "sltu.hex [FAILED]");
        assert(reg_file[9] == 0 && "sltu.hex [FAILED]");
        assert(reg_file[10] == 0 && "sltu.hex [FAILED]");
    } else if (test_case == "jal.hex") {   // control start
        assert(reg_file[31] == 0x0 && "jal.hex [FAILED]");
        assert(reg_file[30] == 0xF && "jal.hex [FAILED]");
        assert(reg_file[29] == 0xF && "jal.hex [FAILED]");
        assert(reg_file[28] == 0xF && "jal.hex [FAILED]");

        assert(reg_file[1] == 16 && "jal.hex [FAILED]");
        assert(reg_file[2] == 28 && "jal.hex [FAILED]");
    } else if (test_case == "jalr.hex") {
        assert(reg_file[31] == 0x0 && "jalr.hex [FAILED]");
        assert(reg_file[30] == 0xF && "jalr.hex [FAILED]");
        assert(reg_file[29] == 0xF && "jalr.hex [FAILED]");

        assert(reg_file[1] == 16 && "jalr.hex [FAILED]");
        assert(reg_file[2] == 56 && "jalr.hex [FAILED]");
    } else if (test_case == "beq.hex") {
        assert(reg_file[31] == 0x0 && "beq.hex [FAILED]");
        assert(reg_file[30] == 0xF && "beq.hex [FAILED]");
        assert(reg_file[29] == 0xF && "beq.hex [FAILED]");
    } else if (test_case == "bne.hex") {
        assert(reg_file[31] == 0xF && "bne.hex [FAILED]");
        assert(reg_file[30] == 0x0 && "bne.hex [FAILED]");
        assert(reg_file[29] == 0xF && "bne.hex [FAILED]");
    } else if (test_case == "blt.hex") {
        assert(reg_file[31] == 0x0 && "blt.hex [FAILED]");
        assert(reg_file[30] == 0xF && "blt.hex [FAILED]");
        assert(reg_file[29] == 0x0 && "blt.hex [FAILED]");
    } else if (test_case == "bge.hex") {
        assert(reg_file[31] == 0x0 && "bge.hex [FAILED]");
        assert(reg_file[30] == 0xF && "bge.hex [FAILED]");
        assert(reg_file[29] == 0x0 && "bge.hex [FAILED]");
        assert(reg_file[28] == 0xF && "bge.hex [FAILED]");
    } else if (test_case == "bltu.hex") {
        assert(reg_file[31] == 0x0 && "bltu.hex [FAILED]");
        assert(reg_file[30] == 0xF && "bltu.hex [FAILED]");
        assert(reg_file[29] == 0xF && "bltu.hex [FAILED]");
        assert(reg_file[28] == 0x0 && "bltu.hex [FAILED]");
    } else if (test_case == "bgeu.hex") {
        assert(reg_file[31] == 0xF && "bgeu.hex [FAILED]");
        assert(reg_file[30] == 0x0 && "bgeu.hex [FAILED]");
        assert(reg_file[29] == 0xF && "bgeu.hex [FAILED]");
        assert(reg_file[28] == 0xF && "bgeu.hex [FAILED]");
    } else if (test_case == "sb.hex") {   // stores
        assert(ME.mem[0x80] == 0x60 && "sb.hex [FAILED]");
        assert(ME.mem[0x81] == 0x37 && "sb.hex [FAILED]");
        assert(ME.mem[0x86] == 0x1 && "sb.hex [FAILED]");
        assert(ME.mem[0x9C] == 0xF3 && "sb.hex [FAILED]");
        assert(ME.mem[0x9B] == 0xF3 && "sb.hex [FAILED]");
    } else if (test_case == "sh.hex") {
        assert(ME.mem[0x80] == 0x60 && "sh.hex [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sh.hex [FAILED]");
        assert(ME.mem[0x7E] == 0xF3 && "sh.hex [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sh.hex [FAILED]");

        assert(ME.mem[0x9C] == 0x1 && "sh.hex [FAILED]");
        assert(ME.mem[0x9D] == 0x0 && "sh.hex [FAILED]");
        assert(ME.mem[0x9E] == 0x37 && "sh.hex [FAILED]");
        assert(ME.mem[0x9F] == 0x0 && "sh.hex [FAILED]");
    } else if (test_case == "sw.hex") {
        assert(ME.mem[0x80] == 0x60 && "sw.hex [FAILED]");
        assert(ME.mem[0x81] == 0x01 && "sw.hex [FAILED]");
        assert(ME.mem[0x82] == 0x0 && "sw.hex [FAILED]");
        assert(ME.mem[0x83] == 0x0 && "sw.hex [FAILED]");

        assert(ME.mem[0x7C] == 0xF3 && "sw.hex [FAILED]");
        assert(ME.mem[0x7D] == 0xFF && "sw.hex [FAILED]");
        assert(ME.mem[0x7E] == 0xFF && "sw.hex [FAILED]");
        assert(ME.mem[0x7F] == 0xFF && "sw.hex [FAILED]");

        assert(ME.mem[0x84] == 0x01 && "sw.hex [FAILED]");
        assert(ME.mem[0x85] == 0x0 && "sw.hex [FAILED]");
        assert(ME.mem[0x86] == 0x0 && "sw.hex [FAILED]");
        assert(ME.mem[0x87] == 0x0 && "sw.hex [FAILED]");
    } else if (test_case == "lb.hex") {   // loads
        assert(reg_file[31] == 0x00000001 && "lb.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFFFF && "lb.hex [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lb.hex [FAILED]");
        assert(reg_file[28] == 0xFFFFFFFC && "lb.hex [FAILED]");
    } else if (test_case == "lbu.hex") {
        assert(reg_file[31] == 0x00000001 && "lbu.hex [FAILED]");
        assert(reg_file[30] == 0x000000FF && "lbu.hex [FAILED]");
        assert(reg_file[29] == 0x00000004 && "lbu.hex [FAILED]");
        assert(reg_file[28] == 0x000000FC && "lbu.hex [FAILED]");
    } else if (test_case == "lh.hex") {
        assert(reg_file[31] == 0x00000201 && "lh.hex [FAILED]");
        assert(reg_file[30] == 0xFFFFFEFF && "lh.hex [FAILED]");
        assert(reg_file[29] == 0xFFFFFF04 && "lh.hex [FAILED]");
    } else if (test_case == "lhu.hex") {
        assert(reg_file[31] == 0x00000201 && "lhu.hex [FAILED]");
        assert(reg_file[30] == 0x0000FEFF && "lhu.hex [FAILED]");
        assert(reg_file[29] == 0x0000FF04 && "lhu.hex [FAILED]");
    } else if (test_case == "lw.hex") {
        assert(reg_file[31] == 0x04030201 && "lw.hex [FAILED]");
        assert(reg_file[30] == 0xFCFDFEFF && "lw.hex [FAILED]");
        assert(reg_file[29] == 0xFEFF0403 && "lw.hex [FAILED]");
    } else if (test_case == "JB.hex") {
        assert(reg_file[01] == 0x18 && "jb.hex [FAILED]");
        assert(reg_file[02] == 0x20 && "jb.hex [FAILED]");
        assert(reg_file[03] == 0x18 && "jb.hex [FAILED]");
        assert(reg_file[04] == 0x00 && "jb.hex [FAILED]");
        assert(reg_file[05] == 0x00 && "jb.hex [FAILED]");
        assert(reg_file[06] == 0x180 && "jb.hex [FAILED]");
        assert(reg_file[07] == 0x00 && "jb.hex [FAILED]");
        assert(reg_file[8] == 0x00 && "jb.hex [FAILED]");
        assert(reg_file[9] == 0x2C && "jb.hex [FAILED]");
        assert(reg_file[10] == 0x44 && "jb.hex [FAILED]");
        assert(reg_file[11] == 0x88 && "jb.hex [FAILED]");
        assert(ME.mem[0x180] == 0x18 && "jb.hex [FAILED]");
        assert(reg_file[14] == 0x00 && "jb.hex [FAILED]");
        assert(ME.mem[0x184] == 0x20 && "jb.hex [FAILED]");
        assert(reg_file[12] == 0xAC && "jb.hex [FAILED]");
        assert(ME.mem[0x188] == 0x88 && "jb.hex [FAILED]");
        assert(reg_file[17] == 0x11 && "jb.hex [FAILED]");
        assert(reg_file[18] == 0x00 && "jb.hex [FAILED]");
        assert(reg_file[19] == 0x00 && "jb.hex [FAILED]");
        assert(ME.mem[0x18C] == 0x44 && "jb.hex [FAILED]");
        assert(reg_file[13] == 0xD4 && "jb.hex [FAILED]");
        assert(ME.mem[0x190] == 0x44 && "jb.hex [FAILED]");
        assert(reg_file[20] == 0x38 && "jb.hex [FAILED]");
        assert(reg_file[21] == 0x70 && "jb.hex [FAILED]");
        assert(reg_file[22] == 0xE4 && "jb.hex [FAILED]");
        assert(reg_file[25] == 0xA8 && "jb.hex [FAILED]");
        assert(ME.mem[0x194] == 0x44 && "jb.hex [FAILED]");
        assert(reg_file[26] == 0xFC && "jb.hex [FAILED]");
        assert(reg_file[27] == 0x150 && "jb.hex [FAILED]");
        assert(ME.mem[0x198] == 0x44 && "jb.hex [FAILED]");
        assert(reg_file[28] == 0x154 && "jb.hex [FAILED]");
        assert(reg_file[29] == 0x118 && "jb.hex [FAILED]");
        assert(reg_file[30] == 0x230 && "jb.hex [FAILED]");
    } else {

        cout << "Tests for test case: '" << test_case << "':" << " [DOES NOT EXIST]" << endl;
        // close files
        log_file.close();
        hex_file.close();
        return;
    }

    cout << "Tests for test case: '" << test_case << "':" << " [PASSED]" << endl;

    // close files
    log_file.close();
    hex_file.close();
};

#endif //PROJECT_CORE_TEST_H