#ifndef PROJECT_MASTER_3_STAGE_H
#define PROJECT_MASTER_3_STAGE_H


#include "systemc.h"
#include "../Interfaces/Interfaces.h"


struct pipeline : public sc_module {
    master_in<int> m_in;
    master_out<int> m_out1;
    master_out<int> m_out2;
    //Constructor
    SC_HAS_PROCESS(pipeline);

    pipeline(sc_module_name name) :
            m_in("m_in"),
            m_out1("m_out1"),
			m_out2("m_out2"){
        SC_THREAD(fsm);
    }

    int x;

    void fsm() {
        while (true) {
          	m_in->read(x);
			m_out1->write(x);
			if (x > 0)
          		m_out2->write(x);
			else
				m_out2->write(1);
        }
    }
};

#endif //PROJECT_MASTER_3_STAGE_H
