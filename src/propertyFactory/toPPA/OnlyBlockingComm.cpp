//
// Created by ludwig on 25.04.17.
//



//
// Created by tobias on 12.07.16.
//

#include "OnlyBlockingComm.h"




SCAM::OnlyBlockingComm::OnlyBlockingComm(const std::map<std::string, std::vector<SCAM::Path *> > &sectionPathMap) :
        sectionPathMap(sectionPathMap) {

    this->stateMap.insert(std::make_pair(-1, new State("init", -1, nullptr)));

    splitPathAtCommPoint();
    addWait();
    addNB();

}

void SCAM::OnlyBlockingComm::splitPathAtCommPoint() {
    for (auto section: this->sectionPathMap) {
        for (auto path: section.second) {
            //Traverse paths and in case of a communication split path
            //All new pahts are added to a newPathList for a path with 1 communication there will be 2 new paths
            std::vector<SCAM::Path *> newPathList;
            std::vector<SCAM::Stmt *> stmtList;
            for (auto stmt: path->getStmtList()) {
                //Visitor used to determine whether a stmt is a communication(read,write) or just a regular operation
                SCAM::FindCommunication findCommunication;
                //Decide for each stmt whether it contains a communication:
                //IF NOT: add to current statementList
                //IF: create a new path and add current stmtList to this path
                //  Adjust next state and state of current/newPath accordingly
                stmt->accept(findCommunication);
                //Stores the commPort of the previous path. Interfaces is first stmt of the new path
                if (findCommunication.isCommunication() && !findCommunication.isShared()) {
                    //Create new path
                    SCAM::Path *newPath = new SCAM::Path(*path,stmtList);
                    if(findCommunication.isWrite()){
                        auto dataSig = new DataSignalOperand(findCommunication.getPort()->getDataSignal());
                        auto value = findCommunication.getWriteValue();
                        Assignment * test = new Assignment(dataSig,value);
                        newPath->addStmt(test);
                    }
                    //Set communication condition
                    path->setCommunicationConditionList(std::vector<Expr *>());
                    //No sync for alwaysReady
                    if(findCommunication.isBlockingInterface() || findCommunication.isNonBlockingAccess()) path->setCommunicationCondition(new PortOperand(findCommunication.getPort()), true);

                    //Returns the unique id to the commounication
                    int state_id = SCAM::OnlyBlockingComm::find_or_add_communication(stmt, path->getStmtNextstateMap().at(stmt), section.first);
                    //
                    if(newPathList.empty()){
                        newPath->setNextSection((path->getSection()));
                        newPath->setSubNext(std::to_string(state_id));

                    }else {
                        newPath->setSubSection(newPathList.back()->getSubNext());
                        //Sets the nextState of the path to the new ID
                        newPath->setSubNext(std::to_string(state_id));
                        //The endstate of the path is not the beginning state
                        //If a path is split up the new endstate of the previous path is only a substate of starstate of the path
                        if (path->getNextSection() != path->getSection()) {
                            newPath->setNextSection(path->getSection());
                        }
                    }
                    newPathList.push_back(newPath);
                    //Clear old stmtList
                    stmtList.clear();
                }
                //Add stmt to stmtList
                stmtList.push_back(stmt);
            }
            //Leftover stmts that are behind a communication or paths without any stmts behind a communication
            SCAM::Path *newPath = new SCAM::Path(*path, stmtList);
            if (!newPathList.empty()) newPath->setSubSection(newPathList.back()->getSubNext());
            newPathList.push_back(newPath);
            //Insert everything for this section to the sectionPathMap
            this->sectionNewPathMap[section.first].insert(this->sectionNewPathMap[section.first].end(), newPathList.begin(), newPathList.end());

        }
    }
}

int SCAM::OnlyBlockingComm::find_or_add_communication(SCAM::Stmt *stmt, std::string nextstate, std::string section) {
    auto stmt_state = std::make_pair(stmt, nextstate);
    if (this->communicationMap.find(stmt_state) == this->communicationMap.end()) {
        this->communicationMap.insert(std::make_pair(stmt_state, this->communicationMap.size()));
        FindCommunication findComm;
        stmt->accept(findComm);
        if (findComm.isRead()) {
            State *newState = new State(section, this->communicationMap.size() - 1, findComm.getCommStmt());
            this->stateMap.insert(std::make_pair(this->communicationMap.size() - 1, newState));
        } else if (findComm.isWrite()) {
            State *newState = new State(section, this->communicationMap.size() - 1, findComm.getCommStmt(), findComm.getWriteValue());
            this->stateMap.insert(std::make_pair(this->communicationMap.size() - 1, newState));
        } else throw std::runtime_error("Interfaces is neither wirte nor read");


    }
    return this->communicationMap.find(stmt_state)->second;
}


