//
// Created by ludwig on 07.06.17.
//

#ifndef PROJECT_MODULES_MS_H
#define PROJECT_MODULES_MS_H

#include "systemc.h"
#include "Interfaces.h"

struct TestMasterSlave0 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave0);

    TestMasterSlave0(sc_module_name name) :
            s_in("s_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave1 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave1);

    TestMasterSlave1(sc_module_name name) :
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_out->nb_write(1337);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave2 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave2);

    TestMasterSlave2(sc_module_name name) :
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_out->nb_write(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave3 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave3);

    TestMasterSlave3(sc_module_name name) :
            s_out("s_out"),
            s_in("s_in"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_out<int> s_out;
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_out->nb_write(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave4 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave4);

    TestMasterSlave4(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestMasterSlave5 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave5);

    TestMasterSlave5(sc_module_name name) :
            s_in2("s_in2"),
            s_in("s_in"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            val(1337){
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in2;
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_out->nb_write(val);
                s_in2->nb_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave6 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave6);

    TestMasterSlave6(sc_module_name name):
            s_in("s_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }
    //Out-port
    slave_in<int> s_in;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_in->nb_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestMasterSlave7 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave7);

    TestMasterSlave7(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_out->nb_write(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                ++val;
                s_out->nb_write(val);
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestMasterSlave8 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave8);

    TestMasterSlave8(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_out<int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {

                s_in->nb_read(val);
                s_out->nb_write(val);
                if(val > 10)  nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                ++val;
                s_out->nb_write(val);
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave9 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave9);

    TestMasterSlave9(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> s_out;

    //Variable
    int val;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_out->set(val);
                s_in->nb_read(val);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestMasterSlave10 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave10);

    TestMasterSlave10(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            s_out("s_out"),
            sharded_in("sharded_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_in<int> sharded_in;
    shared_out <int> s_out;

    //Variable
    int val;
    int shared;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                s_out->set(val);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                val = val*2;
                sharded_in->get(shared);
                s_out->set(val*2 + shared);
                nextsection = SECTION_A;
            }
        }
    }
};




struct TestMasterSlave11 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave11);

    TestMasterSlave11(sc_module_name name) :
            s_in("s_in"),
            s_out("s_out"),
            shared_in("shared_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    shared_out <int> s_out;
    shared_in <bool> shared_in;

    //Variable
    int val;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_out->set(val);
                shared_in->get(succ);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                val = val*2;
                s_out->set(val);
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestMasterSlave12 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave12);

    TestMasterSlave12(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            s_out("s_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> s_out;

    //Variable
    int val;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                s_out->set(val);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                val = val*2;
                s_out->set(val*2);
                nextsection = SECTION_A;
            }
        }
    }
};




struct TestMasterSlave13 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;

    //Constructor
    SC_HAS_PROCESS(TestMasterSlave13);

    TestMasterSlave13(sc_module_name name) :
            s_in("s_in"),
            s_in2("s_in2"),
            s_out("s_out"),
            m_in("m_in"),
            m_out("m_out"),
            shared_out("shared_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    slave_in<int> s_in;
    slave_in<int> s_in2;
    shared_out <int> s_out;
    master_in<int> m_in;
    master_out<int> m_out;
    shared_out<int> shared_out;


    //Variable
    int val;
    int save_val;
    bool succ;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                s_in->nb_read(val);
                save_val += val;
                m_in->read(val);
                save_val += val;
                s_in2->nb_read(val);
                save_val += val;
                m_out->write(save_val);
                shared_out->set(save_val);
                s_out->set(val);
                if(succ) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                s_in->nb_read(val);
                s_in2->nb_read(val);
                val = val*2;
                s_out->set(val*2);
                nextsection = SECTION_A;
            }
        }
    }
};




#endif //PROJECT_FIFO_H


