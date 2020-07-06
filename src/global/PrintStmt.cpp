//
// Created by joakim on 11/9/16.
//


#include <assert.h>
#include "PrintStmt.h"


void SCAM::PrintStmt::visit(VariableOperand &node) {
    useParenthesesFlag = true;
    if (node.getVariable()->isSubVar()) {
        if (node.getVariable()->getParent()->isCompoundType()) {
            this->ss << node.getVariable()->getParent()->getName() << "." << node.getVariable()->getName();
        } else if (node.getVariable()->getParent()->isArrayType()) {
            this->ss << node.getVariable()->getParent()->getName() << "[" << node.getVariable()->getName() << "]";
        } else throw std::runtime_error("Unknown Type for SubVar");
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

        if (std::next(iterator) != node.getValues().end()) this->ss << ", ";
    }
    this->ss << "}";
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

    if (node.isBlocking()) {
        if (node.isNonBlockingAccess()) {
            this->ss << ".try_read(";
            node.getVariableOperand()->accept(*this);
            if (node.getStatusOperand() != nullptr) {
                this->ss << ",";
                node.getStatusOperand()->accept(*this);
            }
        } else {
            this->ss << ".read(";
            node.getVariableOperand()->accept(*this);
        }
    } else if (node.isMaster()) {
        this->ss << ".master_read(";
        node.getVariableOperand()->accept(*this);
    } else if (node.isSlave()) {
        this->ss << ".slave_read(";
        node.getVariableOperand()->accept(*this);
        if (node.getStatusOperand() != nullptr) {
            this->ss << ",";
            node.getStatusOperand()->accept(*this);
        }
    } else if (node.isShared()) {
        this->ss << ".get(";
        node.getVariableOperand()->accept(*this);
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
    this->ss << ")";
}

void SCAM::PrintStmt::visit(Write &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName();
    if (node.isBlocking()) {
        if (node.isNonBlockingAccess()) {
            this->ss << ".try_write(";
            node.getValue()->accept(*this);
            if (node.getStatusOperand() != nullptr) {
                this->ss << ",";
                node.getStatusOperand()->accept(*this);
            }
        } else {
            this->ss << ".write(";
            node.getValue()->accept(*this);
        }
    } else if (node.isMaster()) {
        this->ss << ".master_write(";
        node.getValue()->accept(*this);
    } else if (node.isSlave()) {
        this->ss << ".slave_write(";
        node.getValue()->accept(*this);
    } else if (node.isShared()) {
        this->ss << ".set(";
        node.getValue()->accept(*this);
    } else throw std::runtime_error("Unknown interface: " + node.getPort()->getInterface()->getName());
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
        if (begin != --paramMap.end()) this->ss << ",";
    }
    this->ss << ")";
}

void SCAM::PrintStmt::visit(SyncSignal &node) {
    useParenthesesFlag = true;
    if(node.getPort()) {
        this->ss << node.getPort()->getName() << ".sync()";
    }
    else{
        this->ss << node.getPortname()<< ".sync()";
    }
}

void SCAM::PrintStmt::visit(DataSignalOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getDataSignal()->getPort()->getName() << "_sig";
    if (node.getDataSignal()->isSubVar()) {
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
    return printer.createString(const_cast<Stmt *>(stmt), indentSize, indentOffset);
}

void SCAM::PrintStmt::visit(SCAM::ArrayOperand &node) {
    useParenthesesFlag = true;

    this->ss << node.getArrayOperand()->getOperandName();
    this->ss << "[";
    node.getIdx()->accept(*this);
    this->ss << "]";
}

void SCAM::PrintStmt::visit(struct CompoundExpr &node) {
    useParenthesesFlag = true;
    this->ss << "{";
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
    this->ss << "}";

}

void SCAM::PrintStmt::visit(SCAM::ParamOperand &node) {
    useParenthesesFlag = true;
    this->ss << node.getOperandName();
}

void SCAM::PrintStmt::visit(SCAM::Return &node) {
    useParenthesesFlag = true;
//    if(node.getReturnValue() != nullptr) {
//        this->ss << "return(";
//        node.getReturnValue()->accept(*this);
//        this->ss << ")";
//    }
//    else{
        this->ss << node.getFunctionName();
//    }
}

void SCAM::PrintStmt::visit(SCAM::Notify &node) {
    useParenthesesFlag = true;
    if(node.getPort() != nullptr) {
        this->ss << node.getPort()->getName() << "_notify";
    }
    else{
        this->ss << node.getEventname();
    }
}

void SCAM::PrintStmt::visit(SCAM::Wait &node) {
    this->ss << "wait(SC_ZERO_TIME)";
}

void SCAM::PrintStmt::visit(SCAM::Peek &node) {
    useParenthesesFlag = true;
    this->ss << node.getPort()->getName() << ".sync()";
}

void SCAM::PrintStmt::visit(SCAM::ArrayExpr &node) {

    useParenthesesFlag = true;
    this->ss << "[";
    auto valueMap = node.getValueMap();
    for (auto begin = valueMap.begin(); begin != valueMap.end(); ++begin) {
        begin->second->accept(*this);
        if (begin != --valueMap.end()) this->ss << ",";
    }
    this->ss << "]";
}


void SCAM::PrintStmt::visit(TimePointOperand &node) {
    this->ss << node.getTimepoint()->getName();
}

void SCAM::PrintStmt::visit(SCAM::Ternary &node) {

    this->ss << "(";
    node.getCondition()->accept(*this);
    this->ss << ")?";
    node.getTrueExpr()->accept(*this);
    this->ss << ":";
    node.getFalseExpr()->accept(*this);


}
