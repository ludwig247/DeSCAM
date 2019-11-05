//
// Created by M.I.Alkoudsi on 12.09.19.
//


#include "AnalyzeCounterVariables.h"


SCAM::AnalyzeCounterVariables::AnalyzeCounterVariables(std::set<std::string> counterVariablesSet,
                                                       std::map<int, SCAM::CfgNode *> CFG) : CFG(std::move(CFG)),
                                                                                                       counterVariablesSet(std::move(
                                                                                                               counterVariablesSet)) {
    for (auto node : this->CFG) {
        if (auto stmt = node.second->getStmt()) {
            if (auto ifStmt = dynamic_cast<SCAM::If *>(stmt)) {
                this->counterVariablesInIfStmt.clear();
                SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(ifStmt);
                for (auto variable : variablesInStmtFinder.getVariablesInStmtSet()) {
                    if (this->counterVariablesSet.find(variable) != this->counterVariablesSet.end()) {
                        counterVariablesInIfStmt.insert(variable);
                    }
                }
                int trueBranchNode = node.second->getSuccessorList()[0]->getId();
                int elseNodeId = node.second->getSuccessorList()[1]->getId();
                std::set<std::string> counterIncrementAssignmentFound;
                std::set<std::string> nestedIfWithCounterFound;
                while (trueBranchNode != elseNodeId) {
                    if (auto stmtInTrueBranch = this->CFG.at(trueBranchNode)->getStmt()) {
                        if (auto assignment = dynamic_cast<SCAM::Assignment *>(stmtInTrueBranch)) {
                            if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                                std::string counterVariable = varOp->getVariable()->getFullName();
                                SCAM::DetectCounterVariable counterDetector(counterVariable, assignment->getRhs());
                                if (counterDetector.isCounterVariable()) {
                                    if (counterDetector.isIncrementKnown()) {
                                        this->counterVariableIncrements = counterDetector.isVariableIncrements();
                                        this->currentCounterVariable = counterVariable;
                                        this->hardToAnalyzeCounterVariable = false;
                                        if (!this->counterVariablesInIfStmt.empty()) {
                                            if (counterVariablesInIfStmt.find(counterVariable) !=
                                                counterVariablesInIfStmt.end()) {
                                                ifStmt->accept(*this);
                                                if (this->hardToAnalyzeCounterVariable) {
                                                    if (this->marginalValuesMap.find(counterVariable) !=
                                                        this->marginalValuesMap.end()) {
                                                        this->marginalValuesMap.at(counterVariable) = "HardToAnalyze";
                                                    } else {
                                                        this->marginalValuesMap.insert(
                                                                std::make_pair(counterVariable, "HardToAnalyze"));
                                                    }
                                                } else {
                                                    addToMarginalValuesMap(counterVariable);
                                                }
                                            }
                                        } else { //no counters in if stmt, traverse through the true branch looking for a counter increment/decrement followed by if(var==bound)
                                            if (nestedIfWithCounterFound.find(counterVariable) ==
                                                nestedIfWithCounterFound.end()) {
                                                counterIncrementAssignmentFound.insert(counterVariable);
                                            }
                                        }
                                    } else {
                                        if (this->marginalValuesMap.find(counterVariable) !=
                                            this->marginalValuesMap.end()) {
                                            this->marginalValuesMap.at(counterVariable) = "HardToAnalyze";
                                        } else {
                                            this->marginalValuesMap.insert(
                                                    std::make_pair(counterVariable, "HardToAnalyze"));
                                        }
                                    }
                                }
                            }
                        } else if (auto nestedIfStmt = dynamic_cast<SCAM::If *> (stmtInTrueBranch)) {

                            SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(nestedIfStmt);
                            for (auto variable : variablesInStmtFinder.getVariablesInStmtSet()) {
                                if (this->counterVariablesSet.find(variable) != this->counterVariablesSet.end()) {
                                    counterVariablesInIfStmt.insert(variable);
                                    nestedIfWithCounterFound.insert(variable);
                                }
                            }
                            if (!this->counterVariablesInIfStmt.empty()) {
                                int nestedTrueBranchNode = this->CFG.at(
                                        trueBranchNode)->getSuccessorList()[0]->getId();
                                int nestedElseNodeId = this->CFG.at(trueBranchNode)->getSuccessorList()[1]->getId();
                                while (nestedTrueBranchNode != nestedElseNodeId) {
                                    if (auto stmtInTrueBranch = this->CFG.at(nestedTrueBranchNode)->getStmt()) {
                                        if (auto assignment = dynamic_cast<SCAM::Assignment *>(stmtInTrueBranch)) {
                                            if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                                                auto varName = varOp->getVariable()->getFullName();
                                                if (counterIncrementAssignmentFound.find(varName) !=
                                                    counterIncrementAssignmentFound.end()) {
                                                    if (this->counterVariablesSet.find(varName) !=
                                                        this->counterVariablesSet.end()) {
                                                        SCAM::DetectCounterVariable counterDetector(varName,
                                                                                                    assignment->getRhs());
                                                        if (!counterDetector.isCounterVariable()) { //assignment is not a countertype e.g. x=x+1;
                                                            this->marginValue = MarginValue::limited;
                                                            addToMarginalValuesMap(varName);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if (this->CFG.at(nestedTrueBranchNode)->getSuccessorList()[0]->getId() <
                                        nestedTrueBranchNode) {
                                        break;
                                    }
                                    nestedTrueBranchNode++;
                                }
                            }
                        }
                    }
                    if (this->CFG.at(trueBranchNode)->getSuccessorList()[0]->getId() < trueBranchNode) {
                        break;
                    }
                    trueBranchNode++;
                }
            } else {
                auto parentNode = node.second->getPredecessorList()[0];
                if (dynamic_cast<SCAM::If *> (parentNode->getStmt())) {
                    if (node.second->getId() == parentNode->getSuccessorList()[1]->getId()) { //current node is else
                        int nodeINElseBranchId = node.second->getSuccessorList()[0]->getId();
                        std::set<std::string> counterIncrementAssignmentFound;
                        std::set<std::string> nestedIfWithCounterFound;
                        while (nodeINElseBranchId < this->CFG.at(nodeINElseBranchId)->getSuccessorList()[0]->getId()) {
                            if (auto stmtInTrueBranch = this->CFG.at(nodeINElseBranchId)->getStmt()) {
                                if (auto assignment = dynamic_cast<SCAM::Assignment *>(stmtInTrueBranch)) {
                                    if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                                        std::string counterVariable = varOp->getVariable()->getFullName();
                                        SCAM::DetectCounterVariable counterDetector(counterVariable, assignment->getRhs());
                                        if (counterDetector.isCounterVariable() && counterDetector.isIncrementKnown()) {
                                            if (nestedIfWithCounterFound.find(counterVariable) ==
                                                nestedIfWithCounterFound.end()) {
                                                counterIncrementAssignmentFound.insert(counterVariable);
                                            }
                                        }
                                    }
                                } else if (auto nestedIfStmt = dynamic_cast<SCAM::If *> (stmtInTrueBranch)) {

                                    SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(nestedIfStmt);
                                    for (auto var : variablesInStmtFinder.getVariablesInStmtSet()) {
                                        if (this->counterVariablesSet.find(var) !=
                                            this->counterVariablesSet.end()) {
                                            counterVariablesInIfStmt.insert(var);
                                            nestedIfWithCounterFound.insert(var);
                                        }
                                    }
                                    if (!this->counterVariablesInIfStmt.empty()) {
                                        int nestedTrueBranchNode = this->CFG.at(
                                                nodeINElseBranchId)->getSuccessorList()[0]->getId();
                                        int nestedElseNodeId = this->CFG.at(
                                                nodeINElseBranchId)->getSuccessorList()[1]->getId();
                                        while (nestedTrueBranchNode != nestedElseNodeId) {
                                            if (auto stmtInElseBranch = this->CFG.at(nestedTrueBranchNode)->getStmt()) {
                                                if (auto assignment = dynamic_cast<SCAM::Assignment *>(stmtInElseBranch)) {
                                                    if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                                                        auto varName = varOp->getVariable()->getFullName();
                                                        if (counterIncrementAssignmentFound.find(varName) !=
                                                            counterIncrementAssignmentFound.end()) {
                                                            if (this->counterVariablesSet.find(varName) !=
                                                                this->counterVariablesSet.end()) {
                                                                SCAM::DetectCounterVariable counterDetector(varName,
                                                                                                            assignment->getRhs());
                                                                if (!counterDetector.isCounterVariable()) { //assignment is not a countertype e.g. x=x+1;
                                                                    this->marginValue = MarginValue::limited;
                                                                    addToMarginalValuesMap(varName);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if (this->CFG.at(nestedTrueBranchNode)->getSuccessorList()[0]->getId() <
                                                nestedTrueBranchNode) {
                                                break;
                                            }
                                            nestedTrueBranchNode++;
                                        }
                                    }
                                }
                            }
                            nodeINElseBranchId++;
                        }
                    }
                }
            }
        }
    } //counter variables that are outside if statements and inside the while(true) loop (take the full range of int/unsigned)
    for (auto var : this->counterVariablesSet) {
        if (this->marginalValuesMap.find(var) == this->marginalValuesMap.end()) {
            this->marginalValuesMap.insert(
                    std::make_pair(var, "HardToAnalyze"));
        }
    }
}

const std::map<std::string, std::string> &SCAM::AnalyzeCounterVariables::getMarginalValuesMap() {
    return this->marginalValuesMap;
}

void SCAM::AnalyzeCounterVariables::visit(SCAM::UnaryExpr &node) {
    this->hardToAnalyzeCounterVariable = true;
}

void SCAM::AnalyzeCounterVariables::visit(SCAM::If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::AnalyzeCounterVariables::visit(SCAM::Logical &node) {
    if (node.getOperation() == "&&") {
        node.getLhs()->accept(*this);
        if (marginValue != MarginValue::limited && !this->hardToAnalyzeCounterVariable) {
            node.getRhs()->accept(*this);
        }
    } else if (node.getOperation() == "or") {
        node.getLhs()->accept(*this);
        if (this->marginValue == MarginValue::limited && !this->hardToAnalyzeCounterVariable) {
            node.getRhs()->accept(*this);
        }
    } else {
        this->hardToAnalyzeCounterVariable = true;
    }
}

void SCAM::AnalyzeCounterVariables::visit(SCAM::Relational &node) {
    auto operation = node.getOperation();
    bool counterOnLhs = false;
    this->hardToAnalyzeCounterVariable = false;
    std::string variableDataType;
    if (auto counterVar = NodePeekVisitor::nodePeekVariableOperand(node.getLhs())) {
        if (counterVar->getVariable()->getFullName() == this->currentCounterVariable) {
            counterOnLhs = true;
            variableDataType = counterVar->getVariable()->getDataType()->getName();
        } else if (auto counterVar = NodePeekVisitor::nodePeekVariableOperand(node.getRhs())) {
            if (counterVar->getVariable()->getFullName() == this->currentCounterVariable) {
                counterOnLhs = false;
                variableDataType = counterVar->getVariable()->getDataType()->getName();
            } else {
                this->hardToAnalyzeCounterVariable = true;
            }
        }
    } else if (auto counterVar = NodePeekVisitor::nodePeekVariableOperand(node.getRhs())) {
        if (counterVar->getVariable()->getFullName() == this->currentCounterVariable) {
            counterOnLhs = false;
            variableDataType = counterVar->getVariable()->getDataType()->getName();
        } else {
            this->hardToAnalyzeCounterVariable = true;
        }
    } else { this->hardToAnalyzeCounterVariable = true; }
    if (!this->hardToAnalyzeCounterVariable) {
        if ((operation == ">" || operation == ">=")) {
            if (this->counterVariableIncrements) {
                if (counterOnLhs) {//goes to the positive end of the range
                    if (variableDataType == "int") {
                        this->marginValue = MarginValue::intRange;
                    } else if (variableDataType == "unsigned") {
                        this->marginValue = MarginValue::unsignedRange;
                    }
                } else {
                    //range limited by margins
                    this->marginValue = MarginValue::limited;
                }
            } else { //counterdecrements
                if (counterOnLhs) {
                    //range limited by margins
                    this->marginValue = MarginValue::limited;
                } else {
                    //goes to the negative end of the range
                    if (variableDataType == "int") {
                        this->marginValue = MarginValue::intRange;
                    } else if (variableDataType == "unsigned") {
                        this->marginValue = MarginValue::unsignedRange;
                    }
                }
            }
        } else if ((operation == "<" || operation == "<=")) {
            if (this->counterVariableIncrements) {
                if (counterOnLhs) {
                    //range limited by margins
                    this->marginValue = MarginValue::limited;
                } else {
                    //goes to the positive end of the range
                    if (variableDataType == "int") {
                        this->marginValue = MarginValue::intRange;
                    } else if (variableDataType == "unsigned") {
                        this->marginValue = MarginValue::unsignedRange;
                    }
                }
            } else { //counterdecrements
                if (counterOnLhs) {
                    //goes to the negative end of the range
                    if (variableDataType == "int") {
                        this->marginValue = MarginValue::intRange;
                    } else if (variableDataType == "unsigned") {
                        this->marginValue = MarginValue::unsignedRange;
                    }
                } else {
                    //range limited by margins
                    this->marginValue = MarginValue::limited;
                }
            }
        } else if ((operation == "==")) {
            //range limited by margins
            this->marginValue = MarginValue::limited;
        } else if ((operation == "!=")) { //have to know the comparison value to be able to decide
            if (this->counterVariableIncrements) {
                //goes to positive end of the range
                if (variableDataType == "int") {
                    this->marginValue = MarginValue::intRange;
                } else if (variableDataType == "unsigned") {
                    this->marginValue = MarginValue::unsignedRange;
                } else {
                    //goes to negative end of the range
                    if (variableDataType == "int") {
                        this->marginValue = MarginValue::intRange;
                    } else if (variableDataType == "unsigned") {
                        this->marginValue = MarginValue::unsignedRange;
                    }
                }
            }
        }
    }
}

void SCAM::AnalyzeCounterVariables::addToMarginalValuesMap(std::string varName) {
    if (this->marginalValuesMap.find(varName) != this->marginalValuesMap.end()) {
        if (this->marginalValuesMap.at(varName) == "HardToAnalyze") {
            return;
        } else if (this->marginalValuesMap.at(varName) == "Limited") {
            if (this->marginValue == MarginValue::unsignedRange) {
                this->marginalValuesMap.at(varName) = "Unsigned";
            } else if (this->marginValue == MarginValue::intRange) {
                this->marginalValuesMap.at(varName) = "Int";
            }
        }
    } else {
        if (this->marginValue == MarginValue::limited) {
            this->marginalValuesMap.insert(std::make_pair(varName, "Limited"));
        } else if (this->marginValue == MarginValue::unsignedRange) {
            this->marginalValuesMap.insert(std::make_pair(varName, "Unsigned"));
        } else if (this->marginValue == MarginValue::intRange) {
            this->marginalValuesMap.insert(std::make_pair(varName, "Int"));
        }

    }
}



