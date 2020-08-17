#include "systemc.h"
#include "Control.h"
#include "Initializer_Dummy.h"

int sc_main(int argc, char *argv[]){
    Regfile R("Regfile");
    Control C("Control");
    Initializer_Dummy I("Initializer");

    C.inp.bind(R);
    C.out.bind(R);
    I.init_out.bind(R);

    sc_start(200, SC_PS);

    return 0;

}
