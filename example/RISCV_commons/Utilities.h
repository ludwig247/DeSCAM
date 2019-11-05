#ifndef PROJECT_UTILITIES_H
#define PROJECT_UTILITIES_H

#include <iostream>
#include <fstream>
#include "Defines.h"

using namespace std;

ifstream& open_hex_file(string hex_file_path, ifstream &hex_file) {

    hex_file.open(hex_file_path);
    if (!hex_file.is_open()) {
        cout << "Can't open the hex file with path: '" << hex_file_path << "' ! Terminating..." << endl;
        exit(0);
    }

};

ofstream& open_log_file(string log_file_path, ofstream &log_file) {

    // open log file
    log_file.open(log_file_path, ofstream::out | ofstream::trunc);
    if (!log_file.is_open()) {
        cout << "Can't open the log file with path: '" << log_file_path << "' ! Terminating..." << endl;
        exit(0);
    }
};


#ifdef LOGTOFILE
std::string stringInstrType(InstrType toPrint) {

    std::string s;

    switch (toPrint) {
        case InstrType::INSTR_UNKNOWN:
            s = "UNKNOWN";
            break;
        case InstrType::INSTR_ADDI:
            s = "ADDI";
            break;
        case InstrType::INSTR_ANDI:
            s = "ANDI";
            break;
        case InstrType::INSTR_ORI:
            s = "ORI";
            break;
        case InstrType::INSTR_XORI:
            s = "XORI";
            break;
        case InstrType::INSTR_SLTI:
            s = "SLTI";
            break;
        case InstrType::INSTR_SLTUI:
            s = "SLTUI";
            break;
        case InstrType::INSTR_SLLI:
            s = "SLLI";
            break;
        case InstrType::INSTR_SRLI:
            s = "SRLI";
            break;
        case InstrType::INSTR_SRAI:
            s = "SRAI";
            break;
        case InstrType::INSTR_ADD:
            s = "ADD";
            break;
        case InstrType::INSTR_SUB:
            s = "SUB";
            break;
        case InstrType::INSTR_SLL:
            s = "SLL";
            break;
        case InstrType::INSTR_SLT:
            s = "SLT";
            break;
        case InstrType::INSTR_SLTU:
            s = "SLTU";
            break;
        case InstrType::INSTR_XOR:
            s = "XOR";
            break;
        case InstrType::INSTR_SRL:
            s = "SRL";
            break;
        case InstrType::INSTR_SRA:
            s = "SRA";
            break;
        case InstrType::INSTR_OR:
            s = "OR";
            break;
        case InstrType::INSTR_AND:
            s = "AND";
            break;
        case InstrType::INSTR_BEQ:
            s = "BEQ";
            break;
        case InstrType::INSTR_BNE:
            s = "BNE";
            break;
        case InstrType::INSTR_BLT:
            s = "BLT";
            break;
        case InstrType::INSTR_BGE:
            s = "BGE";
            break;
        case InstrType::INSTR_BLTU:
            s = "BLTU";
            break;
        case InstrType::INSTR_BGEU:
            s = "BGEU";
            break;
        case InstrType::INSTR_LB:
            s = "LB";
            break;
        case InstrType::INSTR_LH:
            s = "LH";
            break;
        case InstrType::INSTR_LW:
            s = "LW";
            break;
        case InstrType::INSTR_LBU:
            s = "LBU";
            break;
        case InstrType::INSTR_LHU:
            s = "LHU";
            break;
        case InstrType::INSTR_LUI:
            s = "LUI";
            break;
        case InstrType::INSTR_AUIPC:
            s = "AUIPC";
            break;
        case InstrType::INSTR_JAL:
            s = "JAL";
            break;
        case InstrType::INSTR_JALR:
            s = "JALR";
            break;
        case InstrType::INSTR_SB:
            s = "SB";
            break;
        case InstrType::INSTR_SH:
            s = "SH";
            break;
        case InstrType::INSTR_SW:
            s = "SW";
            break;
        default:
            NULL;
            break;
    }
    return s;
}
#endif


#endif  //PROJECT_UTILITIES_H

