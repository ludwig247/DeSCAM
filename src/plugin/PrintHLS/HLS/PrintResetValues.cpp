//
// Created by johannes on 31.01.20.
//

#include "PrintResetValues.h"

PrintResetValues::PrintResetValues(SCAM::Stmt* stmt, const std::string& signalName, unsigned int indentSize, unsigned int indentOffset) :
    stmt(stmt),
    indentSize(indentSize),
    indentOffset(indentOffset),
    resetSignal(signalName),
    signalFound(false)
{
}

bool PrintResetValues::toString()
{
    this->createString(stmt, indentSize, indentOffset);
    return signalFound;
}

std::string PrintResetValues::getString()
{
    return this->ss.str();
}

void PrintResetValues::visit(Assignment& node)
{
    node.getLhs()->accept(*this);
    if (signalFound) {
        node.getRhs()->accept(*this);
    }
}

void PrintResetValues::visit(DataSignalOperand& node)
{
    if (node.getDataSignal()->getFullName() == resetSignal) {
        signalFound = true;
    }
}

void PrintResetValues::visit(Notify& node)
{
    if ((node.getPort()->getName() + "_notify") == resetSignal) {
        signalFound = true;
    }
}

void PrintResetValues::visit(VariableOperand& node)
{
    if (node.getVariable()->getFullName() == resetSignal) {
        signalFound = true;
    }
}
