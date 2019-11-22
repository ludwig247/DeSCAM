//
// Created by johannes on 26.10.19.
//

#include "PrintVisibleRegisters.h"
#include "NodePeekVisitor.h"


using namespace SCAM;

PrintVisibleRegisters::PrintVisibleRegisters(Stmt *stmt, Utilities *utils, unsigned int indentSize, unsigned int indentOffset) {
    this->isRegister = false;
    this->utilities = utils;
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintVisibleRegisters::toString(Stmt *stmt, Utilities *utils, unsigned int indentSize, unsigned int indentOffset) {
    PrintVisibleRegisters printer(stmt, utils, indentSize, indentOffset);
    return printer.getString();
}

std::string PrintVisibleRegisters::getString() {
    return this->ss.str();
}

void PrintVisibleRegisters::visit(Assignment &node) {
    printIndent();
    this->ss << "static ";
    node.getLhs()->accept(*this);
    this->ss << ";\n";
    if (!isRegister) {
        this->ss.str("");
    }
}

void PrintVisibleRegisters::visit(VariableOperand &node) {
    if (utilities) {
        auto visibleRegisters = utilities->getRegisters();
        if (visibleRegisters.find(node.getVariable()) != visibleRegisters.end()) {
            isRegister = true;
        }
    }
    if (node.getVariable()->isSubVar()) {
        std::string dataType = node.getVariable()->getParent()->getDataType()->getName();
        std::size_t pos;
        if ((pos = dataType.find('_')) != std::string::npos) {
            this->ss << Utilities::convertDataType(dataType.substr(0, pos)) << " ";
        } else {
            this->ss << Utilities::convertDataType(dataType) << " ";
        }
        this->ss << node.getVariable()->getParent()->getName();

        if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << "[" << node.getVariable()->getParent()->getSubVarList().size() << "]";
            this->ss << " = {";
            auto subVarList = node.getVariable()->getParent()->getSubVarList();
            for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                (*subVar)->getInitialValue()->accept(*this);
                if (std::next(subVar) != subVarList.end()) {
                    this->ss << ", ";
                }
            }
            this->ss << "}";
        } else {
            this->ss << " = {";
            auto subVarList = node.getVariable()->getParent()->getSubVarList();
            for (auto subVar = subVarList.begin(); subVar != subVarList.end(); ++subVar) {
                (*subVar)->getInitialValue()->accept(*this);
                if (std::next(subVar) != subVarList.end()) {
                    this->ss << ", ";
                }
            }
            this->ss << "}";
        }
    } else {
        this->ss << Utilities::convertDataType(node.getDataType()->getName()) << " " << node.getVariable()->getName() << " = ";
        node.getVariable()->getInitialValue()->accept(*this);
    }
}

void PrintVisibleRegisters::printIndent() {
    for (std::size_t i = 0; i < indent; ++i) {
            this->ss << "\t";
    }
}

void PrintVisibleRegisters::visit(ParamOperand &node) {
    this->ss << node.getOperandName();
}


