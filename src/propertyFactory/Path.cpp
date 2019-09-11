//

#include <stdexcept>
#include <iostream>
#include <BoolValue.h>
#include <If.h>
#include <Assignment.h>
#include <Stmts/PortOperand.h>
#include <Stmts/Relational.h>
#include <Stmts/SyncSignal.h>
#include <Stmts/SectionValue.h>
#include <PrintStmt.h>
#include <cassert>
#include "Path.h"


//
// Created by ludwig on 05.07.16.
int SCAM::Path::pathCnt = 0;

SCAM::Path::Path(std::string state) :
        state(state),
        nextstate(""),
        subState(""),
        subNext(""),
        pathId(pathCnt++),
        returnValue(nullptr),
        wait(false){
    assert(pathId >= -1 && "PathID is never less then -1");
}


SCAM::Path::Path(const SCAM::Path &path) :
        state(path.getSection()),
        nextstate(path.getNextSection()),
        conditionList(path.getConditionList()),
        communicationConditionList(path.communicationConditionList),
        stmtList(path.getStmtList()),
        pathId(path.getPathId()),
        wait(path.isWait()),
        subState(path.subState),
        subNext(path.subNext) {
    assert(pathId >= -1 && "PathID is never less then -1");
}


SCAM::Path::Path(const SCAM::Path &path, const std::vector<SCAM::Stmt *> &stmtList) :
        state(path.getSection()),
        nextstate(path.getNextSection()),
        conditionList(path.getConditionList()),
        communicationConditionList(path.communicationConditionList),
        stmtList(stmtList),
        pathId(pathCnt++),
        wait(path.isWait()),
        subState(path.getSubState()),
        subNext(path.getSubNext()),
        dataPathList(path.getDataPathList()),
        dataPathMap(path.dataPathMap){
    assert(pathId >= -1 && "PathID is never less then -1");

}

SCAM::Path::~Path() {
}

void SCAM::Path::addStmt(SCAM::Stmt *stmt) {
    this->stmtList.push_back(stmt);
}

void SCAM::Path::setConditionList(const std::vector<SCAM::Expr *> &conditionList) {
    this->conditionList = conditionList;
}


const std::vector<SCAM::Stmt *> &SCAM::Path::getStmtList() const {
    return this->stmtList;
}

const std::vector<SCAM::Expr *> &SCAM::Path::getConditionList() const {
    return this->conditionList;
}

std::string SCAM::Path::getSection() const {
    return state;
}

std::string SCAM::Path::getNextSection() const {
    return nextstate;
}


const std::vector<SCAM::Assignment *> &SCAM::Path::getDataPathList() const {
    return this->dataPathList;
}

void SCAM::Path::setDataPathList(const std::vector<SCAM::Assignment *> &dataPathList) {
    this->dataPathMap.clear();
    this->dataPathList = dataPathList;
    //Create new entries for dataPathMap
    for (auto assignment: this->dataPathList) {
        //if (SCAM::Assignment *assignment = dynamic_cast<Assignment *>(dataPath)) {
            //lhs = assigned_Value -> create string for lhs variable
            //Todo: CHECK IF THIS STILL WORKS!
            this->dataPathMap.insert(std::make_pair(PrintStmt::toString(assignment->getLhs()), assignment->getRhs()));
        //} else throw std::runtime_error("Every element in datapathlist has to be an assignment");
    }

}


void SCAM::Path::setCommunicationCondition(PortOperand *portOperand, bool ready) {
    //Create SyncSignal signal for port
    auto synch = portOperand->getPort()->getSynchSignal();
    if(ready){
        this->communicationConditionList.push_back(synch);
    }else{
        this->communicationConditionList.push_back(new UnaryExpr("not",synch));
    }

}

std::string SCAM::Path::print()  {

    std::stringstream ss;
    ss << "PathID[" << this->getPathId() << "]" << std::endl;
    ss << "Transition:\n ";
    if (this->isWait()) {
        ss << "wait_";
        ss << this->state;
        if (this->subState != "") ss << "_" << this->subState << "";
        ss << "\n";
    } else {
        ss << this->state;
        if (this->subState != "") ss << "_" << this->subState << "";
        ss << "->";
        ss << this->nextstate;
        if (this->subNext != "") ss << "_" << this->subNext;
        ss << "\n";
    }
    ss << "Conditions:\n";
    for (auto condition: this->conditionList) {
        ss << "\t" << PrintStmt::toString(condition) << " : " << condition << "\n";
    }
    ss << "Interfaces conditions:\n";
    for (auto condition: this->communicationConditionList) {

        ss << "\t" << PrintStmt::toString(condition)  << "\n";
    }
    ss << "Datapath:\n";
    for (auto datapath: this->dataPathList) {
        ss << "\t" << PrintStmt::toString(datapath)  << "\n";
    }

    ss << "Stmts:\n";
    for (auto stmt: this->stmtList) {
        ss << "\t" << PrintStmt::toString(stmt) << " : " << stmt << " :" << this->getStmtNextstateMap().at(stmt);
        if (SCAM::If *test = dynamic_cast<SCAM::If *>(stmt)) {
            ss << "(" << test->getConditionStmt() << ")";

        }
        ss << "\n";
    }
    return ss.str();

}

