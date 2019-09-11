//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef PROJECT_OPTIONS_H
#define PROJECT_OPTIONS_H

#include <iostream>
#include <iostream>
#include <boost/program_options.hpp>
//#include "../Defines.h"

struct Options {
    typedef unsigned int addr_t;

    Options &check_and_post_process() {
        mem_end_addr = mem_start_addr + mem_size;
        return *this;
    }

    std::string input_program;

    addr_t mem_size           = 1024*1024*32;  // 32 MB ram, to place it before the CLINT and run the base examples (assume memory start at zero) without modifications
    addr_t mem_start_addr     = 0x00000000;
    addr_t mem_end_addr       = mem_start_addr + mem_size;
    addr_t clint_start_addr   = 0x02000000;
    addr_t clint_end_addr     = 0x0200ffff;
    addr_t term_start_addr    = 0x20000000;
    addr_t term_end_addr      = term_start_addr + 16;
    addr_t plic_start_addr    = 0x40000000;
    addr_t plic_end_addr      = 0x40001000;
    addr_t sensor_start_addr  = 0x50000000;
    addr_t sensor_end_addr    = 0x50001000;
    addr_t sensor2_start_addr = 0x50002000;
    addr_t sensor2_end_addr   = 0x50004000;
    addr_t dma_start_addr     = 0x70000000;
    addr_t dma_end_addr       = 0x70001000;

    bool use_debug_runner = false;
    bool use_instr_dmi = false;
    bool use_data_dmi = false;

    unsigned int tlm_global_quantum = 10;

    void show() {
        std::cout << "options {" << std::endl;
        std::cout << "  use instr dmi = " << use_instr_dmi << std::endl;
        std::cout << "  use data dmi = " << use_data_dmi << std::endl;
        std::cout << "  tlm global quantum = " << tlm_global_quantum << std::endl;
        std::cout << "}" << std::endl;
    }
};


Options parse_command_line_arguments(int argc, char **argv) {
    // Note: first check for *help* argument then run *notify*, see: https://stackoverflow.com/questions/5395503/required-and-optional-arguments-using-boost-library-program-options
    try {
        Options opt;

        namespace po = boost::program_options;

        po::options_description desc("Options");

        desc.add_options()
                ("help", "produce help message")
                ("memory-start", po::value<unsigned int>(&opt.mem_start_addr), "set memory start address")
                ("debug-mode", po::bool_switch(&opt.use_debug_runner), "start execution in debugger (using gdb rsp interface)")
                ("tlm-global-quantum", po::value<unsigned int>(&opt.tlm_global_quantum), "set global tlm quantum (in NS)")
                ("use-instr-dmi", po::bool_switch(&opt.use_instr_dmi), "use dmi to fetch instructions")
                ("use-data-dmi", po::bool_switch(&opt.use_data_dmi), "use dmi to execute load/store operations")
                ("use-dmi", po::bool_switch(), "use instr and data dmi")
                ("input-file", po::value<std::string>(&opt.input_program)->required(), "input file to use for execution")
                ;

        po::positional_options_description pos;
        pos.add("input-file", 1);

        po::variables_map vm;
        po::store(po::command_line_parser(argc, argv).options(desc).positional(pos).run(), vm);

        if (vm.count("help")) {
            std::cout << desc << std::endl;
            exit(0);
        }

        po::notify(vm);

        if (vm["use-dmi"].as<bool>()) {
            opt.use_data_dmi = true;
            opt.use_instr_dmi = true;
        }

        return opt.check_and_post_process();
    } catch (boost::program_options::error &e) {
        std::cerr << "Error parsing command line options: " << e.what() << std::endl;
        exit(-1);
    }
}


#endif //PROJECT_OPTIONS_H
