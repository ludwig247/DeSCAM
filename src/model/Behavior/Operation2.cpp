//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#include <PrintStmt.h>
#include "Operation2.h"

namespace SCAM {
    int SCAM::Operation2::operations_cnt = 0;

    SCAM::Operation2::Operation2() :
            resetOperation(false),
            waitOperation(false),
            state(nullptr),
            nextState(nullptr),
            id(Operation2::operations_cnt++) {}

    SCAM::Operation2::~Operation2() = default;

    // Getter
    bool SCAM::Operation2::IsReset() {
        return this->resetOperation;
    }

    bool SCAM::Operation2::IsWait() {
        return this->waitOperation;
    }

    const std::vector<SCAM::Stmt *> &SCAM::Operation2::getStatementsList() const {
        return this->statementsList;
    }

    const std::vector<Expr *> &SCAM::Operation2::getAssumptionsList() const {
        return this->assumptionList;
    }

    const std::vector<Assignment *> &SCAM::Operation2::getCommitmentsList() const {
        return this->commitmentList;
    }

    SCAM::State2 *SCAM::Operation2::getState() const {
        return this->state;
    }

    SCAM::State2 *SCAM::Operation2::getNextState() const {
        return this->nextState;
    }

    int SCAM::Operation2::getId() const {
        return id;
    }

    int SCAM::Operation2::getOperations_cnt() {
        return operations_cnt;
    }

    // Setter
    void SCAM::Operation2::setStatementsList(std::vector<SCAM::Stmt *> statementsList_arg) {
        this->statementsList = std::move(statementsList_arg);
    }

    void SCAM::Operation2::setAssumptionsList(std::vector<SCAM::Expr *> assumptionsList) {
        this->assumptionList = std::move(assumptionsList);
    }

    void SCAM::Operation2::setCommitmentsList(std::vector<Assignment *> commitmentsList) {
        this->commitmentList = std::move(commitmentsList);
    }

    void SCAM::Operation2::setState(SCAM::State2 *state_arg) {
        this->state = state_arg;
    }

    void SCAM::Operation2::setNextState(SCAM::State2 *nextState_arg) {
        this->nextState = nextState_arg;
    }

    void SCAM::Operation2::setReset(bool reset) {
        this->resetOperation = reset;
    }

    void SCAM::Operation2::setWait(bool wait) {
        this->waitOperation = wait;
    }

    void SCAM::Operation2::addStatement(SCAM::Stmt *stmt) {
        this->statementsList.push_back(stmt);
    }

    void SCAM::Operation2::addAssumption(SCAM::Expr *assumption) {
        this->assumptionList.push_back(assumption);
    }

    void SCAM::Operation2::addCommitment(SCAM::Assignment *commitment) {
        this->commitmentList.push_back(commitment);
    }

    std::string Operation2::print() {
        std::stringstream ss;
        ss << "OP[" << this->getId() << "]: ";
        ss << "FROM STATE["<<this->getState()->getStateId()<< "] ";
        ss << "TO STATE[" << this->getNextState()->getStateId()<< "]";

        return ss.str();
    }

}