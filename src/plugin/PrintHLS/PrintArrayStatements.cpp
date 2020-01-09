//
// Created by schauss on 09.01.20.
//

#include "PrintArrayStatements.h"

using namespace SCAM;

PrintArrayStatements::PrintArrayStatements(Expr *expr, Port* port) :
    port(port)
{
    expr->accept(*this);
}

std::list<Expr *> PrintArrayStatements::getArrayExprs(SCAM::Expr *expr, Port* port) {
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



