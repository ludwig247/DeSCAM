//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#include <PrintStmt.h>
#include "Operation.h"

namespace SCAM {
    int SCAM::Operation::operations_cnt = 0;

    SCAM::Operation::Operation() :
            resetOperation(false),
            waitOperation(false),
            state(nullptr),
            nextState(nullptr),
            id(Operation::operations_cnt++) {}

    SCAM::Operation::~Operation() = default;

    // Getter
    bool SCAM::Operation::IsReset() {
        return this->resetOperation;
    }

    bool SCAM::Operation::IsWait() {
        return this->waitOperation;
    }

    const std::vector<SCAM::Stmt *> &SCAM::Operation::getStatementsList() const {
        return this->statementsList;
    }

    const std::vector<Expr *> &SCAM::Operation::getAssumptionsList() const {
        return this->assumptionList;
    }

    const std::vector<Assignment *> &SCAM::Operation::getCommitmentsList() const {
        return this->commitmentList;
    }

    const std::vector<SCAM::Assignment *> &Operation::getCommitmentList() const {
        return commitmentList;
    }

    SCAM::State *SCAM::Operation::getState() const {
        return this->state;
    }

    SCAM::State *SCAM::Operation::getNextState() const {
        return this->nextState;
    }

    int SCAM::Operation::getId() const {
        return id;
    }

    // Setter
    void SCAM::Operation::setStatementsList(std::vector<SCAM::Stmt *> statementsList_arg) {
        this->statementsList = std::move(statementsList_arg);
    }

    void SCAM::Operation::setAssumptionsList(std::vector<SCAM::Expr *> assumptionsList) {
        this->assumptionList = std::move(assumptionsList);
    }

    void SCAM::Operation::setCommitmentsList(std::vector<Assignment *> commitmentsList) {
        this->commitmentList = std::move(commitmentsList);
    }

    void SCAM::Operation::setState(SCAM::State *state_arg) {
        this->state = state_arg;
    }

    void SCAM::Operation::setNextState(SCAM::State *nextState_arg) {
        this->nextState = nextState_arg;
    }

    void SCAM::Operation::setReset(bool reset) {
        this->resetOperation = reset;
    }

    void SCAM::Operation::setWait(bool wait) {
        this->waitOperation = wait;
    }

    void SCAM::Operation::addStatement(SCAM::Stmt *stmt) {
        this->statementsList.push_back(stmt);
    }

    void SCAM::Operation::addAssumption(SCAM::Expr *assumption) {
        this->assumptionList.push_back(assumption);
    }

    void SCAM::Operation::addCommitment(SCAM::Assignment *commitment) {
        this->commitmentList.push_back(commitment);
    }

    std::string Operation::print() {
        std::stringstream ss;
        ss << "OP[" << this->getId() << "]: ";
        ss << "FROM STATE["<<this->getState()->getStateId()<< "] ";
        ss << "TO STATE[" << this->getNextState()->getStateId()<< "]";

        return ss.str();
    }



}