std::map<std::string, std::vector<SCAM::Path *> > SCAM::OnlyBlockingComm::getNewSectionPathMap() {
    return this->sectionNewPathMap;
}

const std::map<int, SCAM::State *> &SCAM::OnlyBlockingComm::getStateMap() const {
    return stateMap;
}

void SCAM::OnlyBlockingComm::addWait() {
    for (auto section: this->sectionNewPathMap) {
        std::vector<SCAM::Path *> waitPathList;
        for (auto path: section.second) {
            //Visitor used to determine whether a stmt is a communication(read,write) or just a regular operation
            SCAM::FindCommunication findCommunication;
            if(path->getStmtList().empty()) continue;
            path->getStmtList().front()->accept(findCommunication);

            // Blocking communication -> add waitstate
            // Creats a wait-operation for each communication. Erased in MergeSections()
            if (findCommunication.isCommunication() && findCommunication.isBlockingInterface() && !findCommunication.isNonBlockingAccess()) {

                //Make sure output value stays the same in case of an write
                std::vector<SCAM::Stmt *> stmtList = {};
                if(findCommunication.isWrite()){
                    if(!ExprVisitor::isConstVal(findCommunication.getWriteValue())){
                        for(Operand * op: ExprVisitor::getUsedOperands(findCommunication.getWriteValue())){
                            if(VariableOperand * varOp = dynamic_cast<VariableOperand*>(op)){
                                stmtList.push_back(new Assignment(varOp,varOp));
                            }//else assert(false); //TODO: is this important?
                        }
                    }
                    auto dataSig = new DataSignalOperand(findCommunication.getPort()->getDataSignal());
                    auto value = findCommunication.getWriteValue();
                    stmtList.push_back(new Assignment(dataSig,value));
                }
                SCAM::Path *waitPath = new SCAM::Path(*path, stmtList);


                waitPath->setCommunicationConditionList(std::vector<SCAM::Expr *>());
                waitPath->setCommunicationCondition(new PortOperand(findCommunication.getPort()), false);
                waitPath->setSection(path->getSection());
                waitPath->setSubSection(path->getSubState());
                waitPath->setNextSection(path->getSection());
                waitPath->setSubNext(path->getSubState());
                waitPath->setWait(true);
                waitPathList.push_back(waitPath);

            }
        }
        this->sectionNewPathMap[section.first].insert(this->sectionNewPathMap[section.first].end(), waitPathList.begin(), waitPathList.end());
    }
}

void SCAM::OnlyBlockingComm::addNB() {
    for (auto section: this->sectionNewPathMap) {
        std::vector<SCAM::Path *> nonBlockingPathList;
        for (auto path: section.second) {

            SCAM::FindCommunication findComm;
            if(path->getStmtList().empty()) continue;
            path->getStmtList().front()->accept(findComm);

            // Non-Blocking communication
            // Change:
            // res = port->nb_read(a) for port_sync == true  into a = port->value();res = port-available();
            // res = port->nb_write(a)for port_sync == false into res = port-avfindComm.getCommPort()->getPort()ailable();
            if (findComm.isShared()) continue;

            if (findComm.isCommunication() && findComm.isNonBlockingAccess()) {
                SCAM::ReplaceStmt rS(findComm.getStmt(), new SCAM::BoolValue(false));
                if(path->getStmtList().empty()) continue;
                path->getStmtList().front()->accept(rS);
                std::vector<SCAM::Stmt *> newStmtList = path->getStmtList();
                newStmtList.at(0) = rS.getNewStmt();
                SCAM::Path *notAvailabble = new SCAM::Path(*path, newStmtList);

                notAvailabble->setCommunicationConditionList(std::vector<SCAM::Expr *>());
                notAvailabble->setCommunicationCondition(new PortOperand(findComm.getPort()), false);
                nonBlockingPathList.push_back(notAvailabble);
            }

        }
        this->sectionNewPathMap[section.first].insert(this->sectionNewPathMap[section.first].end(), nonBlockingPathList.begin(),
                                                      nonBlockingPathList.end());
    }
}


std::string SCAM::OnlyBlockingComm::print() const {
    std::stringstream ss;
    for (auto section: this->sectionNewPathMap) {
        for (auto path: section.second) {
            ss << "Section: " << section.first << " PathID: " << path->getPathId() << std::endl;
            ss << path->print() << std::endl;
        }
    }
    return ss.str();
}

SCAM::OnlyBlockingComm::~OnlyBlockingComm() {

}

