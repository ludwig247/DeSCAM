//
// Created by wezel on 9/24/20.
//



#include "ChannelProperties.h"

//#include <Stmts_all.h>
//#include <PrintStmt.h>
//#include <ModelGlobal.h>
//#include <PrintITL/PrintITL.h>
//#include <ReconstructOperations.h>
//#include <ExprVisitor.h>
#include <PropertyFactory.h>
#include <ValidOperations.h>
//#include <z3++.h>
//#include <ExprTranslator.h>
#include <chrono>
#include <OperationOptimizations/ConditionOptimizer2.h>
//#include "Model.h"



ChannelProperties::ChannelProperties (DESCAM::Module *module) :
        module(module)
{
    generateProperties();
}

void ChannelProperties::generateProperties() {
    //Step0:Define start and end nodes
    for (auto func: module->getFunctionMap()){
        eventID start;
        eventID end;
        eventID function;
        std::string name = func.first;
        start.eventname = name + "_sync";
        end.eventname = name + "_notify";
        function.eventname = name;
        for(auto node: func.second->getCfg()){
            //Find node without predecessor or predecessors that only have higher IDs and set it as startnode
            auto preds = node.second->getPredecessorList();
            if(preds.size() == 0){
                start.id = node.first;
                function.id = node.first;
            }
            else{
                bool id_is_greater = false;
                for(auto pred: preds){
                    //check if ID of predecessor is greater than the ID of the node
                    if(pred->getId() > node.first){
                        id_is_greater = true;
                    }
                }
                if(!id_is_greater){
                    start.id = node.first;
                    function.id = node.first;
                }
            }
            //Find node without successors and set it as endnode
            auto succs = node.second->getSuccessorList();
            if(succs.size() == 0){
                end.id = node.first;
            }
        }
        startnodes.push_back(start);
        endnodes.push_back(end);
        functions.push_back(function);
    }


    //Step1:Find important states
    std::vector<std::map<int, DESCAM::CfgNode *>> importantStatesVector;

    //Find all important states for the CFG of each function
    for(int i=0; i<module->getFunctionMap().size();i++){
        std::map<int, DESCAM::CfgNode*> importantStates;
        findImportantStates(allcontrolFlowMaps.at(i),&importantStates);
        importantStatesVector.push_back(importantStates);
    }


    //Step2:Find Sub-Paths
    for(int i=0; i<allcontrolFlowMaps.size();i++) {
        //Find Sub-Paths for each function
        auto start = allcontrolFlowMaps.at(i).begin()->second;
        //Find Sub-Paths starting from first node
        findPathsfromNode(start, &subPaths.at(i), &subPathsIDs.at(i));
        //Find Sub-Paths starting from important states
        for (auto const &node : importantStatesVector.at(i)) {
            findPathsfromNode(node.second, &subPaths.at(i), &subPathsIDs.at(i));
        }
    }

    //Push all paths to allSubPaths variable
    for(int i=0; i<subPaths.size();i++){
        for(int j=0; j<subPathsIDs.at(i).size();j++){
            pathIDStmt p = {subPathsIDs.at(i).at(j),subPaths.at(i).at(j)};
            allSubPaths.push_back(p);
        }
    }


    //Step3:Generate Permutations
    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);


    //Step4:Combine Sub-Paths to generate the Operations
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    int i = 0;
    std::chrono::steady_clock::time_point begin;
    std::chrono::steady_clock::time_point end;

    // generate all Paths combining all CFGs and store them in variable finalPaths
    std::chrono::steady_clock::time_point begin_all = std::chrono::steady_clock::now();
    for(auto perm: permutations){
        //set ready queue to current permutation and clear blocked queue
        readyQueue = perm;
        blockedFunctions.clear();
        begin = std::chrono::steady_clock::now();
        combinePaths(readyQueue,blockedFunctions);
        end = std::chrono::steady_clock::now();
        std::cout << "Time needed for permutation " << ++i << ": " << std::chrono::duration_cast<std::chrono::milliseconds>(end-begin).count() <<" [ms]" << std::endl;
        std::cout << "Number of operations: " << operationsFinal.size() << std::endl;
        //if(i>2) break;
    }
    std::chrono::steady_clock::time_point end_all = std::chrono::steady_clock::now();
    std::cout << "Time needed for all permutations: " << std::chrono::duration_cast<std::chrono::milliseconds>(end_all-begin_all).count() <<" [ms]" << std::endl;

    //Set Incoming and Outgoing Operations
    for(auto op:operationsFinal){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }

    //add reset operation
    //TODO: auto rOperations = new ReconstructOperations(module);
    //TODO: rOperations->sortOperation(reset_op);
    for(int i=0; i<startnodes.size();i++){
        auto noti = new Notify(module->getPort(portnames.at(i)));
        auto assign = new Assignment(noti,new BoolValue(false));
        reset_op->addCommitment(assign);
    }
    operationsFinal.push_back(reset_op);

    //Create empty path for reset operation
    std::vector<int> int_vec;
    std::vector<DESCAM::Stmt*> stmt_vec;
    pathIDStmt temp = {int_vec,stmt_vec};
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    //TODO: rOperations->sortOperation(wait_op);
    for(int i=0; i<startnodes.size();i++){
        auto sync = new SyncSignal(module->getPort(portnames.at(i)));
        auto noti = new Notify(module->getPort(portnames.at(i)));
        wait_op->addAssumption(new UnaryExpr("not",sync));
        auto assign = new Assignment(noti,new BoolValue(false));
        wait_op->addCommitment(assign);
    }
    operationsFinal.push_back(wait_op);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);


    //Step5:Create Property File
    //Statemap consists of a initial state Init and one state start_state
    std::map<int,State*> stateMap;
    stateMap.insert(std::make_pair(init->getStateId(),init ));
    stateMap.insert(std::make_pair(start_state->getStateId(),start_state));
    module->getFSM()->setStateMap(stateMap);

    //Create PropertySuite
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());

