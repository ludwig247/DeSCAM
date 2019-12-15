//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/5/19.
//

#ifndef PRINT_ITL_TESTING_H
#define PRINT_ITL_TESTING_H

#include "systemc.h"
#include "../../../example/Interfaces/Interfaces.h"

/*
struct TestBasicX : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasicX);

    TestBasicX(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            m_in("m_in"),
            m_out("m_out"),
            reqValue(0),
            rspValue(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    master_in<int> m_in;
    master_out<int> m_out;
    int reqValue;
    int rspValue;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(reqValue); // State_10
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                m_out->write(reqValue);
                m_in->read(rspValue);
                nextphase = WRITE;
            } else if (phase == WRITE) {
                b_out->write(rspValue); // State_18
                nextphase = READ;
            } else {
                wait(0); // State_20 // will present warning because it's unreachable
                nextphase = nextphase;
            }
        }
    }
};


struct TestBasicXX : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasicXX);

    TestBasicXX(sc_module_name name) :
    b_in("b_in"),
    b_out("b_out"),
    value(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int value;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(value); // State_9
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                value = value + 5;
                wait(0); // State_14
                nextphase = WRITE;
            } else if (phase == WRITE) {
                b_out->write(value); // State_17
                nextphase = READ;
            } else {
                wait(0); // State_19 // will present warning because it's unreachable
                nextphase = nextphase;
            }
        }
    }
};
*/


struct TestBasic00 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic00);

    TestBasic00(sc_module_name name) :
            b_out("b_out")
            {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(5);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic01 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic01);

    TestBasic01(sc_module_name name) :
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_in<int> b_in;
    //Vars
    int x;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(x);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic03 : public sc_module {

    //Constructor
    TestBasic03(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic03);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;

    void fsm() {
        while (true) {
//            nb_result = b_out->nb_write(10); //state_4
            b_out->try_write(10,nb_result); //state_4
            if (nb_result) {
//                b_out->nb_write(11); //state_6
                b_out->try_write(11); //state_6
            }
            wait(SC_ZERO_TIME); // not considered! should be wait(0) to be valid
        }
    }
};

struct TestBasic04 : public sc_module {
    //Constructor
    TestBasic04(sc_module_name name) :
            b_out("b_out"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic04);

    //Out port
    blocking_out<int> b_out;
    //Variable
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
//            nb_result = b_out->nb_write(var); //state_5
            b_out->try_write(var,nb_result); //state_5
            if (nb_result) {
                ++var;
            } else {
                --var;
            }
            wait(SC_ZERO_TIME); // not considered! should be wait(0) to be valid
        }
    }
};

struct TestBasic05 : public sc_module {
    //Constructor
    TestBasic05(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic05);

    //Out port
    blocking_out<int> b_out;
    blocking_in<int> b_in;
    //Variable - both should be removed from the model // wrong
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            b_out->write(var); //state_6 // need var for case of !sync
            wait(SC_ZERO_TIME); //No state
        }
    }
};

struct TestBasic06 : public sc_module {
    //Constructor
    TestBasic06(sc_module_name name) :
            b_in("b_in"),
            b_in2("b_in2"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic06);

    //Out port
    blocking_in<int> b_in;
    blocking_in<int> b_in2;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            b_in2->read(var); //state_6
            wait(SC_ZERO_TIME); //No state
        }
    }
};

struct TestBasic07 : public sc_module {
    //Constructor
    TestBasic07(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic07);

    //Out port
    blocking_in<int> b_in;
    master_out<int> m_out;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            m_out->master_write(var);
            wait(SC_ZERO_TIME);
        }
    }
};

struct TestBasic08 : public sc_module {
    //Constructor
    TestBasic08(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic08);

    //Out port
    blocking_in<int> b_in;
    master_out<int> m_out;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            var = 10;
            m_out->master_write(var);
            wait(SC_ZERO_TIME);
        }
    }
};

