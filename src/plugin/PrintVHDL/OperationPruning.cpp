//
// Created by pmorku on 7/29/18.
//

#include <ExprVisitor.h>
#include "OperationPruning.h"
#include "VHDLPrintVisitor.h"
#include "NodePeekVisitor.h"
#include <assert.h>
#include "ExprTranslator.h"
#include "z3++.h"
#include "CleanUpPaths.h"

OperationPruning::OperationPruning(const std::map<int, State *> &stateMap, Module *module) : module(module) {
    struct operationReachability_t {
        Operation *op = nullptr;
        bool markedAsReachable = false;
    };

    std::map<State *, std::vector<operationReachability_t>> operationReachabilityMap;

    // create operation reachability map
    for (auto state_it: stateMap) {
        if (state_it.second->isInit()) continue;
        std::vector<operationReachability_t> operationList;
        for (auto op_it : state_it.second->getOutgoingOperationList()) {
            operationReachability_t operation;
            operation.op = op_it;
            operationList.push_back(operation);
        }
        operationReachabilityMap.insert(std::make_pair(state_it.second, operationList));
    }

    // add initial state, initial operation and state that this operation leads to
    State *initialState = stateMap.at(-1);
    Operation *initialOperation = *initialState->getOutgoingOperationList().begin();
    // create new states in order to keep the original stateMap
    State *initialState_new = new State(*initialOperation->getState());
    State *nextState_new = new State(*initialOperation->getNextState());
    newStateMap.insert(std::make_pair(initialState_new->getStateId(), initialState_new));
    newStateMap.insert(std::make_pair(nextState_new->getStateId(), nextState_new));
    new Operation(*initialOperation, initialState_new, nextState_new);

    std::vector<Operation *> reachableOpList1;
    std::vector<Operation *> reachableOpList2;

    std::vector<Operation *> *reachableOpListPrev = &reachableOpList1;
    std::vector<Operation *> *reachableOpListNext = &reachableOpList2;

    reachableOpListPrev->push_back(initialOperation);
    bool newOpsFound = true;
    while (newOpsFound) {
        newOpsFound = false;
        for (auto &rootOp_it : *reachableOpListPrev) {
            State *nextState = rootOp_it->getNextState();

            if (nextState->getStateId() == 2)
            {
                __asm("nop");
            }
            auto &potentialOps = operationReachabilityMap.at(nextState);
            for (auto &op_it : potentialOps) {
                if (op_it.markedAsReachable) continue;
                bool opReached = true;

                if (op_it.op->getOp_id() == 20)
                {
                    __asm("nop");
                }

                // create conditions for sat solver:
                // if commitment contains cnt = 3
                // and assumption contains cnt = cnt -1
                // then constructed condition for sat solver looks like (cnt - 1 = 3) which is sat solvable
                // TODO: need to unroll more states to make this algorithm find vacuous operations
                std::vector<Relational> satConditions;
                for (auto &commit_it : rootOp_it->getCommitmentList()) {
                    for (auto &assume_it : op_it.op->getAssumptionList()) {
                        NodePeekVisitor nodePeekVisitor(assume_it);
                        if (nodePeekVisitor.nodePeekRelational()) {
                            if (commit_it->getLhs() == nodePeekVisitor.nodePeekRelational()->getLhs()) {
                                Relational condition(commit_it->getRhs(), "==", nodePeekVisitor.nodePeekRelational()->getRhs());
                                satConditions.push_back(condition);
                            } else if (commit_it->getLhs() == nodePeekVisitor.nodePeekRelational()->getRhs()) {
                                Relational condition(commit_it->getRhs(), "==", nodePeekVisitor.nodePeekRelational()->getLhs());
                                satConditions.push_back(condition);
                            }
                        }
                    }
                }

                if (!satConditions.empty()) {
                    z3::context context;
                    ExprTranslator translator(&context);
                    z3::solver solver(context);
                    //Translate each expression with the ExprtTranslator and add to solver
                    for (auto &condition : satConditions) {
                        solver.add(translator.translate(&condition));
                    }
                    // Check for SAT if unsat -> mark operation as unreachable
                    if (solver.check() == z3::unsat) {
                        opReached = false;
                        __asm("nop");
                    }
                }

//                if (CleanUpPaths::isVacous(op_it.op->getAssumptionList(),rootOp_it->getCommitmentList(), module)) {
//                    opReached = false;
//                }


                // if operation is reachable mark it as reachable and add it to the new state
                if (opReached) {
                    assert(op_it.markedAsReachable != true);
                    // Operation passed reachability anc vacuousness test
                    op_it.markedAsReachable = true;
                    reachableOpListNext->push_back(op_it.op);

                    // New states are still pointing to the operations of the old stateMap
                    // Create new operations for the new stateMap
                    // Add state that operation is pointing to
                    State *nextState_new = nullptr;
                    auto state_it = newStateMap.find(op_it.op->getNextState()->getStateId());
                    if (state_it == newStateMap.end()) {
                        // state is not in the newStateMap, create new state
                        nextState_new = new State(*op_it.op->getNextState());
                        newStateMap.insert(std::make_pair(op_it.op->getNextState()->getStateId(), nextState_new));
                    } else {
                        nextState_new = state_it->second;
                    }
                    // Create new operation
                    new Operation(*op_it.op, newStateMap.at(op_it.op->getState()->getStateId()), nextState_new);
                }
            }
        }

        if (!reachableOpListNext->empty()) {
            newOpsFound = true;
            reachableOpListPrev->clear();
            auto tempPtr = reachableOpListPrev;
            reachableOpListPrev = reachableOpListNext;
            reachableOpListNext = tempPtr;
        }
    }

    unsigned int opCnt = 0;
    unsigned int unreachableOpCnt = 0;
    for (auto &state_it: operationReachabilityMap) {
        for (auto &op_it: state_it.second) {
            opCnt++;
            if (!op_it.markedAsReachable) {
                unreachableOpCnt++;
            }
        }
    }
    std::cout << "OperationPruning: " << unreachableOpCnt << " operations out of " << opCnt << " were removed.\n";

    for (auto &state_it: stateMap) {
        if (newStateMap.find(state_it.first) == newStateMap.end()) {
            unreachableStates.push_back(state_it.second);
        }
    }

    std::cout << "OperationPruning: " << unreachableStates.size() << " states out of " << stateMap.size() << " were removed.\n";
}

const std::map<int, State *> &OperationPruning::getNewStateMap() const {
    return newStateMap;
}

const std::vector<State *> &OperationPruning::getUnreachableStates() const {
    return unreachableStates;
}
