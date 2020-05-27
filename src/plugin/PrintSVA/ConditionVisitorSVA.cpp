//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "ConditionVisitorSVA.h"
#include "FatalError.h"
#include "Logger/Logger.h"


void DESCAM::ConditionVisitorSVA::visit(DESCAM::VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
    this->ss << "()";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
    this->ss << "()";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        this->ss << node.getDataSignal()->getParent()->getName() << "_" << node.getDataSignal()->getName();
    } else {
        this->ss << node.getDataSignal()->getName();
    }
    this->ss << "()";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Relational &node) {
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

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Bitwise &node) {
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

void DESCAM::ConditionVisitorSVA::visit(DESCAM::UnsignedValue &node) {
    this->ss << node.getValue();
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::IntegerValue &node) {
    this->ss << node.getValue();
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned'(32'(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed'(32'(";
    } else TERMINATE("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << "))";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::ITE &node) {

    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ") then" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        std::string statementstring = ConditionVisitorSVA::toString(stmt, indentSize, indent);
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
            std::string statementstring = ConditionVisitorSVA::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Assignment &node) {
    if (node.getLhs() != nullptr)
        node.getLhs()->accept(*this);

    this->ss << " == ";
    if (node.getRhs() != nullptr)
        node.getRhs()->accept(*this);
}


void DESCAM::ConditionVisitorSVA::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}


void DESCAM::ConditionVisitorSVA::visit(BoolValue &node) {
    if (node.getValue())
        this->ss << "1";
    else
        this->ss << "0";
}

void DESCAM::ConditionVisitorSVA::visit(Logical &node) {
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

void DESCAM::ConditionVisitorSVA::visit(UnaryExpr &node) {
    if (node.getOperation() == "not") {
        this->ss << "!";
    } else if (node.getOperation() == "-") {
        this->ss << node.getOperation();
    }
    this->ss << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}


std::string DESCAM::ConditionVisitorSVA::toString(DESCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ConditionVisitorSVA printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify()";
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::ParamOperand &node) {
    if (node.getParameter()->isSubVar()) {
        this->ss << node.getParameter()->getParent()->getName();
        this->ss << "_";
        this->ss << node.getParameter()->getName();
    } else {
        this->ss << node.getOperandName();
    }
    useParenthesesFlag = true;
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Timepoint &node) {
    this->ss << node.getName();
    if (node.getName() != "t") {
        this->ss << "(o)";
    }
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::TimePointOperand &node) {
    this->ss << node.getOperandName();
    if (node.getOperandName() != "t") {
        this->ss << "(o)";
    }
}

void DESCAM::ConditionVisitorSVA::visit(DESCAM::Ternary &node) {
    this->ss << "(";
    node.getCondition()->accept(*this);
    this->ss << "?";
    node.getTrueExpr()->accept(*this);
    this->ss << ":";
    node.getFalseExpr()->accept(*this);
    this->ss << ")";

}

