//
// Created by M.I.Alkoudsi on 08.06.19.
//

#include "LivenessAnalysis.h"

#include <utility>
#include <Stmts/StmtCastVisitor.h>


namespace DESCAM {

    LivenessAnalysis::LivenessAnalysis(std::map<int, DESCAM::CfgNode *> CFG,
                                       const std::map<std::string, DESCAM::Variable *> &ModuleVariables) :
            CFG(std::move(CFG)), deadNodeDetected(false) {
        this->moduleVariablesMap.clear();
        initLA(ModuleVariables);
        this->numToTrueToggles = 0;
        for (int i = 0; i < (*this->CFG.rbegin()).first; i++) {
            this->toggledToTrueNodeVector.push_back(false);
        }
        for (auto it = this->CFG.rbegin();
             it != this->CFG.rend(); it++) {
            auto statement = (*it).second->getStmt();
            currentNodeID = (*it).second->getId();
            //check if there is a use of a variable, then toggle its in info to true at currentNode
            if (statement != nullptr) {
                statement->accept(*this);
            }
        }
        while (true) {
            for (int i = 0; i < 2; i++) {
                // if in info of any succ stmt = true  , current stmt out info = true
                for (auto node = this->CFG.rbegin(); node != this->CFG.rend(); node++) {
                    for (const auto& var: this->stmtInfoMap) {
                        for (auto succ : (*node).second->getSuccessorList()) {
                            if (this->stmtInfoMap.at(var.first).at(succ->getId()).first) {
                                this->stmtInfoMap.at(var.first).at((*node).first).second = true;
                                this->toggledToTrueNodeVector[(*node).first] = true;
                                break;
                            }
                        }
                        // now set input info of every variable not used in current statement to the output of it
                        if (this->variablesInStmtMap.find((*node).first) != this->variablesInStmtMap.end()) {
                            if (this->variablesInStmtMap.at((*node).first).find(var.first) ==
                                this->variablesInStmtMap.at((*node).first).end()) {
                                if (this->stmtInfoMap.at(var.first).at((*node).first).second) {
                                    this->stmtInfoMap.at(var.first).at((*node).first).first = true;
                                }
                            }
                        } else {
                            if (this->stmtInfoMap.at(var.first).at((*node).first).second) {
                                this->stmtInfoMap.at(var.first).at((*node).first).first = true;
                            }
                        }
                    }
                }
            }
            int numToggledNodes = 0;
            for (auto node : this->toggledToTrueNodeVector) {
                if (node) { numToggledNodes++; }
            }
            if (numToggledNodes == this->numToTrueToggles) { break; }
            this->numToTrueToggles = numToggledNodes;
        }


#ifdef DEBUG_LIVENESS_ANALYSIS
        std::cout << std::endl << "******************* Variables liveness analysis ******************* " << std::endl;
//        for (auto stmtinfo : this->stmtInfoMap) {
//            for (auto node: stmtinfo.second) {
//                std::cout << stmtinfo.first << " at " << node.first << " in " << node.second.first << " out "
//                          << node.second.second << std::endl;
//            }
//        }
#endif
        // Deleting dead assignments
        for (const auto& element : this->allAssignments) {
          //fixme 'continue' is not a nice thing to use
            if (this->stmtInfoMap.find(element.first) == this->stmtInfoMap.end()) {
                continue;
            }
            for (auto nodeId : element.second) {
              //fixme 'continue' is not a nice thing to use
                if(StmtCastVisitor<DESCAM::Read>(this->CFG.at(nodeId)->getStmt()).Get()){continue;}
                if (this->assignmentsToCompoundsVarsMap.find(nodeId) == this->assignmentsToCompoundsVarsMap.end()) {
                    if (!this->stmtInfoMap.at(element.first).at(nodeId).second) {
                        if (this->CFG.find(nodeId) != this->CFG.end()) {
#ifdef DEBUG_LIVENESS_ANALYSIS
                            std::cout << "The assignment: " << PrintStmt::toString(this->CFG.at(nodeId)->getStmt())
                                      << " at node"<< nodeId <<" is dead" << std::endl;
#endif
                            deadNodeDetected = true;
                            removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(nodeId);
                        }
                    }
                } else {
                    bool isDead = true;
                    for (auto subVar : this->assignmentsToCompoundsVarsMap.at(nodeId)->getSubVarList()) {
                        if (this->stmtInfoMap.at(subVar->getFullName()).at(nodeId).second) {
                            isDead = false;
                        }
                    }
                    if (isDead) {
                        if (this->CFG.find(nodeId) != this->CFG.end()) {
#ifdef DEBUG_LIVENESS_ANALYSIS
                            std::cout << "The assignment: " << PrintStmt::toString(this->CFG.at(nodeId)->getStmt())
                                      << " is dead" << std::endl;
#endif
                            deadNodeDetected = true;
                            removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(nodeId);
                        }
                    }
                }
            }
        }
        if (this->deadNodeDetected) {
            std::vector<int> pointlessIfStmtsNodeIdsVector;
            for (auto node : this->CFG) {
                if (StmtCastVisitor<DESCAM::If>(node.second->getStmt()).Get()) {
                    if (node.second->getSuccessorList().size() != 2) {
                        pointlessIfStmtsNodeIdsVector.push_back(node.first);
                    }
                }
            }
            for (auto pointlessIfStmtNodeId : pointlessIfStmtsNodeIdsVector) {
                removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(pointlessIfStmtNodeId);
            }
            for (auto deadAssignment : deadAssignmentSet) {
                removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(deadAssignment);
            }
        }

#ifdef DEBUG_LIVENESS_ANALYSIS
        std::cout << "*******************************************************************" << std::endl;
#endif
    }

