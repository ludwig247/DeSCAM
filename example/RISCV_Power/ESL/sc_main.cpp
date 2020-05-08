#include <iostream>
#include <fstream>
#include "systemc.h"
#include "Interfaces.h"
#include "ALU.h"
#include "Memory.h"
#include "regs.h"
#include "cpath.h"
#include "Decoder.h"
#include "Progam_tests.h"


using namespace std;


int sc_main(int, char **) {

    //string program = "fibonacci";
    //string program = "multiplication";
    //string program = "push_pop";
    //string program = "recursive_sum";
    //string program = "store";


    // File paths
    string log_file_path = "/import/lab/users/mehmedag/DeSCAM_Remote/DeSCAM/example/RISCV_Test_ELF/Instruction_Power_Tests/lowPower/whatever.lg";
    string hex_file_path = "/import/lab/users/mehmedag/DeSCAM_Remote/DeSCAM/example/RISCV_Test_ELF/Instruction_Power_Tests/lowPower/enc_i_i_low.hex";
    string assembly_file_path = "/import/lab/users/mehmedag/DeSCAM_Remote/DeSCAM/example/RISCV_Test_ELF/Instruction_Power_Tests/lowPower/enc_i_i_low.s";
    //string log_file_path = "../../Logfiles/" + program + ".lg";
    //string hex_file_path = "../../Programs/" + program + ".hex";
    //string assembly_file_path = "../../Programs/" + program + ".s";

    ofstream log_file;
    ifstream hex_file;
    ifstream assembly_file;

/*
#ifndef NDEBUG
    // redirect cout to log_file

    log_file.open(log_file_path, ofstream::out | ofstream::trunc);
    if (!log_file.is_open()) {
        cout << "Can't open the log  file! Terminating..." << endl;
        exit(0);
    }
    // save output buffer of cout
    streambuf *strm_buffer = cout.rdbuf();
    // redirect output into logfile
    cout.rdbuf(log_file.rdbuf());


    assembly_file.open(assembly_file_path);
    if (assembly_file.is_open()) {

        cout << "Assembly file:" << endl;
        cout << assembly_file.rdbuf();
        cout << endl;

    } else {
        cout << "Can't open the assembly file! Terminating..." << endl;
        exit(0);
    }
#endif
*/

    hex_file.open(hex_file_path);
    if (!hex_file.is_open()) {
        cout << "Can't open the hex file! Terminating..." << endl;
        exit(0);
    }


    // Component instantions
    Memory memory("memory", hex_file, log_file);
    ALU alu("alu");
    Decoder decoder("decoder");
    Regs regs("regs");
    Cpath cpath("ctl");

    // Channel instantiation
    Blocking<MemoryAccess> control_to_memory("control_to_memory");
    Blocking<unsigned int> memory_to_control("memory_to_control");

    MasterSlave<unsigned int> control_to_decoder("memory_to_decoder");
    MasterSlave<DecodedInstr> decoder_to_control("decoder_to_control");

    MasterSlave<CtlToRegs_IF> CtlToRegs_channel("CtlToRegs_channel");
    MasterSlave<RegsToCtl_IF> RegsToCtl_channel("RegsToCtl_channel");

    MasterSlave<ALUtoCtl_IF> ALUtoCtl_channel("ALUtoCtl_channel");
    MasterSlave<CtlToALU_IF> CtlToALU_channel("CtlToALU_channel");

    // Port binding:
    cpath.CtlToMem_port(control_to_memory);
    memory.CtlToMem_port(control_to_memory);
    memory.MemToCtl_port(memory_to_control);
    cpath.MemToCtl_port(memory_to_control);

    cpath.CtlToDec_port(control_to_decoder);
    decoder.CtlToDec_port(control_to_decoder);
    decoder.DecToCtl_port(decoder_to_control);
    cpath.DecToCtl_port(decoder_to_control);

    cpath.RegsToCtl_port(RegsToCtl_channel);
    regs.RegsToCtl_port(RegsToCtl_channel);
    cpath.CtlToRegs_port(CtlToRegs_channel);
    regs.CtlToRegs_port(CtlToRegs_channel);

    alu.CtlToALU_port(CtlToALU_channel);
    cpath.CtlToALU_port(CtlToALU_channel);
    alu.ALUtoCtl_port(ALUtoCtl_channel);
    cpath.ALUtoCtl_port(ALUtoCtl_channel);

/*
    // initial log
#ifndef NDEBUG
    cout << "Initial core state:" << endl;
    memory.log();
    regs.log();
#endif
*/

    // Start simulation.. simulation ends with sc_stop() call
    sc_start();

/*
    // final log and testing
#ifndef NDEBUG
    cout << endl << "Final core state:" << endl;
    memory.log();
    regs.log();

    // Create test object
    Program_tests test_object(program, memory.memory, regs.reg_file);
    // Execute tests
    test_object.test();
#endif
*/
    // close files
    log_file.close();
    hex_file.close();
    assembly_file.close();

    return 0;
} 	
