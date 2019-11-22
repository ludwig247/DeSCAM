//
// Created by schauss on 07.10.19.
//

#include "VHDLPrintReset.h"

using namespace SCAM;

std::string SCAM::VHDLPrintReset::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    VHDLPrintReset printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

SCAM::VHDLPrintReset::VHDLPrintReset(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string VHDLPrintReset::getString() {
    return this->ss.str();
}

void VHDLPrintReset::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    if (!this->ss.str().empty()) {
        this->ss << " <= ";
        node.getRhs()->accept(*this);
        this->ss << ";\n";
    }
}

void VHDLPrintReset::visit(DataSignalOperand &node) {
    if (node.getPort()->getInterface()->isOutput()) {
        this->ss << node.getDataSignal()->getFullName();
    }
}


