//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "DatapathVisitorSVA.h"


void SCAM::DatapathVisitorSVA::visit(SCAM::VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() <<"_"  << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
    this->ss << "_0";
}

void SCAM::DatapathVisitorSVA::visit(SCAM::IntegerValue &node) {
    if(this->resize_flag){
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    }else this->ss << node.getValue();
}

void SCAM::DatapathVisitorSVA::visit(SCAM::UnsignedValue &node) {
    if(this->resize_flag){
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    }else this->ss << node.getValue();
}

void SCAM::DatapathVisitorSVA::visit(BoolValue &node) {
    if (node.getValue())
        this->ss << "1";
    else
        this->ss << "0";
}

void SCAM::DatapathVisitorSVA::visit(EnumValue &node) {
    std::locale loc;
    std::string str = node.getEnumValue();
    for (std::string::size_type i=0; i<str.length(); ++i)
        this->ss << std::tolower(str[i],loc);
}

void SCAM::DatapathVisitorSVA::visit(SCAM::Assignment &node) {
    if (node.getLhs() != nullptr) {
        node.getLhs()->accept(*this);
    }

    this->ss << " == ";
    if (node.getRhs() != nullptr) {
        node.getRhs()->accept(*this);
    }
}

void SCAM::DatapathVisitorSVA::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitorSVA::visit(Logical &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);

    this->ss << " ";
    if(node.getOperation()=="and"){
        this->ss << "&&";
    }else if (node.getOperation()=="nand"){
        this->ss << "nand";
    }else if (node.getOperation()=="or"){
        this->ss << "||";
    }else if (node.getOperation()=="nor"){
        this->ss << "nor";
    }else if (node.getOperation()=="xor") {
        this->ss << "^";
    }else if (node.getOperation()=="xnor"){
        this->ss << "xnor";
    }
    this->ss << " ";

    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitorSVA::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if(node.getOperation() == "=="){
        this->ss << " == ";
    }else{
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitorSVA::visit(SCAM::Bitwise &node) {

    if (node.getOperation() == "<<") {
        this->resize_flag = true;
        this->ss << "(shift_left(";
        node.getLhs()->accept(*this);
        this->resize_flag = false;
        this->ss << ",";
        node.getRhs()->accept(*this);
        this->ss << "))";
    } else if (node.getOperation() == ">>") {
        this->ss << "(shift_right(";
        node.getLhs()->accept(*this);
        this->ss << ",";
        node.getRhs()->accept(*this);
        this->ss << "))";
    } else {
        this->ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            this->ss << " and ";
        } else if (node.getOperation() == "|") {
            this->ss << " or ";
        } else if (node.getOperation() == "^") {
            this->ss << " xor ";
        } else throw std::runtime_error("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
    }
}

void SCAM::DatapathVisitorSVA::visit(UnaryExpr &node) {
    if(node.getOperation() == "not"){
        this->ss << "!";
    }else if (node.getOperation() == "-"){
        this->ss << node.getOperation();
    }
    this->ss << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitorSVA::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
    this->ss << "_0";
}

void SCAM::DatapathVisitorSVA::visit(SCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubSig()) this->ss << "_" + node.getDataSignal()->getName();
    this->ss << "_0";
}


std::string SCAM::DatapathVisitorSVA::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    DatapathVisitorSVA printer;
    return printer.createString(stmt, indentSize, indentOffset);
}




