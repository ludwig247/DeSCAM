//
// Created by pmorku on 10.07.18.
//

#include <SimplifyVisitor.h>
#include "RelocateOpStmts.h"
#include <StmtNodeAlloc.h>

#include <Module.h>
#include "NodePeekVisitor.h"

#define EXPERIMENTAL_SIMPLIFY_CONDITIONS 1

namespace SCAM {
    RelocateOpStmts::RelocateOpStmts(const std::map<int, SCAM::State2 *> &stateMap, Module *module) {
        for (auto state_it: stateMap) {
            for (auto op_it: state_it.second->getOutgoingOperationsList()) {

                std::vector<Assignment *> newCommitmentList;
                bool listUpdated = false;
                for (auto commit_it: op_it->getCommitmentsList()) {
                    auto allocatedNodePtr = StmtNodeAlloc::allocNode(*commit_it, true);
                    newCommitmentList.push_back(allocatedNodePtr);
                    if (allocatedNodePtr != commit_it) {
                        listUpdated = true;
                    }
                }
                if (listUpdated) {
                    op_it->setCommitmentsList(newCommitmentList);
                }

                std::vector<Expr *> newAssumptionList;
                listUpdated = false;
                for (auto assume_it: op_it->getAssumptionsList()) {
                    auto allocatedNodePtr = StmtNodeAlloc::allocNode(*assume_it, true);
                    newAssumptionList.push_back(allocatedNodePtr);
                    if (allocatedNodePtr != assume_it) {
                        listUpdated = true;
                    }
                }
                if (listUpdated) {
                    op_it->setAssumptionsList(newAssumptionList);
                }
            }
        }
        bool listUpdated = false;
        for (auto func_it: module->getFunctionMap()) {
            std::vector<std::pair<Return *, std::vector<Expr *>>> newReturnValueConditionList;

#if EXPERIMENTAL_SIMPLIFY_CONDITIONS
            std::vector<Expr *> checkedConditions;
#endif
            for (auto return_it: func_it.second->getReturnValueConditionList()) {
                auto allocatedReturnNodePtr = StmtNodeAlloc::allocNode(*return_it.first, true);
                if (allocatedReturnNodePtr != return_it.first) {
                    listUpdated = true;
                }

                std::vector<Expr *> conditions;
                for (auto cond_it: return_it.second) {
                    auto allocatedNodePtr = StmtNodeAlloc::allocNode(*cond_it, true);

#if EXPERIMENTAL_SIMPLIFY_CONDITIONS
                    // check and ignore repetitive conditions
                    // TODO: should be performed using SAT solver, this is only temporary and experimental solution
                    NodePeekVisitor nodePeek(allocatedNodePtr);
                    if (nodePeek.nodePeekUnaryExpr()) {
                        bool entryFound = false;
                        for (auto it : checkedConditions) {
                            if (it == nodePeek.nodePeekUnaryExpr()->getExpr()) {
                                entryFound = true;
                            }
                        }
                        if (!entryFound) {
                            checkedConditions.push_back(allocatedNodePtr);
                            conditions.push_back(allocatedNodePtr);
                        } else listUpdated = true;
                    } else {
                        bool entryFound = false;
                        for (auto it : checkedConditions) {
                            NodePeekVisitor nodePeek(it);
                            if (nodePeek.nodePeekUnaryExpr()) {
                                if (nodePeek.nodePeekUnaryExpr()->getExpr() == allocatedNodePtr) {
                                    entryFound = true;
                                }
                            }
                        }
                        if (!entryFound) {
                            checkedConditions.push_back(allocatedNodePtr);
                            conditions.push_back(allocatedNodePtr);
                        } else listUpdated = true;
                    }
#else
                    conditions.push_back(allocatedNodePtr);
#endif


                    if (allocatedNodePtr != cond_it) {
                        listUpdated = true;
                    }
                }
                newReturnValueConditionList.push_back(std::make_pair(allocatedReturnNodePtr, conditions));
            }

            if (listUpdated) {
                func_it.second->setReturnValueConditionList(newReturnValueConditionList);
            }
        }
    }
}