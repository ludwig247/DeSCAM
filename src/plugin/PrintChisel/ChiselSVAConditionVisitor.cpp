//
// Created by lukas on 01.04.19.
//

#include "ChiselSVAConditionVisitor.h"


void SCAM::ChiselSVAConditionVisitor::visit(SCAM::VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() <<"_"  << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
    this->ss << "()";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::SyncSignal &node) {
    this->ss << node.getPort()->getName() << "_sync";
    this->ss << "()";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Notify &node) {
    this->ss << node.getPort()->getName() << "_notify";
    this->ss << "()";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        this->ss << node.getDataSignal()->getParent()->getName() << "_"  << node.getDataSignal()->getName();
    } else {
        this->ss << node.getDataSignal()->getName();
    }
    this->ss << "()";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Relational &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    if(node.getOperation() == "=="){
        this->ss << " == ";
    }else{
        this->ss << " " << node.getOperation() << " ";
    }
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Arithmetic &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Bitwise &node) {
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

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::UnsignedValue &node) {
    this->ss << node.getValue();
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::IntegerValue &node) {
    this->ss << node.getValue();
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Cast &node) {
    if(node.getDataType()->isUnsigned()){
        this->ss << "unsigned'(32'(";
    }else if(node.getDataType()->isInteger()){
        this->ss << "signed'(32'(";
    }else throw std::runtime_error("Unsupported type for cast");
    node.getSubExpr()->accept(*this);
    this->ss << "))";
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::ITE &node) {
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
        std::string statementstring = ChiselSVAConditionVisitor::toString(stmt, indentSize, indent);
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
            std::string statementstring = ChiselSVAConditionVisitor::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "end if;";
    }

}

void SCAM::ChiselSVAConditionVisitor::visit(SCAM::Assignment &node) {
    if (node.getLhs() != nullptr)
        node.getLhs()->accept(*this);

    this->ss << " == ";
    if (node.getRhs() != nullptr)
        node.getRhs()->accept(*this);
}


void SCAM::ChiselSVAConditionVisitor::visit(struct CompoundExpr &node) {
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if(begin != --valueMap.end()) this->ss << ",";
    }
}



void SCAM::ChiselSVAConditionVisitor::visit(BoolValue &node) {
    if (node.getValue())
        this->ss << "1";
    else
        this->ss << "0";
}

void SCAM::ChiselSVAConditionVisitor::visit(EnumValue &node) {
    std::locale loc;
    std::string str = node.getEnumValue();
    for (char i : str)
        this->ss << std::tolower(i,loc);
}

void SCAM::ChiselSVAConditionVisitor::visit(Logical &node) {
    this->ss << "(";
    node.getLhs()->accept(*this);

    this->ss << " ";
    if(node.getOperation()=="and"){
        this->ss << "&&";
    }else if (node.getOperation()=="nand"){
        this->ss << "nand";
    }else if (node.getOperation()=="or"){
        this->ss << "||";
    }else if (node.getOperation()=="nor"){
        this->ss << "nor";
    }else if (node.getOperation()=="xor") {
        this->ss << "^";
    }else if (node.getOperation()=="xnor"){
        this->ss << "xnor";
    }
    this->ss << " ";

    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::ChiselSVAConditionVisitor::visit(UnaryExpr &node) {
    if(node.getOperation() == "not"){
        this->ss << "!";
    }else if (node.getOperation() == "-"){
        this->ss << node.getOperation();
    }
    this->ss << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}



std::string SCAM::ChiselSVAConditionVisitor::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    ChiselSVAConditionVisitor printer;
    return printer.createString(stmt, indentSize, indentOffset);
}
