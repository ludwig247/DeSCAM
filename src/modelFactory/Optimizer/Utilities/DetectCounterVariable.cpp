//
// Created by M.I.Alkoudsi on 17.08.19.
//

#include "DetectCounterVariable.h"


SCAM::DetectCounterVariable::DetectCounterVariable(std::string variableName, SCAM::Expr *expr) : isCounter(
        false), variableName(std::move(variableName)), expr(expr), variableIncrementsChanged(false), variableIncrements(
        true),
                                                                                                 incrementKnown(
                                                                                                         true) {
    if (this->expr != nullptr) {
        this->expr->accept(*this);
    }
}

bool SCAM::DetectCounterVariable::isCounterVariable() const {
    return this->isCounter;
}

bool SCAM::DetectCounterVariable::isIncrementKnown() const {
    return this->incrementKnown;
}

bool SCAM::DetectCounterVariable::isVariableIncrements() const {
    return this->variableIncrements;
}

void SCAM::DetectCounterVariable::visit(SCAM::VariableOperand &node) {
    if (node.getVariable()->getFullName() == this->variableName) { this->isCounter = true; }
}

void SCAM::DetectCounterVariable::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);

    if (!this->variableIncrementsChanged && this->isCounter) {
        this->variableIncrementsChanged = true;
        auto operation = node.getOperation();
        if (auto lhs = NodePeekVisitor::nodePeekIntegerValue(node.getLhs())) {
            auto lhsVal = lhs->getValue();
            if (lhsVal > 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = true;
            } else if (lhsVal > 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = false;
            } else if (lhsVal < 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = false;
            } else if (lhsVal < 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = true;
            }
        } else if (auto lhs = NodePeekVisitor::nodePeekUnsignedValue(node.getLhs())) {
            auto lhsVal = lhs->getValue();
            if (lhsVal > 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = true;
            } else if (lhsVal > 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = false;
            }
        } else if (auto rhs = NodePeekVisitor::nodePeekIntegerValue(node.getRhs())) {
            auto lhsVal = rhs->getValue();
            if (lhsVal > 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = true;
            } else if (lhsVal > 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = false;
            } else if (lhsVal < 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = false;
            } else if (lhsVal < 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = true;
            }
        } else if (auto rhs = NodePeekVisitor::nodePeekUnsignedValue(node.getRhs())) {
            auto lhsVal = rhs->getValue();
            if (lhsVal > 0 && (operation == "+" || operation == "*")) {
                this->variableIncrements = true;
            } else if (lhsVal > 0 && (operation == "/" || operation == "-" || operation == "%")) {
                this->variableIncrements = false;
            }
        }
    } else if (this->isCounter) {
        this->incrementKnown = false;
    }
}

void SCAM::DetectCounterVariable::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(SCAM::FunctionOperand &node) {
    for (auto param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
}

void SCAM::DetectCounterVariable::visit(struct ArrayOperand &node) {
    node.getIdx()->accept(*this);
}

void SCAM::DetectCounterVariable::visit(struct CompoundExpr &node) {
    for (auto subvar : node.getValueMap()) {
        subvar.second->accept(*this);
    }
}

void SCAM::DetectCounterVariable::visit(SCAM::ArrayExpr &node) {
    for (auto subvar : node.getValueMap()) {
        subvar.second->accept(*this);
    }
}

void SCAM::DetectCounterVariable::visit(struct ParamOperand &node) {
    if (node.getOperandName() == this->variableName) { this->isCounter = true; }
}

void SCAM::DetectCounterVariable::visit(SCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);

}
