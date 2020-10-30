//
// Created by PauliusMorku on 06.14.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"

#define OPCODE_I_L  0x03 //0000011
#define OPCODE_S    0x23 //0100011

#define OPCODE_FIELD(x) ((x) & 0x7F)

#define EXAMPLE 6

#if EXAMPLE == 0
class ISA_example_0 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_0);

    ISA_example_0(sc_module_name name) :
            nextsection(SEC_IF),
            section(SEC_IF),
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Sections { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Sections section, nextsection;

    // Other control signals:
    unsigned int encodedInstr;

    void run() {
//        nextsection = SEC_IF;
        while (true) {
            section = nextsection;
            if (section == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_12
                fromMemoryPort->read(fromMemoryData); //state_13
                nextsection = SEC_DE;
            }
            if (section == SEC_DE) {
                fromRegsPort->read(regfile);
                nextsection = SEC_EX;
            }
            if (section == SEC_EX) {
                nextsection = SEC_ME;
            }
            if (section == SEC_ME) {
                if (OPCODE_FIELD(fromMemoryData) == OPCODE_I_L) {
                    toMemoryPort->write(memoryAccess);
                    fromMemoryPort->read(fromMemoryData);
                } else if (OPCODE_FIELD(fromMemoryData) == OPCODE_S) {
                    toMemoryPort->write(memoryAccess);
                } else {
                }
                nextsection = SEC_WB;
            }
            if (section == SEC_WB) {
                toRegsPort->write(regfileWrite);
                nextsection = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 1
class ISA_example_1 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_1);

    ISA_example_1(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;
    
    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    void run() {
        phase = SEC_IF;
        while (true) {
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_11
                fromMemoryPort->read(fromMemoryData); //state_12
                phase = SEC_DE;
            }
            if (phase == SEC_DE) {
                fromRegsPort->read(regfile);
                phase = SEC_EX;
            }
            if (phase == SEC_EX) {
                phase = SEC_ME;
            }
            if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess); //state_21
                    fromMemoryPort->read(fromMemoryData); //state_22
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess); //state_29
                } else {
                }
                phase = SEC_WB;
            }
            if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                phase = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 2
class ISA_example_2 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_2);

    ISA_example_2(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    // This thread uses phase and nextphase. it also use if -- if -- if ... statements
    // Create extra operations because it doesn't take into consideration the history values of variables
    void run() {
        nextphase = SEC_IF;
        while (true) {
            phase = nextphase;
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_12
                fromMemoryPort->read(fromMemoryData); //state_13
                nextphase = SEC_DE;
            }
            if (phase == SEC_DE) {
                fromRegsPort->read(regfile);
                nextphase = SEC_EX;
            }
            if (phase == SEC_EX) {
                nextphase = SEC_ME;
            }
            if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess);
                    fromMemoryPort->read(fromMemoryData);
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess);
                } else {
                }
                nextphase = SEC_WB;
            }
            if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                nextphase = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 3
class ISA_example_3 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_3);

    ISA_example_3(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    // This thread uses phase and nextphase. it also use if -- else if -- else ... statements
    void run() {
        nextphase = SEC_IF;
        while (true) {
            phase = nextphase;
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_12
                fromMemoryPort->read(fromMemoryData); //state_13
                nextphase = SEC_DE;
            }
            else if (phase == SEC_DE) {
                fromRegsPort->read(regfile);
                nextphase = SEC_EX;
            }
            else if (phase == SEC_EX) {
                nextphase = SEC_ME;
            }
            else if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess);
                    fromMemoryPort->read(fromMemoryData);
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess);
                } else {
                }
                nextphase = SEC_WB;
            }
            else if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                nextphase = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 4
class ISA_example_4 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_4);

    ISA_example_4(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    void run() {
        phase = SEC_IF;
        while (true) {
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_11
                fromMemoryPort->read(fromMemoryData); //state_12
                phase = SEC_DE;
            }
            else if (phase == SEC_DE) {
                fromRegsPort->read(regfile);
                phase = SEC_EX;
            }
            else if (phase == SEC_EX) {
                phase = SEC_ME;
            }
            else if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess); //state_21
                    fromMemoryPort->read(fromMemoryData); //state_22
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess); //state_29
                } else {
                }
                phase = SEC_WB;
            }
            else if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                phase = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 5
class ISA_example_5 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_5);

    ISA_example_5(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    /// Erroneous CFG: fixed loop between SEC_DE and SEC_EX without important states
    void run() {
        nextphase = SEC_IF;
        while (true) {
            phase = nextphase;
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_12
                fromMemoryPort->read(fromMemoryData); //state_13
                nextphase = SEC_DE;
            }
            else if (phase == SEC_DE) {
//                fromRegsPort->read(regfile);
                nextphase = SEC_EX;
            }
            else if (phase == SEC_EX) {
//                nextphase = SEC_ME;
                nextphase = SEC_DE;
            }
            else if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess);
                    fromMemoryPort->read(fromMemoryData);
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess);
                } else {
                }
                nextphase = SEC_WB;
            }
            else if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                nextphase = SEC_IF;
            }
        }
    }
};
#endif

#if EXAMPLE == 6
class ISA_example_6 : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA_example_6);

    ISA_example_6(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort")
    {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<unsigned int> toMemoryPort;
    blocking_in<unsigned int> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int> fromRegsPort;
    master_out<unsigned int> toRegsPort;

    // data for communication with memory
    unsigned int memoryAccess;
    unsigned int fromMemoryData;

    // data for communication with register file
    unsigned int regfileWrite;
    unsigned int regfile;

    // ISA sections
    enum Phases { SEC_IF, SEC_DE, SEC_EX, SEC_ME, SEC_WB };
    Phases phase, nextphase;

    /// fixed loop triggers secondary coloring of a master communication
    void run() {
        nextphase = SEC_IF;
        while (true) {
            phase = nextphase;
            if (phase == SEC_IF) {
                toMemoryPort->write(memoryAccess); //state_12
                fromMemoryPort->read(fromMemoryData); //state_13
                nextphase = SEC_DE;
            }
            else if (phase == SEC_DE) {
                fromRegsPort->read(regfile); //state_17
                nextphase = SEC_EX;
            }
            else if (phase == SEC_EX) {
//                nextphase = SEC_ME;
                nextphase = SEC_DE;
            }
            else if (phase == SEC_ME) {
                if (fromMemoryData == 0x03) {
                    toMemoryPort->write(memoryAccess); //state_23
                    fromMemoryPort->read(fromMemoryData); //state_24
                } else if (fromMemoryData == 0x23) {
                    toMemoryPort->write(memoryAccess); //state_27
                } else {
                }
                nextphase = SEC_WB;
            }
            else if (phase == SEC_WB) {
                toRegsPort->write(regfileWrite);
                nextphase = SEC_IF;
            }
        }
    }
};
#endif

#endif //RISCV_ISA_H_