    void LivenessAnalysis::initLA(const std::map<std::string, DESCAM::Variable *> &ModuleVariables) {
        for (const auto& var : ModuleVariables) {
            this->moduleVariablesMap.insert(std::make_pair(var.second->getFullName(), var.second));
            if (var.second->isCompoundType() || var.second->isArrayType()) {
                for (auto subvar : var.second->getSubVarList()) {
                    this->moduleVariablesMap.insert(std::make_pair(subvar->getFullName(), subvar));
                }
            }
        }
        std::map<int, std::pair<bool, bool>> id2boolmap;
        for (auto node : this->CFG) {
            id2boolmap.insert(std::make_pair(node.second->getId(), std::make_pair(false, false)));
        }
        for (const auto& var: this->moduleVariablesMap) {
            std::map<int, std::pair<bool, bool>> idboolsMap = id2boolmap;
            this->stmtInfoMap.insert(std::make_pair(var.first, idboolsMap));
        }
    }

    const std::map<int, CfgNode *> &LivenessAnalysis::getCFG() const {
        return this->CFG;
    }

    void LivenessAnalysis::visit(struct VariableOperand &node) {
        if (this->variablesInStmtMap.find(this->currentNodeID) != this->variablesInStmtMap.end()) {
            this->variablesInStmtMap.at(this->currentNodeID).insert(node.getVariable()->getFullName());
        } else {
            std::set<std::string> variablesInStmtSet;
            variablesInStmtSet.insert(node.getVariable()->getFullName());
            this->variablesInStmtMap.insert(std::make_pair(this->currentNodeID, variablesInStmtSet));
        }
        if (this->stmtInfoMap.find(node.getVariable()->getFullName()) != this->stmtInfoMap.end()) {
            this->stmtInfoMap.at(node.getVariable()->getFullName()).at(currentNodeID).first = true;
        }

        if (node.getVariable()->isSubVar()) {
            auto parent = node.getVariable()->getParent();
            this->variablesInStmtMap.at(this->currentNodeID).insert(parent->getFullName());
            if (this->stmtInfoMap.find(parent->getFullName()) != this->stmtInfoMap.end()) {
                this->stmtInfoMap.at(parent->getFullName()).at(currentNodeID).first = true;
            }
        } else if (node.getVariable()->isCompoundType() || node.getVariable()->isArrayType()) {
            for (auto subVar : node.getVariable()->getSubVarList()) {
                this->variablesInStmtMap.at(this->currentNodeID).insert(subVar->getFullName());
                if (this->stmtInfoMap.find(subVar->getFullName()) != this->stmtInfoMap.end()) {
                    this->stmtInfoMap.at(subVar->getFullName()).at(currentNodeID).first = true;
                }
            }
        }
    }

