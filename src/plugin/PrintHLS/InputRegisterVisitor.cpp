//
// Created by schauss on 26.08.19.
//

#include "InputRegisterVisitor.h"

InputRegisterVisitor::InputRegisterVisitor(Stmt *stmt, Port *port) :
    arrayPort(false),
    port(port)
{
    stmt->accept(*this);
}

bool InputRegisterVisitor::getStmtTypes(Stmt *stmt, Port *port) {
    InputRegisterVisitor inputRegisterVisitor(stmt, port);
    return inputRegisterVisitor.arrayPort;
}

void InputRegisterVisitor::visit(Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void InputRegisterVisitor::visit(Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void InputRegisterVisitor::visit(UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void InputRegisterVisitor::visit(Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void InputRegisterVisitor::visit(FunctionOperand &node) {
    auto paramValueMap = node.getParamValueMap();
    for (auto param : paramValueMap) {
        param.second->accept(*this);
    }
}

void InputRegisterVisitor::visit(ArrayOperand &node) {
    node.getIdx()->accept(*this);
}

void InputRegisterVisitor::visit(Bitwise &node) {

}

void InputRegisterVisitor::visit(DataSignalOperand &node) {
    if (node.getDataSignal()->isSubVar()) {
        if (port->getDataSignal()->getName() == node.getDataSignal()->getParent()->getName()) {
            if (node.getDataSignal()->getParent()->isArrayType()) {
                arrayPort = true;
            }
        }
    }
}

void InputRegisterVisitor::visit(Assignment &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}
