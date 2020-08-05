//
// Created by johannes on 31.01.20.
//

#include "PrintReset.h"

using namespace DESCAM::HLSPlugin::HLS;

PrintReset::PrintReset(DESCAM::Stmt* stmt, const std::string& signalName, unsigned int indentSize, unsigned int indentOffset) :
    stmt(stmt),
    indentSize(indentSize),
    indentOffset(indentOffset),
    resetSignal(signalName),
    signalFound(false)
{
}

bool PrintReset::hasReset()
{
    this->createString(stmt, indentSize, indentOffset);
    return signalFound;
}

std::string PrintReset::getString()
{
    return this->ss.str();
}

void PrintReset::visit(DataSignalOperand& node)
{
    if (node.getDataSignal()->getFullName() == resetSignal) {
        signalFound = true;
    }
}

void PrintReset::visit(Notify& node)
{
    if ((node.getPort()->getName() + "_notify") == resetSignal) {
        signalFound = true;
    }
}

void PrintReset::visit(VariableOperand& node)
{
    if (node.getVariable()->getFullName() == resetSignal) {
        signalFound = true;
    }
}
