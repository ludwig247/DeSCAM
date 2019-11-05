//
// Created by dejanovic on 10.12.17.
//

#ifndef PROJECT_MEMORY_H
#define PROJECT_MEMORY_H

#include <iomanip>
#include "systemc.h"
#include "Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"
#include "../../RISCV_commons/Defines.h"


class Memory : public sc_module {
public:

    SC_HAS_PROCESS(Memory);

    Memory(sc_module_name name, ifstream *hex_file, ofstream *log_file) :
            sc_module(name),
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            log_file(log_file)
    {
        initialize(*hex_file); // initialize with hex data
        SC_THREAD(run); // register thread with kernel
    }

    //Ports
    blocking_in<CUtoME_IF> COtoME_port; // read_instruction/load/store
    blocking_out<MEtoCU_IF> MEtoCO_port; // store/load done

    CUtoME_IF COtoME_data;
    MEtoCU_IF MEtoCO_data;

    ofstream *log_file; // log file

    unsigned char mem[MEM_DEPTH] = {}; // memory contents //zero initialize

    void initialize(ifstream &hex_file); // initialize with data in hex file

    void run(); // thread

    void log(); // prints the memory contents
};


void Memory::initialize(ifstream &hex_file) {

    memset(mem, 0, sizeof(mem)); // clear the array

    string buff;
    int byte = 0;

    while (true) {

        // Little endian: Least significant byte in the smallest address...
        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst3 = (unsigned char) stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst2 = (unsigned char) stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst1 = (unsigned char) stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst0 = (unsigned char) stoul(buff, nullptr, 16);

        if (byte == MEM_DEPTH) {
            cout << "@IM: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst0;

        if (byte == MEM_DEPTH) {
            cout << "@IM: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst1;

        if (byte == MEM_DEPTH) {
            cout << "@IM: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst2;

        if (byte == MEM_DEPTH) {
            cout << "@IM: The program can't fit into memory!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst3;
    }

}


void Memory::run() {

    while (true) {

        COtoME_port->read(COtoME_data); //Wait for next request

        MEtoCO_data.loadedData = 0;

        if (COtoME_data.addrIn > MEM_DEPTH) {
            cout << "@ME: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }

#ifdef LOGTOFILE
        // log file sanity check
        if (log_file->tellp() > 2000000) { // 2 MB
            cout << "@ME: Log file too big (2 MB) - probably an infinite loop in assembly! Terminating..." << endl;
            exit(0);
        }
#endif

        if (COtoME_data.req == ME_RD) { // LOAD

            // Little endian: Least significant byte in the smallest address...
            if (COtoME_data.mask == MT_W) {

                // read 32 bits
                MEtoCO_data.loadedData = mem[COtoME_data.addrIn]
                                         + ((mem[COtoME_data.addrIn + 1]) << 8)
                                         + ((mem[COtoME_data.addrIn + 2]) << 16)
                                         + ((mem[COtoME_data.addrIn + 3]) << 24);

            } else if (COtoME_data.mask == MT_H) {

                // read 16 bits
                MEtoCO_data.loadedData = mem[COtoME_data.addrIn]
                                         + ((mem[COtoME_data.addrIn + 1]) << 8);

                // sign extend
                if (Sub(MEtoCO_data.loadedData, 15, 15) == 1) {
                    MEtoCO_data.loadedData = Cat(Fill(16), 16, MEtoCO_data.loadedData, 16);
                }

            } else if (COtoME_data.mask == MT_B) {

                // read 8 bits
                MEtoCO_data.loadedData = mem[COtoME_data.addrIn];

                // sign extend
                if (Sub(MEtoCO_data.loadedData, 7, 7) == 1) {
                    MEtoCO_data.loadedData = Cat(Fill(24), 24, MEtoCO_data.loadedData, 8);
                }

            } else if (COtoME_data.mask == MT_HU) {

                // read 16 bits, zero extend implicit
                MEtoCO_data.loadedData = mem[COtoME_data.addrIn]
                                         + ((mem[COtoME_data.addrIn + 1]) << 8);

            } else if (COtoME_data.mask == MT_BU) {

                // read 8 bits, zero extend implicit
                MEtoCO_data.loadedData = mem[COtoME_data.addrIn];

            } else {

                throw std::logic_error(std::string("@ME: Load mask not defined!"));
            }

#ifdef LOGTOFILE
            // has to be adjusted according to the address of the last instruction
            if (COtoME_data.addrIn < 0x100) {
                cout << ".~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FETCHING NEW INST~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~." << endl;
                cout << "S1: @IM: Load from location 0x" << hex << COtoME_data.addrIn << endl;
                cout << "S1: @IM: Loaded instr 0x" << hex << MEtoCO_data.loadedData << " = " << dec << MEtoCO_data.loadedData << "(dec)" << endl;
            } else {
                cout << "S4: @DM: Load from location 0x" << hex << COtoME_data.addrIn << endl;
                cout << "S4: @DM: Loaded data 0x" << hex << MEtoCO_data.loadedData << " = " << dec << MEtoCO_data.loadedData << "(dec)" << endl;
                //log();
            }
#endif

        } else if (COtoME_data.req == ME_WR) {

            // Little endian: Least significant byte in the smallest address...
            if (COtoME_data.mask == MT_W) {

                // store 32 bits
                mem[COtoME_data.addrIn] = COtoME_data.dataIn & 0xFF;
                mem[COtoME_data.addrIn + 1] = (COtoME_data.dataIn >> 8) & 0xFF;
                mem[COtoME_data.addrIn + 2] = (COtoME_data.dataIn >> 16) & 0xFF;
                mem[COtoME_data.addrIn + 3] = (COtoME_data.dataIn >> 24) & 0xFF;

            } else if (COtoME_data.mask == MT_H) {

                // store 16 bits
                mem[COtoME_data.addrIn] = COtoME_data.dataIn & 0xFF;
                mem[COtoME_data.addrIn + 1] = (COtoME_data.dataIn >> 8) & 0xFF;

            } else if (COtoME_data.mask == MT_B) {

                // store 8 bits
                mem[COtoME_data.addrIn] = COtoME_data.dataIn & 0xFF;

            } else if (COtoME_data.mask == MT_BU || COtoME_data.mask == MT_HU){

                throw std::logic_error(std::string("@ME: Store mask illegal!"));

            } else {

                throw std::logic_error(std::string("@ME: Store mask not defined!"));
            }

            MEtoCO_data.loadedData = 1;

#ifdef LOGTOFILE
            cout << "S4: @DM: Store at location 0x" << hex << COtoME_data.addrIn << endl;
            cout << "S4: @DM: Stored data 0x" << hex << COtoME_data.dataIn << " = " << dec << COtoME_data.dataIn << "(dec)" << endl;
            //log();
#endif

        } else {

            // throw std::logic_error(std::string("@ME: Undefined memory's req value"));
        }

        MEtoCO_port->write(MEtoCO_data);
    }
}


void Memory::log() {

    stringstream s;

    s << hex;

    cout << string(143, '-') << endl;

    cout << "Memory Content (Hex):" << endl;

    cout << string(143, '-') << endl;

    for (int i = 0; i < 64; i++) {

        for (int j = 0; j < 8; j++) {

            if ((j + (8 * i)) >= 0 && (j + (8 * i)) < 16) {
                s << "MEM[00" << j + (8 * i) << "]   0x" << int(mem[j + (8 * i)]);
            } else if ((j + (8 * i)) >= 16 && (j + (8 * i)) < 256){
                s << "MEM[0" << j + (8 * i) << "]   0x" << int(mem[j + (8 * i)]);
            } else {
                s << "MEM[" << j + (8 * i) << "]   0x" << int(mem[j + (8 * i)]);
            }

            cout << left << setw(18) << s.str();

            s.str("");
        }

        cout << endl;
    }

    cout << string(143, '-') << endl;
}


#endif //PROJECT_MEMORY_H