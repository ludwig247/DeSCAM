//
// Created by M.I.Alkoudsi on 10.09.19.
//

#include "FindVariablesValuesInRelationalExpressions.h"
/* Idea:
 * Looks for relational expressions inside conditional statements and inside functions
 * example
 * if(x == 10)
 * if(x > y)
 * the algorithm returns the values y and 10 for variable x
 */
SCAM::FindVariablesValuesInRelationalExpressions::FindVariablesValuesInRelationalExpressions(const std::map<int, SCAM::CfgNode *> &CFG) : CFG(CFG) {
    for (auto node : this->CFG) {
        auto stmt = node.second->getStmt();
        if (stmt != nullptr) {
            stmt->accept(*this);
        }
    }
}

const std::map<std::string, std::set<SCAM::Expr *>> &
SCAM::FindVariablesValuesInRelationalExpressions::getVariableValuesFromRelationalExpressionsMap() const {
    return this->variableValuesFromRelationalExpressionsMap;
}

const std::set<std::string> &
SCAM::FindVariablesValuesInRelationalExpressions::getDifficultToAnalyseVariablesSet() const {
    return this->difficultToAnalyseVariablesSet;
}

void SCAM::FindVariablesValuesInRelationalExpressions::addValToVarValMap(std::string varName, SCAM::Expr *expr) {
    if (this->variableValuesFromRelationalExpressionsMap.find(varName) !=
        this->variableValuesFromRelationalExpressionsMap.end()) {
        this->variableValuesFromRelationalExpressionsMap.at(varName).insert(expr);
    } else {
        std::set<SCAM::Expr *> valuesSet;
        valuesSet.insert(expr);
        this->variableValuesFromRelationalExpressionsMap.insert(std::make_pair(varName, valuesSet));
    }
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(SCAM::Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct Relational &node) {
    if (auto varOp = SCAM::NodePeekVisitor::nodePeekVariableOperand(node.getLhs())) {
        if (varOp->getDataType()->getName() != "bool") {
            std::string varName = varOp->getVariable()->getFullName();
            addValToVarValMap(varName, node.getRhs());
        }
    } else if (auto varOp = SCAM::NodePeekVisitor::nodePeekVariableOperand(node.getRhs())) {
        if (varOp->getDataType()->getName() != "bool") {
            std::string varName = varOp->getVariable()->getFullName();
            addValToVarValMap(varName, node.getLhs());
        }
    } else if (auto paramOp = SCAM::NodePeekVisitor::nodePeekParamOperand(node.getLhs())) {
        if (paramOp->getDataType()->getName() != "bool") {
            std::string varName = paramOp->getOperandName();
            addValToVarValMap(varName, node.getRhs());
        }
    } else if (auto paramOp = SCAM::NodePeekVisitor::nodePeekParamOperand(node.getRhs())) {
        if (paramOp->getDataType()->getName() != "bool") {
            std::string varName = paramOp->getOperandName();
            addValToVarValMap(varName, node.getLhs());
        }
    } else {
        SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(&node,std::set<std::string>{});
        for (auto varName : variablesInStmtFinder.getVariablesInStmtSet()) {
            this->difficultToAnalyseVariablesSet.insert(varName);
        }
    }
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(SCAM::FunctionOperand &node) {
    for (auto returnPath : node.getFunction()->getReturnValueConditionList()) {
        for (auto conditionalExpression : returnPath.second) {
            conditionalExpression->accept(*this);
        }
    }
}

void SCAM::FindVariablesValuesInRelationalExpressions::visit(SCAM::Ternary &node) {

    throw std::runtime_error("Combining -Optmize and Compare Operator ? is not allowed");

}