//    //Print ITL Properties to file
//    PrintITL printITL;
//    auto map = printITL.printModule(module);
//    std::ofstream myfile;
//    myfile.open("/tests/Buffer_Channel_Properties/" + module->getName() + "_generated.vhi");
//    myfile << map.at(module->getName() + ".vhi") << std::endl;
//    myfile.close();

}

std::string ChannelProperties::printCFG(std::map<int,DESCAM::CfgNode*> controlFlowMap) {
    //Print CFG for debugging
    std::stringstream ss;
    for (auto node: controlFlowMap) {
        DESCAM::CfgNode *sus = node.second;

        ss << "[ID" << node.first << "] [Node" << sus->getName() << "]" << "\n";
        ss << "\tStmnt: " << "\n";


        auto stmt = sus->getStmt();
        ss << "\t\t" << PrintStmt::toString(stmt) << "\n";

        ss << "\tPred: ";
        for (auto pred: sus->getPredecessorList()) {
            ss << "[ID" << pred->getId() << "], ";
        }
        ss << "\n";;
        ss << "\tSucc: ";
        for (auto succ: sus->getSuccessorList()) {
            ss << "[ID" << succ->getId() << "], ";
        }
        ss << "\n";
    }
    return ss.str();
}

void ChannelProperties::findImportantStates(std::map<int,DESCAM::CfgNode*> controlFlowMap, std::map<int,DESCAM::CfgNode*>* importantStateMap) {
    //Iterate over all CfgNodes and find wait and return statements
    for (auto node : controlFlowMap) {
        //Nodes with a wait statement
        if (NodePeekVisitor::nodePeekWait(node.second->getStmt())) {
            importantStateMap->insert(node);
        }
        //Nodes with a return statement
        if (NodePeekVisitor::nodePeekReturn(node.second->getStmt())) {
            importantStateMap->insert(node);
        }
    }
    return;
}

