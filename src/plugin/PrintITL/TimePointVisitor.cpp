//
// Created by lucas on 28.01.20.
//

#include "TimePointVisitor.h"
#include "FatalError.h"
#include "Logger/Logger.h"


void SCAM::TimePointVisitor::visit(SCAM::VariableOperand &node) {

    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isCompoundType()) {
            this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getVariable()->getParent()->getName() << "(" << node.getVariable()->getName() << ")";
        } else TERMINATE(" Unknown ");

    } else {
        this->ss << node.getVariable()->getName();
    }
}

void SCAM::TimePointVisitor::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void SCAM::TimePointVisitor::visit(SCAM::DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isArrayType()) {
            this->ss << node.getDataSignal()->getParent()->getName() << "(" << node.getDataSignal()->getName() << ")";
        } else {
            this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName();
        }
    } else {
        this->ss << node.getDataSignal()->getName();
    }
}

std::string SCAM::TimePointVisitor::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    TimePointVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::TimePointVisitor::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        this->ss << " = ";
    } else if (node.getOperation() == "!=") {
        this->ss << " /= ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}


void SCAM::TimePointVisitor::visit(SCAM::Arithmetic &node) {
    //TODO: Removing the brackets could lead to wrong expressions
    //this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "%") {
        this->ss << " mod ";
    } else if (node.getOperation() == "/") {
        this->ss << " div ";
    } else this->ss << node.getOperation();
    node.getRhs()->accept(*this);
    //this->ss << ")";

}

void SCAM::TimePointVisitor::visit(SCAM::Bitwise &node) {
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
        } else TERMINATE("Should not get here");
        node.getRhs()->accept(*this);
        this->ss << ")";
    }
}

void SCAM::TimePointVisitor::visit(SCAM::UnsignedValue &node) {
    this->ss << node.getValueAsString();
}

void SCAM::TimePointVisitor::visit(SCAM::IntegerValue &node) {
    this->ss << node.getValueAsString();
}

void SCAM::TimePointVisitor::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitor::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::TimePointVisitor::visit(SCAM::ITE &node) {
    /*
     * if (print condition) {
     *   print stmts
     * } else {
     *   print stmts
     * }
     *
     */

    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ") then" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        std::string statementstring = TimePointVisitor::toString(stmt, indentSize, indent);
        this->ss << statementstring;
        if (statementstring.find('\n') == std::string::npos) this->ss << ";";
        this->ss << std::endl;
    }
    indent -= indentSize;
    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
    this->ss << "";
    if (!node.getElseList().empty()) {
        this->ss << " else " << std::endl;
        indent += indentSize;
        for (auto stmt: node.getElseList()) {
            for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
            std::string statementstring = TimePointVisitor::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void SCAM::TimePointVisitor::visit(SCAM::Assignment &node) {
    PrintStmt::visit(node);
}

void SCAM::TimePointVisitor::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitor::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::TimePointVisitor::visit(SCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if (param->isSubVar()) {
        this->ss << param->getParent()->getName() << "_" << param->getName();
    } else this->ss << param->getName();
}

void SCAM::TimePointVisitor::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}



void SCAM::TimePointVisitor::visit(SCAM::ArrayExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}


void SCAM::TimePointVisitor::visit(SCAM::UnaryExpr &node) {
    useParenthesesFlag = true;
    if(node.getOperation() == "~") {
        this->ss << "not(";
    }else this->ss << node.getOperation() << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitor::visit(SCAM::Timepoint &node) {
    this->ss << node.getName();
}