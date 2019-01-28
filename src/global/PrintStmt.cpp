//
// Created by joakim on 11/9/16.
//


#include <assert.h>
#include "PrintStmt.h"


void SCAM::PrintStmt::visit(VariableOperand &node) {
    useParenthesesFlag = true;
    if (node.getVariable()->isSubVar()) {
        this->ss << node.getVariable()->getParent()->getName() << "." << node.getVariable()->getName();
    } else {
        this->ss << node.getVariable()->getName();
    }
}

void SCAM::PrintStmt::visit(IntegerValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getValue();

}

void SCAM::PrintStmt::visit(SCAM::UnsignedValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getValue();
}

void SCAM::PrintStmt::visit(BoolValue &node) {
    useParenthesesFlag = true;
    if (node.getValue()) {
        this->ss << "true";
    } else {
        this->ss << "false";
    }
}


void SCAM::PrintStmt::visit(EnumValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getEnumValue();

}

void SCAM::PrintStmt::visit(SCAM::CompoundValue &node) {
    useParenthesesFlag = true;
    this->ss << "{";
    for (auto iterator = node.getValues().begin(); iterator != node.getValues().end(); ++iterator) {
        (*iterator).second->accept(*this);

        if(iterator != (node.getValues().end()--)) this->ss << ",";
    } this->ss << "}";
}


void SCAM::PrintStmt::visit(SCAM::Assignment &node) {
    useParenthesesFlag = true;
    //FIXME: not necssary
    if (node.getLhs() != nullptr) {
        node.getLhs()->accept(*this);
    }

    this->ss << " = ";
    if (node.getRhs() != nullptr) {
        node.getRhs()->accept(*this);
    }
}

void SCAM::PrintStmt::visit(Arithmetic &node) {
    useParenthesesFlag = true;
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}


void SCAM::PrintStmt::visit(Logical &node) {
    bool tempUseParentheses = useParenthesesFlag;
    useParenthesesFlag = true;
    if (tempUseParentheses) this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    if (tempUseParentheses) this->ss << ")";
}

void SCAM::PrintStmt::visit(Relational &node) {
    useParenthesesFlag = true;
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(SCAM::Bitwise &node) {
    useParenthesesFlag = true;
    this->ss << "(";
    node.getLhs()->accept(*this);
    this->ss << " " + node.getOperation() << " ";
    node.getRhs()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(PortOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
}


void SCAM::PrintStmt::visit(UnaryExpr &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperation() << "(";
    node.getExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(Read &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
    auto interface = node.getPort()->getInterface()->getName();
    if ( interface == "blocking" || interface == "master" || interface == "slave") {
        this->ss << ".read(";
        node.getVariableOperand()->accept(*this);
    } else if (interface == "synch") {
        this->ss << ".req(";
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
    this->ss << ")";
}


void SCAM::PrintStmt::visit(Write &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
    auto interface = node.getPort()->getInterface()->getName();
    if ( interface == "blocking" || interface == "master") {
        this->ss << ".write(";
        node.getValue()->accept(*this);
    } else if (interface == "synch") {
        this->ss << ".ack(";

    } else if(interface == "slave"){ //FIXME: this belongs to NBWRITE?
        this->ss << ".nb_write(";
        node.getValue()->accept(*this);
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
    this->ss << ")";
}

void SCAM::PrintStmt::visit(NBRead &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
    if (node.getPort()->getInterface()->getName() == "shared") {
        this->ss << ".get(";
    } else if (node.getPort()->getInterface()->isBlocking()) {
        this->ss << ".nb_read(";
    } else if (node.getPort()->getInterface()->isSlave()) {
        this->ss << ".nb_read(";
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
    node.getVariableOperand()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(NBWrite &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
    if (node.getPort()->getInterface()->getName() == "shared") {
        this->ss << ".set(";
    } else if (node.getPort()->getInterface()->isBlocking()) {
        this->ss << ".nb_write(";
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
    node.getValue()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(While &node) {
    useParenthesesFlag = true;
    this->ss << "while (";
    node.getConditionStmt()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(If &node) {
    useParenthesesFlag = true;
    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(SectionOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getName();
}

void SCAM::PrintStmt::visit(SectionValue &node) {
    useParenthesesFlag = true;
    this->ss << node.getValue();
}


void SCAM::PrintStmt::visit(ITE &node) {
    useParenthesesFlag = true;

    /*
     * if (print condition) {
     *   print stmts
     * } else {
     *   print stmts
     * }
     * */

    this->ss << "if (";
    node.getConditionStmt()->accept(*this);
    this->ss << ") {" << std::endl;
    indent += indentSize;
    for (auto stmt: node.getIfList()) {
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        std::string statementstring = PrintStmt::toString(stmt, indentSize, indent);
        this->ss << statementstring;
        if (statementstring.find('\n') == std::string::npos) this->ss << ";";
        this->ss << std::endl;
    }
    indent -= indentSize;
    for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
    this->ss << "}";
    if (!node.getElseList().empty()) {
        this->ss << " else {" << std::endl;
        indent += indentSize;
        for (auto stmt: node.getElseList()) {
            for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
            std::string statementstring = PrintStmt::toString(stmt, indentSize, indent);
            this->ss << statementstring;
            if (statementstring.find('\n') == std::string::npos) this->ss << ";";
            this->ss << std::endl;
        }
        indent -= indentSize;
        for (int i = 0; i < indent; ++i) { this->ss << " "; } //add indent
        this->ss << "}";
    }
}

void SCAM::PrintStmt::visit(Cast &node) {
    useParenthesesFlag = true;
    this->ss << "to_" << node.getDataType()->getName() << "(";
    node.getSubExpr()->accept(*this);
    this->ss << ")";
}

void SCAM::PrintStmt::visit(SCAM::FunctionOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperandName() << "(";
    auto paramMap = node.getParamValueMap();
    for (auto begin = paramMap.begin(); begin != paramMap.end(); ++begin) {
        begin->second->accept(*this);
        if(begin != --paramMap.end()) this->ss << ",";
    }
    this->ss << ")";
}

void SCAM::PrintStmt::visit(SyncSignal &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName() << ".sync()";
}

void SCAM::PrintStmt::visit(DataSignalOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubSig()) {
        this->ss << "[" + node.getDataSignal()->getName() << "]";
    }
}

std::string SCAM::PrintStmt::createString(SCAM::Stmt *stmt, unsigned int size, unsigned int offset) {

    this->indent = offset;
    this->indentSize = size;
    stmt->accept(*this);
    return this->ss.str();
}

std::string SCAM::PrintStmt::toString(SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintStmt printer;
    return printer.createString(stmt, indentSize, indentOffset);
}

std::string SCAM::PrintStmt::toString(const SCAM::Stmt *stmt, unsigned int indentSize, unsigned int indentOffset) {
    PrintStmt printer;
    return printer.createString(const_cast<Stmt*>(stmt), indentSize, indentOffset);
}

void SCAM::PrintStmt::visit(SCAM::SubSelect &node) {
    useParenthesesFlag = true;
    node.getOperand()->accept(*this);
    this->ss << "." << node.getSub();

}

void SCAM::PrintStmt::visit(struct CompoundExpr &node) {
    useParenthesesFlag = true;
    this->ss << "{";
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if(begin != --valueMap.end()) this->ss << ",";
    }
    this->ss << "}";

}

void SCAM::PrintStmt::visit(SCAM::ParamOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperandName();
}

void SCAM::PrintStmt::visit(SCAM::Return &node) {
    useParenthesesFlag = true;
    this->ss << "return(";
    node.getReturnValue()->accept(*this);
    this->ss << ")";
}







