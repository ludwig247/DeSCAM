//
// Created by Deutschmann on 09.09.20.
//

#include "PrintStmtVHDL.h"
#include "FatalError.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

PrintStmtVHDL::PrintStmtVHDL(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintStmtVHDL::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintStmtVHDL printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

void PrintStmtVHDL::visit(DESCAM::Arithmetic &node) {
    // TODO: Consider replacing multiplication by a power of two with shifting
    ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        ss << " rem ";
    } else {
        ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::ArrayOperand &node) {

    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(to_integer(unsigned(";
    node.getIdx()->accept(*this);
    this->ss << ")))";
}

//void PrintStmtVHDL::visit(DESCAM::Assignment &node) {
//TODO
//}

void PrintStmtVHDL::visit(DESCAM::Bitwise &node) {

    if (node.getOperation() == "<<" || node.getOperation() == ">>") {
        ss << ((node.getOperation() == "<<") ? "shift_left(" : "shift_right(");
        node.getLhs()->accept(*this);
        ss << ", ";
        node.getRhs()->accept(*this);
        ss << ")";
    } else {
        ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            ss << " and ";
        } else if (node.getOperation() == "|") {
            ss << " or ";
        } else if (node.getOperation() == "^") {
            ss << " xor ";
        } else {
            throw std::runtime_error("Unknown bitwise operator in PrintStmtVHDL::visit(DESCAM::Bitwise &node)");
        }
        node.getRhs()->accept(*this);
        ss << ")";
    }
}

void PrintStmtVHDL::visit(DESCAM::BoolValue &node) {
    ss << "\'" << node.getValue() << "\'";
}

void PrintStmtVHDL::visit(DESCAM::Cast &node) {

    const auto &type = node.getDataType()->getName();

    if ((type == "unsigned" && NodePeekVisitor::nodePeekIntegerValue(node.getSubExpr()))
        || (type == "int" && NodePeekVisitor::nodePeekUnsignedValue(node.getSubExpr()))) {
        node.getSubExpr()->accept(*this);
    } else {
        if (type == "unsigned") {
            ss << "unsigned";
        } else if (type == "int") {
            ss << "signed";
        } else if (type == "bool") {
            ss << "boolean";
        }
        ss << "(";
        node.getSubExpr()->accept(*this);
        ss << ")";
    }
}

//void PrintStmtVHDL::visit(DESCAM::CompoundExpr &node) {
//TODO
//}

void PrintStmtVHDL::visit(DESCAM::DataSignalOperand &node) {

    ss << node.getDataSignal()->getPort()->getName() << "_sig";

    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isCompoundType()) {
            ss << "." << node.getDataSignal()->getName();
        } else if (node.getDataSignal()->getParent()->isArrayType()) {
            ss << "(" << node.getDataSignal()->getName() << ")";
        } else {
            throw std::runtime_error(
                    "Unknown type for SubVar in PrintStmtVHDL::visit(DESCAM::DataSignalOperand &node)");
        }
    }
}

void PrintStmtVHDL::visit(DESCAM::FunctionOperand &node) {

    ss << node.getOperandName() << "(";
    for (auto parameter = node.getParamValueMap().begin(); parameter != node.getParamValueMap().end(); parameter++) {
        parameter->second->accept(*this);
        if (std::next(parameter) != node.getParamValueMap().end()) {
            ss << ", ";
        }
    }
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::IntegerValue &node) {
    //TODO: Slicing / Consider printing as hex vector
    ss << "to_signed(";
    ss << node.getValue();
    ss << ", 32)";
}

void PrintStmtVHDL::visit(DESCAM::Relational &node) {

    ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        ss << " = ";
    } else if (node.getOperation() == "!=") {
        ss << " /= ";
    } else {
        ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::SyncSignal &node) {
    ss << node.getPort()->getName() << "_sync";
}

void PrintStmtVHDL::visit(DESCAM::UnaryExpr &node) {
    if (node.getOperation() == "~") {
        ss << "not";
    } else {
        ss << node.getOperation();
    }
    ss << "(";
    node.getExpr()->accept(*this);
    ss << ")";
}

void PrintStmtVHDL::visit(DESCAM::UnsignedValue &node) {
    //TODO: Slicing / Consider printing as hex vector
    ss << "to_unsigned(";
    ss << node.getValue();
    ss << ", 32)";
}

void PrintStmtVHDL::visit(DESCAM::VariableOperand &node) {

    if (node.getVariable()->isSubVar()) {
        ss << node.getVariable()->getParent()->getName();
        if (node.getVariable()->getParent()->isCompoundType()) {
            ss << "." << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            ss << "(" << node.getVariable()->getName() << ")";
        } else {
            throw std::runtime_error("Unknown type for SubVar in PrintStmtVHDL::visit(DESCAM::VariableOperand &node)");
        }
    } else {
        ss << node.getVariable()->getName();
    }
}

std::string PrintStmtVHDL::getString() {
    return ss.str();
}




