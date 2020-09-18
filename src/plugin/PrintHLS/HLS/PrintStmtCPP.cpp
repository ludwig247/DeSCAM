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

std::string PrintStmtCPP::getString() {
    return ss.str();
}