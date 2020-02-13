//
// Created by schauss on 07.10.19.
//

#include "PrintReset.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

std::string PrintResetNotify::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintResetNotify printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

PrintResetNotify::PrintResetNotify(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintResetNotify::getString() {
    return this->ss.str();
}

void PrintResetNotify::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    if (!this->ss.str().empty()) {
        this->ss << " <= ";
        node.getRhs()->accept(*this);
        this->ss << ";\n";
    }
}

void PrintResetNotify::visit(BoolValue &node) {
    if (node.getValue()) {
        this->ss << "'1'";
    } else {
        this->ss << "'0'";
    }
}

PrintResetSignal::PrintResetSignal(SCAM::Stmt* stmt, const std::string& signalName, unsigned int indentSize, unsigned int indentOffset) :
    stmt(stmt),
    indentSize(indentSize),
    indentOffset(indentOffset),
    resetSignal(signalName),
    signalFound(false)
{
}

bool PrintResetSignal::toString()
{
    this->createString(stmt, indentSize, indentOffset);
    return signalFound;
}

std::string PrintResetSignal::getString()
{
    return this->ss.str();
}

void PrintResetSignal::visit(Assignment& node)
{
    node.getLhs()->accept(*this);
    if (signalFound) {
        node.getRhs()->accept(*this);
    }
}

void PrintResetSignal::visit(DataSignalOperand& node)
{
    if (node.getDataSignal()->getFullName() == resetSignal) {
        signalFound = true;
    }
}

void PrintResetSignal::visit(VariableOperand& node)
{
    if (node.getVariable()->getFullName() == resetSignal) {
        signalFound = true;
    }
}

void PrintResetSignal::visit(BoolValue &node) {
    if (node.getValue()) {
        this->ss << "\'1\'";
    } else {
        this->ss << "\'0\'";
    }
}
