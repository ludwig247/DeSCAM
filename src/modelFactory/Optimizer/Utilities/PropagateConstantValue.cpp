//
// Created by M.I.Alkoudsi on 28.05.19.
//

#include "PropagateConstantValue.h"
#include "FindVariablesAndFunctionsInStatement.h"

namespace SCAM {

    SCAM::PropagateConstantValue::PropagateConstantValue(
            const std::map<int, std::vector<SCAM::CfgNode *>> &allPathsToNodeMap,
            SCAM::Variable *var, int stmtId) :
            allPathsToNodeMap(allPathsToNodeMap),
            variable(var), numLastAssignments(0), isVarRead(false), stmtId(stmtId), currentNodeId(0),
            lastAssignmentAlreadyStored(false) {

        for (const auto &pathPair: allPathsToNodeMap) {
            variableValueMap.clear();
            this->isVarRead = false;
            auto lastVarValInPath = this->lastVariableValueInPath(pathPair.second);
            if (this->isVarRead) {
                this->propagatedValue = nullptr;
                return;
            }
            //if there is an assignment to the variable in check, store the rhs of the assignment in the LastAssignmentMap
            if (lastVarValInPath != nullptr) {
                this->LastAssignmentMap.insert(std::make_pair(pathPair.first, lastVarValInPath));
                this->numLastAssignments++;
            }
        }
        //check if all last assignments to the variable on all paths
        bool Propagtionvalid = true;
        if (!this->LastAssignmentMap.empty()) {
            Expr *lastVarValInFirstPath = this->LastAssignmentMap.begin()->second;
            for (auto assignment : this->LastAssignmentMap) {
                if (!(*assignment.second == *lastVarValInFirstPath)) {
                    Propagtionvalid = false;
                    break;
                }
            }
            if (Propagtionvalid) {
                SCAM::DetectCounterVariable counterDetector(this->variable->getFullName(), lastVarValInFirstPath);
                if (counterDetector.isCounterVariable()) {
                    this->propagatedValue = nullptr;
                    return;
                }
                this->propagatedValue = lastVarValInFirstPath;
                return;
            } else {
                this->propagatedValue = nullptr;
                return;
            }
        }
        this->propagatedValue = nullptr;
    }


    SCAM::Expr *SCAM::PropagateConstantValue::lastVariableValueInPath(const std::vector<SCAM::CfgNode *> &path) {

        for (auto node : path) {
            if (node->getStmt() != nullptr) {
                this->currentNodeId = node->getId();
                node->getStmt()->accept(*this);
            }
        }
        if (this->variableValueMap.empty() || isVarRead) {
            return nullptr;
        } else if (this->wasRhsVarOp) {
            bool isPropagationFalse = false;
            for (const auto &rhsVar : this->rhsVariableAssignmentsIds) {
                for (auto rhsVarAssignmentId : rhsVar.second) {
                    if (this->lastAssignmentId < rhsVarAssignmentId && rhsVarAssignmentId < this->stmtId) {
                        isPropagationFalse = true;
                        break;
                    }
                }
            }
            this->wasRhsVarOp = false;
            this->lastAssignmentAlreadyStored = false;
            this->rhsVariableAssignmentsIds.clear();

            if (isPropagationFalse) {
                this->variableValueMap.clear();
                return nullptr;
            }
        }
        if (variable->getDataType()->isCompoundType()) {
            for (const auto &subVar: variable->getDataType()->getSubVarMap()) {
                //check that there is no missing assignment to the subvariable or datatype mismatch
                if (variableValueMap.find(subVar.first) == variableValueMap.end() ||
                    (variableValueMap.find(subVar.first) != variableValueMap.end() &&
                     variableValueMap.find(subVar.first)->second->getDataType() != subVar.second)) {
                    return nullptr;
                }
            }
            return new CompoundExpr(variableValueMap, variable->getDataType());
        } else if (variable->getDataType()->isArrayType()) {
            for (const auto &subVar: variable->getDataType()->getSubVarMap()) {
                //check that there is no missing assignment to the subvariable or datatype mismatch
                if (variableValueMap.find(subVar.first) == variableValueMap.end() ||
                    (variableValueMap.find(subVar.first) != variableValueMap.end() &&
                     variableValueMap.find(subVar.first)->second->getDataType() != subVar.second)) {
                    return nullptr;
                }
            }
            return new ArrayExpr(variableValueMap, variable->getDataType());
        } else if (variableValueMap.size() == 1) { //variable is not a compound variable or array
            if (variableValueMap.begin()->second->getDataType() != this->variable->getDataType()) {
                throw std::runtime_error("propagated values and variable are of different datatypes");
            }
            return variableValueMap.begin()->second;
        } else {
            return nullptr;
        }
    }

    void PropagateConstantValue::addOrSubstituteVariableValue(const std::string &varName, SCAM::Expr *expr) {
        if (this->variableValueMap.find(varName) == this->variableValueMap.end()) {
            this->variableValueMap.insert(std::make_pair(varName, expr));

        } else {
            this->variableValueMap.at(varName) = expr;
        }
    }

