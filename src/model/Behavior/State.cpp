//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/25/19.
//

#include <algorithm>
#include "State.h"

namespace SCAM {

    int State::state_cnt = 0;



    State::State(std::string name) :
            stateId(State::state_cnt++),
            name(name),
            commStmt(nullptr),
            wait(false),
            init(false) {
    }


    //GETTERS
    int State::getStateId() const {
        return this->stateId;
    }

    std::string State::getName() const {
        return this->name;
    }

    const std::vector<Operation *> &State::getOutgoingOperationsList() const {
        return this->outgoingOperationsList;
    }

    const std::vector<Operation *> &State::getIncomingOperationsList() const {
        return this->incomingOperationsList;
    }

    SCAM::Port *State::getCommunicationPort() const {
        if (this->commStmt != nullptr)
            return this->commStmt->getPort();
        return nullptr;
    }


    //SETTERS
    void State::setName(std::string name_arg) {
        this->name = std::move(name_arg);
    }

    void State::setInit() {
        this->init = true;
    }

    void State::setWait() {
        this->wait = true;
    }

    void State::setCommunicationStmt(SCAM::Communication *commStmt_arg) {
        this->commStmt = commStmt_arg;
    }

    //ADDERS
    void State::addIncomingOperation(SCAM::Operation *incomingOperation) {
        this->incomingOperationsList.push_back(incomingOperation);
    }

    void State::addOutgoingOperation(SCAM::Operation *outgoingOperation) {
        this->outgoingOperationsList.push_back(outgoingOperation);
    }

    void State::removeIncomingOperation(SCAM::Operation *incomingOperation) {
        this->incomingOperationsList.erase(std::find(this->incomingOperationsList.begin(), this->incomingOperationsList.end(), incomingOperation));
    }

    void State::removeOutgoingOperation(SCAM::Operation *outgoingOperation) {
        this->outgoingOperationsList.erase(std::find(this->outgoingOperationsList.begin(), this->outgoingOperationsList.end(), outgoingOperation));
    }

    bool State::isInit() const {
        return this->init;
    }

    bool State::isWait() const {
        return this->wait;
    }

    //Print
    std::string State::print() const {
        return this->name;
    }

}