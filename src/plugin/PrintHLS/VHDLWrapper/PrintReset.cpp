//
// Created by schauss on 07.10.19.
//

#include "PrintReset.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

PrintResetSignal::PrintResetSignal(DESCAM::Stmt* stmt, const std::string& signalName, unsigned int indentSize, unsigned int indentOffset) :
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