    void LivenessAnalysis::visit(struct Read &node) {
        //store at which node the variable gets assigned
        auto variable = node.getVariableOperand()->getVariable();
        if (this->variablesInStmtMap.find(this->currentNodeID) != this->variablesInStmtMap.end()) {
            this->variablesInStmtMap.at(this->currentNodeID).insert(variable->getFullName());
        } else {
            std::set<std::string> variablesInStmtSet;
            variablesInStmtSet.insert(variable->getFullName());
            this->variablesInStmtMap.insert(std::make_pair(this->currentNodeID, variablesInStmtSet));
        }
        if (variable->isCompoundType() || variable->isArrayType()) {
            for (auto subVar : variable->getSubVarList()) {
                this->variablesInStmtMap.at(this->currentNodeID).insert(subVar->getFullName());
                if (this->allAssignments.find(subVar->getFullName()) ==
                    this->allAssignments.end()) {
                    std::set<int> nodesVec;
                    nodesVec.insert(currentNodeID);
                    this->allAssignments.insert(std::make_pair(subVar->getFullName(), nodesVec));
                } else {
                    this->allAssignments.at(subVar->getFullName()).insert(currentNodeID);
                }
            }
            this->assignmentsToCompoundsVarsMap.insert(std::make_pair(this->currentNodeID, variable));
        }
        if (this->allAssignments.find(variable->getFullName()) ==
            this->allAssignments.end()) {
            std::set<int> nodesVec;
            nodesVec.insert(currentNodeID);
            this->allAssignments.insert(std::make_pair(variable->getFullName(), nodesVec));
        } else {
            this->allAssignments.at(variable->getFullName()).insert(currentNodeID);
        }
    }

    void LivenessAnalysis::visit(class Assignment &node) {
        // if the lhs of the assignment is a variable operand set it initially to not used then check if there is a use of a variable in the rhs
        if (auto lhs = StmtCastVisitor<DESCAM::VariableOperand>(node.getLhs()).Get()) {
            if (this->variablesInStmtMap.find(this->currentNodeID) != this->variablesInStmtMap.end()) {
                this->variablesInStmtMap.at(this->currentNodeID).insert(lhs->getVariable()->getFullName());
            } else {
                std::set<std::string> variablesInStmtSet;
                variablesInStmtSet.insert(lhs->getVariable()->getFullName());
                this->variablesInStmtMap.insert(std::make_pair(this->currentNodeID, variablesInStmtSet));
            }
            //store at which node the variable gets assigned
            if (this->allAssignments.find(lhs->getVariable()->getFullName()) ==
                this->allAssignments.end()) {
                std::set<int> nodesVec;
                nodesVec.insert(currentNodeID);
                this->allAssignments.insert(std::make_pair(lhs->getVariable()->getFullName(), nodesVec));
            } else {
                this->allAssignments.at(lhs->getVariable()->getFullName()).insert(currentNodeID);
            }
            if (lhs->getVariable()->isCompoundType() || lhs->getVariable()->isArrayType()) {
                for (auto subVar : lhs->getVariable()->getSubVarList()) {
                    this->variablesInStmtMap.at(this->currentNodeID).insert(subVar->getFullName());
                    if (this->allAssignments.find(subVar->getFullName()) ==
                        this->allAssignments.end()) {
                        std::set<int> nodesVec;
                        nodesVec.insert(currentNodeID);
                        this->allAssignments.insert(std::make_pair(subVar->getFullName(), nodesVec));
                    } else {
                        this->allAssignments.at(subVar->getFullName()).insert(currentNodeID);
                    }
                }
                this->assignmentsToCompoundsVarsMap.insert(std::make_pair(this->currentNodeID, lhs->getVariable()));
            }

            node.getRhs()->accept(*this);
            if (*node.getLhs() == *node.getRhs()) {
                deadAssignmentSet.insert(currentNodeID);
                this->deadNodeDetected = true;
            }
        }
    }

    void LivenessAnalysis::visit(struct UnaryExpr &node) {
        node.getExpr()->accept(*this);
    }

    void LivenessAnalysis::visit(struct If &node) {
        if (node.getConditionStmt() != nullptr) {
            node.getConditionStmt()->accept(*this);
        }
    }

    void LivenessAnalysis::visit(struct Write &node) {
        node.getValue()->accept(*this);
    }

