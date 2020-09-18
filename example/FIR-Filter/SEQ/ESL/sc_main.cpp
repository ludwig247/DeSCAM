//
// Created by Tobias Jauch on 15.07.2020
//

#include "../../../Interfaces/Blocking.h"
#include "systemc.h"
#include "DataTypes.h"

//Data Path Algorithm File
#include "FIR-Filter.h"

//Testbench
#include "Testbench.h"


using namespace std;

int sc_main(int argc, char* argv[]) {

    FIR FIR("BubbleSort");
    Testbench testbench("Testbench");

    Blocking<int>data_out("data_out");
    testbench.data_in(data_out);
    FIR.data_out(data_out);

    Blocking<int>data_in("data_in");
    testbench.data_out(data_in);
    FIR.data_in(data_in);
    

    sc_start();

    return 0;
}

