//
// Created by wezel on 9/24/20.
//

#ifndef SCAM_CHANNELPROPERTIES_H
#define SCAM_CHANNELPROPERTIES_H

//#include <Stmts_all.h>
//#include <PrintStmt.h>
//#include <ModelGlobal.h>
#include <PrintITL/PrintITL.h>
//#include <ReconstructOperations.h>
//#include <ExprVisitor.h>
#include <PropertyFactory.h>
#include <ValidOperations.h>
//#include <z3++.h>
//#include <ExprTranslator.h>
#include <chrono>
#include <OperationOptimizations/ConditionOptimizer2.h>
//#include "Model.h"

struct pathIDStmt{
    std::vector<int> idList;
    std::vector<DESCAM::Stmt*> stmtList;
};

struct eventID{
    int id;
    std::string eventname;
};

class ChannelProperties {

public:
    ChannelProperties(DESCAM::Module *module);
    ~ChannelProperties() = default;

    DESCAM::Module *module;
    std::vector<std::map<int, CfgNode *>> allcontrolFlowMaps;
    std::map<int, CfgNode *> controlFlowMap;
    std::vector<std::vector<std::vector<DESCAM::Stmt*>>> subPaths;
    std::vector<std::vector<std::vector<int>>> subPathsIDs;
    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;
    std::vector<eventID> functions;
    std::vector<pathIDStmt> allSubPaths;
    std::vector<Operation*> operationsFinal;

    std::vector<std::vector<eventID>>permutations;
    std::vector<std::string> portnames;

    Operation *reset_op;
    State* start_state;
    State* init;

    std::string printCFG(std::map<int,CfgNode*> controlFlowMap);
    void findImportantStates(std::map<int,CfgNode*> controlFlowMap, std::map<int,CfgNode*>* importantStateMap);
    void findPathsfromNode(CfgNode* startnode, std::vector<std::vector<DESCAM::Stmt*>> *pathsFromStart, std::vector<std::vector<int>> *pathsAsIDs);
    void combinePaths(std::vector<eventID> readyQueue, std::vector<eventID> blockedFunctions);
    void computePermutations(std::vector<eventID> functionVec);

    void generateProperties();


};
#endif //SCAM_CHANNELPROPERTIES_H
