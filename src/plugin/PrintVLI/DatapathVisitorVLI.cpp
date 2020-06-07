//
// Created by ludwig on 29.08.16.
//


#include "DatapathVisitorVLI.h"

SCAM::DatapathVisitorVLI::DatapathVisitorVLI(std::string tp):
    tp(tp){

}

void SCAM::DatapathVisitorVLI::visit(SCAM::SyncSignal &node) {
    PrintStmt::toString(&node);
    this->ss << node.getPort()->getName() << "_sync" << tp;
}

void SCAM::DatapathVisitorVLI::visit(SCAM::DataSignalOperand &node) {
    PrintStmt::toString(&node);
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << node.getDataSignal()->getParent()->getName() << tp << "(" << node.getDataSignal()->getName() << ")";
        } else {
            this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName() << tp;
        }
    } else {
        this->ss << node.getDataSignal()->getName() << tp;
    }
}


void SCAM::DatapathVisitorVLI::visit(class VariableOperand &node) {
    if(node.getVariable()->isConstant()) this->ss << node.getOperandName();
    else{
        if (node.getVariable()->isSubVar()) {
            this->ss << node.getVariable()->getParent()->getName() + "_" + node.getVariable()->getName() + tp;
        } else this->ss << node.getOperandName() << tp;
    }
}

std::string SCAM::DatapathVisitorVLI::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset, std::string tp) {
    DatapathVisitorVLI printer(tp);
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::DatapathVisitorVLI::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        this->ss << " mod ";
    } else if (node.getOperation() == "/") {
        this->ss << " div ";
    } else this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")[31:0]";
}

void SCAM::DatapathVisitorVLI::visit(SCAM::Bitwise &node) {

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

void SCAM::DatapathVisitorVLI::visit(SCAM::UnsignedValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void SCAM::DatapathVisitorVLI::visit(SCAM::IntegerValue &node) {
    if (this->resize_flag) {
        //FIXME: remove once concat is present?
        this->ss << "resize(" << node.getValueAsString() << ",32)";
    } else this->ss << node.getValue();
}

void SCAM::DatapathVisitorVLI::visit(SCAM::Relational &node) {
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

void SCAM::DatapathVisitorVLI::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::DatapathVisitorVLI::visit(SCAM::CompoundExpr &node) {

    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }

}

void SCAM::DatapathVisitorVLI::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName() << tp;
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")" ;

//    this->ss << "(";
//    node.getIdx()->accept(*this);
//    this->ss << ")";
}

void SCAM::DatapathVisitorVLI::visit(SCAM::UnaryExpr &node) {
        useParenthesesFlag = true;
        if(node.getOperation() == "~") {
            this->ss << "~";
        }else if (node.getOperation() == "not"){
            this->ss << "!(";
        }else this->ss << node.getOperation() << "(";
        node.getExpr()->accept(*this);
        this->ss << ")";
}

void SCAM::DatapathVisitorVLI::visit(SCAM::Logical &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "and") {
        this->ss << " && ";
    } else if (node.getOperation() == "or") {
        this->ss << " || ";
    } else {
        this->ss << " " + node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    if (tempUseParentheses) this->ss << ")";
}

void SCAM::DatapathVisitorVLI::visit(EnumValue &node) {
    useParenthesesFlag = true;
    this->ss << convertToLower(node.getEnumValue());
}

std::string SCAM::DatapathVisitorVLI::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}
