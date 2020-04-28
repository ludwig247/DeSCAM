//
// Created by lukas on 01.04.19.
//

#include "ChiselSVADatapathVisitor.h"

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
    this->ss << "_0";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::IntegerValue &node) {
    this->ss << node.getValue();
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::UnsignedValue &node) {
    this->ss << node.getValue();
}

void SCAM::ChiselSVADatapathVisitor::visit(BoolValue &node) {
    if (node.getValue())
        this->ss << "1";
    else
        this->ss << "0";
}

void SCAM::ChiselSVADatapathVisitor::visit(EnumValue &node) {
    std::locale loc;
    std::string str = node.getEnumValue();
    for (char i : str)
        this->ss << std::tolower(i, loc);
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Assignment &node) {
    if (node.getLhs() != nullptr) {
        node.getLhs()->accept(*this);
    }

    this->ss << " == ";
    if (node.getRhs() != nullptr) {
        node.getRhs()->accept(*this);
    }
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVADatapathVisitor::visit(Logical &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);

    this->ss << " ";
    if (node.getOperation() == "and") {
        this->ss << "&&";
    } else if (node.getOperation() == "nand") {
        this->ss << "nand";
    } else if (node.getOperation() == "or") {
        this->ss << "||";
    } else if (node.getOperation() == "nor") {
        this->ss << "nor";
    } else if (node.getOperation() == "xor") {
        this->ss << "^";
    } else if (node.getOperation() == "xnor") {
        this->ss << "xnor";
    }
    this->ss << " ";

    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        this->ss << " == ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Bitwise &node) {

    if (node.getOperation() == "<<") {
        this->ss << "(";
        node.getLhs()->accept(*this);
        this->ss << "<<";
        node.getRhs()->accept(*this);
        this->ss << ")";
    } else if (node.getOperation() == ">>") {
        this->ss << "(";
        node.getLhs()->accept(*this);
        this->ss << ">>";
        node.getRhs()->accept(*this);
        this->ss << ")";
    } else {
        this->ss << "(";
        node.getLhs()->accept(*this);
        if (node.getOperation() == "&") {
            this->ss << " & ";
        } else if (node.getOperation() == "|") {
            this->ss << " | ";
        } else if (node.getOperation() == "^") {
            this->ss << " ^ ";
        } else TERMINATE("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
    }
}

void SCAM::ChiselSVADatapathVisitor::visit(UnaryExpr &node) {
    if (node.getOperation() == "not") {
        this->ss << "!";
    } else if (node.getOperation() == "-") {
        this->ss << node.getOperation();
    }
    this->ss << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
    this->ss << "_0";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
    this->ss << "_0";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubVar()) this->ss << "_" + node.getDataSignal()->getName();
    this->ss << "_0";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "int unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "int signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::CompoundExpr &node) {
    useParenthesesFlag = true;
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::ChiselSVADatapathVisitor::visit(SCAM::CompoundValue &node) {
    useParenthesesFlag = true;
    for (auto iterator = node.getValues().begin(); iterator != node.getValues().end(); ++iterator) {
        (*iterator).second->accept(*this);

        if (iterator != (node.getValues().end()--)) this->ss << ",";
    }
}

std::string SCAM::ChiselSVADatapathVisitor::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ChiselSVADatapathVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}
