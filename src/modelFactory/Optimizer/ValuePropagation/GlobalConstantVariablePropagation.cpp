//
// Created by mi-alkoudsi on 09.12.19.
//

#include "GlobalConstantVariablePropagation.h"


SCAM::GlobalConstantVariablePropagation::GlobalConstantVariablePropagation(const std::map<int, SCAM::CfgNode *> &CFG,
                                                                           const std::map<std::string, Variable *> &globalVariableMap)
        : CFG(CFG), globalVariableMap(globalVariableMap) {

    if (!this->CFG.empty()&& !this->globalVariableMap.empty()) {
        for (auto node : CFG) {
            if (auto stmt = node.second->getStmt()) {
                this->currentNodeId = node.first;
                stmt->accept(*this);
            }
        }
    }
}

const std::map<int, SCAM::CfgNode *> &SCAM::GlobalConstantVariablePropagation::getCFG() const {
    return this->CFG;
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::VariableOperand &node) {
    auto var = node.getVariable();
    if (this->globalVariableMap.find(var->getName()) != this->globalVariableMap.end()) {
        if (var->isConstant()) {
            if (auto val = var->getInitialValue()) {
                this->newExpr = val;
            }
        }
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Assignment &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }

    //Create new stmt
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->CFG.at(this->currentNodeId)->setStmt(new SCAM::Assignment(lhs, rhs));
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::UnaryExpr &node) {
    this->newExpr = nullptr;
    node.getExpr()->accept(*this);
    if (this->newExpr) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1));
            }
        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::While &node) {
    this->newExpr = nullptr;
    node.getConditionStmt()->accept(*this);
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->CFG.at(this->currentNodeId)->setStmt(new While(this->newExpr));
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::If &node) {
    this->newExpr = nullptr;
    node.getConditionStmt()->accept(*this);
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->CFG.at(this->currentNodeId)->setStmt(new While(this->newExpr));
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr) {
        this->CFG.at(this->currentNodeId)->setStmt(
                new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand()));
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Arithmetic &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }

    //Create new stmt
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new SCAM::Arithmetic(lhs, node.getOperation(), rhs);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Logical &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }

    //Create new stmt
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Relational &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }

    //Create new stmt
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Bitwise &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }

    //RHS
    this->newExpr = nullptr;
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }

    //Create new stmt
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::Cast &node) {
    this->newExpr = nullptr;
    node.getSubExpr()->accept(*this);
    if (this->newExpr) {
        this->newExpr = new Cast(this->newExpr, node.getDataType());
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::FunctionOperand &node) {
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (const auto &param : node.getParamValueMap()) {
        this->newExpr = nullptr;
        param.second->accept(*this);
        if (this->newExpr) {
            newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
        } else { newParamValueMap.insert(param); }
    }
    assert(node.getParamValueMap().size() == newParamValueMap.size());
    if (newParamValueMap != node.getParamValueMap()) {
        this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::ArrayOperand &node) {
    this->newExpr = nullptr;
    node.getIdx()->accept(*this);
    if (!(*node.getIdx() == *this->newExpr)) {
        this->newExpr = new ArrayOperand(node.getArrayVar(), this->newExpr);
    }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::CompoundExpr &node) {
    std::map<std::string, SCAM::Expr *> newValMap;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr != nullptr) {
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (newValMap != node.getValueMap()) {
        this->newExpr = new SCAM::CompoundExpr(newValMap, node.getDataType());
    } else { this->newExpr = nullptr; }
}

void SCAM::GlobalConstantVariablePropagation::visit(SCAM::ArrayExpr &node) {
    std::map<std::string, SCAM::Expr *> newValMap;
    bool valueMapChanged = false;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr) {
            valueMapChanged = true;
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (valueMapChanged) {
        this->newExpr = new SCAM::ArrayExpr(newValMap, node.getDataType());
    } else { this->newExpr = nullptr; }
}