    void PropagateConstantValue::visit(SCAM::Assignment &node) {
        if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(node.getLhs())) { //var is not sectionOperand
            std::string varOpName = varOp->getVariable()->getFullName();
            if (varOpName == this->variable->getFullName()) {
                addOrSubstituteVariableValue(varOpName, node.getRhs());
                this->isVarRead = false;
                this->lastAssignmentId = this->currentNodeId;
                checkIfRhsOfAssignmentIsAVarOp(node.getRhs());
            } else if (this->variable->isCompoundType() ||
                       this->variable->isArrayType()) {
                //check if the assignment's Lhs is a child of the propagate value variable
                if (varOp->getVariable()->getParent() != nullptr) {
                    if (varOp->getVariable()->getParent()->getFullName() == this->variable->getFullName()) {
                        addOrSubstituteVariableValue(varOp->getVariable()->getName(), node.getRhs());
                        if (!this->lastAssignmentAlreadyStored) {
                            this->lastAssignmentId = this->currentNodeId;
                            this->lastAssignmentAlreadyStored = true;
                        }
                        checkIfRhsOfAssignmentIsAVarOp(node.getRhs());
                        if (this->variable->getDataType()->getSubVarMap().size() == this->variableValueMap.size()) {
                            this->isVarRead = false;
                        }
                    }
                }
            } else if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
                //check if the assignment's Lhs is a parent of the propagate value variable
                if (this->variable->getParent() != nullptr) {
                    if (varOp->getVariable()->getFullName() == this->variable->getParent()->getFullName()) {
                        this->isVarRead = false;
                        addOrSubstituteVariableValue(this->variable->getFullName(), node.getRhs());
                        checkIfRhsOfAssignmentIsAVarOp(node.getRhs());
                    }
                }
            }
            if (this->wasRhsVarOp) {
                if (this->rhsVariableAssignmentsIds.find(varOpName) != this->rhsVariableAssignmentsIds.end()) {
                    this->rhsVariableAssignmentsIds.at(varOpName).insert(this->currentNodeId);
                }
            }
        }
    }

    void PropagateConstantValue::visit(SCAM::ITE &node) {
        throw std::runtime_error("ITE not allowed");

    }

    void SCAM::PropagateConstantValue::visit(struct Read &node) {
        if (node.getStatusOperand() != nullptr &&
            node.getStatusOperand()->getVariable()->getFullName() == this->variable->getFullName()) {
            this->isVarRead = true;
            this->lastAssignmentId = this->currentNodeId;
        }
        auto varOp = node.getVariableOperand();
        std::string varOpName = varOp->getVariable()->getFullName();
        if (varOpName == this->variable->getFullName()) {
            this->isVarRead = true;
            this->lastAssignmentId = this->currentNodeId;
        } else if (this->variable->isCompoundType() ||
                   this->variable->isArrayType()) {
            //check if the assignment's Lhs is a child of the propagate value variable
            if (varOp->getVariable()->getParent() != nullptr) {
                if (varOp->getVariable()->getParent()->getFullName() == this->variable->getFullName()) {
                    this->isVarRead = true;
                    this->variableValueMap.clear();
                    this->lastAssignmentId = this->currentNodeId;
                }
            }
        } else if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
            //check if the assignment's Lhs is a parent of the propagate value variable
            if (this->variable->getParent() != nullptr) {
                if (varOp->getVariable()->getFullName() == this->variable->getParent()->getFullName()) {
                    this->isVarRead = true;
                    this->lastAssignmentId = this->currentNodeId;
                }
            }
        }
        if (this->wasRhsVarOp) {
            if (this->rhsVariableAssignmentsIds.find(varOpName) != this->rhsVariableAssignmentsIds.end()) {
                this->rhsVariableAssignmentsIds.at(varOpName).insert(this->currentNodeId);
            } else if (node.getStatusOperand() != nullptr &&
                       this->rhsVariableAssignmentsIds.find(node.getStatusOperand()->getVariable()->getFullName()) !=
                       this->rhsVariableAssignmentsIds.end()) {
                this->rhsVariableAssignmentsIds.at(node.getStatusOperand()->getVariable()->getFullName()).insert(
                        this->currentNodeId);
            }
        }
    }

    void SCAM::PropagateConstantValue::visit(struct Write &node) {
        if (node.getStatusOperand() != nullptr &&
            node.getStatusOperand()->getVariable()->getFullName() == this->variable->getFullName()) {
            this->isVarRead = true;
            this->lastAssignmentId = this->currentNodeId;
        }
        if (this->wasRhsVarOp) {
            if (node.getStatusOperand() != nullptr &&
                this->rhsVariableAssignmentsIds.find(node.getStatusOperand()->getVariable()->getFullName()) !=
                this->rhsVariableAssignmentsIds.end()) {
                this->rhsVariableAssignmentsIds.at(node.getStatusOperand()->getVariable()->getFullName()).insert(
                        this->currentNodeId);
            }
        }

    }


    void SCAM::PropagateConstantValue::visit(SCAM::Return &node) {
        throw std::runtime_error("return not expected in the module CFG");
    }

    SCAM::Expr *PropagateConstantValue::getPropagatedValue() const {
        return this->propagatedValue;
    }

    int PropagateConstantValue::getNumLastAssignments() const {
        return this->numLastAssignments;
    }

    const std::map<int, SCAM::Expr *> &PropagateConstantValue::getLastAssignmentsMap() const {
        return this->LastAssignmentMap;
    }

    void PropagateConstantValue::checkIfRhsOfAssignmentIsAVarOp(SCAM::Expr *rhs) {
        SCAM::FindVariablesAndFunctionsInStatement findVars(rhs, std::set<std::string>{});
        if (!findVars.getVariablesInStmtSet().empty()) {// a new assignment to the variable from another variable
            this->wasRhsVarOp = true;
            std::set<int> assignmentsIds;
            for (auto varName : findVars.getVariablesInStmtSet()) {
                if (this->rhsVariableAssignmentsIds.find(varName) == this->rhsVariableAssignmentsIds.end()) {
                    this->rhsVariableAssignmentsIds.insert(
                            std::make_pair(varName, assignmentsIds));
                }
            }
        } else { // if a new assignment to the variable that is not a variable operand occurs, reset flag and clear map
            this->wasRhsVarOp = false;
            this->rhsVariableAssignmentsIds.clear();
        }
    }
}