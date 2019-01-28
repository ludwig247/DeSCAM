//
// Created by ludwig on 07.06.17.
//

#ifndef PROJECT_TESTING_H
#define PROJECT_TESTING_H

#include "systemc.h"
#include "Interfaces.h"

struct TestBasic0 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic0);

    TestBasic0(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->write(5);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic1 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic1);

    TestBasic1(sc_module_name name) :
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_in<int> b_in;
    //Vars
    int x;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(x);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic3 : public sc_module {

    //Constructor
    TestBasic3(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic3);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;

    void fsm() {
        while (true) {
            nb_result = b_out->nb_write(10);
            if (nb_result) {
                b_out->nb_write(11);
            }
            wait(SC_ZERO_TIME);
        }
    }
};


struct TestBasic4 : public sc_module {
    //Constructor
    TestBasic4(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_out("b_out"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic4);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            nb_result = b_out->nb_write(var);
            if (nb_result) {
                ++var;
            } else {
                --var;
            }
            wait(SC_ZERO_TIME);
        }
    }
};


struct TestBasic5 : public sc_module {
    //Constructor
    TestBasic5(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_out("b_out"),
            b_in("b_in"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic5);

    //Out port
    blocking_out<int> b_out;
    blocking_in<int> b_in;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            b_out->write(var);
            wait(SC_ZERO_TIME);
        }
    }
};


struct TestBasic6 : public sc_module {
    //Constructor
    TestBasic6(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_in("b_in"),
            b_in2("b_in2"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic6);

    //Out port
    blocking_in<int> b_in;
    blocking_in<int> b_in2;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            b_in2->read(var);
            wait(SC_ZERO_TIME);
        }
    }
};


struct TestBasic7 : public sc_module {
    //Constructor
    TestBasic7(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic7);

    //Out port
    blocking_in<int> b_in;
    master_out<int> m_out;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            m_out->write(var);
            wait(SC_ZERO_TIME);
        }
    }
};

struct TestBasic8 : public sc_module {
    //Constructor
    TestBasic8(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic8);

    //Out port
    blocking_in<int> b_in;
    master_out<int> m_out;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            var = 10;
            m_out->write(var);
            wait(SC_ZERO_TIME);
        }
    }
};

struct TestBasic9 : public sc_module {
    //Constructor
    TestBasic9(sc_module_name name) :
    //sensor_in("sensor_in"),
            b_in("b_in"),
            m_in("m_in"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic9);

    //Out port
    blocking_in<int> b_in;
    master_in<int> m_in;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var);
            m_in->read(var);
            wait(SC_ZERO_TIME);
        }
    }
};


enum Mode {
    READ, WRITE
};

struct CompoundType {
    int x;
    bool y;
    Mode mode;
};


struct TestBasic10 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic10);

    TestBasic10(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                b_out->write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic11 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic11);

    TestBasic11(sc_module_name name) :
            b_out("b_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {

                b_out->write(compoundType);
                if (compoundType.x > 10) nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                compoundType.mode = WRITE;
                compoundType.y = false;
                --compoundType.x;
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic12 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic12);

    TestBasic12(sc_module_name name) :
            m_out("m_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<int> m_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                if (compoundType.x >= 5) {
                    m_out->write(compoundType.x);
                }
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestBasic13 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic13);

    TestBasic13(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                b_out->nb_write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic14 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic14);

    TestBasic14(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextsection = SECTION_B;
                    compoundType.y = false;
                }

            }
            if (section == SECTION_B) {
                b_out->nb_write(compoundType);

                nextsection = SECTION_A;
            }
        }
    }
};

struct TestBasic15 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic15);

    TestBasic15(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextsection = SECTION_B;
                }

            }
            if (section == SECTION_B) {
                b_out->nb_write(compoundType);
                compoundType.y = false;
                nextsection = SECTION_A;
            }
        }
    }
};


//TODO: TestBasic16 ... actually compoundType.x doesn't need to be a register ... if there is time fix this
struct TestBasic16 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic16);

    TestBasic16(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextsection = SECTION_B;
                }

            }
            if (section == SECTION_B) {
                b_out->nb_write(compoundType);
                --compoundType.x;
                compoundType.y = false;
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic17 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic17);

    TestBasic17(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                m_in->read(compoundType);
                b_out->nb_write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic18 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic18);

    TestBasic18(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                m_in->read(compoundType);
                b_out->write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic19 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic19);

    TestBasic19(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->nb_write(compoundType);
                m_in->read(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct TestBasic20 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic20);

    TestBasic20(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->nb_write(compoundType);
                m_in->read(compoundType);
                m_in->read(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic21 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic21);

    TestBasic21(sc_module_name name) :
            b_out("b_out"),
            m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_out<CompoundType> m_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->nb_write(compoundType);
                m_out->write(compoundType);
                m_out->write(compoundType);
                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};

struct test_compound {
    int x;
    unsigned int y;
};

struct TestBasic22 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic22);

    TestBasic22(sc_module_name name) :
    //m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            test2(30) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<test_compound> m_out;
    //Vars
    test_compound test;
    unsigned int test2;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                //test.set(9);

                ++test.y;
                test.y = test2;
                ++test2;
                //--test;
                if (test.y > 10) {
                    test.y = test2;
                    m_out->write(test);
                } else m_out->write(test);

                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {
                nextsection = SECTION_A;
            }
        }
    }
};


struct TestBasic23 : public sc_module {
    //Sections
    enum Sections {
        SECTION_A, SECTION_B
    };

    Sections section;
    Sections nextsection;


    //Constructor
    SC_HAS_PROCESS(TestBasic23);

    TestBasic23(sc_module_name name) :
    //m_out("m_out"),
            section(SECTION_A),
            nextsection(SECTION_A),
            b_out("b_out"),
            b_out2("b_out2"),
            val_unsigned(13),
            val_signed(-7) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<unsigned int> b_out;
    blocking_out<int> b_out2;
    //Vars
    unsigned int val_unsigned;
    int val_signed;

    void fsm() {
        while (true) {
            section = nextsection;
            if (section == SECTION_A) {
                b_out->write(val_unsigned>>2);
                b_out->write(val_unsigned<<2);
                b_out->write(val_unsigned&2);
                b_out->write(val_unsigned|2);

                if ((val_unsigned % 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned & 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned | 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned >> 2) == 0) nextsection = SECTION_B;
                if ((val_unsigned << 2) == 0) nextsection = SECTION_B;

                nextsection = SECTION_B;
            }
            if (section == SECTION_B) {

                b_out2->write(val_signed>>2);
                b_out2->write(val_signed<<2);
                b_out2->write(val_signed&2);
                b_out2->write(val_signed|2);

                if ((val_signed % 2) == 0) nextsection = SECTION_B;
                if ((val_signed & 2) == 0) nextsection = SECTION_B;
                if ((val_signed | 2) == 0) nextsection = SECTION_B;
                if ((val_signed >> 2) == 0) nextsection = SECTION_B;
                if ((val_signed << 2) == 0) nextsection = SECTION_B;


                nextsection = SECTION_A;
            }
        }
    }
};


#endif //PROJECT_FIFO_H


