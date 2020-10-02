//
// Created by wezel on 9/24/20.
//

#ifndef SCAM_CHANNELPROPERTIES_H
#define SCAM_CHANNELPROPERTIES_H

#include <vector>
#include "Model.h"
using namespace DESCAM;

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
    ChannelProperties() = delete;
    explicit ChannelProperties(DESCAM::Module *module);
    ~ChannelProperties() = default;

    std::string printCFG(std::map<int,DESCAM::CfgNode*> controlFlowMap);
    void findImportantStates(std::map<int,DESCAM::CfgNode*> controlFlowMap, std::map<int,DESCAM::CfgNode*>* importantStateMap);
    void findPathsfromNode(DESCAM::CfgNode* startnode, std::vector<std::vector<DESCAM::Stmt*>> *pathsFromStart, std::vector<std::vector<int>> *pathsAsIDs);
    void combinePaths(std::vector<eventID> readyQueue, std::vector<eventID> blockedFunctions);
    void computePermutations(std::vector<eventID> functionVec);
    void deleteNullNodes();
    void setStartEndNodes();
    void setControlFlowMaps();
    void searchImportantStates();
    void findSubPaths();
    void generateGlobalPaths();
    void generateProperties();

private:
    DESCAM::Module *module;
    std::vector<std::map<int, DESCAM::CfgNode *>> allcontrolFlowMaps;
    std::map<int, DESCAM::CfgNode *> controlFlowMap;
    std::vector<std::vector<std::vector<DESCAM::Stmt*>>> subPaths;
    std::vector<std::vector<std::vector<int>>> subPathsIDs;
    std::vector<std::string> funcNames;
    std::vector<std::string> portNames;
    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;
    std::vector<std::map<int, DESCAM::CfgNode *>> importantStatesVector;
    std::vector<eventID> functions;
    std::vector<pathIDStmt> allSubPaths;
    std::vector<DESCAM::Operation*> operationsFinal;

    std::vector<std::vector<eventID>>permutations;
    std::vector<std::string> portnames;

    DESCAM::Operation *reset_op;
    DESCAM::State* start_state;
    DESCAM::State* init;

};
#endif //SCAM_CHANNELPROPERTIES_H
