//
// Created by Paulius Morkunas on 17.04.19.
//

#ifndef PROJECT_MIXED_3_STAGE_H
#define PROJECT_MIXED_3_STAGE_H


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

struct pipeline : public sc_module {
    blocking_in<int> b_in;
    master_out<int> m_out;
    blocking_out<int> b_out;

    //Constructor
    SC_HAS_PROCESS(pipeline);

    pipeline(sc_module_name name) :
            b_in("b_in"),
			m_out("m_out"),
            b_out("b_out"),
			nextsection(read) {
        SC_THREAD(fsm);
    }

	//Sections
	enum Sections {read, adjust, write};
	Sections section, nextsection;

	//Variables
    int cnt;

    void fsm() {
        while (true) {
			if (section == read) {
				b_in->read(cnt);
				nextsection = adjust;
			} else if (section == adjust) {
				// Could be implemented with pipeline stalling or state unrolling
				if (cnt <= 100) {
					cnt = cnt + 5;
					m_out->write(cnt);
				} else {
					nextsection = write;
				}
			} else if (section == write) {
          		b_out->write(cnt);
				nextsection = read;
			}
        }
    }
};

#endif //PROJECT_MIXED_3_STAGE_H
