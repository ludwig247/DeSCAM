//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/22/19.
//

#include "PrintCFGDot.h"
#include "CreateExplicitCFG.h"

std::map<std::string, std::string> PrintCFGDot::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->ss.str("");
        this->ss << printDot(module.second);
        pluginOutput.insert(std::make_pair(module.first + ".dot", ss.str()));
    }
    return pluginOutput;
}

////////////////
std::string PrintCFGDot::printDot(Module *module) {
    std::stringstream ss;
    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;

    std::map<int, DESCAM::CfgNode *> cfg;
    std::multimap<std::string, std::vector<DESCAM::CfgNode *>> commGroups;

    if (getOptionMap()["explicit"]) {
        DESCAM::CreateExplicitCFG explicitCfg(module->getCFG(), module->getPropertySuite()->getStates());
        cfg = explicitCfg.getCfg();
        commGroups = explicitCfg.getCommGroups();
    } else {
        cfg = module->getCFG();
        commGroups = module->getcommGroups();
    }

    // Node and Name
    for (auto node : cfg) {
        ss << node.second->getName() << "[ label = \"";
        if (node.second->getStmt() == nullptr)
            ss << "------";
        else
            ss << PrintStmtForDot::toString(node.second->getStmt());
        ss << "\"];\n";
        //
    }

    ss << std::endl;

    // Connections
    for (auto node : cfg) {
        for (auto succ : node.second->getSuccessorList()) {
            ss << node.second->getName() << " -> " << succ->getName();
            if (node.second->getSuccessorList().size() > 1) {
                if (succ->getId() == node.second->getId() + 1)
                    ss << "[label = \"yes\"]";
                else
                    ss << "[label = \"no\"]";
            }
            ss << ";\n";
        }
    }

    ss << std::endl;

    // Communication Groups
    int groupCount = 0;
    for (auto commGroup: commGroups) {
        ss << "subgraph cluster_" << groupCount << " {\n";
        ss << "\tstyle=filled; color=slategray;\n";
        for (auto node : commGroup.second)
            ss << "\t" << node->getName() << "\n";
        ss << "\tlabel = \"" << commGroup.first << "\";\n";
        ss << "}\n";
        groupCount++;
    }
    if (module->getPropertySuite() != nullptr) {
        for (auto state : module->getPropertySuite()->getStates()) {
            ss << "subgraph cluster_" << groupCount << " {\n";
            ss << "\tstyle=filled; color=purple;\n";
            ss << "\t" << state->getName() << ";\n";
            ss << "}\n";
            groupCount++;
        }
    }

    ss << "}" << std::endl;

    return ss.str();
}

std::string PrintCFGDot::printCFG_Spurious(std::map<int, DESCAM::CfgNode *> cfg, std::vector<DESCAM::CfgNode *> importantStates, std::vector<DESCAM::CfgNode *> spuriousPath) {
    std::stringstream ss;
    ss << "digraph Spurious {  graph [rankdir=TD];  " << std::endl;

    // Node and Name
    for (auto node : cfg) {
        ss << node.second->getName() << "[ label = \"";
        if (node.second->getStmt() == nullptr)
            ss << "------";
        else
            ss << PrintStmtForDot::toString(node.second->getStmt());
        ss << "\"];\n";
    }
    ss << std::endl;

    // Connections
    for (auto node : cfg) {
        for (auto succ : node.second->getSuccessorList()) {
            ss << node.second->getName() << " -> " << succ->getName();
            if (node.second->getSuccessorList().size() > 1) {
                if (succ->getId() == node.second->getId() + 1)
                    ss << "[label = \"yes\"]";
                else
                    ss << "[label = \"no\"]";
            }
            ss << ";\n";
        }
    }

    ss << std::endl;

    // Highlight States
    int groupCount = 0;
    for (auto state : importantStates) {
        ss << "subgraph cluster_" << groupCount << " {\n";
        ss << "\tstyle=filled; color=slategray;\n";
        ss << "\t" << state->getName() << ";\n";
        ss << "}\n";
        groupCount++;
    }


    // Highlight Spurious
    auto node = spuriousPath.begin();
    int connectionNum = 1;
    while (node != spuriousPath.end() - 1) {
        ss << (*node)->getName() << " -> " << (*(node + 1))->getName();
        ss << "[label = \"" << connectionNum++ << "\", color=red, penwidth=3.0];\n";
        node++;
    }

    ss << "}" << std::endl;

    return ss.str();
}