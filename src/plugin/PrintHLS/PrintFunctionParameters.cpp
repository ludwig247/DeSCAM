//
// Created by johannes on 08.08.19.
//

#include "PrintFunctionParameters.h"
#include "NodePeekVisitor.h"

using namespace SCAM;

PrintFunctionParameters::PrintFunctionParameters(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintFunctionParameters::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintFunctionParameters printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintFunctionParameters::getString() {
    return this->ss.str();
}

void PrintFunctionParameters::visit(VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getDataType()->getName() << " " <<
                     node.getVariable()->getParent()->getName() << "[" << node.getVariable()->getName() << "]";
        } else {
            this->ss << node.getDataType()->getName() << " " <<
                node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
        }
    } else {
        this->ss << node.getDataType()->getName() << " " << node.getVariable()->getName();
    }
}

void PrintFunctionParameters::visit(SCAM::Assignment &node) {
    node.getLhs()->accept(*this);
    if (!this->ss.str().empty()) {
        this->ss << " = ";
        node.getRhs()->accept(*this);
    }
}


