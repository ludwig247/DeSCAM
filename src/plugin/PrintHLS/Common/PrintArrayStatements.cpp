//
// Created by schauss on 09.01.20.
//

#include "PrintArrayStatements.h"

using namespace DESCAM::HLSPlugin;

PrintArrayStatements::PrintArrayStatements(Expr *expr, Port* port) :
    port(port)
{
    expr->accept(*this);
}

std::list<DESCAM::Expr *> PrintArrayStatements::getArrayExprs(DESCAM::Expr *expr, Port* port) {
    PrintArrayStatements printArrayStatements(expr, port);
    return printArrayStatements.arrayExprs;
}

void PrintArrayStatements::visit(Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintArrayStatements::visit(Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintArrayStatements::visit(Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintArrayStatements::visit(Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintArrayStatements::visit(Cast &node) {
    node.getSubExpr()->accept(*this);
}

void PrintArrayStatements::visit(UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void PrintArrayStatements::visit(FunctionOperand &node) {
    for (const auto &parameter : node.getParamValueMap()) {
        parameter.second->accept(*this);
    }
}

void PrintArrayStatements::visit(ArrayOperand &node) {
    if (node.getArrayOperand()->getOperandName() == port->getDataSignal()->getName()) {
        arrayExprs.push_back(node.getIdx());
    }
}

void PrintArrayStatements::visit(DESCAM::Assignment& node)
{
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void PrintArrayStatements::visit(DESCAM::DataSignalOperand& node)
{
    if (node.getDataSignal()->isSubVar()) {
        if (node.getDataSignal()->getParent()->isArrayType()) {
            arrayExprs.push_back(&node);
        }
    }
}



