//
// Created by schauss on 02.10.19.
//

#include "VisitFunctions.h"

using namespace SCAM;

std::set<std::string> VisitFunctions::printFunctionNames(SCAM::Expr *expr) {
    VisitFunctions visitFunctions(expr);
    return visitFunctions.functionNames;
}

VisitFunctions::VisitFunctions(SCAM::Expr *expr) {
    expr->accept(*this);
}

void VisitFunctions::visit(FunctionOperand &node) {
    functionNames.insert(node.getOperandName());
}

void VisitFunctions::visit(Arithmetic &node) {
    node.getRhs()->accept(*this);
    node.getLhs()->accept(*this);
}

void VisitFunctions::visit(Relational &node) {
    node.getRhs()->accept(*this);
    node.getLhs()->accept(*this);
}




