//
// Created by tobias on 02.07.17.
//

#ifndef PROJECT_SLAVEDUMMY_H
#define PROJECT_SLAVEDUMMY_H


#include "systemc.h"
#include "Compound_Bus.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "../../Interfaces/Interfaces.h"

struct Component2 : public sc_module {
public:

    //Out-port
    blocking_in <bus_req_t> component2_in;
    blocking_out <bus_req_t> component2_out;

    //Variables
    bus_req_t req;

    int cnt;
    //Constructor
    SC_HAS_PROCESS(Component2);

    Component2(sc_module_name name) :
            component2_in("component2_in"),
	    component2_out("component2_out"){
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {
            component2_in->read(req, "component2_read");
            std::cout << "received: " << req.data << std::endl;
	    component2_out->write(req, "component2_write");
	   

        }
    }
};

#endif //PROJECT_SLAVEDUMMY_H
