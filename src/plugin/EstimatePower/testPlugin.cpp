//
// Created by lanrez on 8/13/20.
//

#include "testPlugin.h"
#include <PrintStmt.h>
#include <NodePeekVisitor.h>
#include <math.h>



std::map<std::string, std::string> testPlugin::printModel(Model *node) {

    std::map<std::string, Module *> moduleMap = node->getModules();
    for (auto module : node->getModules()) {

        //findStateStmt(module.second->getFSM());
        findOpStmt(module.second->getFSM());
        setVarStr(vars);
        instrumentModule(module.second);


        for (auto v : module.second->getFSM()->getStateMap()){
            if (v.second->isInit()) continue;
            auto w = v.second->getOutgoingOperationsList().at(32);
            for (auto x: w->getStatementsList()){
                std::cout << "St" << std::endl;
                std::cout << PrintStmt::toString(x) << std::endl;
            }
            for (auto x: w->getAssumptionsList()){
                std::cout << "As" << std::endl;
                std::cout << PrintStmt::toString(x) << std::endl;
            }
            for (auto x: w->getCommitmentsList()){
                std::cout << "Com" << std::endl;
                std::cout << PrintStmt::toString(x) << std::endl;
            }
        }

        /*for (auto v : stateStmt){
            auto loc = v.second->getStmtInfo();
            std::cout << loc.getObject() << v.first << std::endl;
        }*/

        /*for (auto v : opStmt){
            std::cout << v.first << " " << v.second.getObject() << " " << v.second.getRowStartNumber() << std::endl;
        }*/


        //std::cout << ss.str();
        //pluginOutput.insert(std::make_pair("inst_" + module.first + ".h",ss.str()));
    }


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
    for(int i = val1;; i++){
        if (!std::getline(inFile,lineStr)) break;
        if (lineStr.find("SC_HAS_PROCESS(")!= std::string::npos) ss << "unsigned int originState, operation;" << std::endl;

        std::size_t startPosition = lineStr.find("SC_THREAD(");
        if (startPosition != std::string::npos) {
            startPosition += 10;
            std::size_t length = lineStr.find(")") - startPosition;
            fName = lineStr.substr(startPosition, length);
        }

        for(auto state : node->getStateMap()) {
            if (state.second->isInit()) continue;
            LocationInfo loc = state.second->GetLocationInfo();

            if (i == loc.getRowStartNumber()){
                /*for(auto op : state.second->getOutgoingOperationsList()){
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
                }*/
                ss << "PowerEstimator::getInstance().update(name(), operation, " << varStr << ");" << std::endl;
                //ss << "-----------------" << state.first << "----------------" << std::endl;
                break;
            }
        }

        ss << lineStr << std::endl;

        if ((lineStr.find("void ") != std::string::npos) & (lineStr.find(fName) != std::string::npos) & (lineStr.find(";") == std::string::npos)) {
            ss << "PowerEstimator::getInstance().initialize(name(), " << opNo << ", "<< varStr << ");" << std::endl;
            ss << "operation = 0;" << std::endl;
            for (auto state : node->getStateMap()){
                if (state.second->isInit()){
                    for (size_t j = 0; j < vars.size(); ++j) {
                        ss << PrintStmt::toString(state.second->getOutgoingOperationsList().at(0)->getStatementsList().at(j)) << "; ";
                    }
                }
            }
        }

        bool flag = false;
        for(auto state : node->getStateMap()) {
            if (state.second->isInit()) continue;
            LocationInfo locSt = state.second->GetLocationInfo();

            if (i == locSt.getRowStartNumber()){
                ss << "originState = " << state.first << ";" << std::endl;
                //ss << "-----------------" << state.first << "----------------" << std::endl;
                flag = true;
            }
            for (auto op : state.second->getOutgoingOperationsList()){
                if (op->IsWait()) continue;
                //LocationInfo locOp = opStmt.at(op->getId())->getStmtInfo();
                if (i == opStmt.at(op->getId()).getRowStartNumber()){
                    ss << "if (originState == " << op->getState()->getStateId() << ") ";
                    for(auto st: op->getStatementsList()){
                        If *ifStmt = NodePeekVisitor::nodePeekIf(st);
                        if(ifStmt != nullptr){
                            if(NodePeekVisitor::nodePeekSyncSignal(ifStmt->getConditionStmt()) == nullptr){
                                ss << PrintStmt::toString(st) << " ";
                            }
                        }
                    }
                    ss << "operation = " << op->getId() << ";" << std::endl;
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

}

void testPlugin::findOpStmt(FSM *node) {
    for (auto state : node->getStateMap()){
        if (state.second->isInit())  {
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
        for (auto op : state.second->getOutgoingOperationsList()){
            if (op->IsWait()) continue;
            if (!(op->getState()->isInit())){
                bool flagif = false;
                bool flagset = false;
                for (auto it = op->getStatementsList().rbegin(); it != op->getStatementsList().rend();it++){
                    auto st = *it;
                    if (NodePeekVisitor::nodePeekIf(st)!= nullptr) {
                        flagif = true;
                    } else if (flagif){
                        opStmt.insert(std::make_pair(op->getId(),st->getStmtInfo()));
                        flagset = true;
                        break;
                    }
                }
                if (!flagset) opStmt.insert(std::make_pair(op->getId(),state.second->GetLocationInfo()));
            }
            opNo++;
        }
    }
    //opNo;
}

void testPlugin::setVarStr(std::set<std::string> vars) {
    bool flag = false;
    varStr = "{";
    for (auto var : vars){
        if (flag) varStr += (", " + var);
        else {
            varStr += var;
            flag = true;
        }
    }
    varStr += "}";
}