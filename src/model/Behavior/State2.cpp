//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/25/19.
//

#include <algorithm>
#include "State2.h"

namespace SCAM {

    int State2::state_cnt = 0;

    State2::State2() :
            stateId(State2::state_cnt++),
            name(""),
            commStmt(nullptr),
            wait(false),
            init(false) {
    }

    State2::State2(std::string name) :
            stateId(State2::state_cnt++),
            name(name),
            commStmt(nullptr),
            wait(false),
            init(false) {
    }


    //GETTERS
    int State2::getStateId() const {
        return this->stateId;
    }

    std::string State2::getName() const {
        return this->name;
    }

    const std::vector<Operation2 *> &State2::getOutgoingOperationsList() const {
        return this->outgoingOperationsList;
    }

    const std::vector<Operation2 *> &State2::getIncomingOperationsList() const {
        return this->incomingOperationsList;
    }

    SCAM::Port *State2::getCommunicationPort() const {
        if (this->commStmt != nullptr)
            return this->commStmt->getPort();
        return nullptr;
    }


    //SETTERS
    void State2::setName(std::string name_arg) {
        this->name = std::move(name_arg);
    }

    void State2::setInit() {
        this->init = true;
    }

    void State2::setWait() {
        this->wait = true;
    }

    void State2::setCommunicationStmt(SCAM::Communication *commStmt_arg) {
        this->commStmt = commStmt_arg;
    }

    //ADDERS
    void State2::addIncomingOperation(SCAM::Operation2 *incomingOperation) {
        this->incomingOperationsList.push_back(incomingOperation);
    }

    void State2::addOutgoingOperation(SCAM::Operation2 *outgoingOperation) {
        this->outgoingOperationsList.push_back(outgoingOperation);
    }

    void State2::removeIncomingOperation(SCAM::Operation2 *incomingOperation) {
        this->incomingOperationsList.erase(std::find(this->incomingOperationsList.begin(), this->incomingOperationsList.end(), incomingOperation));
    }

    void State2::removeOutgoingOperation(SCAM::Operation2 *outgoingOperation) {
        this->outgoingOperationsList.erase(std::find(this->outgoingOperationsList.begin(), this->outgoingOperationsList.end(), outgoingOperation));
    }

    bool State2::isInit() const {
        return this->init;
    }

    bool State2::isWait() const {
        return this->wait;
    }

    //Print
    std::string State2::print() const {
        return this->name;
    }

}