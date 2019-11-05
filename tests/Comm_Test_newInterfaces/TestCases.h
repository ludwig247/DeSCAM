//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 6/14/19.
//

#ifndef SCAM_TEST_H
#define SCAM_TEST_H

#include "systemc.h"
#include "../../example/Interfaces_new/Interfaces.h"

#define CASE 2

#if CASE == 0
/// An example using blocking communications in a similer manner to previous interfaces
struct TestCase_00 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_00);

    TestCase_00(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int cnt;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(cnt); //State /// starting from this state all options for phase are possible, creating three different operations
                nextphase = PROCESS;
            }
            if (phase == PROCESS) {
                cnt = cnt - 1;
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                b_out->write(cnt); //State
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 1

/// An example using blocking communications in a similar manner to previous interfaces
struct TestCase_01 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE, STARTUP
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_01);

    TestCase_01(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int cnt;
    bool b;

    void fsm() {
        nextphase = STARTUP;
        while (true) {
            phase = nextphase;
            if (phase == STARTUP){
                wait(0);
                nextphase = READ;
            }
            if (phase == READ) {
                cnt = 0;
                b = b_in->peek();
                if(b) {
                    b_in->read(cnt); //State /// starting from this state all options for phase are possible, creating three different operations
                    nextphase = PROCESS;
                } else {
                    wait(0);
                }
            }
            if (phase == PROCESS) {
                cnt = cnt - 1;
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                b_out->write(cnt); //State
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 2

// An example trying to understand the effect of the peek method
struct TestCase_02 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE, STARTUP
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_02);

    TestCase_02(sc_module_name name) :
            b_in_1("b_in_1"),
            b_in_2("b_in_2"),
            b_1_status(false),
            b_2_status(false),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in_1;
    blocking_in<int> b_in_2;
    blocking_out<int> b_out;
    int cnt;
    bool b_1_status;
    bool b_2_status;

    void fsm() {
        nextphase = STARTUP;
        while (true) {
            phase = nextphase;
            if (phase == STARTUP){
                wait(0);// state_11
                nextphase = READ;
            }
            if (phase == READ) {
                b_1_status = b_in_1->peek();
                b_2_status = b_in_2->peek();
                if(b_1_status) {
                    b_in_1->read(cnt); // state_17
                    nextphase = PROCESS;
                } else if(b_2_status) {
                        b_in_2->read(cnt); // state_27
                        nextphase = PROCESS;
                } else {
                    wait(0);// state_29
                }
            }
            if (phase == PROCESS) {
                cnt = cnt - 1;
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                b_out->write(cnt); // state_23
                nextphase = READ;
            }
        }
    }
};


#elif CASE == 3

/// An example trying to understand the effect of the peek method if used illogically
struct TestCase_03 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE, STARTUP
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_03);

    TestCase_03(sc_module_name name) :
            b_in_1("b_in_1"),
            b_in_2("b_in_2"),
            b_1_status(false),
            b_2_status(false),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in_1;
    blocking_in<int> b_in_2;
    blocking_out<int> b_out;
    int cnt;
    bool b_1_status;
    bool b_2_status;

    void fsm() {
        nextphase = STARTUP;
        while (true) {
            phase = nextphase;
            if (phase == STARTUP){
                wait(0);// state_11
                nextphase = READ;
            }
            if (phase == READ) {
                b_1_status = b_in_1->peek();
                b_2_status = b_in_2->peek();
                if(!b_1_status) {
                    b_in_1->read(cnt); // state_17 // it is not logical but it's possible and will be blocked while waiting for the sync
                    nextphase = PROCESS;
                } else if(b_2_status) {
                        b_in_2->read(cnt); // state_27
                        nextphase = PROCESS;
                } else {
                    wait(0);// state_29
                }
            }
            if (phase == PROCESS) {
                cnt = cnt - 1;
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                b_out->write(cnt); // state_23
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 20

struct TestCase_01 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_01);

    TestCase_01(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    master_out<int> m_out;
    int cnt;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(cnt); //State /// starting from this state all options for phase are possible, creating three different operations
                nextphase = PROCESS;
            }
            if (phase == PROCESS) {
                cnt = cnt - 1;
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                m_out->write(cnt); //State
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 21
/// An example to show that we can't store VVM along with the state because it might suppress some possible operations
struct TestCase_02 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_02);

    TestCase_02(sc_module_name name) :
            b_in("b_in"),
            m_out("m_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    master_out<int> m_out;
    int cnt;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(cnt); //State
                cnt = 3;
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                m_out->write(cnt); //State with (cnt = 3)
                if(cnt != 0) {
                    cnt = cnt - 1; //this branch will never get triggered because of m_out VVM having cnt = 3
                } else {
                    nextphase = READ;
                }
            }
        }
    }
};

#elif CASE == 3
/// An example to show that we can't use the approach of storing all possible backwards IF and all forwards assignments from every wait and match them
struct TestCase_03 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_03);

    TestCase_03(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int cnt;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(cnt); //State
                nextphase = PROCESS;
            } else if (phase == PROCESS) {
                if(cnt != 0) {
                    cnt = cnt - 1;// spurious path
                } else {
                    nextphase = WRITE;
                }
            } else if (phase == WRITE) {
                b_out->write(cnt); //State /// the required trigger for this comes from an arch that has no wait statement to begin with
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 4
/// eendless fixed point path. happens because of a detected fixed path that is unreachable, but there is no mechanism for retracing so far
struct TestCase_04 : public sc_module {
    //Sections
    enum Phases {
        INIT, READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_04);

    TestCase_04(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            var(0),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int cnt;
    int var;

    void fsm() {
        nextphase = INIT;
        while (true) {
            phase = nextphase;
            if(phase == INIT) {
                var = 0;
                nextphase = READ;
            }
            if (phase == READ) {
                b_in->read(cnt); //State
                nextphase = PROCESS;
            }
            if (phase == PROCESS) {
                if(var != 0) {
                    cnt = cnt - 1; // This shouldn't be reachable
                } else {
                    nextphase = WRITE;
                }
            }
            if (phase == WRITE) {
                b_out->write(cnt); //State
                nextphase = READ;
            }
        }
    }
};

#elif CASE == 5
struct TestCase_05 : public sc_module {
    //Sections
    enum Phases {
        READ, PROCESS, WRITE
    };

    Phases phase;
    Phases nextphase;


    //Constructor
    SC_HAS_PROCESS(TestCase_05);

    TestCase_05(sc_module_name name) :
            b_in("b_in"),
            b_out("b_out"),
            cnt(0) {
        SC_THREAD(fsm);
    }

    blocking_in<int> b_in;
    blocking_out<int> b_out;
    int cnt;

    void fsm() {
        nextphase = READ;
        while (true) {
            phase = nextphase;
            if (phase == READ) {
                b_in->read(cnt); //State
                nextphase = PROCESS;
            }
            if (phase == PROCESS) {
                if(cnt != 0) {
                    cnt = cnt - 1;
                }
                nextphase = WRITE;
            }
            if (phase == WRITE) {
                b_out->write(cnt); //State
                nextphase = READ;
            }
        }
    }
};

#endif

#endif