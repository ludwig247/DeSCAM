//
// Created by tobias on 13.07.16.
//

#include "FindCommunication2.h"
#include "FatalError.h"
#include "Logger/Logger.h"



DESCAM::FindCommunication2::FindCommunication2() :
        waitComm(false),
        communication(false),
        commStmt(nullptr),
        writeValue(nullptr),
        readVariable(nullptr),
        non_blocking_access(false),
        stmt(nullptr){

}

DESCAM::FindCommunication2::~FindCommunication2() = default;


bool DESCAM::FindCommunication2::isWaitComm() const {
    return waitComm;
}

bool DESCAM::FindCommunication2::isCommunication() const {
    return communication;
}

bool DESCAM::FindCommunication2::isBlockingInterface() const {
    if(this->isCommunication()) return this->commStmt->isBlocking();
    return false;
}

bool DESCAM::FindCommunication2::isMaster() const {
    if(this->isCommunication()) return this->commStmt->isMaster();
    return false;
}

bool DESCAM::FindCommunication2::isSlave() const {
    if(this->isCommunication()) return this->commStmt->isSlave();
    return false;
}

bool DESCAM::FindCommunication2::isShared() const {
    if(this->isCommunication()) return this->commStmt->isShared();
    return false;
}

bool DESCAM::FindCommunication2::isRead() const {
    if(this->isCommunication()) return this->commStmt->isRead();
    return false;
}

bool DESCAM::FindCommunication2::isWrite() const {
    if(this->isCommunication()) return this->commStmt->isWrite();
    return false;
}

bool DESCAM::FindCommunication2::isNonBlockingAccess() const {
    return non_blocking_access;
}

DESCAM::Communication * DESCAM::FindCommunication2::getCommStmt() const {
    return commStmt;
}

DESCAM::Port *DESCAM::FindCommunication2::getPort() const {
    if(!this->isCommunication()) TERMINATE("Not a communication stmt! No port available");
    return this->commStmt->getPort();
}

DESCAM::Stmt *DESCAM::FindCommunication2::getStmt() const {
    return this->stmt;
}

DESCAM::Expr *DESCAM::FindCommunication2::getWriteValue() const {
    return writeValue;
}

DESCAM::VariableOperand * DESCAM::FindCommunication2::getReadVariable() const {
    return readVariable;
}


// Visitors
namespace DESCAM {

void DESCAM::FindCommunication2::visit(struct VariableOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct IntegerValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct UnsignedValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct EnumValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct BoolValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct PortOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Assignment &node) {
    waitComm = false;
    node.getRhs()->accept(*this);
}

void DESCAM::FindCommunication2::visit(struct FunctionOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct UnaryExpr &node) {
    FindCommunication2 conditionChecker;
    node.getExpr()->accept(conditionChecker);
    if (conditionChecker.isCommunication()) TERMINATE("Interfaces in unary operator not supported");
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct While &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct If &node) {
    FindCommunication2 conditionChecker;
    node.getConditionStmt()->accept(conditionChecker);
    if (conditionChecker.isCommunication()) TERMINATE("Interfaces in if condition not supported");
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct SectionOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct SectionValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct ITE &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Arithmetic &node) {
    waitComm = false;
    communication = false;
    node.getLhs()->accept(*this);
    if (communication) return;
    node.getRhs()->accept(*this);
}

void DESCAM::FindCommunication2::visit(struct Logical &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Relational &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Bitwise &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Read &node) {
    waitComm = false;
    communication = true;
    this->non_blocking_access = node.isNonBlockingAccess();
    this->commStmt = &node;
    this->stmt = &node;
    this->readVariable = node.getVariableOperand();
    this->stateName = node.getStateName();
}

void DESCAM::FindCommunication2::visit(struct Write &node) {
    waitComm = false;
    communication = true;
    this->non_blocking_access = node.isNonBlockingAccess();
    this->commStmt = &node;
    this->stmt = &node;
    this->writeValue = node.getValue();
    this->stateName = node.getStateName();

}

void DESCAM::FindCommunication2::visit(struct SyncSignal &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct Cast &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct DataSignalOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(struct CompoundValue &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(DESCAM::ArrayOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(DESCAM::CompoundExpr &node) {
    TERMINATE(" Not implemented");
}

void DESCAM::FindCommunication2::visit(DESCAM::ParamOperand &node) {
    TERMINATE(" Not implemented");
}

void DESCAM::FindCommunication2::visit(DESCAM::Return &node) {
    TERMINATE(" Not implemented");
}

void DESCAM::FindCommunication2::visit(DESCAM::Notify &node) {
    TERMINATE(" Not implemented");
}

void DESCAM::FindCommunication2::visit(DESCAM::Wait &node) {
    waitComm = true;
    this->stateName = node.getStateName();
    communication = false;
}

    void DESCAM::FindCommunication2::visit(DESCAM::Peek &node) {
        waitComm = false;
        communication = false;
    }

    void FindCommunication2::visit(class ArrayExpr &node) {
        waitComm = false;
        communication = false;
    }

    const std::string &FindCommunication2::getStateName() const {
        return stateName;
    }

    bool FindCommunication2::hasStateName() const {
        return !this->stateName.empty();
    }
}

void DESCAM::FindCommunication2::visit(struct TimePointOperand &node) {
    waitComm = false;
    communication = false;
}

void DESCAM::FindCommunication2::visit(DESCAM::Ternary &node) {
    waitComm = false;
    communication = false;
}
