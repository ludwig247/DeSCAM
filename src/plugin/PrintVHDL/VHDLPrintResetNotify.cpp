//
// Created by schauss on 07.10.19.
//

#include "VHDLPrintResetNotify.h"

using namespace SCAM;

std::string SCAM::VHDLPrintResetNotify::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    VHDLPrintResetNotify printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

SCAM::VHDLPrintResetNotify::VHDLPrintResetNotify(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string VHDLPrintResetNotify::getString() {
    return this->ss.str();
}

void VHDLPrintResetNotify::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    if (!this->ss.str().empty()) {
        this->ss << " <= ";
        node.getRhs()->accept(*this);
        this->ss << ";\n";
    }
}

void VHDLPrintResetNotify::visit(BoolValue &node) {
    if (node.getValue()) {
        this->ss << "'1'";
    } else {
        this->ss << "'0'";
    }
}
