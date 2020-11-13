//
// Created by M.I.Alkoudsi on 15.07.19.
//

#include <Stmts/StmtCastVisitor.h>
#include "ParamValuePropagation.h"

/* Idea:
 * for each expression in the return value condition list, look for a parameter operand
 * if found, check the name of the operand and update it with its value from the parameter list
 * */

DESCAM::ParamValuePropagation::ParamValuePropagation(std::map<std::string, DESCAM::Expr *> paramValMap,
                                                   const std::map<std::string, Variable *> &globalVariableMap,
                                                   std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> returnValueConditionList)
        : paramValMap(std::move(paramValMap)), globalVariableMap(globalVariableMap),
          returnValueConditionList(std::move(returnValueConditionList)),
          newExpr(nullptr) {

    std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> tempList;
    for (const auto &pair : this->returnValueConditionList) {
        std::vector<Expr *> newExprVector;
        for (auto expr : pair.second) {
            this->newExpr = nullptr;
            expr->accept(*this);
            if (this->newExpr) {
                newExprVector.push_back(this->newExpr);
#ifdef DEBUG_PARAM_VALUE_PROPAGATION
                std::cout << "expr = " << DESCAM::PrintStmt::toString(expr) << std::endl;
                std::cout << "newExpr = " << DESCAM::PrintStmt::toString(this->newExpr) << std::endl;
#endif
            } else { newExprVector.push_back(expr); }
        }
        if (pair.first->getReturnValue()) {
            this->newExpr = nullptr;
            pair.first->getReturnValue()->accept(*this);
            if (this->newExpr) {
                auto newReturn = new Return(this->newExpr,pair.first->getStmtInfo());
                tempList.emplace_back(newReturn, newExprVector);
#ifdef DEBUG_PARAM_VALUE_PROPAGATION
                std::cout << "new return = " << DESCAM::PrintStmt::toString(this->newExpr) << std::endl;
#endif

            } else { tempList.emplace_back(pair.first, newExprVector); }
        } else {
            tempList.emplace_back(pair.first, newExprVector);
        }
    }
    this->returnValueConditionList = tempList;
}

std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>>
DESCAM::ParamValuePropagation::getReturnValueConditionList() const {
    return this->returnValueConditionList;
}


