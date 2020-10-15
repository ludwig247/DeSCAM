//
// Created by wezel on 23.04.20.
//

#ifndef DESCAM_OPERATION_GRAPH_H
#define DESCAM_OPERATION_GRAPH_H


#include <gtest/gtest.h>
#include <Stmts_all.h>
#include <PrintStmt.h>
#include <ModelGlobal.h>
#include <PrintITL/PrintITL.h>
#include <ReconstructOperations.h>
#include <ExprVisitor.h>
#include <PropertyFactory.h>
#include <ValidOperations.h>
#include <chrono>
#include <OperationOptimizations/ConditionOptimizer2.h>




#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new SCAM::Module("FIFO")){
    }

    struct pathIDStmt{
        std::vector<int> idList;
        std::vector<SCAM::Stmt*> stmtList;
    };

    struct eventID{
        int id;
        std::string eventname;
    };

    SCAM::Module *module;

    std::map<int, CfgNode *> controlFlowMapWrite;
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMap;

    std::vector<std::vector<SCAM::Stmt*>> pathsWrite;
    std::vector<std::vector<int>> pathsWriteIDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;


    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;

    Operation *reset_op;
    std::vector<pathIDStmt> allPaths;
    std::vector<pathIDStmt> finalPaths;
    std::vector<Operation*> operationsFinal;
    std::vector<pathIDStmt> finalPathsOpt;
    std::vector<Operation*> operationsFinalOpt;
    State* start_state;
    State* init;
    std::vector<std::vector<eventID>>permutations;
    std::vector<std::string> portnames;



    int merge_count;
    int unreachable_count;


    std::string printCFG(std::map<int,CfgNode*> controlFlowMap) {
        //Print CFG for debugging
        std::stringstream ss;
        for (auto node: controlFlowMap) {
            CfgNode *sus = node.second;

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
    void findImportantStates(std::map<int,CfgNode*> controlFlowMap, std::map<int,CfgNode*>* importantStateMap) {
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
    void findPathsfromNode(CfgNode* startnode, std::vector<std::vector<SCAM::Stmt*>> *pathsFromStart, std::vector<std::vector<int>> *pathsAsIDs){
        //Recursively compute all successors starting from startnode
        //Push _back id of CfgNode to currentPath with each function call
        static std::vector<SCAM::Stmt*> currentPath;
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
    void combinePaths(std::vector<eventID> readyQueue, std::vector<eventID> blockedFunctions) {
        static pathIDStmt currentPath;
        bool equal_commits;

        //Try out all paths
        for(auto path: allPaths){
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
                    auto rOperations = new ReconstructOperations(module);
                    rOperations->sortOperation(test_op);
                    if(!ValidOperations::isOperationReachable(test_op)){
                        unreachable_count++;
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
                                    std::string eventname = notify->getEventname();
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
                    std::vector<SCAM::Stmt*> statementList;
                    for(auto stmt :currentPath.stmtList){
                        statementList.push_back(stmt);
                    }
                    op->setStatementsList(statementList);
                    auto rOperations = new ReconstructOperations(module);
                    rOperations->sortOperation(op);

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
                    for(auto comp_op: operationsFinalOpt){
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
                                SCAM::Expr* combined_assump_list = new BoolValue(true);
                                auto assump_list = op->getAssumptionsList();
                                for(auto assump: assump_list){
                                    combined_assump_list = new Logical(combined_assump_list,"and",assump);
                                }
                                SCAM::Expr* combined_assump_list2 = new BoolValue(true);
                                auto comp_assump_list = comp_op->getAssumptionsList();
                                for(auto assump: comp_assump_list){
                                    combined_assump_list2 = new Logical(combined_assump_list2,"and",assump);
                                }
                                auto merged_assump_list = new Logical(combined_assump_list,"or",combined_assump_list2);
                                std::vector<SCAM::Expr *> merged_assump_vector;
                                merged_assump_vector.push_back(merged_assump_list);
                                ModelGlobal::setModel(new Model("test"));
                                ModelGlobal::getModel()->addModule(this->module);
                                auto opti = new ConditionOptimizer2(merged_assump_vector,this->module);
                                comp_op->setAssumptionsList(opti->getNewConditionList());
                                was_merged = true;
                                merge_count++;
                                break;
                            }
                        }
                    }
                    //If the operation wasn't merged it is a relevant new one, so store it
                    if(!was_merged){
                        //if operation is reachable add it to operationsFinalOpt
                        operationsFinalOpt.push_back(op);
                    }

                }
                return;
            }
        }
    }
    void computePermutations(std::vector<eventID> functionVec){
        static std::vector<eventID> currentPerm;
        if(functionVec.size()>0){
            for(eventID func: functionVec){
                auto reduced_functions = functionVec;
                //only allow ordered permutations
                int compare_id = currentPerm.size()>0 ? currentPerm.back().id : -1;
                if(func.id> compare_id){
                    //if a new function can be added, push currentPerm to permutations
                    currentPerm.push_back(func);
                    permutations.push_back(currentPerm);
                    reduced_functions.erase(reduced_functions.begin());
                    computePermutations(reduced_functions);
                    currentPerm.pop_back();
                }
            }
        }
        return;
    }
    virtual void SetUp() {
        //create variables and datatypes
        auto states = new DataType("states");
        DataTypes::addDataType(states);
        states->addEnumValue("EMPTY");
        states->addEnumValue("FILLED");
        states->addEnumValue("FULL");
        auto array= new DataType("int_8");
        DataTypes::addDataType(array);
        array->addArray(DataTypes::getDataType("int"),8);
        auto buffer = new Variable("buffer", array);
        auto size = new IntegerValue(3);
        auto state = new Variable("state", states);
        auto head = new Variable("head", DataTypes::getDataType("int"));
        auto tail = new Variable("tail", DataTypes::getDataType("int"));
        auto out = new Port("out",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto val = new Port("val",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(buffer);
        module->addVariable(state);
        module->addVariable(head);
        module->addVariable(tail);
        module->addPort(out);
        module->addPort(val);

        //Read Expressions/Assignments
        //if(state == EMPTY)
        auto empty_enum = new EnumValue("EMPTY", states);
        auto state_eq_empty = new Relational(new VariableOperand(module->getVariable("state")),"==",empty_enum);
        auto check_state_empty = new If(state_eq_empty);
        //wait(writer_notify)
        auto writer_wait = new Wait("writer_notify");
        //out = buffer[tail]
        auto port_out = new DataSignalOperand(out->getDataSignal());
        auto buffer_at_tail = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(module->getVariable(("tail"))));
        auto out_assign_buffer_at_tail = new Assignment(port_out,buffer_at_tail);
        //tail = (tail+1)%fifo_size
        auto tail_increment = new Arithmetic(new VariableOperand(module->getVariable("tail")),"+",new IntegerValue(1));
        auto tail_modulo_increment = new Arithmetic(tail_increment,"%", size);
        auto tail_assign_tail_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail")),tail_modulo_increment);
        //state = FILLED
        auto *filled_enum = new EnumValue("FILLED",states);
        auto *state_assign_filled = new Assignment(new VariableOperand(module->getVariable("state")),filled_enum);
        //if(head == tail)
        auto head_eq_tail = new Relational(new VariableOperand(module->getVariable("head")),"==",new VariableOperand(module->getVariable("tail")));
        auto if_head_eq_tail = new If(head_eq_tail);
        //state = EMPTY
        auto state_assign_empty = new Assignment(new VariableOperand(module->getVariable("state")),empty_enum);
        auto noti0 = new Notify("Debug0");
        auto ret0 = new Return("Debug0");
        //reader_notify.notify()
        auto notify_reader = new Notify("reader_notify");
        //return
        auto read_return = new Return("read_return");

        //Write Expressions/Assignments
        //if (state == FULL)
        auto full_enum = new EnumValue("FULL", states);
        auto state_eq_full = new Relational(new VariableOperand(module->getVariable("state")),"==",full_enum);
        auto check_state_full = new If(state_eq_full);
        //wait(reader_notify);
        auto reader_wait = new Wait("reader_notify");
        //buffer[head] = val;
        auto port_val = new DataSignalOperand(val->getDataSignal());
        auto buffer_at_head = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(head));
        auto buffer_at_head_assign_val = new Assignment(buffer_at_head, port_val);
        //head = (head+1)%size
        auto head_increment = new Arithmetic(new VariableOperand(module->getVariable("head")),"+",new IntegerValue(1));
        auto head_modulo_increment = new Arithmetic(head_increment,"%", size);
        auto head_assign_head_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head")),head_modulo_increment);
        //state = FILLED
        //already exists
        //if (head==tail)
        //already exists
        //state = FULL
        auto state_assign_full = new Assignment(new VariableOperand(module->getVariable("state")),full_enum);
        //writer_notify.notify()
        auto notify_writer = new Notify("writer_notify");
        //return
        auto write_return = new Return("write_return");

        //CFG nodes Read
        auto state_equal_empty = new CfgNode(check_state_empty);
        auto read_wait = new CfgNode(writer_wait);
        auto read_value = new CfgNode(out_assign_buffer_at_tail);
        auto tail_incr = new CfgNode(tail_assign_tail_modulo_increment);
        auto state_filled_read = new CfgNode(state_assign_filled);
        auto head_equal_tail_read = new CfgNode(if_head_eq_tail);
        auto state_empty = new CfgNode(state_assign_empty);
        auto reader_noti = new CfgNode(notify_reader);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        state_equal_empty->addSuccessor(read_wait);
        state_equal_empty->addSuccessor(read_value);
        read_wait->addSuccessor(read_value);
        read_value->addSuccessor(tail_incr);
        tail_incr->addSuccessor(state_filled_read);
        state_filled_read->addSuccessor(head_equal_tail_read);
        head_equal_tail_read->addSuccessor(state_empty);
        head_equal_tail_read->addSuccessor(reader_noti);
        state_empty->addSuccessor(reader_noti);
        reader_noti->addSuccessor(return_read);

        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait->getId(),read_wait));
        controlFlowMapRead.insert(std::make_pair(read_value->getId(),read_value));
        controlFlowMapRead.insert(std::make_pair(tail_incr->getId(),tail_incr));
        controlFlowMapRead.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
        controlFlowMapRead.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
        controlFlowMapRead.insert(std::make_pair(state_empty->getId(),state_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti->getId(),reader_noti));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        controlFlowMap.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
        controlFlowMap.insert(std::make_pair(read_wait->getId(),read_wait));
        controlFlowMap.insert(std::make_pair(read_value->getId(),read_value));
        controlFlowMap.insert(std::make_pair(tail_incr->getId(),tail_incr));
        controlFlowMap.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
        controlFlowMap.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
        controlFlowMap.insert(std::make_pair(state_empty->getId(),state_empty));
        controlFlowMap.insert(std::make_pair(reader_noti->getId(),reader_noti));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

        //Print CFG for Read
        std::cout << printCFG(controlFlowMapRead) << std::endl;

        //CFG nodes Write
        auto state_equal_full = new CfgNode(check_state_full);
        auto write_wait = new CfgNode(reader_wait);
        auto write_value = new CfgNode(buffer_at_head_assign_val);
        auto head_incr = new CfgNode(head_assign_head_modulo_increment);
        auto state_filled_write = new CfgNode(state_assign_filled);
        auto head_equal_tail_write = new CfgNode(if_head_eq_tail);
        auto state_full = new CfgNode(state_assign_full);
        auto writer_noti = new CfgNode(notify_writer);
        auto return_write = new CfgNode(write_return);

        //Connect CFG nodes Write
        state_equal_full->addSuccessor(write_wait);
        state_equal_full->addSuccessor(write_value);
        write_wait->addSuccessor(write_value);
        write_value->addSuccessor(head_incr);
        head_incr->addSuccessor(state_filled_write);
        state_filled_write->addSuccessor(head_equal_tail_write);
        head_equal_tail_write->addSuccessor(state_full);
        head_equal_tail_write->addSuccessor(writer_noti);
        state_full->addSuccessor(writer_noti);
        writer_noti->addSuccessor(return_write);

        //Create map with CFG nodes Write
        controlFlowMapWrite.insert(std::make_pair(state_equal_full->getId(),state_equal_full));
        controlFlowMapWrite.insert(std::make_pair(write_wait->getId(),write_wait));
        controlFlowMapWrite.insert(std::make_pair(write_value->getId(),write_value));
        controlFlowMapWrite.insert(std::make_pair(head_incr->getId(),head_incr));
        controlFlowMapWrite.insert(std::make_pair(state_filled_write->getId(),state_filled_write));
        controlFlowMapWrite.insert(std::make_pair(head_equal_tail_write->getId(),head_equal_tail_write));
        controlFlowMapWrite.insert(std::make_pair(state_full->getId(),state_full));
        controlFlowMapWrite.insert(std::make_pair(writer_noti->getId(),writer_noti));
        controlFlowMapWrite.insert(std::make_pair(return_write->getId(),return_write));

        controlFlowMap.insert(std::make_pair(state_equal_full->getId(),state_equal_full));
        controlFlowMap.insert(std::make_pair(write_wait->getId(),write_wait));
        controlFlowMap.insert(std::make_pair(write_value->getId(),write_value));
        controlFlowMap.insert(std::make_pair(head_incr->getId(),head_incr));
        controlFlowMap.insert(std::make_pair(state_filled_write->getId(),state_filled_write));
        controlFlowMap.insert(std::make_pair(head_equal_tail_write->getId(),head_equal_tail_write));
        controlFlowMap.insert(std::make_pair(state_full->getId(),state_full));
        controlFlowMap.insert(std::make_pair(writer_noti->getId(),writer_noti));
        controlFlowMap.insert(std::make_pair(return_write->getId(),return_write));

        //Print CFG Write
        std::cout << printCFG(controlFlowMapWrite) << std::endl;

        init = new State("init");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        reset_op->addStatement(state_assign_empty);
        auto zero = new IntegerValue(0);
        auto tail_assign_0 = new Assignment(new VariableOperand(module->getVariable("tail")),zero);
        auto head_assign_0 = new Assignment(new VariableOperand(module->getVariable("head")),zero);
        reset_op->addStatement(tail_assign_0);
        reset_op->addStatement(head_assign_0);
        reset_op->setState(init);
        start_state = new State("Start_State");
        reset_op->setNextState(start_state);
        reset_op->setReset(true);

        //set start and end nodes for sync and notify
        eventID temp;
        temp = {0,"read_sync"};
        startnodes.push_back(temp);
        temp = {9,"write_sync"};
        startnodes.push_back(temp);


        temp = {8,"read_notify"};
        endnodes.push_back(temp);
        temp = {17,"write_notify"};
        endnodes.push_back(temp);

        //Define portnames for notify and sync signals
        portnames.push_back("out");
        portnames.push_back("val");

    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){

    //Find important states Read
    std::map<int, CfgNode *> importantStatesRead;
    findImportantStates(controlFlowMapRead,&importantStatesRead);

    //Find paths Read
    auto start_Read = controlFlowMapRead.begin()->second;
    findPathsfromNode(start_Read,&pathsRead,&pathsReadIDs);
    for(auto const& node : importantStatesRead) {
        findPathsfromNode(node.second,&pathsRead,&pathsReadIDs);
    }

    //Find important states Write
    std::map<int, CfgNode *> importantStatesWrite;
    findImportantStates(controlFlowMapWrite,&importantStatesWrite);

    //Find paths Write
    auto start_Write = controlFlowMapWrite.begin()->second;
    findPathsfromNode(start_Write,&pathsWrite,&pathsWriteIDs);
    for(auto const& node : importantStatesWrite) {
        findPathsfromNode(node.second,&pathsWrite,&pathsWriteIDs);
    }

    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<eventID> hv;

    //Define all possible functions and their starting nodes
    eventID Read = {0,"Read"};
    eventID Write = {9,"Write"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(Read);
    functions.push_back(Write);

    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);

    std::cout << "Number of permutations: " <<permutations.size() << std::endl;

    //add all functions from always_ready to all permuations
    for(auto readyFunc : always_ready){
        for(auto perm = permutations.begin(); perm != permutations.end(); ++perm){
            perm->push_back(readyFunc);
        }
    }
    //construct a vector of all paths by pushing all paths to allPaths
    for(int i=0; i<pathsReadIDs.size();i++){
        pathIDStmt p = {pathsReadIDs.at(i),pathsRead.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs.size();i++){
        pathIDStmt p = {pathsWriteIDs.at(i),pathsWrite.at(i)};
        allPaths.push_back(p);
    }

    int i = 0;
    merge_count=0;
    unreachable_count=0;
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
        std::cout << "Number of operations: " << operationsFinalOpt.size() << std::endl;
        //if(i>2) break;
    }
    std::chrono::steady_clock::time_point end_all = std::chrono::steady_clock::now();
    std::cout << "Time needed for all permutations: " << std::chrono::duration_cast<std::chrono::milliseconds>(end_all-begin_all).count() <<" [ms]" << std::endl;

    int cnt = 0;
    std::vector<SCAM::Stmt*> statementList;

    auto rOperations = new ReconstructOperations(module);

    //Set Incoming and Outgoing Operations
    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }

    //add reset operation
    rOperations->sortOperation(reset_op);
    for(int i=0; i<startnodes.size();i++){
        auto noti = new Notify(module->getPort(portnames.at(i)));
        auto assign = new Assignment(noti,new BoolValue(false));
        reset_op->addCommitment(assign);
    }
    operationsFinalOpt.push_back(reset_op);
    //Create empty path for reset operation
    std::vector<int> int_vec;
    std::vector<SCAM::Stmt*> stmt_vec;
    pathIDStmt temp = {int_vec,stmt_vec};
    //finalPathsOpt.push_back(temp);
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    rOperations->sortOperation(wait_op);
    for(int i=0; i<startnodes.size();i++){
        auto sync = new SyncSignal(module->getPort(portnames.at(i)));
        auto noti = new Notify(module->getPort(portnames.at(i)));
        wait_op->addAssumption(new UnaryExpr("not",sync));
        auto assign = new Assignment(noti,new BoolValue(false));
        wait_op->addCommitment(assign);
    }

    operationsFinalOpt.push_back(wait_op);
    //create empty path for wait operation
    //finalPathsOpt.push_back(temp);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);

//    //Debug: Print Assumptions and Commitments for operationsFinalOpt
//    for(auto op: operationsFinalOpt){
//        std::cout << "Assumptions Operation " << op->getId() <<std::endl;
//        for(auto assump: op->getAssumptionsList()){
//            std::cout << *assump << std::endl;
//        }
//        std::cout << std::endl;
//        std::cout << "Commitments Operation" << op->getId() <<std::endl;
//        for(auto commit: op->getCommitmentsList()){
//            std::cout << *commit << std::endl;
//        }
//        std::cout << std::endl;
//    }

    //Statemap consists of a initial state Init and one state start_state
    std::map<int,State*> stateMap;
    stateMap.insert(std::make_pair(init->getStateId(),init ));
    stateMap.insert(std::make_pair(start_state->getStateId(),start_state));
    module->getFSM()->setStateMap(stateMap);

    //Create PropertySuite
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
    //Print ITL Properties to file
    PrintITL printITL;
    auto map = printITL.printModule(module);
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Operation_Test/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
