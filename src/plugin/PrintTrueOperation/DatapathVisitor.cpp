//
// Created by ludwig on 29.08.16.
//

#include "DatapathVisitor.h"


SCAM::DatapathVisitor2::DatapathVisitor2(std::string tp):tp(tp) {

}

void SCAM::DatapathVisitor2::visit(SCAM::SyncSignal &node) {
    PrintStmt::toString(&node);
    this->ss << node.getPort()->getName() << "_sync_at_t";
}

void SCAM::DatapathVisitor2::visit(SCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName()  << tp ;
        } else {
            this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName() << tp;
        }
    } else {
        this->ss << node.getDataSignal()->getName() << tp;
    }
}


void SCAM::DatapathVisitor2::visit(class VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() + "_" + node.getVariable()->getName() + tp;
    } else this->ss << node.getOperandName() << tp;
}

std::string SCAM::DatapathVisitor2::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset, std::string tp) {
    DatapathVisitor2 printer(tp);
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::DatapathVisitor2::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        this->ss << " mod ";
    } else if (node.getOperation() == "/") {
        this->ss << " div ";
    } else this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")(31 downto 0)";
}

void SCAM::DatapathVisitor2::visit(SCAM::Bitwise &node) {

    if (node.getOperation() == "<<") {
        this->ss << "(shift_left(";
        this->resize_flag = true;
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

void SCAM::DatapathVisitor2::visit(SCAM::UnsignedValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void SCAM::DatapathVisitor2::visit(SCAM::IntegerValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void SCAM::DatapathVisitor2::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        this->ss << " = ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitor2::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitor2::visit(SCAM::CompoundExpr &node) {

    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }

}



void SCAM::DatapathVisitor2::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

