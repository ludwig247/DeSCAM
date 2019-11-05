//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#include "FindStateOperations.h"
#include <regex>


//#define DEBUG_FINDSTATEOPERATIONS

SCAM::FindStateOperations::FindStateOperations(std::map<int, SCAM::CfgNode *> cfg_arg, std::vector<SCAM::CfgNode *> importantStates_arg, SCAM::Module * module_arg, SCAM::CfgNode * whileNode_arg) :
    cfg(std::move(cfg_arg)),
    importantStates(std::move(importantStates_arg)),
    module(module_arg),
    whileNode(whileNode_arg) {}

std::size_t encodeArch(const std::vector<SCAM::CfgNode *> & arch) {
//    /// example
//    std::size_t seed = arch.size();
//    for(auto node : arch)
//        seed ^= node->getId() + 0x9e3779b9 + (seed << 6) + (seed >> 2) + std::hash<std::size_t>()((node->getId() % arch.size()));
//    return seed;

    std::size_t result = arch.size();
    auto size = arch.size();
    for(auto node : arch) {
        int id = node->getId();
        result ^= (result * 1048576) + (id * 1048576) + (id * 1024) + (id % size); // works
    }
    return (result + size);
}

bool SCAM::FindStateOperations::findOperations(SCAM::CfgNode * state) {
    this->stateOperations.clear();
    this->spuriousPath.clear();

    std::vector<SCAM::CfgNode *> operationPath;
    operationPath.reserve(cfg.size());
    std::vector<std::size_t> operationArches;
    operationArches.reserve(cfg.size());

    int countWhile = 0;
    std::vector<int> whileIndex;
    std::vector<SCAM::CfgNode *> stack;
    stack.reserve(cfg.size());
    std::vector<int> branchingNodesIndex;
    branchingNodesIndex.reserve(cfg.size());
    SCAM::CfgNode *traverseNode = state;
    stack.push_back(traverseNode);
#ifdef DEBUG_FINDSTATEOPERATIONS
    std::cout << "----------New State: --------" << traverseNode->printShort();
#endif
    while (!stack.empty()) {
        traverseNode = stack.back();
        stack.pop_back();
#ifdef DEBUG_FINDSTATEOPERATIONS
        std::cout << traverseNode->printShort();
#endif
        /// Encountering a while node
        if (traverseNode == whileNode) {
            countWhile++;
            /// fixed point
            if (countWhile > 1) {
                std::vector<SCAM::CfgNode *> tempArch;
                tempArch.assign(operationPath.begin()+whileIndex.back(), operationPath.end());
                std::size_t lastArch = encodeArch(tempArch);
#ifdef DEBUG_FINDSTATEOPERATIONS
                std::cout << "-----------************* last Arch: " << lastArch << " -----------*************\n";
                for (auto pathNode: tempArch)
                    std::cout << pathNode->printShort();
                std::cout << "\n";
#endif
                if (std::find(operationArches.begin(), operationArches.end(), lastArch) != operationArches.end()) {
                    this->spuriousPath = operationPath;
                    return true; /// referring to the spurious boolean
                }
                operationArches.push_back(lastArch);
            }
#ifdef DEBUG_FINDSTATEOPERATIONS
            std::cout << "push whileIndex: " << operationPath.size() << "\n";
#endif
            whileIndex.push_back(operationPath.size());
        }

            /// When reaching an important state but of course not the initial one we just started from (this explains the " !operationPath.empty() " )
        if ((std::find(this->importantStates.begin(), this->importantStates.end(), traverseNode) != this->importantStates.end()) && !operationPath.empty()) {
            operationPath.push_back(traverseNode);
            this->stateOperations.push_back(operationPath);

            /// Looking back at the last branching point reached and checking if all its branching paths have been visited
            if(!branchingNodesIndex.empty()) {
#ifdef DEBUG_FINDSTATEOPERATIONS
                std::cout << "branchingStack " << branchingNodesIndex.size() << " - " << branchingNodesIndex.back() << "\n";
#endif
                if(!whileIndex.empty()) { //this should happen
#ifdef DEBUG_FINDSTATEOPERATIONS
                    std::cout << "whileIndex " << whileIndex.size() << " - " << whileIndex.back() << "\n";
#endif
                    while (whileIndex.back() > branchingNodesIndex.back()) {
                        countWhile--;
                        whileIndex.pop_back();
                        if (!operationArches.empty()) {
                            operationArches.pop_back(); //this should happen
                        }
                        if(whileIndex.empty())
                            break;
                    }
                }
                operationPath.resize(branchingNodesIndex.back());
                branchingNodesIndex.pop_back();
            }
#ifdef DEBUG_FINDSTATEOPERATIONS
            std::cout << "Finished Path: Retrace Path: \n";
            for (auto pathNode: operationPath)
                std::cout << "ID[" << pathNode->getId() << "] - ";
            std::cout << "\n";
            std::cout << "While Count: " << countWhile << "\nArches Left: ";
            for (auto arch : operationArches)
                std::cout << arch << " - ";
            std::cout << "\n";
#endif
        }
            /// Normal node
        else {
            operationPath.push_back(traverseNode);
            if (traverseNode->getSuccessorList().size() > 1) {
                int branchingCount = 0;
                /// Push successor if it's reachable
                for (int i = traverseNode->getSuccessorList().size() - 1; i >= 0; i--) {
                    /// push successor to check reachability
                    operationPath.push_back(traverseNode->getSuccessorList()[i]);//necessary for reachability check
                    if (SCAM::ValidOperations::isPathReachable(operationPath, module)) {
                        stack.push_back(traverseNode->getSuccessorList()[i]);
                        branchingCount++;
                    }
                    /// pop successor in order to continue correctly
                    operationPath.pop_back();
                }
                if(branchingCount > 1) {
#ifdef DEBUG_FINDSTATEOPERATIONS
                    std::cout << "push branchingNode: " << operationPath.size() << "\n";
#endif
                    branchingNodesIndex.push_back(operationPath.size());
                }
                /// Visiting a node as many times as reachable successors it has
            } else {
                /// Node has one successor only
                stack.push_back(traverseNode->getSuccessorList()[0]);
            }
        }
    }
    return false;
}

const std::vector<SCAM::CfgNode *> &SCAM::FindStateOperations::getSpurious() {
    return this->spuriousPath;
}


const std::vector<std::vector<SCAM::CfgNode *>> &SCAM::FindStateOperations::getStateOperations() {
    return this->stateOperations;
}
