//
// Created by tobias on 02.07.17.
//

#ifndef PROJECT_MASTERDUMMY_H
#define PROJECT_MASTERDUMMY_H
#include "systemc.h"
#include "Compound_Bus.h"
#include "../../SingleMasterMultiSlave/ESL/Compound.h"
#include "../../Interfaces/Interfaces.h"

struct Component1 : public sc_module {
public:

    //Out-port
    blocking_out <bus_req_t> component1_out;
	
    blocking_in <bus_req_t> component1_in;

    //Variables
    bus_req_t req;

    int cnt;
    //Constructor
    SC_HAS_PROCESS(Component1);

    Component1(sc_module_name name) :
            component1_out("component1_out"), 
	    component1_in("component1_in"){
        SC_THREAD(fsm);
    }


    void fsm() {
        while (true) {
            cnt = cnt +1;
            req.data = cnt;
            req.addr = 8;
            req.trans_type = SINGLE_WRITE;
            std::cout << "sent: " << cnt << std::endl;
            component1_out->write(req, "component1_write");

	    component1_in->read(req, "component1_read");
		
	    
        }
    }
};
#endif //PROJECT_MASTERDUMMY_H
