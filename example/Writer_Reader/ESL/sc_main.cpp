#include "systemc.h"
#include "Component2.h"
#include "Component1.h"


//using namespace std;

int sc_main(int, char **) {

    Component1 component1("component1");
    Component2 component2("component2");



    Blocking<bus_req_t> comp1tocomp2("comp1tocomp2");
    component1.component1_out(comp1tocomp2);
    component2.component2_in(comp1tocomp2);
    Blocking<bus_req_t> comp2tocomp1("comp2tocomp1");
    component1.component1_in(comp2tocomp1);
    component2.component2_out(comp2tocomp1);

    sc_start();

    return 0;
}

