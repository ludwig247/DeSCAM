//
// Created by tobias on 12.12.18.
//

#include <set>
#include <assert.h>
#include "CreateRealCFG.h"
#include "NewNode.h"

SCAM::CreateRealCFG::CreateRealCFG(const std::map<int, SCAM::CFGNode *> &controlFlowMap) {

    std::map<int, SCAM::NewNode *> cfg;

    auto entry = controlFlowMap.at(-1);
    assert(entry->getSuccessorList().size()==1);
    auto succ = entry->getSuccessorList().at(0);
    std::set<int> visited;



}
