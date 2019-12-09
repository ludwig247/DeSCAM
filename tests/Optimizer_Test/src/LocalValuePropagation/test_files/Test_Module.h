//
// Created by mi-alkoudsi 08.12.19
//

#ifndef OPTIMIZER_LVP_TESTING_H
#define OPTIMIZER_LVP_TESTING_H

#include "systemc.h"
#include "../../../../example/Interfaces/Interfaces.h"


struct Test_Module00 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module00);

    Test_Module00(sc_module_name name) :
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

struct Test_Module01 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module01);

    Test_Module01(sc_module_name name) :
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

struct Test_Module03 : public sc_module {

    //Constructor
    Test_Module03(sc_module_name name) :
            b_out("b_out") {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module03);

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

struct Test_Module04 : public sc_module {
    //Constructor
    Test_Module04(sc_module_name name) :
            b_out("b_out"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module04);

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

struct Test_Module05 : public sc_module {
    //Constructor
    Test_Module05(sc_module_name name) :
            b_out("b_out"),
            b_in("b_in"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module05);

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

struct Test_Module06 : public sc_module {
    //Constructor
    Test_Module06(sc_module_name name) :
            b_in("b_in"),
            b_in2("b_in2"),
            var(4) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module06);

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

struct Test_Module07 : public sc_module {
    //Constructor
    Test_Module07(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module07);

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

struct Test_Module08 : public sc_module {
    //Constructor
    Test_Module08(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module08);

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

struct Test_Module09 : public sc_module {
    //Constructor
    Test_Module09(sc_module_name name) :
            b_in("b_in"),
            m_in("m_in"),
            var(1337) {
        SC_THREAD(fsm);
    }

    SC_HAS_PROCESS(Test_Module09);

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

struct Test_Module10 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module10);

    Test_Module10(sc_module_name name) :
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

struct Test_Module11 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module11);

    Test_Module11(sc_module_name name) :
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

struct Test_Module12 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module12);

    Test_Module12(sc_module_name name) :
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

struct Test_Module13 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module13);

    Test_Module13(sc_module_name name) :
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

struct Test_Module14 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module14);

    Test_Module14(sc_module_name name) :
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

struct Test_Module15 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module15);

    Test_Module15(sc_module_name name) :
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

struct Test_Module16 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(Test_Module16);

    Test_Module16(sc_module_name name) :
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

struct Test_Module17 : public sc_module {
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module17);

    Test_Module17(sc_module_name name) :
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

struct Test_Module18 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };

    Phases phase;
    Phases nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module18);

    Test_Module18(sc_module_name name) :
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

struct Test_Module19 : public sc_module {
    //Sections
    enum Phases {
        SECTION_A, SECTION_B
    };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module19);

    Test_Module19(sc_module_name name) :
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

struct Test_Module20 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module20);

    Test_Module20(sc_module_name name) :
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

struct Test_Module21 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module21);

    Test_Module21(sc_module_name name) :
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

struct Test_Module22 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module22);

    Test_Module22(sc_module_name name) :
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

struct Test_Module23 : public sc_module {
    //Sections
    enum Phases { SECTION_A, SECTION_B };
    Phases phase, nextphase;

    //Constructor
    SC_HAS_PROCESS(Test_Module23);

    Test_Module23(sc_module_name name) :
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
struct Test_Module24 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(Test_Module24);

    Test_Module24(sc_module_name name) :
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

struct Test_Module25 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(Test_Module25);

    Test_Module25(sc_module_name name) :
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

struct Test_Module26 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(Test_Module26);

    Test_Module26(sc_module_name name) :
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

struct Test_Module27 : public sc_module {

    //Constructor
    SC_HAS_PROCESS(Test_Module27);

    Test_Module27(sc_module_name name) :
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

SC_MODULE(Test_Module28)
{
    blocking_in <int> test_in;
    blocking_out<unsigned int> test_out;

    int foo;
    unsigned int bar;

    SC_CTOR(Test_Module28):
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
#endif //OPTIMIZER_LVP_TESTING_H


