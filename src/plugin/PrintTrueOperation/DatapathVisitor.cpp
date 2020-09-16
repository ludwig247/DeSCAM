//
// Created by ludwig on 29.08.16.
//

#include "DatapathVisitor.h"


DESCAM::DatapathVisitor2::DatapathVisitor2(std::string tp):tp(tp) {

}

void DESCAM::DatapathVisitor2::visit(DESCAM::SyncSignal &node) {
    PrintStmt::toString(&node);
    this->ss << node.getPort()->getName() << "_sync_at_t";
}

void DESCAM::DatapathVisitor2::visit(DESCAM::DataSignalOperand &node) {
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


void DESCAM::DatapathVisitor2::visit(class VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() + "_" + node.getVariable()->getName() + tp;
    } else this->ss << node.getOperandName() << tp;
}

std::string DESCAM::DatapathVisitor2::toString(DESCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset, std::string tp) {
    DatapathVisitor2 printer(tp);
    return printer.createString(stmt, indentSize, indentOffset);
}

void DESCAM::DatapathVisitor2::visit(DESCAM::Arithmetic &node) {
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

void DESCAM::DatapathVisitor2::visit(DESCAM::Bitwise &node) {

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
        } else TERMINATE("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
    }

}

void DESCAM::DatapathVisitor2::visit(DESCAM::UnsignedValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void DESCAM::DatapathVisitor2::visit(DESCAM::IntegerValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void DESCAM::DatapathVisitor2::visit(DESCAM::Relational &node) {
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

void DESCAM::DatapathVisitor2::visit(DESCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::DatapathVisitor2::visit(DESCAM::CompoundExpr &node) {

    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }

}



void DESCAM::DatapathVisitor2::visit(DESCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