void ChannelProperties::findPathsfromNode(DESCAM::CfgNode* startnode, std::vector<std::vector<DESCAM::Stmt*>> *pathsFromStart, std::vector<std::vector<int>> *pathsAsIDs){
    //Recursively compute all successors starting from startnode
    //Push _back id of CfgNode to currentPath with each function call
    static std::vector<DESCAM::Stmt*> currentPath;
    static std::vector<int> nodeIDPath;
    currentPath.push_back(startnode->getStmt());
    nodeIDPath.push_back(startnode->getId());
    //check if node has at least one successor and node is no wait or return
    if (startnode->getSuccessorList().size() >= 1 && (!NodePeekVisitor::nodePeekWait(startnode->getStmt()) && !NodePeekVisitor::nodePeekReturn(startnode->getStmt()) || currentPath.size() == 1)){
        //true successor
        findPathsfromNode(startnode->getSuccessorList().at(0),pathsFromStart,pathsAsIDs);
        //Node is an If statement
        if(startnode->getSuccessorList().size() > 1) {
            //false successor
            auto if_cond = (If *)currentPath.back();
            currentPath.back() = new If(new UnaryExpr("not", if_cond->getConditionStmt()));
            findPathsfromNode(startnode->getSuccessorList().at(1), pathsFromStart, pathsAsIDs);
        }
        //Pop_back id of CfgNode if you return from node
        currentPath.pop_back();
        nodeIDPath.pop_back();
        return;
    }
        //terminal node => creates a new path and adds it to pathsFromStart
    else{
        //only add paths with more than one node
        if(currentPath.size() > 1) {
            pathsFromStart->push_back(currentPath);
            pathsAsIDs->push_back(nodeIDPath);
        }
        //Pop_back id of CfgNode if you return from node
        currentPath.pop_back();
        nodeIDPath.pop_back();
        return;
    }
}

