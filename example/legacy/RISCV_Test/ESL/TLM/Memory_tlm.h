//
// Created by lukadejanovic on 22.3.18..
//

#ifndef PROJECT_MEMORY_TLM_H
#define PROJECT_MEMORY_TLM_H

#include <iomanip>
#include <tlm.h>
#include "systemc.h"
#include "./../RISCV_commons/Defines.h"


class Memory_tlm : public sc_module, tlm::tlm_fw_transport_if<> {
public:

    SC_HAS_PROCESS(Memory_tlm);

    tlm::tlm_target_socket<> memorySocket;

    // ctor
    Memory_tlm(sc_module_name name, ifstream *hex_file, ofstream *log_file) :
            sc_module(name),
            memorySocket("memorySocket"),
            log_file(log_file)
    {
        memorySocket.bind(*this); // bind socket
        initialize(*hex_file); // initialize with hex data
    };

    // log file
    ofstream *log_file;

    unsigned char mem[MEM_DEPTH] = {}; //zero initialize

    // initialize with data in hex file
    void initialize(ifstream &hex_file);

    // prints the mem_array contents
    void log();

    void b_transport(tlm::tlm_generic_payload &trans, sc_time &delay) {

        // log file sanity check
        if (log_file->tellp() > 2000000) {       // 2 MB
            cout << "@@Memory_tlm: Log file too big (2 MB) - probably an infinite loop in assembly! Terminating..." << endl;
            exit(0);
        }

        if (trans.get_address() + trans.get_data_length() >= MEM_DEPTH) {
            trans.set_response_status(tlm::TLM_ADDRESS_ERROR_RESPONSE);
            cout << "@Memory_tlm: Accessing out of bound. Terminating!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
            return;
        }

        if (trans.get_command() == tlm::TLM_WRITE_COMMAND) {

#ifdef LOGTOFILE
            cout << "S4: @DM: Store at location 0x" << hex << trans.get_address() << ", data length"
                 << trans.get_data_length() << endl;
            //log();
#endif

            memcpy(&mem[trans.get_address()], // destination
                   trans.get_data_ptr(),      // source
                   trans.get_data_length());  // size

        } else { // (trans.get_command() == tlm::TLM_READ_COMMAND)

#ifdef LOGTOFILE
            cout << "S1/S4 @IM/DM: Read from location 0x" << hex << trans.get_address() << endl;
#endif

            memcpy(trans.get_data_ptr(),      // destination
                   &mem[trans.get_address()], // source
                   trans.get_data_length());  // size
        }

        delay = delay + sc_time(0, SC_NS);

        trans.set_response_status(tlm::TLM_OK_RESPONSE);
    }

    // Dummy method
    virtual tlm::tlm_sync_enum nb_transport_fw(
            tlm::tlm_generic_payload &trans,
            tlm::tlm_phase &phase,
            sc_time &delay) {
        SC_REPORT_FATAL(this->name(), "@Memory_tlm: nb_transport_fw is not implemented!");
        return tlm::TLM_ACCEPTED;
    }

    // Dummy method
    bool get_direct_mem_ptr(tlm::tlm_generic_payload &trans,
                            tlm::tlm_dmi &dmi_data) {
        SC_REPORT_FATAL(this->name(), "@Memory_tlm: get_direct_mem_ptr is not implemented!");
        return false;
    }

    // Dummy method
    unsigned int transport_dbg(tlm::tlm_generic_payload &trans) {
        SC_REPORT_FATAL(this->name(), "@Memory_tlm: transport_dbg is not implemented!");
        return 0;
    }
};


void Memory_tlm::initialize(ifstream &hex_file) {

    // clear the array
    memset(mem, 0, sizeof(mem));

    string buff;
    int byte = 0;

    while (true) {

        // Little endian: Least significant byte in the smallest address...
        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst3 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst2 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst1 = stoul(buff, nullptr, 16);

        buff.clear();
        hex_file.width(2);
        hex_file >> buff;
        if (buff.empty()) break; // end of file
        unsigned char inst0 = stoul(buff, nullptr, 16);

        if (byte == MEM_DEPTH) {
            cout << "@Memory_tlm: The program can't fit into mem_array!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst0;

        if (byte == MEM_DEPTH) {
            cout << "@Memory_tlm: The program can't fit into mem_array!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst1;

        if (byte == MEM_DEPTH) {
            cout << "@Memory_tlm: The program can't fit into mem_array!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst2;

        if (byte == MEM_DEPTH) {
            cout << "@Memory_tlm: The program can't fit into mem_array!" << endl;
            sc_stop();
            wait(SC_ZERO_TIME);
        }
        mem[byte++] = inst3;
    }
}


void Memory_tlm::log() {

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


#endif //PROJECT_MEMORY_TLM_H