struct TestBasic09 : public sc_module {
    //Constructor
    TestBasic09(sc_module_name name) :
            b_in("b_in"),
            m_in("m_in"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(TestBasic09);

    //Out port
    blocking_in<int> b_in;
    master_in<int> m_in;
    //Variable - both should be removed from the model
    bool nb_result;
    int var;

    void fsm() {
        while (true) {
            b_in->read(var); //state_5
            m_in->master_read(var);
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
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic10);

    TestBasic10(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);//state_11
                b_out->write(compoundType);//state_12
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic11 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic11);

    TestBasic11(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(compoundType);
                if (compoundType.x > 10)
                    nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                compoundType.mode = WRITE;
                compoundType.y = false;
                --compoundType.x;
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic12 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic12);

    TestBasic12(sc_module_name name) :
            m_out("m_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<int> m_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
                if (compoundType.x >= 5) {
                    m_out->master_write(compoundType.x);
                }
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic13 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic13);

    TestBasic13(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic14 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic14);

    TestBasic14(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextphase = SECTION_B;
                    compoundType.y = false;
                }
            }
            if (phase == SECTION_B) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic15 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic15);

    TestBasic15(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextphase = SECTION_B;
                }
            }
            if (phase == SECTION_B) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                compoundType.y = false;
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic16 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestBasic16);

    TestBasic16(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    blocking_in<CompoundType> b_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_in->read(compoundType);
                ++compoundType.x;
                if (compoundType.mode == WRITE) {
                    nextphase = SECTION_B;
                }
            }
            if (phase == SECTION_B) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                --compoundType.x;
                compoundType.y = false;
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic17 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic17);

    TestBasic17(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                m_in->master_read(compoundType);
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic18 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic18);

    TestBasic18(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                m_in->master_read(compoundType);
                b_out->write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic19 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic19);

    TestBasic19(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
//                b_out->nb_write(compoundType);
                b_out->try_write(compoundType);
                m_in->master_read(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic20 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic20);

    TestBasic20(sc_module_name name) :
            b_out("b_out"),
            m_in("m_in") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_in<CompoundType> m_in;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
//                b_out->nb_write(compoundType);//state_11
                b_out->try_write(compoundType);//state_11
                m_in->master_read(compoundType);
                m_in->master_read(compoundType);//state_13
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic21 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic21);

    TestBasic21(sc_module_name name) :
            b_out("b_out"),
            m_out("m_out") {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<CompoundType> b_out;
    master_out<CompoundType> m_out;

    //Vars
    CompoundType compoundType;

    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
//                b_out->nb_write(compoundType);//state_11
                b_out->try_write(compoundType);//state_11
                m_out->master_write(compoundType);//state_12
                m_out->master_write(compoundType);
                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct test_compound {
    int x;
    unsigned int y;
//    int y;
};

struct TestBasic22 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic22);

    TestBasic22(sc_module_name name) :
            m_out("m_out"),
            test2(30) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_out<test_compound> m_out;
    //Vars
    test_compound test;
    unsigned int test2;
//    int test2;

    // TODO: an issue with conditions optimization
    void fsm() {
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                //test.set(9);
                ++test.y;
                test.y = test2;
                ++test2;
                //--test;
                if (test.y > 10) {
                    test.y = test2;
                    m_out->master_write(test);
                } else
                    m_out->master_write(test);

                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {
                nextphase = SECTION_A;
            }
        }
    }
};

struct TestBasic23 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(TestBasic23);

    TestBasic23(sc_module_name name) :
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
        nextphase = SECTION_A;
        while (true) {
            phase = nextphase;
            if (phase == SECTION_A) {
                b_out->write(val_unsigned>>2);
                b_out->write(val_unsigned<<2);
                b_out->write(val_unsigned&2);
                b_out->write(val_unsigned|2);

                if ((val_unsigned % 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned & 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned | 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned >> 2) == 0) nextphase = SECTION_B;
                if ((val_unsigned << 2) == 0) nextphase = SECTION_B;

                nextphase = SECTION_B;
            }
            if (phase == SECTION_B) {

                b_out2->write(val_signed>>2);
                b_out2->write(val_signed<<2);
                b_out2->write(val_signed&2);
                b_out2->write(val_signed|2);

                if ((val_signed % 2) == 0) nextphase = SECTION_B;
                if ((val_signed & 2) == 0) nextphase = SECTION_B;
                if ((val_signed | 2) == 0) nextphase = SECTION_B;
                if ((val_signed >> 2) == 0) nextphase = SECTION_B;
                if ((val_signed << 2) == 0) nextphase = SECTION_B;

                nextphase = SECTION_A;
            }
        }
    }
};

