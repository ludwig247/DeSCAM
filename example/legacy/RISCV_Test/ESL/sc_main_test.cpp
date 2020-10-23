//
// Created by lukadejanovic on 20.3.18..
//

#include <iostream>
#include "Core_test.h"


int sc_main(int argc, char *argv[]) {

    /// argv[1] -> hex file path  >> extracting: argv[2] -> assembly file path  --  argv[3] -> log file path
    if (argc == 2) {

        string hex_file_path = argv[1];

        string assembly_file_path = hex_file_path.substr(0, hex_file_path.length() - 3) + 's';

        string file_name = hex_file_path.substr(hex_file_path.find_last_of('/') + 1, hex_file_path.find_last_of('.') - hex_file_path.find_last_of('/') - 1);

        string log_file_path = hex_file_path.substr(0, hex_file_path.find_last_of('/'));
               log_file_path = log_file_path.substr(0, log_file_path.find_last_of('/'));
               log_file_path = log_file_path + "/Logfiles/" + file_name + ".lg";

        Core_test *test_object = new Core_test(string(argv[1]), string(assembly_file_path), string(log_file_path));
        test_object->perform_test(); // Run regression tests
        return 0;

    } else {
        std::cout << "You must specify the hex file path as the first argument Terminating..." << endl;
        return 1;
    }
}