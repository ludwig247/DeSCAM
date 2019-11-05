//


#ifndef PROJECT_CORE_TEST_H
#define PROJECT_CORE_TEST_H


#include <tlm.h>
#include <iostream>
#include "assert.h"
#include "systemc.h"
#include "Interfaces.h"
#include "../ESL/Full/Core.h"
#include "memory.h"
#include "Memory_Interfaces.h"
#include "dtb_rom.h"
#include "mem_if.h"



#include "options.h"
#include "elf_loader.h"

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
    string test_case = opt.input_program;
    size_t f1 = test_case.find_last_of("/");
    test_case = test_case.substr(f1 + 1, test_case.length());

    std::cout << endl << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Running test for elf file: '" << test_case << "' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" << endl;

    // Component instantiations
    Core CO("CO");
    Mif mif("mif"); //memory interface is a simplification to avoid needing extra outputs from core for ROM
                    //Should be interfaced directly in this module in future implementation to avoid delay.
//    G_Core CO("CO");
    Memory ME("ME", opt.mem_size);
    Dtb dtb("dtb", opt.dtb_rom_size);  
loader.load_executable_image(ME.mem, ME.size, opt.mem_start_addr);
    


    CO.PCREG = loader.get_entrypoint();
    CO.REGFILE(02) = loader.get_memory_end() - 4; // stack pointer
    // Channel instantiation
    Blocking<CUtoME_IF> COtoIF_channel("COtoIF_channel");
    Blocking<MEtoCU_IF> IFtoCO_channel("IFtoCO_channel");

    Blocking<CUtoME_IF> IFtoME_channel("IFtoME_channel");
    Blocking<MEtoCU_IF> MEtoIF_channel("MEtoIF_channel");

    Blocking<CUtoME_IF> IFtoDTB_channel("IFtoDTB_channel");
    Blocking<MEtoCU_IF> DTBtoIF_channel("DTBtoIF_channel");



  //   Port binding:
    CO.COtoME_port(COtoIF_channel);
    mif.COtoIF_port(COtoIF_channel);
    CO.MEtoCO_port(IFtoCO_channel);
    mif.IFtoCO_port(IFtoCO_channel);

    ME.MEtoCO_port(MEtoIF_channel);
    mif.MEtoIF_port(MEtoIF_channel);
    ME.COtoME_port(IFtoME_channel);
    mif.IFtoME_port(IFtoME_channel);

    dtb.MEtoCO_port(DTBtoIF_channel);
    mif.DTBtoIF_port(DTBtoIF_channel);
    dtb.COtoME_port(IFtoDTB_channel);
    mif.IFtoDTB_port(IFtoDTB_channel);
dtb.load_binary_file("/import/lab/users/ovsthus/SCAM/example/RISCV_privilege/Environment/devicetree.dtb", 0);

    // Start simulation.. simulation ends with sc_stop() call
    sc_start();

 }


#endif //PROJECT_CORE_TEST_H
