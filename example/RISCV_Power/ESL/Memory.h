//
// Created by dejanovic on 10.12.17.
//

#ifndef PROJECT_MEMORY_H
#define PROJECT_MEMORY_H

#include <iomanip>
#include "systemc.h"
#include "CPU_Interfaces.h"
#include "../../Interfaces/Interfaces.h"
#include "Defines.h"
#include "Utilities.h"
#include <string>


class Memory : public sc_module {
public:
    SC_HAS_PROCESS(Memory);

    // ctor
    Memory(sc_module_name name_, ifstream &hex_file, ofstream &logfile);

    //Ports
    blocking_in<MemoryAccess> CtlToMem_port;  // read_instruction/load/store
    blocking_out<unsigned int> MemToCtl_port;    // store/load done

    unsigned int load_data;
    unsigned int instr;


    // memory initialization hex file
    ifstream &hex_file;

    // log file
    ofstream &log_file;

    // memory contents
    unsigned char memory[MEM_DEPTH] = {}; //zero initialize

    // thread
    void run();

    // prints the memory contents
    void log();
};


// Constructor: Reads from the .bin file and initializes the memory
Memory::Memory(sc_module_name name_, ifstream &hex_file, ofstream &log_file) :
        sc_module(name_),
        CtlToMem_port("CtlToMem_port"),
        MemToCtl_port("MemToCtl_port"),
        hex_file(hex_file),
        log_file(log_file),
        instr(0),
        load_data(0) {

    std::string buff;
    int byte = 0;

    while (true) {

        // Little endian: Least significant byte in the smallest address...
        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char instr3 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char instr2 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char instr1 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char instr0 = stoul(buff, nullptr, 16);

        if (byte == MEM_DEPTH) {
            cout << "@Mem: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        memory[byte++] = instr0;

        if (byte == MEM_DEPTH) {
            cout << "@Mem: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        memory[byte++] = instr1;

        if (byte == MEM_DEPTH) {
            cout << "@Mem: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        memory[byte++] = instr2;

        if (byte == MEM_DEPTH) {
            cout << "@Mem: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        memory[byte++] = instr3;

    }

    // register thread with kernel
    SC_THREAD(run);
}


void Memory::run() {

    MemoryAccess MemRequest;

    while (true) {

        //Wait for next request
        CtlToMem_port->read(MemRequest);

        if (MemRequest.addrIn > MEM_DEPTH) {
            cout << "@Mem: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }

#ifndef NDEBUG
        // log file sanity check
        if (log_file.tellp() > 2000000) {       // 2 MB
            cout << "@Mem: Log file too big (2 MB) - probably an infinite loop in assembly! Terminating..." << endl;
            exit(0);
        }
#endif

        // read from memory (read instruction)
        if (MemRequest.req == MemoryAccess::MEM_WRITE) {


            // Little endian: Least significant byte in the smallest address...
            if (MemRequest.mask == MemoryAccess::MT_B) {

                // store 8 bits
                memory[MemRequest.addrIn] = MemRequest.dataIn & 0xFF;

            } else if (MemRequest.mask == MemoryAccess::MT_H) {

                // store 16 bits
                memory[MemRequest.addrIn] = MemRequest.dataIn & 0xFF;
                memory[MemRequest.addrIn + 1] = (MemRequest.dataIn >> 8) & 0xFF;

            } else if (MemRequest.mask == MemoryAccess::MT_W) {

                // store 32 bits
                memory[MemRequest.addrIn] = MemRequest.dataIn & 0xFF;
                memory[MemRequest.addrIn + 1] = (MemRequest.dataIn >> 8) & 0xFF;
                memory[MemRequest.addrIn + 2] = (MemRequest.dataIn >> 16) & 0xFF;
                memory[MemRequest.addrIn + 3] = (MemRequest.dataIn >> 24) & 0xFF;

            } else {
                cout << "@Mem: Store mask illegal!" << endl;
            }

#ifndef NDEBUG
            cout << "@Mem: Store at location 0x" << hex << MemRequest.addrIn << " value 0x" << MemRequest.dataIn
                 << endl;
          //  log();
#endif

            // notify the cpu that the store is successful
            MemToCtl_port->write(1);

        } else if (MemRequest.req == MemoryAccess::MEM_READ) { // LOAD


            // Little endian: Least significant byte in the smallest address...
            if (MemRequest.mask == MemoryAccess::MT_B) {

                // read 8 bits
                load_data = memory[MemRequest.addrIn];

                // sign extend
                if (Sub(load_data, 7, 7) == 1) {
                    load_data = Cat(Fill(24), 24, load_data, 8);
                }

            } else if (MemRequest.mask == MemoryAccess::MT_H) {

                // read 16 bits
                load_data = memory[MemRequest.addrIn]
                            + ((memory[MemRequest.addrIn + 1]) << 8);

                // sign extend
                if (Sub(load_data, 15, 15) == 1) {
                    load_data = Cat(Fill(16), 16, load_data, 16);
                }


            } else if (MemRequest.mask == MemoryAccess::MT_W) {

                // read 32 bits
                load_data = memory[MemRequest.addrIn]
                            + ((memory[MemRequest.addrIn + 1]) << 8)
                            + ((memory[MemRequest.addrIn + 2]) << 16)
                            + ((memory[MemRequest.addrIn + 3]) << 24);

            } else if (MemRequest.mask == MemoryAccess::MT_BU) {

                // read 8 bits, zero extend implicit
                load_data = memory[MemRequest.addrIn];

            } else if (MemRequest.mask == MemoryAccess::MT_HU) {

                // read 16 bits, zero extend implicit
                load_data = memory[MemRequest.addrIn]
                            + ((memory[MemRequest.addrIn + 1]) << 8);

            } else {
                cout << "@Mem: Load mask illegal!" << endl;
            }

#ifndef NDEBUG
            cout << "@Mem: Load from location 0x" << hex << MemRequest.addrIn << endl;
//            log();
            cout << "Loaded data 0x" << hex << load_data << " = " << dec << load_data << "(dec)" << endl;
#endif

            MemToCtl_port->write(load_data);
        }
    }

}


//void Memory::log() {
//
//    stringstream s;
//    s << hex;
//
//    cout << string(MEM_DEPTH * 14, '-') << endl;
//
//    for (int i = 0; i < MEM_DEPTH; i++) {
//        s << "MEM[0x" << i << "]";
//        cout << left << setw(14) << s.str();
//
//        s.str("");
//    }
//
//    cout << endl;
//
//    for (int i = 0; i < MEM_DEPTH; i++) {
//        s << "0x" << int(memory[i]);
//        cout << left << setw(14) << s.str();
//        s.str("");
//    }
//
//    cout << endl;
//    cout << string(MEM_DEPTH * 14, '-') << endl;
//
//}

#endif //PROJECT_MEMORY_H
