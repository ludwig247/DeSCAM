//
// Created by ludwig on 31.08.16.
//

#include "ConditionVisitor2.h"


void SCAM::ConditionVisitor2::visit(SCAM::VariableOperand &node) {

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

void SCAM::ConditionVisitor2::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void SCAM::ConditionVisitor2::visit(SCAM::DataSignalOperand &node) {
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

std::string SCAM::ConditionVisitor2::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ConditionVisitor2 printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::ConditionVisitor2::visit(SCAM::Relational &node) {
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


void SCAM::ConditionVisitor2::visit(SCAM::Arithmetic &node) {
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

void SCAM::ConditionVisitor2::visit(SCAM::Bitwise &node) {
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

void SCAM::ConditionVisitor2::visit(SCAM::UnsignedValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void SCAM::ConditionVisitor2::visit(SCAM::IntegerValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void SCAM::ConditionVisitor2::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ConditionVisitor2::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::ConditionVisitor2::visit(SCAM::ITE &node) {
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
        std::string statementstring = ConditionVisitor2::toString(stmt, indentSize, indent);
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
            std::string statementstring = ConditionVisitor2::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void SCAM::ConditionVisitor2::visit(SCAM::Assignment &node) {
    PrintStmt::visit(node);
    this->ss << ";\n";
}

void SCAM::ConditionVisitor2::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}

void SCAM::ConditionVisitor2::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::ConditionVisitor2::visit(SCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if (param->isSubVar()) {
        this->ss << param->getParent()->getName() << "_" << param->getName();
    } else this->ss << param->getName();
}

void SCAM::ConditionVisitor2::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}

void SCAM::ConditionVisitor2::visit(SCAM::TimePointOperand &node) {

        this->ss << node.getTimepoint()->getName();

}
