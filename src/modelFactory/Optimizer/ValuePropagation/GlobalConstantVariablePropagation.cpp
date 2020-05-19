//
// Created by mi-alkoudsi on 09.12.19.
//

#include "GlobalConstantVariablePropagation.h"


DESCAM::GlobalConstantVariablePropagation::GlobalConstantVariablePropagation(const std::map<int, DESCAM::CfgNode *> &CFG,
                                                                           const std::map<std::string, Variable *> &globalVariableMap)
        : CFG(CFG), globalVariableMap(globalVariableMap) {

    if (!this->CFG.empty() && !this->globalVariableMap.empty()) {
        for (auto node : CFG) {
            if (auto stmt = node.second->getStmt()) {
                this->currentNodeId = node.first;
                stmt->accept(*this);
            }
        }
    }
}

const std::map<int, DESCAM::CfgNode *> &DESCAM::GlobalConstantVariablePropagation::getCFG() const {
    return this->CFG;
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::VariableOperand &node) {
    auto var = node.getVariable();
    if (this->globalVariableMap.find(var->getName()) != this->globalVariableMap.end()) {
        if (var->isConstant()) {
            if (auto val = var->getInitialValue()) {
                this->newExpr = val;
            }
        }
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Assignment &node) {
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
        this->CFG.at(this->currentNodeId)->setStmt(new DESCAM::Assignment(lhs, rhs, node.getStmtInfo()));
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::UnaryExpr &node) {
    this->newExpr = nullptr;
    node.getExpr()->accept(*this);
    if (this->newExpr) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1), node.getStmtInfo());
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1), node.getStmtInfo());
            }
        } else TERMINATE("Unknown unary operator " + node.getOperation());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::While &node) {
    this->newExpr = nullptr;
    node.getConditionStmt()->accept(*this);
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->CFG.at(this->currentNodeId)->setStmt(new While(this->newExpr, node.getStmtInfo()));
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::If &node) {
    this->newExpr = nullptr;
    node.getConditionStmt()->accept(*this);
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->CFG.at(this->currentNodeId)->setStmt(new If(this->newExpr, node.getStmtInfo()));
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr) {
        this->CFG.at(this->currentNodeId)->setStmt(
                new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand(),
                          node.getStmtInfo()));
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Arithmetic &node) {
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
        this->newExpr = new DESCAM::Arithmetic(lhs, node.getOperation(), rhs, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Logical &node) {
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
        this->newExpr = new DESCAM::Logical(lhs, node.getOperation(), rhs, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Relational &node) {
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
        this->newExpr = new DESCAM::Relational(lhs, node.getOperation(), rhs, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Bitwise &node) {
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
        this->newExpr = new DESCAM::Bitwise(lhs, node.getOperation(), rhs, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Cast &node) {
    this->newExpr = nullptr;
    node.getSubExpr()->accept(*this);
    if (this->newExpr) {
        this->newExpr = new Cast(this->newExpr, node.getDataType(), node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::FunctionOperand &node) {
    std::map<std::string, DESCAM::Expr *> newParamValueMap;
    for (const auto &param : node.getParamValueMap()) {
        this->newExpr = nullptr;
        param.second->accept(*this);
        if (this->newExpr) {
            newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
        } else { newParamValueMap.insert(param); }
    }
    assert(node.getParamValueMap().size() == newParamValueMap.size());
    if (newParamValueMap != node.getParamValueMap()) {
        this->newExpr = new DESCAM::FunctionOperand(node.getFunction(), newParamValueMap, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::ArrayOperand &node) {
    this->newExpr = nullptr;
    node.getIdx()->accept(*this);
    if (!(*node.getIdx() == *this->newExpr)) {
        this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr, node.getStmtInfo());
    }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::CompoundExpr &node) {
    std::map<std::string, DESCAM::Expr *> newValMap;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr != nullptr) {
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (newValMap != node.getValueMap()) {
        this->newExpr = new DESCAM::CompoundExpr(newValMap, node.getDataType(), node.getStmtInfo());
    } else { this->newExpr = nullptr; }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::ArrayExpr &node) {
    std::map<std::string, DESCAM::Expr *> newValMap;
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
        this->newExpr = new DESCAM::ArrayExpr(newValMap, node.getDataType());
    } else { this->newExpr = nullptr; }
}

void DESCAM::GlobalConstantVariablePropagation::visit(DESCAM::Ternary &node) {
    this->newExpr = nullptr;
    auto condition = node.getCondition();
    auto trueExpr = node.getTrueExpr();
    auto falseExpr = node.getFalseExpr();
    node.getCondition()->accept(*this);
    if (this->newExpr) condition = this->newExpr;
    this->newExpr = nullptr;
    node.getTrueExpr()->accept(*this);
    if (this->newExpr) trueExpr = this->newExpr;
    this->newExpr = nullptr;
    node.getFalseExpr()->accept(*this);
    if (this->newExpr) falseExpr = this->newExpr;
    if (!(*condition == *node.getCondition()) || !(*trueExpr == *node.getTrueExpr()) ||
        !(*falseExpr == *node.getFalseExpr()))
        this->newExpr = new DESCAM::Ternary(condition, trueExpr, falseExpr, node.getStmtInfo());
}

