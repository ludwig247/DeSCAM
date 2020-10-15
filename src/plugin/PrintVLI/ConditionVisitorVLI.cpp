//
// Created by ludwig on 31.08.16.
//

#include "ConditionVisitorVLI.h"


void SCAM::ConditionVisitorVLI::visit(SCAM::VariableOperand &node) {

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

void SCAM::ConditionVisitorVLI::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
}

void SCAM::ConditionVisitorVLI::visit(SCAM::DataSignalOperand &node) {
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

std::string SCAM::ConditionVisitorVLI::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ConditionVisitorVLI printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Relational &node) {
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


void SCAM::ConditionVisitorVLI::visit(SCAM::Arithmetic &node) {
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

void SCAM::ConditionVisitorVLI::visit(SCAM::Bitwise &node) {
    if (node.getOperation() == "<<") {
        this->ss << "((";
        node.getLhs()->accept(*this);
        this->ss << ")";
//        if(node.getLhs()->getDataType()->isInteger())
//            this->ss << " <<< ";
//        else
        this->ss << " << ";
        this->ss << "(";
        node.getRhs()->accept(*this);
        this->ss << "))";
    } else if (node.getOperation() == ">>") {
        this->ss << "((";
        node.getLhs()->accept(*this);
        this->ss << ")";
//        if(node.getLhs()->getDataType()->isInteger())
//            this->ss << " >>> ";
//        else
        this->ss << " >> ";
        this->ss << "(";
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

void SCAM::ConditionVisitorVLI::visit(SCAM::UnsignedValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void SCAM::ConditionVisitorVLI::visit(SCAM::IntegerValue &node) {
    //if(this->resize_flag){
    //FIXME: remove once concat is present?
    this->ss << "resize(" << node.getValueAsString() << ",32)";
    //}else this->ss << node.getValue();
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Cast &node) {
    if (node.getDataType()->isUnsigned()) {
        this->ss << "unsigned(";
    } else if (node.getDataType()->isInteger()) {
        this->ss << "signed(";
    } else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::ConditionVisitorVLI::visit(SCAM::ITE &node) {
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
        std::string statementstring = ConditionVisitorVLI::toString(stmt, indentSize, indent);
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
            std::string statementstring = ConditionVisitorVLI::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "endif;";
    }

}

void SCAM::ConditionVisitorVLI::visit(SCAM::Assignment &node) {
    useParenthesesFlag = true;
    if (node.getLhs() != nullptr) {
        node.getLhs()->accept(*this);
    }

    this->ss << " == ";
    if (node.getRhs() != nullptr) {
        node.getRhs()->accept(*this);
    }
}

void SCAM::ConditionVisitorVLI::visit(SCAM::ArrayOperand &node) {
    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "(";
    node.getIdx()->accept(*this);
    this->ss << ")";
}

void SCAM::ConditionVisitorVLI::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}

void SCAM::ConditionVisitorVLI::visit(SCAM::ParamOperand &node) {
    auto param = node.getParameter();
    if (param->isSubVar()) {
        this->ss << param->getParent()->getName() << "_" << param->getName();
    } else this->ss << param->getName();
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
}



void SCAM::ConditionVisitorVLI::visit(SCAM::ArrayExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
}


void SCAM::ConditionVisitorVLI::visit(SCAM::UnaryExpr &node) {
    useParenthesesFlag = true;
    if(node.getOperation() == "~") {
        this->ss << "~";
    }else if (node.getOperation() == "not"){
        this->ss << "!(";
    }else this->ss << node.getOperation() << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Timepoint &node) {
    this->ss << node.getName();
}

void SCAM::ConditionVisitorVLI::visit(SCAM::Logical &node) {
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

void SCAM::ConditionVisitorVLI::visit(EnumValue &node) {
    useParenthesesFlag = true;
    this->ss << convertToLower(node.getEnumValue());
}

std::string SCAM::ConditionVisitorVLI::convertToLower(const std::string &in_string) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : in_string)
        ret << std::tolower(i, loc);
    return ret.str();
}