void SCAM::Path::addCondition(SCAM::Expr *stmt) {
    if (stmt == nullptr) throw std::runtime_error("stmt is null");
    this->conditionList.push_back(stmt);

}

SCAM::Path &SCAM::Path::operator+=(const SCAM::Path &newPath) {
    {
        this->pathId = newPath.getPathId();
        //Is there a nextstate assignemtn in the new path?
        if(newPath.getNextSection() != ""){
            this->setNextSection(newPath.getNextSection());
        }

        //Append condition of newPath told one
        for (auto condition: newPath.getConditionList()) {
            this->conditionList.push_back(condition);
        }
        //Append stmt of newPath told one
        for (auto stmt: newPath.getStmtList()) {
            this->stmtList.push_back(stmt);
        }
        return *this;
    }

}


void SCAM::Path::setNextSection(const std::string nextstate) {
    if (nextstate == "") throw std::runtime_error("nextstate is not defined");
    this->nextstate = nextstate;
}

int SCAM::Path::getPathId() const {
    return this->pathId;
}


std::string SCAM::Path::getSubState() const {
    return this->subState;
}

void SCAM::Path::setSubSection(const std::string substate) {
    this->subState = substate;

}

void SCAM::Path::setSubNext(const std::string substate) {
    this->subNext = substate;
}


//void SCAM::Path::addCommunicationCondition(Variable *portSyncVar, bool sync) {
//    SCAM::VariableOperand *lhs = new VariableOperand(portSyncVar);
//    SCAM::BoolValue *rhs = new BoolValue(sync);
//    this->communicationConditionList.push_back(new Compare(lhs, rhs, "=="));
//}

std::string SCAM::Path::getSubNext() const {
    return this->subNext;
}

void SCAM::Path::setSection(const std::string state) {
    this->state = state;

}

const std::vector<SCAM::Expr *> &SCAM::Path::getCommunicationConditionList() const {
    return communicationConditionList;
}

void SCAM::Path::setCommunicationConditionList(const std::vector<SCAM::Expr *> &communicationConditionList) {
    Path::communicationConditionList = communicationConditionList;
}

bool SCAM::Path::isWait() const {
    return wait;
}

void SCAM::Path::setWait(bool wait) {
    Path::wait = wait;
}

const std::map<SCAM::Stmt *, std::string> &SCAM::Path::getStmtNextstateMap(){
    if(this->stmtNextstateMap.empty()){
        //Fill map
        std::string new_state  = this->state;
        for(auto stmt: this->stmtList){
            //Check for each stmt whether it is an assignment oft type nextstate = XXX
            if (Assignment * node = dynamic_cast<Assignment *>(stmt)) {
                if (SectionValue *nextState = dynamic_cast<SectionValue *>(node->getRhs())) {
                        new_state = PrintStmt::toString(node->getRhs());
                    }
                }
            this->stmtNextstateMap.insert(std::make_pair(stmt,new_state));
        }
    }
    return stmtNextstateMap;
}

const bool SCAM::Path::operator<(const SCAM::Path &p) const {
    if(this->getSubState() == "") throw std::runtime_error("1 Can't compare paths without substates");
    if(this->getSubNext() == "") throw std::runtime_error("2 Can't compare paths without substates");
    if(p.getSubState() == "")  throw std::runtime_error("3 Can't compare paths without substates");
    if(p.getSubNext() == "")  throw std::runtime_error("4 Can't compare paths without substates");
    if(this->getSubState() == p.getSubState()){
        if(this->getSubNext() == p.getSubNext()){
            if(this->stmtList.size() == p.stmtList.size()) {
                int differences = 0;
                for (int i = 0; i < this->stmtList.size(); i++) {
                    std::string A = PrintStmt::toString(this->stmtList.at(i));
                    std::string B = PrintStmt::toString(p.stmtList.at(i));
                    if (A.compare(B) != 0) differences++;

                }
                if(differences == 0) return false;
                return this->pathId  < p.pathId;

            }
            return this->stmtList.size() < p.stmtList.size();
        }
        return atoi(this->getSubNext().c_str()) < atoi(p.getSubNext().c_str());
    }
    return atoi(this->getSubState().c_str()) < atoi(p.getSubState().c_str());
}

void SCAM::Path::resetPathCnt() {
    Path::pathCnt = 0;
}

SCAM::Return *SCAM::Path::getReturnValue() const {
    return returnValue;
}

void SCAM::Path::setReturnValue(SCAM::Return *returnValue) {
    Path::returnValue = returnValue;
}