void ChannelProperties::combinePaths(std::vector<eventID> readyQueue, std::vector<eventID> blockedFunctions) {
    static pathIDStmt currentPath;
    bool equal_commits;

    //Try out all paths
    for(auto path: allSubPaths){
        //Check if there are still functions to run
        if(readyQueue.size() > 0) {
            int start = readyQueue.front().id;
            //if path starts with id start
            if(path.idList.front()==start){
                //store context to restore it later for other possible paths
                pathIDStmt savedPath = currentPath;
                std::vector<eventID> savedReady = readyQueue;
                std::vector<eventID> savedBlocked = blockedFunctions;

                //add IDs and statements to current path
                currentPath.idList.insert(currentPath.idList.end(),path.idList.begin(),path.idList.end());
                currentPath.stmtList.insert(currentPath.stmtList.end(),path.stmtList.begin(),path.stmtList.end());

                //check if resulting path is reachabble
                auto test_op = new Operation();
                test_op->setStatementsList(currentPath.stmtList);
                //TODO: auto rOperations = new ReconstructOperations(module);
                //TODO: rOperations->sortOperation(test_op);
                if(!ValidOperations::isOperationReachable(test_op)){
                    //TODO:unreachable_count++;
                    currentPath = savedPath;
                    readyQueue = savedReady;
                    blockedFunctions = savedBlocked;
                    continue;
                }


                //check if path stmts contain a notify
                for(auto p:path.idList){
                    //if node is a notify statement
                    Notify* notify = NodePeekVisitor::nodePeekNotify(controlFlowMap.at(p)->getStmt());
                    if(notify){
                        int size = blockedFunctions.size();
                        for(int i=0; i < size;i++){
                            //check if function is existent in blockedFunctions
                            for(auto iter=blockedFunctions.begin(); iter!=blockedFunctions.end(); ++iter)
                            {
                                std::string eventname ;//TODO: = notify->getEventname();
                                if(iter->eventname == eventname) {
                                    //add function to readyQueue
                                    readyQueue.push_back(*iter);
                                    //remove function from blockedFunctions
                                    blockedFunctions.erase(iter);
                                    break;
                                }
                            }
                        }
                    }
                }

                //check if path ends with a wait
                Wait* wait = NodePeekVisitor::nodePeekWait(controlFlowMap.at(path.idList.back())->getStmt());
                if(wait)
                {
                    std::string eventname = wait->getStateName();
                    //add function to blockedFunctions
                    eventID blocked = {path.idList.back(),eventname};
                    blockedFunctions.push_back(blocked);
                    //remove function from readyQueue
                    readyQueue.erase(readyQueue.begin());
                }
                //check if path ends with return
                if(NodePeekVisitor::nodePeekReturn(controlFlowMap.at(path.idList.back())->getStmt()))
                {
                    //remove function from readyQueue
                    readyQueue.erase(readyQueue.begin());
                }

                //Start Recursion
                combinePaths(readyQueue,blockedFunctions);

                //After reaching the end of a path:
                //Restore Context to old value to be able to try next path
                currentPath = savedPath;
                readyQueue = savedReady;
                blockedFunctions = savedBlocked;
            }
        }
        else {
            //End of path reached
            //Create Operation and compare commitments with all other commitments
            auto op = new Operation();
            if (currentPath.idList.size() > 0){
                //Create new Operation
                op->setState(start_state);
                op->setNextState(start_state);
                std::vector<DESCAM::Stmt*> statementList;
                for(auto stmt :currentPath.stmtList){
                    statementList.push_back(stmt);
                }
                op->setStatementsList(statementList);
                //TODO
//                auto rOperations = new ReconstructOperations(module);
//                rOperations->sortOperation(op);

                //Add sync and notify
                //Arrays that state if sync or notify needs to be added
                bool addsync[startnodes.size()];
                bool addnoti[startnodes.size()];

                //Sync and Notify are unset by default
                for(int j=0;j<startnodes.size();j++){
                    addsync[j] = false;
                    addnoti[j] = false;
                }

                for(auto id: currentPath.idList){
                    for(int j=0; j<startnodes.size();j++){
                        //If the startnode of a function is contained in the path, add the sync of that function
                        if(id==startnodes.at(j).id){
                            addsync[j]=true;
                        }
                        //If the endnode of a function is contained in the path, add the notify of that function
                        if(id==endnodes.at(j).id){
                            addnoti[j]=true;
                        }
                    }
                }

                for(int j=0; j<startnodes.size();j++){
                    //Add Sync and Notify to Assumptions/Commitments
                    auto sync = new SyncSignal(module->getPort(portnames.at(j)));
                    auto noti = new Notify(module->getPort(portnames.at(j)));
                    if(addsync[j]){
                        op->addAssumption(sync);
                    }
                    else{
                        op->addAssumption(new UnaryExpr("not",sync));
                    }
                    if(addnoti[j]){
                        auto assign = new Assignment(noti,new BoolValue(true));
                        op->addCommitment(assign);
                    }
                    else{
                        auto assign = new Assignment(noti,new BoolValue(false));
                        op->addCommitment(assign);
                    }
                }

                //Compare commitments
                bool was_merged = false;
                for(auto comp_op: operationsFinal){
                    if(comp_op->getCommitmentsList().size()==op->getCommitmentsList().size()){
                        equal_commits = true;
                        for(int i=0; i< op->getCommitmentsList().size();i++){
                            if(!(*comp_op->getCommitmentsList().at(i)==*op->getCommitmentsList().at(i))){
                                //if one pair of commitments is not equal: stop
                                equal_commits = false;
                                break;
                            }
                        }
                        //if all commitments are equal, merge the AssumptionLists of both operations
                        if(equal_commits){
                            //Merge
                            DESCAM::Expr* combined_assump_list = new BoolValue(true);
                            auto assump_list = op->getAssumptionsList();
                            for(auto assump: assump_list){
                                combined_assump_list = new Logical(combined_assump_list,"and",assump);
                            }
                            DESCAM::Expr* combined_assump_list2 = new BoolValue(true);
                            auto comp_assump_list = comp_op->getAssumptionsList();
                            for(auto assump: comp_assump_list){
                                combined_assump_list2 = new Logical(combined_assump_list2,"and",assump);
                            }
                            auto merged_assump_list = new Logical(combined_assump_list,"or",combined_assump_list2);
                            std::vector<DESCAM::Expr *> merged_assump_vector;
                            merged_assump_vector.push_back(merged_assump_list);
                            //TODO:ModelGlobal::setModel(new Model("test"));
                            //TODO:ModelGlobal::getModel()->addModule(this->module);
                            auto opti = new ConditionOptimizer2(merged_assump_vector,this->module);
                            comp_op->setAssumptionsList(opti->getNewConditionList());
                            was_merged = true;
                            //TODO:merge_count++;
                            break;
                        }
                    }
                }
                //If the operation wasn't merged it is a relevant new one, so store it
                if(!was_merged){
                    //if operation is reachable add it to operationsFinal
                    operationsFinal.push_back(op);
                }

            }
            return;
        }
    }
}

void ChannelProperties::computePermutations(std::vector<eventID> functionVec){

}