//
// Created by schauss on 07.10.19.
//

#include "VHDLPrintReset.h"

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

VHDLPrintResetValue::VHDLPrintResetValue(SCAM::Stmt* stmt, const std::string& signalName, unsigned int indentSize, unsigned int indentOffset) :
    stmt(stmt),
    indentSize(indentSize),
    indentOffset(indentOffset),
    resetSignal(signalName),
    signalFound(false)
{
}

bool VHDLPrintResetValue::toString()
{
    this->createString(stmt, indentSize, indentOffset);
    return signalFound;
}

std::string VHDLPrintResetValue::getString()
{
    return this->ss.str();
}

void VHDLPrintResetValue::visit(Assignment& node)
{
    node.getLhs()->accept(*this);
    if (signalFound) {
        node.getRhs()->accept(*this);
    }
}

void VHDLPrintResetValue::visit(DataSignalOperand& node)
{
    if (node.getDataSignal()->getFullName() == resetSignal) {
        signalFound = true;
    }
}

void VHDLPrintResetValue::visit(VariableOperand& node)
{
    if (node.getVariable()->getFullName() == resetSignal) {
        signalFound = true;
    }
}