/// checking a master_in after a master_out => color master_out
struct TestBasic24 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic24);

    TestBasic24(sc_module_name name) :
            b_out("b_out"),
            reg_in("reg_in"),
            alu_out("alu_out"),
            alu_in("alu_in"),
            reg_out("reg_out"),
            reg_inData(0),
            alu_inData(0),
            var1(5) {
        SC_THREAD(fsm);
    }

    //Out-port
    blocking_out<int> b_out;
    master_in<int> reg_in;
    master_out<int> alu_out;
    master_in<int> alu_in;
    master_out<int> reg_out;

    //Vars
    int var1;
    int reg_inData;
    int alu_inData;

    void fsm() {
        while (true) {
            b_out->write(var1);//state_6
            reg_in->master_read(reg_inData);
            alu_out->master_write(reg_inData + 5);//state_8
            alu_in->master_read(alu_inData);
            reg_out->master_write(alu_inData);
        }
    }
};

struct TestBasic25 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic25);

    TestBasic25(sc_module_name name) :
            reg_in("reg_in"),
            alu_out("alu_out"),
            alu_in("alu_in"),
            reg_out("reg_out"),
            reg_inData(0),
            alu_inData(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<int> reg_in;
    master_out<int> alu_out;
    master_in<int> alu_in;
    master_out<int> reg_out;

    //Vars
    int reg_inData;
    int alu_inData;

    void fsm() {
        while (true) {
            reg_in->master_read(reg_inData);
            alu_out->master_write(reg_inData + 5);//state_6
            alu_in->master_read(alu_inData);
            reg_out->master_write(alu_inData);//state_8
        }
    }
};

struct TestBasic26 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic26);

    TestBasic26(sc_module_name name) :
            m_in_1("m_in_1"),
            m_in_2("m_in_2"),
            m_in_3("m_in_3"),
            m_out_1("m_out_1"),
            m_out_2("m_out_2"),
            m_out_3("m_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<int> m_in_1;
    master_in<int> m_in_2;
    master_in<int> m_in_3;
    master_out<int> m_out_1;
    master_out<int> m_out_2;
    master_out<int> m_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            m_in_1->master_read(data1);
            m_in_2->master_read(data2);
            m_in_3->master_read(data3);

            m_out_1->master_write(data1);
            m_out_2->master_write(data2);
            m_out_3->master_write(data3);//state_11
        }
    }
};

struct TestBasic27 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(TestBasic27);

    TestBasic27(sc_module_name name) :
            m_in_1("m_in_1"),
            m_in_2("m_in_2"),
            m_in_3("m_in_3"),
            m_out_1("m_out_1"),
            m_out_2("m_out_2"),
            m_out_3("m_out_3"),
            data1(0),
            data2(0),
            data3(0) {
        SC_THREAD(fsm);
    }

    //Out-port
    master_in<int> m_in_1;
    master_in<int> m_in_2;
    master_in<int> m_in_3;
    master_out<int> m_out_1;
    master_out<int> m_out_2;
    master_out<int> m_out_3;

    //Vars
    int data1;
    int data2;
    int data3;

    void fsm() {
        while (true) {
            m_in_1->master_read(data1);
            m_in_2->master_read(data2);
            m_in_3->master_read(data3);

            m_in_1->master_read(data1);//state_9

            m_out_1->master_write(data1);
            m_out_2->master_write(data2);
            m_out_3->master_write(data3);//state_12
        }
    }
};

SC_MODULE(TestBasic28)
{
    blocking_in <int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    SC_CTOR(TestBasic28):
            test_in("test_in"),
            test_out("test_out")
    {
        SC_THREAD(fsm);
    }
    void fsm()
    {

        foo = 23;
        bar = 24;
        while(true)
        {
            test_in->read(foo);

            bar = static_cast<unsigned int>(~foo) + bar ;
            if(bar > 10){
                ++bar;
            }
            test_out->write(bar);
        }
    }
};
#endif //PRINT_ITL_TESTING_H


