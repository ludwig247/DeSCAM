//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#include <PrintStmt.h>
#include "Operation.h"

namespace DESCAM {
    int DESCAM::Operation::operations_cnt = 0;

    DESCAM::Operation::Operation() :
            resetOperation(false),
            waitOperation(false),
            state(nullptr),
            nextState(nullptr),
            id(Operation::operations_cnt++) {}

    DESCAM::Operation::~Operation() = default;

    // Getter
    bool DESCAM::Operation::IsReset() {
        return this->resetOperation;
    }

    bool DESCAM::Operation::IsWait() const{
        return this->waitOperation;
    }

    const std::vector<DESCAM::Stmt *> &DESCAM::Operation::getStatementsList() const {
        return this->statementsList;
    }

    const std::vector<Expr *> &DESCAM::Operation::getAssumptionsList() const {
        return this->assumptionList;
    }

    const std::vector<Assignment *> &DESCAM::Operation::getCommitmentsList() const {
        return this->commitmentList;
    }

    const std::vector<DESCAM::Assignment *> &Operation::getCommitmentList() const {
        return commitmentList;
    }

    DESCAM::State *DESCAM::Operation::getState() const {
        return this->state;
    }

    DESCAM::State *DESCAM::Operation::getNextState() const {
        return this->nextState;
    }

    int DESCAM::Operation::getId() const {
        return id;
    }

    // Setter
    void DESCAM::Operation::setStatementsList(std::vector<DESCAM::Stmt *> statementsList_arg) {
        this->statementsList = std::move(statementsList_arg);
    }

    void DESCAM::Operation::setAssumptionsList(std::vector<DESCAM::Expr *> assumptionsList) {
        this->assumptionList = std::move(assumptionsList);
    }

    void DESCAM::Operation::setCommitmentsList(std::vector<Assignment *> commitmentsList) {
        this->commitmentList = std::move(commitmentsList);
    }

    void DESCAM::Operation::setState(DESCAM::State *state_arg) {
        this->state = state_arg;
    }

    void DESCAM::Operation::setNextState(DESCAM::State *nextState_arg) {
        this->nextState = nextState_arg;
    }

    void DESCAM::Operation::setReset(bool reset) {
        this->resetOperation = reset;
    }

    void DESCAM::Operation::setWait(bool wait) {
        this->waitOperation = wait;
    }

    void DESCAM::Operation::addStatement(DESCAM::Stmt *stmt) {
        this->statementsList.push_back(stmt);
    }

    void DESCAM::Operation::addAssumption(DESCAM::Expr *assumption) {
        this->assumptionList.push_back(assumption);
    }

    void DESCAM::Operation::addCommitment(DESCAM::Assignment *commitment) {
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