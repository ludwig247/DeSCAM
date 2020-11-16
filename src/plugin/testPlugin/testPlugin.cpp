//
// Created by lanrez on 8/13/20.
//

#include "testPlugin.h"
#include <PrintStmt.h>
#include <NodePeekVisitor.h>
#include <math.h>



std::map<std::string, std::string> testPlugin::printModel(Model *node) {

    /*std::map<std::string, Module *> moduleMap = node->getModules();
    for (auto module : node->getModules()) {

        findStateStmt(module.second->getFSM());
        findOpStmt(module.second->getFSM());
        instrumentModule(module.second);

        for (auto v : vars){
            LocationInfo loc = v.second->getStmtInfo();
            std::cout << v << std::endl;
        }

        std::cout << ss.str();
        pluginOutput.insert(std::make_pair("inst_" + module.first + ".h",ss.str()));
    }*/


    return pluginOutput;
}

void testPlugin::instrumentModule(DESCAM::Module *node) {
    LocationInfo loc = node->getLocationInfo();
    inFile.open(loc.getFile());
    if (!inFile) throw (std::runtime_error("Unable to open file."));

    printPrefix(loc.getRowStartNumber());
    printMain(loc.getRowStartNumber(),loc.getRowEndNumber(),node->getFSM());
    //printSuffix();

    inFile.close();
}

void testPlugin::printPrefix(int val){
    std::string lineStr;

    for(int i=1;i < val;i++) {
        std::getline(inFile, lineStr);
        ss << lineStr << std::endl;
    }

    ss << "//------------------------------------------------------------------------------------\n";
}

void testPlugin::printMain(int val1, int val2, FSM *node) {
    std::string lineStr,fName;
    for(int i = val1; i <= val2; i++){
        std::getline(inFile,lineStr);
        if (lineStr.find("SC_HAS_PROCESS(")!= std::string::npos) ss << "unsigned int originState;" << std::endl;

        std::size_t startPosition = lineStr.find("SC_THREAD(");
        if (startPosition != std::string::npos) {
            startPosition += 10;
            std::size_t length = lineStr.find(")") - startPosition;
            fName = lineStr.substr(startPosition, length);
        }

        /*for(auto state : node->getStateMap()) {
            if (state.second->isInit() | state.second->isWait()) continue;
            LocationInfo loc = stateStmt.at(state.first)->getStmtInfo();
            if (i == loc.getRowStartNumber()){
                for(auto op : state.second->getOutgoingOperationsList()){
                    if ((op->getState() == op->getNextState()) | (op->getState()->isWait()) | (op->getState()->isInit())) continue;
                    ss << "if (originState == " << op->getState()->getStateId() << ") \n";
                    for(auto st: op->getStatementsList()){
                        If *ifStmt = NodePeekVisitor::nodePeekIf(st);
                        if(ifStmt != nullptr){
                            if(NodePeekVisitor::nodePeekSyncSignal(ifStmt->getConditionStmt()) == nullptr){
                                ss << PrintStmt::toString(st) << "\n";
                            }
                        }
                    }
                    ss << "PowerEstimator::getInstance().countOperation(name(), " << op->getId() << ");" << std::endl;
                }
                //ss << "-----------------" << state.first << "----------------" << std::endl;
                break;
            }
        }*/

        ss << lineStr << std::endl;

        if ((lineStr.find("void ") != std::string::npos) & (lineStr.find(fName) != std::string::npos) & (lineStr.find(";") == std::string::npos)) {
                    ss << "PowerEstimator::getInstance().initializeOperations(name(), " << opNo << ");" << std::endl;
                    ss << "PowerEstimator::getInstance().countOperation(name(), 0);" << std::endl;
        }

        bool flag = false;
        for(auto state : node->getStateMap()) {
            if (state.second->isInit() | state.second->isWait()) continue;
            LocationInfo locSt = stateStmt.at(state.first)->getStmtInfo();
            if (i == locSt.getRowStartNumber()){
                ss << "originState = " << state.first << ";" << std::endl;
                //ss << "-----------------" << state.first << "----------------" << std::endl;
                flag = true;
            }
            for (auto op : state.second->getOutgoingOperationsList()){
                if (op->getState() == op->getNextState()) continue;
                LocationInfo locOp = opStmt.at(op->getId())->getStmtInfo();
                if (i == locOp.getRowStartNumber()){
                    ss << "if (originState == " << op->getState()->getStateId() << ") ";
                    for(auto st: op->getStatementsList()){
                        If *ifStmt = NodePeekVisitor::nodePeekIf(st);
                        if(ifStmt != nullptr){
                            if(NodePeekVisitor::nodePeekSyncSignal(ifStmt->getConditionStmt()) == nullptr){
                                ss << PrintStmt::toString(st) << " ";
                            }
                        }
                    }
                    ss << "PowerEstimator::getInstance().countOperation(name(), " << op->getId() << ");" << std::endl;
                }
            }
            if (flag) break;
        }
    }

    ss << "//------------------------------------------------------------------------------------\n";
}

void testPlugin::printSuffix() {
    std::string lineStr;
    while (std::getline(inFile,lineStr)) ss << lineStr << std::endl;
}

void testPlugin::findStateStmt(FSM *node) {
    for (auto state : node->getStateMap()) {
        if (state.second->isWait() ) continue;
        else if (state.second->isInit())  {
            for (auto op : state.second->getOutgoingOperationsList()){
                for (auto st : op->getStatementsList()){
                    if (NodePeekVisitor::nodePeekAssignment(st) != nullptr){
                        vars.insert(PrintStmt::toString(NodePeekVisitor::nodePeekAssignment(st)->getLhs()));
                    }
                }
                break;
            }
            continue;
        }
        bool flag = false;
        for (auto op : state.second->getOutgoingOperationsList()) {
            for (auto st : op->getStatementsList()) {
                if (NodePeekVisitor::nodePeekRead(st) != nullptr | NodePeekVisitor::nodePeekWrite(st) != nullptr) {
                    stateStmt.insert(std::make_pair(state.first, st));
                    flag = true;
                    break;
                }
            }
            if (flag) break;
        }
    }

}

void testPlugin::findOpStmt(FSM *node) {
    for (auto state : node->getStateMap()){
        for (auto op : state.second->getOutgoingOperationsList()){
            if (op->getState() == op->getNextState()) continue;
            if (!(op->getState()->isInit() | op->getState()->isWait())){
                bool flagif = false;
                bool flagset = false;
                for (auto it = op->getStatementsList().rbegin(); it != op->getStatementsList().rend();it++){
                    auto st = *it;
                    if (NodePeekVisitor::nodePeekIf(st)!= nullptr) {
                        flagif = true;
                    } else if (flagif){
                        opStmt.insert(std::make_pair(op->getId(),st));
                        flagset = true;
                        break;
                    }
                }
                if (!flagset) opStmt.insert(std::make_pair(op->getId(),stateStmt.at(state.first)));
            }
            opNo++;
        }
    }
    //opNo;
}