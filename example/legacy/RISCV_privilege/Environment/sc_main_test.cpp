//
// Created by lukadejanovic on 20.3.18..
//

#include <iostream>

//#define USE_ELF 1
// USE_ELF = 1 -> This configuration sets the acceptable input programs types to elf.
//                  Also, it will require the use of the memory module defined in ELFstyle subdirectory.
// USE_ELF = 0 -> This configuration sets the acceptable input programs types to hex.
//                  Also, it will require the use of the memory module defined in current directory.

#include "Core_test.h"


int sc_main(int argc, char *argv[]) {
    if (argc == 2) {
        Core_test *test_object = new Core_test(argc, argv);
        test_object->perform_test();
        return 0;
    } else {
        std::cout << "You must specify the elf file path as the first argument Terminating..." << endl;
        return 1;
    }
}