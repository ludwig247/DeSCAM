#include "../../../Interfaces/Blocking.h"
#include "systemc.h"

//Data Path Algorithm File
#include "FFT.h"

//Testbench
#include "Testbench.h"


using namespace std;

int sc_main(int argc, char* argv[]) {

    FFT FFT("BubbleSort");
    Testbench testbench("Testbench");

    Blocking<double[ARRAY_DIM][ARRAY_SIZE]> unsorted_data("unsorted_data");
    testbench.data_out(unsorted_data);
    FFT.data_in(unsorted_data);

    Blocking<double[ARRAY_DIM][ARRAY_SIZE]> sorted_data("sorted_data");
    testbench.data_in(sorted_data);
    FFT.data_out(sorted_data);

    sc_start();

    return 0;
}

