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
#include <z3++.h>
#include <ExprTranslator.h>
#include <chrono>
#include <OperationOptimizations/ConditionOptimizer2.h>


#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new SCAM::Module("Buffer_Channel")){
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

    std::map<int, CfgNode *> controlFlowMapWrite0;
    std::map<int, CfgNode *> controlFlowMapWrite1;
    std::map<int, CfgNode *> controlFlowMapWrite2;
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMap;

    std::vector<std::vector<SCAM::Stmt*>> pathsWrite0;
    std::vector<std::vector<int>> pathsWrite0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite1;
    std::vector<std::vector<int>> pathsWrite1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite2;
    std::vector<std::vector<int>> pathsWrite2IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;


    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;

    Operation *reset_op;
    std::vector<pathIDStmt> allPaths;
    std::vector<pathIDStmt> finalPaths;
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
    bool isUnreachable(const std::vector<SCAM::Expr *> &assumptionList) {
        z3::context context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        //Idea: check for satisfiability of assumptions_of_operation & assumption_of_ternary
        //If unsat -> always false
        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: assumptionList) {
            solver.add(translator.translate(condition));
        }
        // Check for SAT if unsat -> erase path
        if ((solver.check() == z3::unsat)) {
            //expr->setTrivialFalse();
            return true;
        }
        return false;
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
        auto state0 = new Variable("state0", states);
        auto state1 = new Variable("state1", states);
        auto state2 = new Variable("state2", states);

        auto array = new DataType("int_8");
        DataTypes::addDataType(array);
        array->addArray(DataTypes::getDataType("int"),8);
        auto buffer0 = new Variable("buffer0", array);
        auto buffer1 = new Variable("buffer1", array);
        auto buffer2 = new Variable("buffer2", array);

        //auto size = new Variable("size", DataTypes::getDataType("unsigned"));
        auto size = new IntegerValue(3);
        auto head0 = new Variable("head0", DataTypes::getDataType("int"));
        auto tail0 = new Variable("tail0", DataTypes::getDataType("int"));
        auto head1 = new Variable("head1", DataTypes::getDataType("int"));
        auto tail1 = new Variable("tail1", DataTypes::getDataType("int"));
        auto head2 = new Variable("head2", DataTypes::getDataType("int"));
        auto tail2 = new Variable("tail2", DataTypes::getDataType("int"));

        auto next_read = new Variable("next_read",DataTypes::getDataType("int"));

        auto out = new Port("out",new Interface("blocking","out"),DataTypes::getDataType(("int")));
        auto val_0 = new Port("val_0",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_1 = new Port("val_1",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_2 = new Port("val_2",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(state0);
        module->addVariable(buffer0);
        //module->addVariable(size);
        module->addVariable(head0);
        module->addVariable(tail0);
        module->addVariable(state1);
        module->addVariable(buffer1);
        module->addVariable(head1);
        module->addVariable(tail1);
        module->addVariable(state2);
        module->addVariable(buffer2);
        module->addVariable(head2);
        module->addVariable(tail2);
        module->addVariable(next_read);

        module->addPort(out);
        module->addPort(val_0);
        module->addPort(val_1);
        module->addPort(val_2);

        //Read Expressions/Assignments
        //if(next_read == 0)
        auto next_read_eq_0 = new Relational(new VariableOperand(module->getVariable("next_read")),"==",new IntegerValue(0));
        auto if_next_read_eq_0 = new If(next_read_eq_0);
        //while(state == EMPTY)
        auto empty_enum = new EnumValue("EMPTY", states);
        auto state0_eq_empty = new Relational(new VariableOperand(module->getVariable("state0")),"==",empty_enum);
        auto check_state0_empty = new If(state0_eq_empty);

        //wait(writer_notify0)
        auto writer_wait0 = new Wait("writer_notify0");
        //out = buffer0.at(tail0)
        auto port_out = new DataSignalOperand(out->getDataSignal());
        auto buffer0_at_tail0 = new ArrayOperand(new VariableOperand(module->getVariable("buffer0")),new VariableOperand(module->getVariable(("tail0"))));
        auto out_assign_buffer0_at_tail0 = new Assignment(port_out,buffer0_at_tail0);
        //tail0 = (tail0+1)%size
        auto tail0_increment = new Arithmetic(new VariableOperand(module->getVariable("tail0")),"+",new IntegerValue(1));
        auto tail0_modulo_increment = new Arithmetic(tail0_increment,"%",size);
        auto tail0_assign_tail0_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail0")),tail0_modulo_increment);
        //state = FILLED
        auto filled_enum = new EnumValue("FILLED",states);
        auto state0_assign_filled = new Assignment(new VariableOperand(module->getVariable("state0")),filled_enum);
        //if(head == tail)
        auto head0_eq_tail0 = new Relational(new VariableOperand(module->getVariable("head0")),"==",new VariableOperand(module->getVariable("tail0")));
        auto if_head0_eq_tail0 = new If(head0_eq_tail0);
        //state = EMPTY
        auto state0_assign_empty = new Assignment(new VariableOperand(module->getVariable("state0")),empty_enum);

        auto noti0 = new Notify("Debug0");
        auto noticfg0 = new CfgNode(noti0);
        auto ret0 = new Return("Debug0");
        //reader_notify.notify()
        auto notify_reader0 = new Notify("reader_notify0");
        //next_read++
        auto next_read_increment = new Arithmetic(new VariableOperand(module->getVariable("next_read")),"+",new IntegerValue(1));
        auto next_read_assign_increment = new Assignment(new VariableOperand(module->getVariable("next_read")),next_read_increment);

        //else if(next_read == 1)
        auto next_read_eq_1 = new Relational(new VariableOperand(module->getVariable("next_read")),"==",new IntegerValue(1));
        auto if_next_read_eq_1 = new If(next_read_eq_1);
        //while(state == EMPTY)
        auto state1_eq_empty = new Relational(new VariableOperand(module->getVariable("state1")),"==",empty_enum);
        auto check_state1_empty = new If(state1_eq_empty);

        //wait(writer_notify1)
        auto writer_wait1 = new Wait("writer_notify1");
        //out = buffer1.at(tail1)
        auto buffer1_at_tail1 = new ArrayOperand(new VariableOperand(module->getVariable("buffer1")),new VariableOperand(module->getVariable(("tail1"))));
        auto out_assign_buffer1_at_tail1 = new Assignment(port_out,buffer1_at_tail1);
        //tail1 = (tail1+1)%size
        auto tail1_increment = new Arithmetic(new VariableOperand(module->getVariable("tail1")),"+",new IntegerValue(1));
        auto tail1_modulo_increment = new Arithmetic(tail1_increment,"%",size);
        auto tail1_assign_tail1_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail1")),tail1_modulo_increment);
        //state = FILLED
        auto state1_assign_filled = new Assignment(new VariableOperand(module->getVariable("state1")),filled_enum);
        //if(head == tail)
        auto head1_eq_tail1 = new Relational(new VariableOperand(module->getVariable("head1")),"==",new VariableOperand(module->getVariable("tail1")));
        auto if_head1_eq_tail1 = new If(head1_eq_tail1);
        //state = EMPTY
        auto state1_assign_empty = new Assignment(new VariableOperand(module->getVariable("state1")),empty_enum);

        auto noti1 = new Notify("Debug1");
        auto noticfg1 = new CfgNode(noti1);
        auto ret1 = new Return("Debug1");
        //reader_notify.notify()
        auto notify_reader1 = new Notify("reader_notify1");
        //next_read++
        //already exists
//        auto next_read_increment = new Arithmetic(new VariableOperand(module->getVariable("next_read")),"+",new IntegerValue(1));
//        auto next_read_assign_increment = new Assignment(new VariableOperand(module->getVariable("next_read")),next_read_increment);

        //else
        //while(state == EMPTY)
        auto state2_eq_empty = new Relational(new VariableOperand(module->getVariable("state2")),"==",empty_enum);
        auto check_state2_empty = new If(state2_eq_empty);

        //wait(writer_notify2)
        auto writer_wait2 = new Wait("writer_notify2");
        //out = buffer2.at(tail2)
        auto buffer2_at_tail2 = new ArrayOperand(new VariableOperand(module->getVariable("buffer2")),new VariableOperand(module->getVariable(("tail2"))));
        auto out_assign_buffer2_at_tail2 = new Assignment(port_out,buffer2_at_tail2);
        //tail2 = (tail2+1)%size
        auto tail2_increment = new Arithmetic(new VariableOperand(module->getVariable("tail2")),"+",new IntegerValue(1));
        auto tail2_modulo_increment = new Arithmetic(tail2_increment,"%",size);
        auto tail2_assign_tail2_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail2")),tail2_modulo_increment);
        //state = FILLED
        auto state2_assign_filled = new Assignment(new VariableOperand(module->getVariable("state2")),filled_enum);
        //if(head == tail)
        auto head2_eq_tail2 = new Relational(new VariableOperand(module->getVariable("head2")),"==",new VariableOperand(module->getVariable("tail2")));
        auto if_head2_eq_tail2 = new If(head2_eq_tail2);
        //state = EMPTY
        auto state2_assign_empty = new Assignment(new VariableOperand(module->getVariable("state2")),empty_enum);

        auto noti2 = new Notify("Debug2");
        auto noticfg2 = new CfgNode(noti2);
        auto ret2 = new Return("Debug2");
        //reader_notify.notify()
        auto notify_reader2 = new Notify("reader_notify2");
        //next_read = 0;
        auto next_read_assign_0 = new Assignment(new VariableOperand(module->getVariable("next_read")),new IntegerValue(0));
        //return
        auto read_return = new Return("read_return");

        //Write0 Expressions/Assignments
        //while (state0 == FULL)
        auto full_enum = new EnumValue("FULL", states);
        auto state0_eq_full = new Relational(new VariableOperand(module->getVariable("state0")),"==",full_enum);
        auto check_state0_full = new If(state0_eq_full);
        //wait(reader_notify0);
        auto reader_wait0 = new Wait("reader_notify0");
        //buffer0.at(head0) = val;
        auto buffer0_at_head0 = new ArrayOperand(new VariableOperand(module->getVariable("buffer0")),new VariableOperand(head0));
        auto port0_val_0 = new DataSignalOperand(val_0->getDataSignal());
        auto buffer0_at_head0_assign_val_0 = new Assignment(buffer0_at_head0, port0_val_0);

        //head0 = (head0+1)%size
        auto head0_increment = new Arithmetic(new VariableOperand(module->getVariable("head0")),"+",new IntegerValue(1));
        auto head0_modulo_increment = new Arithmetic(head0_increment,"%",size);
        auto head0_assign_head0_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head0")),head0_modulo_increment);
        //state = FILLED
        //already exists
        //if (head0==tail0)
        //already exists
        //state0 = FULL
        auto state0_assign_full = new Assignment(new VariableOperand(module->getVariable("state0")),full_enum);

        auto noti3 = new Notify("Debug3");
        auto noti3cfg = new CfgNode(noti3);
        auto ret3 = new Return("Debug3");

        //writer_notify.notify()
        auto notify_writer0 = new Notify("writer_notify0");
        //return
        auto write_return0 = new Return("write_return0");

        //Write1 Expressions/Assignments
        //while (state1 == FULL)
        auto state1_eq_full = new Relational(new VariableOperand(module->getVariable("state1")),"==",full_enum);
        auto check_state1_full = new If(state1_eq_full);
        //wait(reader_notify1);
        auto reader_wait1 = new Wait("reader_notify1");
        //buffer1.at(head1) = val;
        auto buffer1_at_head1 = new ArrayOperand(new VariableOperand(module->getVariable("buffer1")),new VariableOperand(head1));
        auto port1_val_1 = new DataSignalOperand(val_1->getDataSignal());
        auto buffer1_at_head1_assign_val_1 = new Assignment(buffer1_at_head1, port1_val_1);

        //head1 = (head1+1)%size
        auto head1_increment = new Arithmetic(new VariableOperand(module->getVariable("head1")),"+",new IntegerValue(1));
        auto head1_modulo_increment = new Arithmetic(head1_increment,"%",size);
        auto head1_assign_head1_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head1")),head1_modulo_increment);
        //state = FILLED
        //already exists
        //if (head1==tail1)
        //already exists
        //state1 = FULL
        auto state1_assign_full = new Assignment(new VariableOperand(module->getVariable("state1")),full_enum);

        auto noti4 = new Notify("Debug4");
        auto noti4cfg = new CfgNode(noti4);
        auto ret4 = new Return("Debug4");

        //writer_notify.notify()
        auto notify_writer1 = new Notify("writer_notify1");
        //return
        auto write_return1 = new Return("write_return1");

        //Write2 Expressions/Assignments
        //while (state2 == FULL)
        auto state2_eq_full = new Relational(new VariableOperand(module->getVariable("state2")),"==",full_enum);
        auto check_state2_full = new If(state2_eq_full);
        //wait(reader_notify2);
        auto reader_wait2 = new Wait("reader_notify2");
        //buffer2.at(head2) = val;
        auto buffer2_at_head2 = new ArrayOperand(new VariableOperand(module->getVariable("buffer2")),new VariableOperand(head2));
        auto port2_val_2 = new DataSignalOperand(val_2->getDataSignal());
        auto buffer2_at_head2_assign_val_2 = new Assignment(buffer2_at_head2, port2_val_2);

        //head2 = (head2+1)%size
        auto head2_increment = new Arithmetic(new VariableOperand(module->getVariable("head2")),"+",new IntegerValue(1));
        auto head2_modulo_increment = new Arithmetic(head2_increment,"%",size);
        auto head2_assign_head2_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head2")),head2_modulo_increment);
        //state = FILLED
        //already exists
        //if (head2==tail2)
        //already exists
        //state2 = FULL
        auto state2_assign_full = new Assignment(new VariableOperand(module->getVariable("state2")),full_enum);

        auto noti5 = new Notify("Debug5");
        auto noti5cfg = new CfgNode(noti5);
        auto ret5 = new Return("Debug5");

        //writer_notify.notify()
        auto notify_writer2 = new Notify("writer_notify2");
        //return
        auto write_return2 = new Return("write_return2");

        //CFG Nodes Read
        auto check_next_read_eq_0 = new CfgNode(if_next_read_eq_0);
        auto state0_equal_empty = new CfgNode(check_state0_empty);
        auto read_wait0 = new CfgNode(writer_wait0);
        auto read_value0 = new CfgNode(out_assign_buffer0_at_tail0);
        auto tail0_incr = new CfgNode(tail0_assign_tail0_modulo_increment);
        auto state0_filled_read = new CfgNode(state0_assign_filled);
        auto head0_equal_tail0_read = new CfgNode(if_head0_eq_tail0);
        auto state0_empty = new CfgNode(state0_assign_empty);
        auto reader_noti0 = new CfgNode(notify_reader0);
        auto next_read_incr0 = new CfgNode(next_read_assign_increment);

        auto check_next_read_eq_1 = new CfgNode(if_next_read_eq_1);
        auto state1_equal_empty = new CfgNode(check_state1_empty);
        auto read_wait1 = new CfgNode(writer_wait1);
        auto read_value1 = new CfgNode(out_assign_buffer1_at_tail1);
        auto tail1_incr = new CfgNode(tail1_assign_tail1_modulo_increment);
        auto state1_filled_read = new CfgNode(state1_assign_filled);
        auto head1_equal_tail1_read = new CfgNode(if_head1_eq_tail1);
        auto state1_empty = new CfgNode(state1_assign_empty);
        auto reader_noti1 = new CfgNode(notify_reader1);
        auto next_read_incr1 = new CfgNode(next_read_assign_increment);

        auto state2_equal_empty = new CfgNode(check_state2_empty);
        auto read_wait2 = new CfgNode(writer_wait2);
        auto read_value2 = new CfgNode(out_assign_buffer2_at_tail2);
        auto tail2_incr = new CfgNode(tail2_assign_tail2_modulo_increment);
        auto state2_filled_read = new CfgNode(state2_assign_filled);
        auto head2_equal_tail2_read = new CfgNode(if_head2_eq_tail2);
        auto state2_empty = new CfgNode(state2_assign_empty);
        auto reader_noti2 = new CfgNode(notify_reader2);
        auto next_read_reset = new CfgNode(next_read_assign_0);
        auto return_read = new CfgNode(read_return);


        //Add Nodes to controFlowMap
        controlFlowMapRead.insert(std::make_pair(check_next_read_eq_0->getId(),check_next_read_eq_0));
        controlFlowMapRead.insert(std::make_pair(state0_equal_empty->getId(),state0_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait0->getId(),read_wait0));
        controlFlowMapRead.insert(std::make_pair(read_value0->getId(),read_value0));
        controlFlowMapRead.insert(std::make_pair(tail0_incr->getId(),tail0_incr));
        controlFlowMapRead.insert(std::make_pair(state0_filled_read->getId(),state0_filled_read));
        controlFlowMapRead.insert(std::make_pair(head0_equal_tail0_read->getId(),head0_equal_tail0_read));
        controlFlowMapRead.insert(std::make_pair(state0_empty->getId(),state0_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti0->getId(),reader_noti0));
        controlFlowMapRead.insert(std::make_pair(next_read_incr0->getId(),next_read_incr0));

        controlFlowMapRead.insert(std::make_pair(check_next_read_eq_1->getId(),check_next_read_eq_1));
        controlFlowMapRead.insert(std::make_pair(state1_equal_empty->getId(),state1_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait1->getId(),read_wait1));
        controlFlowMapRead.insert(std::make_pair(read_value1->getId(),read_value1));
        controlFlowMapRead.insert(std::make_pair(tail1_incr->getId(),tail1_incr));
        controlFlowMapRead.insert(std::make_pair(state1_filled_read->getId(),state1_filled_read));
        controlFlowMapRead.insert(std::make_pair(head1_equal_tail1_read->getId(),head1_equal_tail1_read));
        controlFlowMapRead.insert(std::make_pair(state1_empty->getId(),state1_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti1->getId(),reader_noti1));
        controlFlowMapRead.insert(std::make_pair(next_read_incr1->getId(),next_read_incr1));

        controlFlowMapRead.insert(std::make_pair(state2_equal_empty->getId(),state2_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait2->getId(),read_wait2));
        controlFlowMapRead.insert(std::make_pair(read_value2->getId(),read_value2));
        controlFlowMapRead.insert(std::make_pair(tail2_incr->getId(),tail2_incr));
        controlFlowMapRead.insert(std::make_pair(state2_filled_read->getId(),state2_filled_read));
        controlFlowMapRead.insert(std::make_pair(head2_equal_tail2_read->getId(),head2_equal_tail2_read));
        controlFlowMapRead.insert(std::make_pair(state2_empty->getId(),state2_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti2->getId(),reader_noti2));
        controlFlowMapRead.insert(std::make_pair(next_read_reset->getId(),next_read_reset));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //Link CFG Nodes
        check_next_read_eq_0->addSuccessor(state0_equal_empty);
        check_next_read_eq_0->addSuccessor(check_next_read_eq_1);
        state0_equal_empty->addSuccessor(read_wait0);
        state0_equal_empty->addSuccessor(read_value0);
        read_wait0->addSuccessor(read_value0);
        read_value0->addSuccessor(tail0_incr);
        tail0_incr->addSuccessor(state0_filled_read);
        state0_filled_read->addSuccessor(head0_equal_tail0_read);
        head0_equal_tail0_read->addSuccessor(state0_empty);
        head0_equal_tail0_read->addSuccessor(reader_noti0);
        state0_empty->addSuccessor(reader_noti0);
        reader_noti0->addSuccessor(next_read_incr0);
        next_read_incr0->addSuccessor(return_read);
        check_next_read_eq_1->addSuccessor(state1_equal_empty);
        check_next_read_eq_1->addSuccessor(state2_equal_empty);
        state1_equal_empty->addSuccessor(read_wait1);
        state1_equal_empty->addSuccessor(read_value1);
        read_wait1->addSuccessor(read_value1);
        read_value1->addSuccessor(tail1_incr);
        tail1_incr->addSuccessor(state1_filled_read);
        state1_filled_read->addSuccessor(head1_equal_tail1_read);
        head1_equal_tail1_read->addSuccessor(state1_empty);
        head1_equal_tail1_read->addSuccessor(reader_noti1);
        state1_empty->addSuccessor(reader_noti1);
        reader_noti1->addSuccessor(next_read_incr1);
        next_read_incr1->addSuccessor(return_read);
        state2_equal_empty->addSuccessor(read_wait2);
        state2_equal_empty->addSuccessor(read_value2);
        read_wait2->addSuccessor(read_value2);
        read_value2->addSuccessor(tail2_incr);
        tail2_incr->addSuccessor(state2_filled_read);
        state2_filled_read->addSuccessor(head2_equal_tail2_read);
        head2_equal_tail2_read->addSuccessor(state2_empty);
        head2_equal_tail2_read->addSuccessor(reader_noti2);
        state2_empty->addSuccessor(reader_noti2);
        reader_noti2->addSuccessor(next_read_reset);
        next_read_reset->addSuccessor(return_read);

        //CFG Nodes Write0
        auto state0_equal_full_0 = new CfgNode(check_state0_full);
        auto write_wait_0 = new CfgNode(reader_wait0);
        auto write_value_0 = new CfgNode(buffer0_at_head0_assign_val_0);
        auto head0_incr_0 = new CfgNode(head0_assign_head0_modulo_increment);
        auto state0_filled_write_0 = new CfgNode(state0_assign_filled);
        auto head0_equal_tail0_write_0 = new CfgNode(if_head0_eq_tail0);
        auto state0_full_0 = new CfgNode(state0_assign_full);
        auto writer_noti_0 = new CfgNode(notify_writer0);
        auto return_write_0 = new CfgNode(write_return0);

        //Add Nodes to controFlowMap
        controlFlowMapWrite0.insert(std::make_pair(state0_equal_full_0->getId(),state0_equal_full_0));
        controlFlowMapWrite0.insert(std::make_pair(write_wait_0->getId(),write_wait_0));
        controlFlowMapWrite0.insert(std::make_pair(write_value_0->getId(),write_value_0));
        controlFlowMapWrite0.insert(std::make_pair(head0_incr_0->getId(),head0_incr_0));
        controlFlowMapWrite0.insert(std::make_pair(state0_filled_write_0->getId(),state0_filled_write_0));
        controlFlowMapWrite0.insert(std::make_pair(head0_equal_tail0_write_0->getId(),head0_equal_tail0_write_0));
        controlFlowMapWrite0.insert(std::make_pair(state0_full_0->getId(),state0_full_0));
        controlFlowMapWrite0.insert(std::make_pair(writer_noti_0->getId(),writer_noti_0));
        controlFlowMapWrite0.insert(std::make_pair(return_write_0->getId(),return_write_0));

        //Link CFG Nodes
        state0_equal_full_0->addSuccessor(write_wait_0);
        state0_equal_full_0->addSuccessor(write_value_0);
        write_wait_0->addSuccessor(write_value_0);
        write_value_0->addSuccessor(head0_incr_0);
        head0_incr_0->addSuccessor(state0_filled_write_0);
        state0_filled_write_0->addSuccessor(head0_equal_tail0_write_0);
        head0_equal_tail0_write_0->addSuccessor(state0_full_0);
        head0_equal_tail0_write_0->addSuccessor(writer_noti_0);
        state0_full_0->addSuccessor(writer_noti_0);
        writer_noti_0->addSuccessor(return_write_0);

        //CFG Nodes Write1
        auto state1_equal_full_1 = new CfgNode(check_state1_full);
        auto write_wait_1 = new CfgNode(reader_wait1);
        auto write_value_1 = new CfgNode(buffer1_at_head1_assign_val_1);
        auto head1_incr_1 = new CfgNode(head1_assign_head1_modulo_increment);
        auto state1_filled_write_1 = new CfgNode(state1_assign_filled);
        auto head1_equal_tail1_write_1 = new CfgNode(if_head1_eq_tail1);
        auto state1_full_1 = new CfgNode(state1_assign_full);
        auto writer_noti_1 = new CfgNode(notify_writer1);
        auto return_write_1 = new CfgNode(write_return1);

        //Add Nodes to controFlowMap
        controlFlowMapWrite1.insert(std::make_pair(state1_equal_full_1->getId(),state1_equal_full_1));
        controlFlowMapWrite1.insert(std::make_pair(write_wait_1->getId(),write_wait_1));
        controlFlowMapWrite1.insert(std::make_pair(write_value_1->getId(),write_value_1));
        controlFlowMapWrite1.insert(std::make_pair(head1_incr_1->getId(),head1_incr_1));
        controlFlowMapWrite1.insert(std::make_pair(state1_filled_write_1->getId(),state1_filled_write_1));
        controlFlowMapWrite1.insert(std::make_pair(head1_equal_tail1_write_1->getId(),head1_equal_tail1_write_1));
        controlFlowMapWrite1.insert(std::make_pair(state1_full_1->getId(),state1_full_1));
        controlFlowMapWrite1.insert(std::make_pair(writer_noti_1->getId(),writer_noti_1));
        controlFlowMapWrite1.insert(std::make_pair(return_write_1->getId(),return_write_1));

        //Link CFG Nodes
        state1_equal_full_1->addSuccessor(write_wait_1);
        state1_equal_full_1->addSuccessor(write_value_1);
        write_wait_1->addSuccessor(write_value_1);
        write_value_1->addSuccessor(head1_incr_1);
        head1_incr_1->addSuccessor(state1_filled_write_1);
        state1_filled_write_1->addSuccessor(head1_equal_tail1_write_1);
        head1_equal_tail1_write_1->addSuccessor(state1_full_1);
        head1_equal_tail1_write_1->addSuccessor(writer_noti_1);
        state1_full_1->addSuccessor(writer_noti_1);
        writer_noti_1->addSuccessor(return_write_1);

        //CFG Nodes Write2
        auto state2_equal_full_2 = new CfgNode(check_state2_full);
        auto write_wait_2 = new CfgNode(reader_wait2);
        auto write_value_2 = new CfgNode(buffer2_at_head2_assign_val_2);
        auto head2_incr_2 = new CfgNode(head2_assign_head2_modulo_increment);
        auto state2_filled_write_2 = new CfgNode(state2_assign_filled);
        auto head2_equal_tail2_write_2 = new CfgNode(if_head2_eq_tail2);
        auto state2_full_2 = new CfgNode(state2_assign_full);
        auto writer_noti_2 = new CfgNode(notify_writer2);
        auto return_write_2 = new CfgNode(write_return2);

        //Add Nodes to controFlowMap
        controlFlowMapWrite2.insert(std::make_pair(state2_equal_full_2->getId(),state2_equal_full_2));
        controlFlowMapWrite2.insert(std::make_pair(write_wait_2->getId(),write_wait_2));
        controlFlowMapWrite2.insert(std::make_pair(write_value_2->getId(),write_value_2));
        controlFlowMapWrite2.insert(std::make_pair(head2_incr_2->getId(),head2_incr_2));
        controlFlowMapWrite2.insert(std::make_pair(state2_filled_write_2->getId(),state2_filled_write_2));
        controlFlowMapWrite2.insert(std::make_pair(head2_equal_tail2_write_2->getId(),head2_equal_tail2_write_2));
        controlFlowMapWrite2.insert(std::make_pair(state2_full_2->getId(),state2_full_2));
        controlFlowMapWrite2.insert(std::make_pair(writer_noti_2->getId(),writer_noti_2));
        controlFlowMapWrite2.insert(std::make_pair(return_write_2->getId(),return_write_2));

        //Link CFG Nodes
        state2_equal_full_2->addSuccessor(write_wait_2);
        state2_equal_full_2->addSuccessor(write_value_2);
        write_wait_2->addSuccessor(write_value_2);
        write_value_2->addSuccessor(head2_incr_2);
        head2_incr_2->addSuccessor(state2_filled_write_2);
        state2_filled_write_2->addSuccessor(head2_equal_tail2_write_2);
        head2_equal_tail2_write_2->addSuccessor(state2_full_2);
        head2_equal_tail2_write_2->addSuccessor(writer_noti_2);
        state2_full_2->addSuccessor(writer_noti_2);
        writer_noti_2->addSuccessor(return_write_2);


        //Add all Nodes to controlFlowMap
        for(auto node: controlFlowMapRead){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapWrite0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapWrite1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapWrite2){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }

        //Print CFGs
        std::cout << printCFG(controlFlowMapRead) << std::endl;
        std::cout << printCFG(controlFlowMapWrite0) << std::endl;
        std::cout << printCFG(controlFlowMapWrite1) << std::endl;
        std::cout << printCFG(controlFlowMapWrite2) << std::endl;

        init = new State("reset");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        reset_op->addStatement(state0_assign_empty);
        reset_op->addStatement(state1_assign_empty);
        reset_op->addStatement(state2_assign_empty);
        auto zero = new IntegerValue(0);
        auto tail0_assign_0 = new Assignment(new VariableOperand(module->getVariable("tail0")),zero);
        auto head0_assign_0 = new Assignment(new VariableOperand(module->getVariable("head0")),zero);
        auto tail1_assign_0 = new Assignment(new VariableOperand(module->getVariable("tail1")),zero);
        auto head1_assign_0 = new Assignment(new VariableOperand(module->getVariable("head1")),zero);
        auto tail2_assign_0 = new Assignment(new VariableOperand(module->getVariable("tail2")),zero);
        auto head2_assign_0 = new Assignment(new VariableOperand(module->getVariable("head2")),zero);
        reset_op->addStatement(tail0_assign_0);
        reset_op->addStatement(head0_assign_0);
        reset_op->addStatement(tail1_assign_0);
        reset_op->addStatement(head1_assign_0);
        reset_op->addStatement(tail2_assign_0);
        reset_op->addStatement(head2_assign_0);
        reset_op->addStatement(next_read_assign_0);
        reset_op->setState(init);
        start_state = new State("start_state");
        reset_op->setNextState(start_state);
        reset_op->setReset(true);

        //set start and end nodes for sync and notify
        eventID temp;
        temp = {6,"read_sync"};
        startnodes.push_back(temp);
        temp = {36,"write_0_sync"};
        startnodes.push_back(temp);
        temp = {45,"write_1_sync"};
        startnodes.push_back(temp);
        temp = {54,"write_2_sync"};
        startnodes.push_back(temp);

        temp = {35,"read_notify"};
        endnodes.push_back(temp);
        temp = {44,"write_0_notify"};
        endnodes.push_back(temp);
        temp = {53,"write_1_notify"};
        endnodes.push_back(temp);
        temp = {62,"write_2_notify"};
        endnodes.push_back(temp);

        //Define portnames for notify and sync signals
        portnames.push_back("out");
        portnames.push_back("val_0");
        portnames.push_back("val_1");
        portnames.push_back("val_2");
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

    //Find important states Write0
    std::map<int, CfgNode *> importantStatesWrite0;
    findImportantStates(controlFlowMapWrite0,&importantStatesWrite0);

    //Find paths Write0
    auto start_Write0 = controlFlowMapWrite0.begin()->second;
    findPathsfromNode(start_Write0,&pathsWrite0,&pathsWrite0IDs);
    for(auto const& node : importantStatesWrite0) {
        findPathsfromNode(node.second,&pathsWrite0,&pathsWrite0IDs);
    }

    //Find important states Write1
    std::map<int, CfgNode *> importantStatesWrite1;
    findImportantStates(controlFlowMapWrite1,&importantStatesWrite1);

    //Find paths Write1
    auto start_Write1 = controlFlowMapWrite1.begin()->second;
    findPathsfromNode(start_Write1,&pathsWrite1,&pathsWrite1IDs);
    for(auto const& node : importantStatesWrite1) {
        findPathsfromNode(node.second,&pathsWrite1,&pathsWrite1IDs);
    }

    //Find important states Write2
    std::map<int, CfgNode *> importantStatesWrite2;
    findImportantStates(controlFlowMapWrite2,&importantStatesWrite2);

    //Find paths Write2
    auto start_Write2 = controlFlowMapWrite2.begin()->second;
    findPathsfromNode(start_Write2,&pathsWrite2,&pathsWrite2IDs);
    for(auto const& node : importantStatesWrite2) {
        findPathsfromNode(node.second,&pathsWrite2,&pathsWrite2IDs);
    }

    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<eventID> hv;

    //Define all possible functions and their starting nodes
    eventID Read = {6,"Read"};
    eventID Write0 = {36,"Write0"};
    eventID Write1 = {45,"Write1"};
    eventID Write2 = {54,"Write2"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(Read);
    functions.push_back(Write0);
    functions.push_back(Write1);
    functions.push_back(Write2);

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
    for(int i=0; i<pathsWrite0IDs.size();i++){
        pathIDStmt p = {pathsWrite0IDs.at(i),pathsWrite0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWrite1IDs.size();i++){
        pathIDStmt p = {pathsWrite1IDs.at(i),pathsWrite1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWrite2IDs.size();i++){
        pathIDStmt p = {pathsWrite2IDs.at(i),pathsWrite2.at(i)};
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
    myfile.open(SCAM_HOME"/tests/Buffer_Channel_Properties/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
