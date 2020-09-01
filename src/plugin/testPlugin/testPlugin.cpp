//
// Created by lanrez on 8/13/20.
//

#include "testPlugin.h"
#include <PrintStmt.h>
#include <NodePeekVisitor.h>
#include <math.h>

std::map<std::string, std::string> testPlugin::printModel(Model *node) {

    std::map<std::string, Module *> moduleMap = node->getModules();
    ss << "Module map size: "<< moduleMap.size() << std::endl;
    for (auto module : moduleMap){
        ss << "Name: " << module.first << std::endl << std::endl;
        FSM* myFSM = module.second->getFSM();
        //std::map<int, State *> stateMap = myFSM->getStateMap();
        findStateStmt(myFSM);
        //std::map<int, Stmt *> stateStmt;
        //ss << "State map size: " << stateMap.size() << std::endl;
        /*for (auto state : stateMap){
            ss << std::endl << "State no: " << state.first << " is Init: " << state.second->isInit() << " is Wait: " << state.second->isWait() << std::endl;
            //std::vector<SCAM::Operation *> incoming = state.second->getIncomingOperationsList();
            //ss << "Incoming operation list size: " << incoming.size() << std::endl;
            std::vector<Operation *> outgoing = state.second->getOutgoingOperationsList();
            //ss << "Outgoing operation list size: " << outgoing.size() << std::endl;
            //ss << "--------------------------------------------------------" << std::endl << "Oncoming" << std::endl;
            for (auto op : outgoing){
                //int flag = 0;
                //ss << "--------------------------------------------------------" << std::endl;
                //ss << op->print() << std::endl;
                std::vector<Stmt *> statementsList = op->getStatementsList();
                //ss << "\t Statement list size: " << statementsList.size() << std::endl;
                for (auto st : statementsList){
                    //NodePeekVisitor peek = NodePeekVisitor(st);
                    //ss << "\t\t * " << PrintStmt::toString(st) << std::endl;
                    //const DataType* dat;
                    if (NodePeekVisitor::nodePeekRead(st) != nullptr | NodePeekVisitor::nodePeekWrite(st) != nullptr) {
                        ss << "\t * " << PrintStmt::toString(st) << std::endl;
                        LocationInfo loc = st->getStmtInfo();
                        ss << loc.getObject() << std::endl;
                        flag = 1;
                        stateStmt.insert(std::make_pair(state.first,st));
                        break;
                        /*dat = NodePeekVisitor::nodePeekRead(st)->getVariableOperand()->getDataType();
                        ss << "\t   " << returnBits(dat) << " bits flipped" << std::endl;
                        total += returnBits(dat);/
                    }/*else if  (NodePeekVisitor::nodePeekAssignment(st) != nullptr) {
                        ss << "\t * " << PrintStmt::toString(st) << std::endl;
                        dat = NodePeekVisitor::nodePeekAssignment(st)->getLhs()->getDataType();
                        ss << "\t   " << returnBits(dat) << " bits flipped" << std::endl;
                        total += returnBits(dat);
                    }/
                }
                if (flag == 1) break;
                //ss << "Total bits flipped (Worst case): " << total << std::endl;

                /*std::vector<SCAM::Expr *> assumptionList = op->getAssumptionsList();
                ss << std::endl << "\t Assumption list size: " << assumptionList.size() << std::endl;
                for (auto st : assumptionList){
                    ss << "\t\t * " << PrintStmt::toString(st) << std::endl;
                }
                std::vector<SCAM::Assignment *> commitmentList = op->getCommitmentList();
                ss << std::endl << "\t Commitment list size: " << commitmentList.size() << std::endl;
                for (auto st : commitmentList){
                    ss << "\t\t * " << PrintStmt::toString(st) << std::endl;
                }/
            }
            /*std::cout << "--------------------------------------------------------" << std::endl << "Outgoing" << std::endl;
            for (auto op : outgoing){
                std::cout << op->print() << std::endl;
            }/
        }*/
        for (auto st : stateStmt) {
            LocationInfo loc = st.second->getStmtInfo();
            ss << st.first << " " + loc.getObject() + "Row info: " <<
            loc.getRowStartNumber() << " " << loc.getRowEndNumber() <<
            "Column info: " << loc.getColumnStartNumber() << " " << loc.getColumnEndNumber() <<
            std::endl;
        }
    }
    std::cout << ss.str();

    //pluginOutput.insert(std::make_pair("test.txt",ss.str()));

    return pluginOutput;
}

int testPlugin::returnBits(const DataType *dataType) {
    if (dataType->getName() == "RegfileType") return 32;
    int count = 0;
    if (dataType->isBoolean()) return count + 1;
    else if (dataType->isInteger() | dataType->isUnsigned()) return count + 32;
    else if (dataType->isEnumType()){
        if (dataType->getEnumValueMap().size() == 1) return count + 1;
        else return count + int(ceil(log2(dataType->getEnumValueMap().size())));
    }
    else if (dataType->isCompoundType()){
        for (const auto& dat : dataType->getSubVarMap()){
            count += returnBits(dat.second);
        }
        return count;
    }
    return 0;
}

void testPlugin::findStateStmt(FSM *node) {
    for (auto state : node->getStateMap()){
        bool flag = false;
        for(auto op : state.second->getOutgoingOperationsList()){
            for (auto st : op->getStatementsList()){
                if(NodePeekVisitor::nodePeekRead(st) != nullptr | NodePeekVisitor::nodePeekWrite(st) != nullptr){
                    stateStmt.insert(std::make_pair(state.first,st));
                    flag = true;
                    break;
                }
            }
            if (flag) break;
        }
    }
}