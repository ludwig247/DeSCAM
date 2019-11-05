//
// Created by Paulius Morkunas on 02.05.19.
//

#ifndef PROJECT_BLOCKING_3_STAGE_WITH_SHORTCUTS_H
#define PROJECT_BLOCKING_3_STAGE_WITH_SHORTCUTS_H


#include "systemc.h"
#include "../../Interfaces/Interfaces.h"

struct pipeline : public sc_module {
    blocking_in<int> b_in1;
    blocking_in<int> b_in2;
    blocking_out<int> b_out;

    //Constructor
    SC_HAS_PROCESS(pipeline);

    pipeline(sc_module_name name) :
            b_in1("b_in1"),
			b_in2("b_in2"),
            b_out("b_out"),
			nextsection(read1) {
        SC_THREAD(fsm);
    }

	//Sections
	enum Sections {read1, read2, write};
	Sections section, nextsection;

    int in1;
    int in2;
    int out;

    void fsm() {
        while (true) {
			section = nextsection;
			if (section == read1) {
				b_in1->read(in1);
				if (in1 < 10) {
					nextsection = read2;
				} else if (in1 > 100) {
					out = in1;
					nextsection = write;
				}
			} else if (section == read2) {
				b_in2->read(in2);
				out = in2;
				nextsection = write;
			} else if (section == write) {
          		b_out->write(out);
				if (out == 30) {
					nextsection = read2;
				} else {
					nextsection = read1;
				}
			}
        }
    }
};

#endif //PROJECT_BLOCKING_3_STAGE_WITH_SHORTCUTS_H
