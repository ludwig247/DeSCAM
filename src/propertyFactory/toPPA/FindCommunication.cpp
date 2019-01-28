//
// Created by tobias on 13.07.16.
//

#include "FindCommunication.h"


SCAM::FindCommunication::FindCommunication() :
        communication(false),
        commStmt(nullptr),
        writeValue(nullptr),
        non_blocking_access(false),
        stmt(nullptr){

}

SCAM::FindCommunication::~FindCommunication() {

}


void SCAM::FindCommunication::visit(struct VariableOperand &node) {
    communication = false;
}


void SCAM::FindCommunication::visit(struct IntegerValue &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct UnsignedValue &node) {
    communication = false;
}
void SCAM::FindCommunication::visit(struct EnumValue &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct BoolValue &node) {
    communication = false;

}

void SCAM::FindCommunication::visit(struct PortOperand &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct Assignment &node) {

    node.getRhs()->accept(*this);
}


void SCAM::FindCommunication::visit(struct FunctionOperand &node) {
    communication = false;

}

void SCAM::FindCommunication::visit(struct UnaryExpr &node) {
    FindCommunication conditionChecker;
    node.getExpr()->accept(conditionChecker);
    if (conditionChecker.isCommunication()) throw std::runtime_error("Interfaces in unary operator not supported");
    communication = false;
}


void SCAM::FindCommunication::visit(struct While &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct If &node) {
    FindCommunication conditionChecker;
    node.getConditionStmt()->accept(conditionChecker);
    if (conditionChecker.isCommunication()) throw std::runtime_error("Interfaces in if condition not supported");
    communication = false;

}


void SCAM::FindCommunication::visit(struct SectionOperand &node) {
    communication = false;

}

void SCAM::FindCommunication::visit(struct SectionValue &node) {
    communication = false;

}

void SCAM::FindCommunication::visit(struct ITE &node) {
    communication = false;

}

void SCAM::FindCommunication::visit(struct Arithmetic &node) {
    communication = false;
    node.getLhs()->accept(*this);
    if (communication) return;
    node.getRhs()->accept(*this);
}

SCAM::Expr *SCAM::FindCommunication::getWriteValue() const {
    return writeValue;
}

bool SCAM::FindCommunication::isCommunication() const {
    return communication;
}

bool SCAM::FindCommunication::isBlockingInterface() const {
    if(this->isCommunication()) return this->commStmt->isBlocking();
    return false;
}

SCAM::Communication * SCAM::FindCommunication::getCommStmt() const {
    return commStmt;
}

bool SCAM::FindCommunication::isRead() const {
    if(this->isCommunication()) return this->commStmt->isRead();
    return false;
}

bool SCAM::FindCommunication::isWrite() const {
    if(this->isCommunication()) return this->commStmt->isWrite();
    return false;
}


void SCAM::FindCommunication::visit(struct Logical &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct Relational &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct Bitwise &node) {
    communication = false;
}


void SCAM::FindCommunication::visit(struct Read &node) {
    communication = true;
    this->commStmt = &node;
    this->stmt = &node;
}

void SCAM::FindCommunication::visit(struct Write &node) {
    communication = true;
    this->commStmt = &node;
    this->stmt = &node;
    this->writeValue = node.getValue();

}

void SCAM::FindCommunication::visit(struct NBRead &node) {
    communication = true;
    this->non_blocking_access = true;
    this->commStmt = &node;
    this->stmt = &node;

}

void SCAM::FindCommunication::visit(struct NBWrite &node) {
    communication = true;
    this->non_blocking_access = true;
    this->commStmt = &node;
    this->stmt = &node;
    this->writeValue = node.getValue();


}

void SCAM::FindCommunication::visit(struct SyncSignal &node) {
    communication = false;
    communication = false;
}

void SCAM::FindCommunication::visit(struct Cast &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(struct DataSignalOperand &node) {
    communication = false;
    communication = false;
}

SCAM::Port *SCAM::FindCommunication::getPort() const {
    if(!this->isCommunication()) throw std::runtime_error("Not a communication stmt! No port available");
    return this->commStmt->getPort();

}

SCAM::Stmt *SCAM::FindCommunication::getStmt() const {
    return this->stmt;
}

bool SCAM::FindCommunication::isShared() const {
    if(this->isCommunication()) return this->commStmt->isShared();
    return false;
}

void SCAM::FindCommunication::visit(struct CompoundValue &node) {
    communication = false;
}

bool SCAM::FindCommunication::isMaster() const {
    if(this->isCommunication()) return this->commStmt->isMaster();
    return false;
}

bool SCAM::FindCommunication::isNonBlockingAccess() const {
    return non_blocking_access;
}

void SCAM::FindCommunication::visit(SCAM::SubSelect &node) {
    communication = false;
}

void SCAM::FindCommunication::visit(SCAM::CompoundExpr &node) {
    throw std::runtime_error(" Not implemented");

}

void SCAM::FindCommunication::visit(SCAM::ParamOperand &node) {
    throw std::runtime_error(" Not implemented");

}

void SCAM::FindCommunication::visit(SCAM::Return &node) {
    throw std::runtime_error(" Not implemented");

}
