//
// Created by lukadejanovic on 20.3.18..
//

#include <iostream>
#include "Core_test.h"


int sc_main(int argc, char *argv[]) {
    // argv[1] -> hex file path
    // argv[2] -> assembly file path
    // argv[3] -> log file path

    // Run regression tests
    if (argc == 2) {

        string a = argv[1];

        string b = a.substr(0, a.length() - 3);
        b = b + "S";

        size_t f1 = a.find_last_of("/");
        string c1 = a.substr(f1, a.length());
        c1 = c1.substr(1, c1.length() - 5);

        string t =  a.substr(0, f1);
        size_t f2 = t.find_last_of("/");
        t = t.substr(0, f2);
        t = t + "/Logfiles/" + c1 + ".lg";

        Core_test *test_object = new Core_test(string(argv[1]), string(b), string(t));
        test_object->perform_test();
        return 0;
    } else {
        std::cout << "You must specify the hex file path as the first argument Terminating..." << endl;
        return 1;
    }
}