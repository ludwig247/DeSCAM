//
// Created by johannes on 17.08.19.
//

#include "VisitParameters.h"
#include "NodePeekVisitor.h"

using namespace SCAM;

VisitParameters::VisitParameters(Expr *expr) :
    parameters(),
    operators()
{
    expr->accept(*this);
}

std::set<std::pair<std::string, std::string> > VisitParameters::getParameters(Expr *expr) {
    VisitParameters parameterVisitor(expr);
    return parameterVisitor.parameters;
}

std::map<std::string, std::string> VisitParameters::getParametersVHDL(Expr *expr) {
    VisitParameters parameterVisitor(expr);
    return parameterVisitor.HDLToVHDLMap;
}

std::vector<std::string> VisitParameters::getOperators(Expr *expr) {
    VisitParameters parameterVisitor(expr);
    return parameterVisitor.operators;
}

void VisitParameters::visit(Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
    operators.push_back(node.getOperation());
}

void VisitParameters::visit(VariableOperand &node) {
    if (node.getVariable()->isSubVar()) {
        std::string typeName = convertDataType(node.getVariable()->getDataType()->getName());
        std::string variableName = node.getVariable()->getParent()->getName() + "_" + node.getVariable()->getName();
        std::string variableNameVHDL = node.getVariable()->getParent()->getName() + "." + node.getVariable()->getName();
        parameters.insert(std::make_pair(typeName, variableName));
        HDLToVHDLMap.insert(std::make_pair(variableName, variableNameVHDL));
    } else {
        std::string typeName = convertDataType(node.getVariable()->getDataType()->getName());
        std::string variableName = node.getVariable()->getName();
        parameters.insert(std::make_pair(typeName, variableName));
        HDLToVHDLMap.insert(std::make_pair(variableName, variableName));
    }
}

void VisitParameters::visit(DataSignalOperand &node) {
    std::string typeName =  convertDataType(node.getDataSignal()->getDataType()->getName());
    std::string variableName = node.getDataSignal()->getPort()->getName() + "_sig";
    std::string variableNameVHDL = variableName;
    if (node.getDataSignal()->isSubVar()) {
        variableName.append("_" + node.getDataSignal()->getName());
        variableNameVHDL.append((".") + node.getDataSignal()->getName());
    }
    parameters.insert(std::make_pair(typeName, variableName));
    HDLToVHDLMap.insert(std::make_pair(variableName, variableNameVHDL));
}

void VisitParameters::visit(SyncSignal &node) {
    std::string variableName = node.getPort()->getName() + "_sync,";
    parameters.insert(std::make_pair("bool", variableName));
    HDLToVHDLMap.insert(std::make_pair(variableName, variableName));
}

void VisitParameters::visit(Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
    operators.push_back(node.getOperation());
}

void VisitParameters::visit(UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void VisitParameters::visit(Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
    operators.push_back(node.getOperation());
}

void VisitParameters::visit(FunctionOperand &node) {
    auto parameterMap = node.getParamValueMap();
    for (auto &parameter : parameterMap) {
        parameter.second->accept(*this);
    }
    for (auto stmt : node.getFunction()->getStmtList()) {
        stmt->accept(*this);
    }
}

void VisitParameters::visit(CompoundExpr &node) {
//    std::string variableName = "_" + node.getDataType()->getName();
    for (auto value = node.getValueMap().begin(); value != node.getValueMap().end(); value++) {
//        NodePeekVisitor nodePeekVisitor(value->second);
//        if(nodePeekVisitor.nodePeekDataSignalOperand()) {
//           std::string typeName = convertDataType(node.getDataType()->getName());
//           std::string variableName = nodePeekVisitor.nodePeekDataSignalOperand()->getDataSignal()->getParent()->getName();
//           parameters.insert(std::make_pair(typeName, variableName));
//           HDLToVHDLMap.insert(std::make_pair(variableName, variableName));
//           break;
//        } else {
            value->second->accept(*this);
//        }
    }
}

void VisitParameters::visit(ITE &node) {
    node.getConditionStmt()->accept(*this);
    for (auto stmt : node.getIfList()) {
        stmt->accept(*this);
    }
    for (auto stmt : node.getElseList()) {
        stmt->accept(*this);
    }
}

void VisitParameters::visit(Return &node) {
    node.getReturnValue()->accept(*this);
}

void VisitParameters::visit(Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
    operators.push_back(node.getOperation());
}

std::string VisitParameters::convertDataType(const std::string &typeName) {
    if (typeName == "unsigned") {
        return "unsigned int";
    } else {
        return typeName;
    }
}

void VisitParameters::visit(Notify &node) {
    std::string variableName = node.getPort()->getName() + "_notify";
    parameters.insert(std::make_pair("bool", variableName));
    HDLToVHDLMap.insert(std::make_pair(variableName, variableName));
}
