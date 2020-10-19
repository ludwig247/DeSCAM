//
// Created by Deutschmann on 18.09.20.
//

#include "PrintStmtCPP.h"


using namespace DESCAM::HLSPlugin::HLS;

PrintStmtCPP::PrintStmtCPP(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    this->createString(stmt, indentSize, indentOffset);
}

std::string PrintStmtCPP::toString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintStmtCPP printer(stmt, indentSize, indentOffset);
    return printer.getString();
}

void PrintStmtCPP::visit(DESCAM::Arithmetic &node) {
    ss << "(";
    node.getLhs()->accept(*this);
    ss << " " << node.getOperation() << " ";
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtCPP::visit(ArrayOperand &node) {
    node.getArrayOperand()->accept(*this);
    ss << "[";
    node.getIdx()->accept(*this);
    ss << "]";
}

void PrintStmtCPP::visit(DESCAM::Assignment &node) {
    node.getLhs()->accept(*this);
    ss << " = ";
    node.getRhs()->accept(*this);
}

void PrintStmtCPP::visit(DESCAM::Bitwise &node) {
    ss << "(";
    node.getLhs()->accept(*this);
    ss << " " << node.getOperation() << " ";
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtCPP::visit(DESCAM::Cast &node) {

    if (node.getDataType()->isInteger()) {
        ss << "ap_int<32>";
    } else if (node.getDataType()->isUnsigned()) {
        ss << "ap_uint<32>";
    } else {
        ss << node.getDataType()->getName();
    }

    ss << "(";
    node.getSubExpr()->accept(*this);
    ss << ")";
}

void PrintStmtCPP::visit(IntegerValue &node) {
    ss << node.getValue();
}

void PrintStmtCPP::visit(Logical &node) {
    ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "or") {
        ss << " || ";
    } else if (node.getOperation() == "and") {
        ss << " && ";
    }
    node.getRhs()->accept(*this);
    ss << ")";
}

void PrintStmtCPP::visit(Notify &node) {
    ss << node.getPort()->getName() << "_notify";
}

void PrintStmtCPP::visit(ParamOperand &node) {
    if (node.getParameter()->isSubVar()) {
        ss << node.getParameter()->getParent()->getName() << "_" << node.getParameter()->getName();
    } else {
        ss << node.getOperandName();
    }
}

void PrintStmtCPP::visit(Return &node) {
    ss << "return ";
    node.getReturnValue()->accept(*this);
    ss << "";
}

void PrintStmtCPP::visit(SyncSignal &node) {
    ss << node.getPort()->getName() << "_sync";
}

void PrintStmtCPP::visit(Ternary &node) {
    ss << "(";
    node.getCondition()->accept(*this);
    ss << " ? ";
    node.getTrueExpr()->accept(*this);
    ss << " : ";
    node.getFalseExpr()->accept(*this);
    ss << ")";
}

void PrintStmtCPP::visit(UnaryExpr &node) {
    ss << "(";
    if (node.getOperation() == "not") {
        ss << "!(";
    } else {
        ss << node.getOperation() << "(";
    }
    node.getExpr()->accept(*this);
    ss << "))";
}

void PrintStmtCPP::visit(UnsignedValue &node) {
    ss << node.getValue();
}

void PrintStmtCPP::visit(VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        ss << node.getVariable()->getParent()->getName();
        if (node.getVariable()->getParent()->isArrayType()) {
            ss << "[" << node.getVariable()->getName() << "]";
        } else {
            ss << "_" << node.getVariable()->getName();
        }
    } else {
        ss << node.getVariable()->getName();
    }
}

std::string PrintStmtCPP::getString() {
    return ss.str();
}