//
// Created by deutschmann on 9/26/19.
//

#include "PrintSVA.h"
#include "DatapathVisitorSVA.h"

void DESCAM::DatapathVisitorSVA::visit(DESCAM::VariableOperand &node) {
     if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
    if(!node.getVariable()->isConstant()) this->ss << PrintSVA::freezeSigSuffix;
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::IntegerValue &node) {
    this->ss << node.getValue();
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::UnsignedValue &node) {
    this->ss << node.getValue();
}

void DESCAM::DatapathVisitorSVA::visit(BoolValue &node) {
    if (node.getValue())
        this->ss << "1";
    else
        this->ss << "0";
}

void DESCAM::DatapathVisitorSVA::visit(EnumValue &node) {
/*    std::locale loc;
    std::string str = node.getEnumValue();
    for (char i : str)
        this->ss << std::tolower(i, loc);*/
    this->ss << node.getEnumValue();
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Assignment &node) {
    if (node.getLhs() != nullptr) {
        node.getLhs()->accept(*this);
    }

    this->ss << " == ";
    if (node.getRhs() != nullptr) {
        node.getRhs()->accept(*this);
    }
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void DESCAM::DatapathVisitorSVA::visit(Logical &node) {
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

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Relational &node) {
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

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Bitwise &node) {

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
        } else throw std::runtime_error("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
    }
}

void DESCAM::DatapathVisitorSVA::visit(UnaryExpr &node) {
    if (node.getOperation() == "not") {
        this->ss << "!";
    } else  {
        this->ss << node.getOperation();
    }

    this->ss << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
    this->ss << PrintSVA::freezeSigSuffix;
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubVar()) this->ss << "_" + node.getDataSignal()->getName();
    this->ss << PrintSVA::freezeSigSuffix;
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned'(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed'(";
    } else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::CompoundExpr &node) {
    useParenthesesFlag = true;
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::CompoundValue &node) {
    useParenthesesFlag = true;
    for (auto iterator = node.getValues().begin(); iterator != node.getValues().end(); ++iterator) {
        (*iterator).second->accept(*this);
        if (iterator != (node.getValues().end()--)) this->ss << ",";
    }
}

std::string DESCAM::DatapathVisitorSVA::toString(DESCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    DatapathVisitorSVA printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::Ternary &node) {
    this->ss << "(";
    node.getCondition()->accept(*this);
    this->ss << "?";
    node.getTrueExpr()->accept(*this);
    this->ss << ":";
    node.getFalseExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::DatapathVisitorSVA::visit(DESCAM::ArrayOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << PrintSVA::freezeSigSuffix;
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}
