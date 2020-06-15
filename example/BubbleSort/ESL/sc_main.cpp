#include "../../Interfaces/Blocking.h"
#include "systemc.h"

//Data Path Algorithm File
//#include "BubbleSort_original.h"
//#include "BubbleSort_Step-1.h"
#include "BubbleSort_Step-2_ternary.h"

//Testbench
#include "Testbench.h"


using namespace std;

int sc_main(int argc, char* argv[]) {

    BubbleSort bubbleSort("BubbleSort");
    Testbench testbench("Testbench");

    Blocking<int[ARRAY_SIZE]> unsorted_data("unsorted_data");
    testbench.data_out(unsorted_data);
    bubbleSort.data_in(unsorted_data);

    Blocking<int[ARRAY_SIZE]> sorted_data("sorted_data");
    testbench.data_in(sorted_data);
    bubbleSort.data_out(sorted_data);

    sc_start();

    return 0;
}

