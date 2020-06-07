//
// Created by lucas on 28.01.20.
//

#include "TimePointVisitorVLI.h"

void SCAM::TimePointVisitorVLI::visit(SCAM::VariableOperand &node) {

    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isCompoundType()) {
            this->ss << node.getVariable()->getParent()->getName() << "_" << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getVariable()->getParent()->getName() << "(" << node.getVariable()->getName() << ")";
        } else throw std::runtime_error(" Unknown ");

    } else {
        this->ss << node.getVariable()->getName();
    }
}

void SCAM::TimePointVisitorVLI::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void SCAM::TimePointVisitorVLI::visit(SCAM::DataSignalOperand &node) {
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

std::string SCAM::TimePointVisitorVLI::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    TimePointVisitorVLI printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if (node.getOperation() == "==") {
        this->ss << " == ";
    } else if (node.getOperation() == "!=") {
        this->ss << " != ";
    } else {
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}


void SCAM::TimePointVisitorVLI::visit(SCAM::Arithmetic &node) {
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

void SCAM::TimePointVisitorVLI::visit(SCAM::Bitwise &node) {
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

void SCAM::TimePointVisitorVLI::visit(SCAM::UnsignedValue &node) {
    this->ss << node.getValueAsString();
}

void SCAM::TimePointVisitorVLI::visit(SCAM::IntegerValue &node) {
    this->ss << node.getValueAsString();
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::TimePointVisitorVLI::visit(SCAM::ITE &node) {
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
    this->ss << ")" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        std::string statementstring = TimePointVisitorVLI::toString(stmt, indentSize, indent);
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
            std::string statementstring = TimePointVisitorVLI::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "endif;";
    }

}

void SCAM::TimePointVisitorVLI::visit(SCAM::Assignment &node) {
    PrintStmt::visit(node);
}

void SCAM::TimePointVisitorVLI::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitorVLI::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::TimePointVisitorVLI::visit(SCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if (param->isSubVar()) {
        this->ss << param->getParent()->getName() << "_" << param->getName();
    } else this->ss << param->getName();
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}



void SCAM::TimePointVisitorVLI::visit(SCAM::ArrayExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}


void SCAM::TimePointVisitorVLI::visit(SCAM::UnaryExpr &node) {
    useParenthesesFlag = true;
    if(node.getOperation() == "~") {
        this->ss << "~";
    }else if (node.getOperation() == "not"){
        this->ss << "!(";
    }else this->ss << node.getOperation() << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Timepoint &node) {
    this->ss << node.getName();
}

void SCAM::TimePointVisitorVLI::visit(SCAM::Logical &node) {
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

void SCAM::TimePointVisitorVLI::visit(EnumValue &node) {
    useParenthesesFlag = true;
    this->ss << convertToLower(node.getEnumValue());
}

std::string SCAM::TimePointVisitorVLI::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}