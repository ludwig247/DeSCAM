#include "systemc.h"
#include "Control.h"

int sc_main(int argc, char *argv[]){
    Regfile R("Regfile");
    Control C("Control");

    C.inp.bind(R);
    C.out.bind(R);

    sc_start(200, SC_PS);

    return 0;

}