void DESCAM::ParamValuePropagation::visit(DESCAM::VariableOperand &node) {
    this->newExpr = nullptr;
    if (!this->globalVariableMap.empty()) {
        if (this->globalVariableMap.find(node.getOperandName()) != this->globalVariableMap.end()) {
            auto var = this->globalVariableMap.at(node.getOperandName());
            if (var->isConstant()) {
                if (var->getInitialValue()) {
                    this->newExpr = var->getInitialValue();
                    return;
                }
            }
        } else {
            for (const auto& pair : this->globalVariableMap) {
                if (pair.second->isCompoundType() || pair.second->isArrayType()) {
                    for (auto subVar : pair.second->getSubVarList()) {
                        if (subVar->getName() == node.getOperandName()) {
                            if (subVar->isConstant()) {
                                if (subVar->getInitialValue()) {
                                    this->newExpr = subVar->getInitialValue();
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for (const auto &param : this->paramValMap) {
        if (node.getVariable()->getName() == param.first) {
            this->newExpr = param.second;
            return;
        } else if (auto varOp = StmtCastVisitor<DESCAM::VariableOperand>(param.second).Get()) {
            auto var = varOp->getVariable();
            if (node.getVariable()->isSubVar() && (var->isCompoundType() || var->isArrayType())) {
                for (auto subVar : var->getSubVarList()) {
                    if (node.getVariable()->getName() == subVar->getName()) {
                        this->newExpr = new VariableOperand(subVar,node.getStmtInfo());
                        return;
                    }
                }
            }
        }
    }
}



void DESCAM::ParamValuePropagation::visit(DESCAM::UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr);
        } else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr);
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1));
            } else { this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1)); }
        } else TERMINATE("Unknown unary operator " + node.getOperation())
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Arithmetic &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }
    this->newExpr = nullptr;
    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }
    if(lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new DESCAM::Arithmetic(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Logical &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr) { rhs = this->newExpr; }
    if(lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new DESCAM::Logical(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Relational &node) {
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
    if(lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new DESCAM::Relational(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Bitwise &node) {
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
    if(lhs->getDataType() != rhs->getDataType()) {
        this->newExpr = nullptr;
        return;
    }
    if (!(*lhs == *node.getLhs()) || !(*rhs == *node.getRhs())) {
        this->newExpr = new DESCAM::Bitwise(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Cast &node) {
    node.getSubExpr()->accept(*this);
    if (this->newExpr) {
        this->newExpr = new Cast(this->newExpr, node.getDataType(),node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::FunctionOperand &node) {
    for (const auto &param : this->paramValMap) {
        if (node.getOperandName() == param.first) {
            this->newExpr = param.second;
            return;
        }
    }
    std::map<std::string, DESCAM::Expr *> newParamValueMap;
    for (auto prm : node.getParamValueMap()) {
        this->newExpr = nullptr;
        prm.second->accept(*this);
        if (this->newExpr) {
            newParamValueMap.insert(std::make_pair(prm.first, this->newExpr));
        } else { newParamValueMap.insert(std::make_pair(prm.first, prm.second)); }
    }
    if (newParamValueMap != node.getParamValueMap()) {
        this->newExpr = new DESCAM::FunctionOperand(node.getFunction(), newParamValueMap,node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    if (!(*node.getIdx() == *this->newExpr)) {
        this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr,node.getStmtInfo());
    } else this->newExpr = nullptr;
}

void DESCAM::ParamValuePropagation::visit(DESCAM::CompoundExpr &node) {
    std::map<std::string, DESCAM::Expr *> newValueMap;
    bool valueMapChanged = false;
    for (auto prm : node.getValueMap()) {
        this->newExpr = nullptr;
        prm.second->accept(*this);
        if (this->newExpr) {
            valueMapChanged = true;
            newValueMap.insert(std::make_pair(prm.first, this->newExpr));
        } else { newValueMap.insert(std::make_pair(prm.first, prm.second)); }
    }
    if (valueMapChanged) {
        this->newExpr = new DESCAM::CompoundExpr(newValueMap, node.getDataType(),node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::ArrayExpr &node) {
    std::map<std::string, DESCAM::Expr *> newValueMap;
    bool valueMapChanged = false;
    for (auto prm : node.getValueMap()) {
        this->newExpr = nullptr;
        prm.second->accept(*this);
        if (this->newExpr) {
            valueMapChanged = true;
            newValueMap.insert(std::make_pair(prm.first, this->newExpr));
        } else { newValueMap.insert(std::make_pair(prm.first, prm.second)); }
    }
    if (valueMapChanged) {
        this->newExpr = new DESCAM::ArrayExpr(newValueMap, node.getDataType(),node.getStmtInfo());
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::ParamOperand &node) {
    this->newExpr = nullptr;
    if (!this->globalVariableMap.empty()) {
        if (this->globalVariableMap.find(node.getOperandName()) != this->globalVariableMap.end()) {
            auto var = this->globalVariableMap.at(node.getOperandName());
            if (var->isConstant()) {
                if (var->getInitialValue()) {
                    this->newExpr = var->getInitialValue();
                    return;
                }
            }
        } else {
            for (const auto& pair : this->globalVariableMap) {
                if (pair.second->isCompoundType() || pair.second->isArrayType()) {
                    for (auto subVar : pair.second->getSubVarList()) {
                        if (subVar->getName() == node.getOperandName()) {
                            if (subVar->isConstant()) {
                                if (subVar->getInitialValue()) {
                                    this->newExpr = subVar->getInitialValue();
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for (const auto &param : this->paramValMap) {
        if (node.getOperandName() == param.first) {
            this->newExpr = param.second;
            return;
        } else if (auto varOp = StmtCastVisitor<DESCAM::VariableOperand>(param.second).Get()) {
            auto var = varOp->getVariable();
            if (node.getParameter()->isSubVar() && (var->isCompoundType() || var->isArrayType())) {
                for (auto subVar : var->getSubVarList()) {
                    if (node.getParameter()->getName() == subVar->getName()) {
                        this->newExpr = new VariableOperand(subVar);
                        return;
                    }
                }
            }
        }
    }
}

void DESCAM::ParamValuePropagation::visit(DESCAM::Ternary &node) {
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

