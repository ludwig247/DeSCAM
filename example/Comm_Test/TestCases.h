//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 6/14/19.
//

#ifndef SCAM_TEST_H
#define SCAM_TEST_H

#include "systemc.h"
#include "Interfaces.h"

#define CASE 5

#if CASE == 0
/// An example to show that we can't start from an important state without considering the history
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

#elif CASE == 2
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