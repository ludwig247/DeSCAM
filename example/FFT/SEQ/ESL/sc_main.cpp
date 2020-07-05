#include "../../../Interfaces/Blocking.h"
#include "systemc.h"
#include "DataTypes.h"

//Data Path Algorithm File
#include "FFT.h"

//Testbench
#include "Testbench.h"


using namespace std;

int sc_main(int argc, char* argv[]) {

    FFT FFT("BubbleSort");
    Testbench testbench("Testbench");

    Blocking<float[ARRAY_SIZE]>time_real("time_real");
    testbench.data_out_real(time_real);
    FFT.data_in_real(time_real);

    Blocking<float[ARRAY_SIZE]>time_img("time_img");
    testbench.data_out_img(time_img);
    FFT.data_in_img(time_img);

    Blocking<float[ARRAY_SIZE]> frequency_real("frequency_real");
    testbench.data_in_real(frequency_real);
    FFT.data_out_real(frequency_real);

    Blocking<float[ARRAY_SIZE]> frequency_img("frequency_img");
    testbench.data_in_img(frequency_img);
    FFT.data_out_img(frequency_img);

    sc_start();

    return 0;
}

