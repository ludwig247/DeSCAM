//
// Created by lukas on 19.02.19.
//

#include "ChiselDatapathVisitor.h"

std::string SCAM::ChiselDatapathVisitor::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ChiselDatapathVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::SyncSignal &node) {
    PrintStmt::toString(&node);
    this->ss << node.getPort()->getName() << "_sync_at_t";
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    if (node.getPort()->getInterface()->getDirection() == "in") {
        this->ss << "io." << node.getDataSignal()->getPort()->getName() << "." << node.getDataSignal()->getName();
    } else {
        this->ss << node.getDataSignal()->getPort()->getName() << "_r." << node.getDataSignal()->getName();
    }
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::EnumValue &node) {
    std::string str = node.getEnumValue();
    std::string::size_type i = str.find("_");

    /*while (i != std::string::npos)
    {
        str.erase(i, 1);
        i = str.find("_");
    }*/
    std::transform(str.begin(), str.end(), str.begin(), ::tolower);
    this->ss << str;
}

void SCAM::ChiselDatapathVisitor::visit(class VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() + "_signal_r." + node.getVariable()->getName();
    } else {
        this->ss << node.getOperandName() << "_signal_r";
    }
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        this->ss << " mod ";
    } else if (node.getOperation() == "/") {
        this->ss << " div ";
    } else this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
    //this->ss << ")(31 downto 0)";
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::Bitwise &node) {

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

void SCAM::ChiselDatapathVisitor::visit(SCAM::UnsignedValue &node) {
    /*if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();*/
    this->ss << node.getValueAsString() << ".U(32.W)";
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::IntegerValue &node) {
    /*if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();*/
    this->ss << "(" << node.getValueAsString() << ")" << ".S(32.W)";
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::BoolValue &node) {
    if (node.getValue()) {
        this->ss << "true.B";
    } else {
        this->ss << "false.B";
    }
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::Relational &node) {
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

void SCAM::ChiselDatapathVisitor::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselDatapathVisitor::visit(SCAM::CompoundExpr &node) {

    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }

}