    void LivenessAnalysis::visit(struct Arithmetic &node) {
        node.getLhs()->accept(*this);
        node.getRhs()->accept(*this);
    }

    void LivenessAnalysis::visit(struct Logical &node) {
        node.getLhs()->accept(*this);
        node.getRhs()->accept(*this);
    }

    void LivenessAnalysis::visit(struct Relational &node) {
        node.getLhs()->accept(*this);
        node.getRhs()->accept(*this);
    }

    void LivenessAnalysis::visit(struct Bitwise &node) {
        node.getLhs()->accept(*this);
        node.getRhs()->accept(*this);
    }


    void LivenessAnalysis::visit(struct Cast &node) {
        node.getSubExpr()->accept(*this);
    }

    void LivenessAnalysis::visit(struct DESCAM::FunctionOperand &node) {
        for (auto param : node.getParamValueMap()) {
            param.second->accept(*this);
        }
    }

    void LivenessAnalysis::visit(struct ArrayOperand &node) {
        node.getIdx()->accept(*this);
        if (this->stmtInfoMap.find(node.getArrayOperand()->getOperandName()) != this->stmtInfoMap.end()) {
            this->stmtInfoMap.at(node.getArrayOperand()->getOperandName()).at(currentNodeID).first = true;
        }
        if (this->variablesInStmtMap.find(this->currentNodeID) != this->variablesInStmtMap.end()) {
            this->variablesInStmtMap.at(this->currentNodeID).insert(node.getArrayOperand()->getOperandName());
        } else {
            std::set<std::string> variablesInStmtSet;
            variablesInStmtSet.insert(node.getArrayOperand()->getOperandName());
            this->variablesInStmtMap.insert(std::make_pair(this->currentNodeID, variablesInStmtSet));
        }
    }

    void LivenessAnalysis::visit(class CompoundExpr &node) {
        for (auto subVar : node.getValueMap()) {
            subVar.second->accept(*this);
        }
    }


    void LivenessAnalysis::visit(class ArrayExpr &node) {
        for (auto subVar : node.getValueMap()) {
            subVar.second->accept(*this);
        }
    }

    void LivenessAnalysis::visit(class Ternary &node) {
        node.getCondition()->accept(*this);
        node.getTrueExpr()->accept(*this);
        node.getFalseExpr()->accept(*this);
    }

    void LivenessAnalysis::removeDeadStatementAndReplaceItInPredecessorsAndSuccessors(int nodeId) {
        auto cfgnode = this->CFG.at(nodeId);
        std::vector<bool> alreadyReplacedPred(this->CFG.at(nodeId)->getSuccessorList().size(), false);
        std::vector<bool> alreadyReplacedSucc(this->CFG.at(nodeId)->getSuccessorList().size(), false);
        int succIdx = 0, predIdx = 0;
        for (auto pred : this->CFG.at(nodeId)->getPredecessorList()) {
            for (auto succ : this->CFG.at(nodeId)->getSuccessorList()) {
                if (!alreadyReplacedPred[succIdx]) {
                    bool predAlreadyInSuccPredList = false;
                    for (auto predInSuc : succ->getPredecessorList()) {
                        if (predInSuc == pred) {
                            predAlreadyInSuccPredList = true;
                            break;
                        }
                    }
                    if (predAlreadyInSuccPredList) {
                        succ->removePredecessor(cfgnode);
                    } else {
                        succ->replacePredecessor(cfgnode, pred);
                    }
                    alreadyReplacedPred[succIdx] = true;
                } else { succ->addPredecessor(pred); }
                if (!alreadyReplacedSucc[predIdx]) {
                    bool succAlreadyInPredSuccList = false;
                    for (auto succInPred : pred->getSuccessorList()) {
                        if (succInPred == succ) {
                            succAlreadyInPredSuccList = true;
                        }
                    }
                    if (succAlreadyInPredSuccList) {
                        pred->removeSuccessor(cfgnode);
                    } else {
                        pred->replaceSuccessor(cfgnode, succ);
                    }
                    alreadyReplacedSucc[predIdx] = true;
                } else { pred->addSuccessor(succ); }
                succIdx++;
            }
            succIdx = 0;
            predIdx++;
        }
        this->CFG.erase(nodeId);
    }
}
