//
// Created by ludwig on 25.10.16.
//

#include "Operation.h"
#include "PrintStmt.h"

int SCAM::Operation::op_cnt = 0;


SCAM::Operation::Operation(SCAM::State *state, SCAM::State *nextstate) :
        state(state),
        nextstate(nextstate),
        wait(false),
        op_id(op_cnt++){
    if (state == nullptr) throw std::runtime_error("State ptr  is NULL");
    state->addOutgoingOperation(this);
    if (nextstate == nullptr) throw std::runtime_error("Nextstate ptr  is NULL");
    nextstate->addIncomingOperation(this);
}

SCAM::Operation::Operation(const SCAM::Operation &op, SCAM::State * state, SCAM::State * nextState):
    state(state),
    nextstate(nextState),
    wait(op.wait),
    op_id(op_cnt++),
    assumptionList(op.assumptionList),
    commitmentList(op.commitmentList)
    {
        if (state == nullptr) throw std::runtime_error("State ptr  is NULL");
        state->addOutgoingOperation(this);

        if (nextstate == nullptr) throw std::runtime_error("Nextstate ptr  is NULL");
        nextstate->addIncomingOperation(this);
}

SCAM::Operation::~Operation() {
    //this->state->removeOutgoingOperation(this);
    //this->nextstate->removeIncomingOperation(this);
    //Operation::op_cnt--;
}


SCAM::State *SCAM::Operation::getState() const {
    return state;
}

SCAM::State *SCAM::Operation::getNextState() const {
    return nextstate;
}

void SCAM::Operation::addAssumption(SCAM::Expr *stmt) {
    this->assumptionList.push_back(stmt);

}

void SCAM::Operation::addCommitment(SCAM::Stmt *stmt) {
    if(Assignment * assignment = dynamic_cast<Assignment*>(stmt)){
        this->commitmentList.push_back(assignment);
    }else throw std::runtime_error(PrintStmt::toString(stmt) + ": is not an assignment");

}

std::string SCAM::Operation::print() const {
    std::stringstream ss;
    ss << "[" << op_id << "]";
    if(this->wait) ss << "wait_" << state->print() << "\n";
    //else if(this->state->getStateId() == -1) ss << "reset\n";
    else ss << state->print() << " -> " << nextstate->print() << "\n";

    ss << "Assumptions:\n";
    for(auto assumption: this->assumptionList){
        ss << "\t" << PrintStmt::toString(assumption) << "\n";
    }
    ss << "Commitments:\n";
    for(auto commitment: this->commitmentList){
        ss <<  "\t" << PrintStmt::toString(commitment) << "\n";
    }

    return ss.str();
}



void SCAM::Operation::setWait(bool wait) {
    Operation::wait = wait;
}

bool SCAM::Operation::isWait() const {
    return wait;
}

const std::vector<SCAM::Expr*> &SCAM::Operation::getAssumptionList() const {
    return assumptionList;
}

const std::vector<SCAM::Assignment *> &SCAM::Operation::getCommitmentList() const {
    return commitmentList;
}

int SCAM::Operation::getOp_id() const {
    return op_id;
}

void SCAM::Operation::setCommitmentList(const std::vector<SCAM::Assignment *> &commitmentList) {
    Operation::commitmentList = commitmentList;
}

void SCAM::Operation::setAssumptionList(const std::vector<SCAM::Expr *> &assumptionList) {
    Operation::assumptionList = assumptionList;
}



