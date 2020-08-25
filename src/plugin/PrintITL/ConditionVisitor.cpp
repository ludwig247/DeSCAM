//
// Created by ludwig on 31.08.16.
//

#include "ConditionVisitor.h"
#include "FatalError.h"
#include "Logger/Logger.h"



void DESCAM::ConditionVisitor::visit(DESCAM::VariableOperand &node) {

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

void DESCAM::ConditionVisitor::visit(DESCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void DESCAM::ConditionVisitor::visit(DESCAM::DataSignalOperand &node) {
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

std::string DESCAM::ConditionVisitor::toString(DESCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ConditionVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void DESCAM::ConditionVisitor::visit(DESCAM::Relational &node) {
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


void DESCAM::ConditionVisitor::visit(DESCAM::Arithmetic &node) {
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

void DESCAM::ConditionVisitor::visit(DESCAM::Bitwise &node) {
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

void DESCAM::ConditionVisitor::visit(DESCAM::UnsignedValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void DESCAM::ConditionVisitor::visit(DESCAM::IntegerValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void DESCAM::ConditionVisitor::visit(DESCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::ConditionVisitor::visit(DESCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void DESCAM::ConditionVisitor::visit(DESCAM::ITE &node) {
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
        std::string statementstring = ConditionVisitor::toString(stmt, indentSize, indent);
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
            std::string statementstring = ConditionVisitor::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void DESCAM::ConditionVisitor::visit(DESCAM::Assignment &node) {
    PrintStmt::visit(node);
}

void DESCAM::ConditionVisitor::visit(DESCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

void DESCAM::ConditionVisitor::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void DESCAM::ConditionVisitor::visit(DESCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if (param->isSubVar()) {
        this->ss << param->getParent()->getName() << "_" << param->getName();
    } else this->ss << param->getName();
}

void DESCAM::ConditionVisitor::visit(DESCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}



void DESCAM::ConditionVisitor::visit(DESCAM::ArrayExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}


void DESCAM::ConditionVisitor::visit(DESCAM::UnaryExpr &node) {
    useParenthesesFlag = true;
    if(node.getOperation() == "~") {
        this->ss << "not(";
    }else this->ss << node.getOperation() << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void DESCAM::ConditionVisitor::visit(DESCAM::Timepoint &node) {
    this->ss << node.getName();
}


