//
// Created by ludwig on 25.10.16.
//

#include <sstream>
#include <PrintStmt.h>
#include "State.h"
#include <algorithm>
#include <assert.h>
#include <set>


SCAM::State::State(std::string section) :
        section(section),
        stateId(-1),
        commStmt(nullptr),
        writeValue(nullptr){
}

SCAM::State::State(std::string section, int stateId, Communication *commStmt):
        section(section),
        stateId(stateId),
        commStmt(commStmt),
        writeValue(nullptr){
        this->commStmtSet.insert(commStmt);
}

SCAM::State::State(std::string section, int stateId, Communication * commStmt, Expr *writeValue) :
        section(section),
        stateId(stateId),
        commStmt(commStmt),
        writeValue(writeValue){
    this->commStmtSet.insert(commStmt);
}

SCAM::State::State(const SCAM::State& state ):
        section(state.section),
        stateId(state.stateId),
        commStmt(state.commStmt),
        writeValue(state.writeValue),
        commStmtSet(state.commStmtSet)
    {
}


const std::string &SCAM::State::getSection() const {
    return section;
}

int SCAM::State::getStateId() const {
    return stateId;
}

SCAM::Port *SCAM::State::getCommPort() const {
    return this->getCommStmt()->getPort();
}

std::string SCAM::State::print() const {
    std::stringstream ss;
    if (section != "init"){
        ss << section << "_" << stateId << "[";
      for(auto cS: commStmtSet){
          ss << cS->getPort()->getName() << ",";
      }
        ss << "]";

    }
    else ss << section;

    return ss.str();

}

bool SCAM::State::isInit() const {
    return section == "init" && stateId == -1 && commStmt == nullptr;

}

void SCAM::State::addIncomingOperation(SCAM::Operation *operation) {
    this->incomingOperationList.push_back(operation);

}

void SCAM::State::addOutgoingOperation(SCAM::Operation *operation) {
    this->outgoingOperationList.push_back(operation);
}



const std::vector<SCAM::Operation *> &SCAM::State::getOutgoingOperationList() const {
    return outgoingOperationList;
}

const std::vector<SCAM::Operation *> &SCAM::State::getIncomingOperationList() const {
    return incomingOperationList;
}

void SCAM::State::removeIncomingOperation(SCAM::Operation *operation) {
    this->incomingOperationList.erase(std::remove(incomingOperationList.begin(), incomingOperationList.end(), operation), incomingOperationList.end());
    //TODO: always remove both sides ? Idea: Add an operation release to operation that removes itself from both sides or try deleting the operation
}

void SCAM::State::removeOutgoingOperation(SCAM::Operation *operation) {
    this->outgoingOperationList.erase(std::remove(outgoingOperationList.begin(), outgoingOperationList.end(), operation), outgoingOperationList.end());
    operation->getNextState()->removeIncomingOperation(operation);
}

bool SCAM::State::isRead() const {
    return this->writeValue == nullptr && this->commStmt != nullptr;
}

bool SCAM::State::isWrite() const {
    return this->writeValue != nullptr && this->commStmt != nullptr;
}

std::string SCAM::State::getName() const {
    if(stateId == -1) return "init";
    return this->section + "_" + std::to_string(stateId);
}

SCAM::Communication *SCAM::State::getCommStmt() const {
    return commStmt;
}

SCAM::Expr *SCAM::State::getWriteValue() const {
    return writeValue;
}

SCAM::State::~State() {
    for (auto operation : outgoingOperationList) {
        delete operation;
    }
}

std::string SCAM::State::printOutgoingOperations() const {
    std::stringstream ss;
    for(auto op: outgoingOperationList){
        ss << op->print() << "\n";
    }
    return ss.str();
}

void SCAM::State::addCommStmt(SCAM::Communication *commStmt) {
    assert(commStmt != nullptr);
    this->commStmtSet.insert(commStmt);
}

const std::set<SCAM::Communication *> & SCAM::State::getCommStmtSet() const {
    return commStmtSet;
}



