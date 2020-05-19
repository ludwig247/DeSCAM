//
// Created by M.I.Alkoudsi on 11.09.19.
//

#include "ExpressionSubstitution.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::ExpressionSubstitution::ExpressionSubstitution(DESCAM::Stmt *stmt, DESCAM::Expr *oldExpr, DESCAM::Expr *newExpr) {
    this->oldExpr = oldExpr;
    this->newExpr = newExpr;
    this->oldStmt = stmt;
    this->newStmt = nullptr;
    this->propagatedExpr = nullptr;
    if (this->oldStmt) {
        stmt->accept(*this);
        if (*stmt == *this->newStmt) {
//            std::cout << "oldExpr " << PrintStmt::toString(this->oldExpr) << std::endl;
//            std::cout << "newExpr " << PrintStmt::toString(this->newExpr) << std::endl;
//            std::cout << PrintStmt::toString(this->newStmt) << std::endl;
            //    TERMINATE("substitutionError!, oldExpr was not found in stmt");
        }
    }
}

DESCAM::ExpressionSubstitution::ExpressionSubstitution(DESCAM::Expr *expr, DESCAM::Expr *oldExpr, DESCAM::Expr *newExpr) {
    this->oldExpr = oldExpr;
    this->newExpr = newExpr;
    this->oldStmt = nullptr;
    this->newStmt = nullptr;
    this->propagatedExpr = nullptr;
    if (expr) {
        expr->accept(*this);
        if (*expr == *this->propagatedExpr) {
//            std::cout << "oldExpr " << PrintStmt::toString(this->oldExpr) << std::endl;
//            std::cout << "newExpr " << PrintStmt::toString(this->newExpr) << std::endl;
//            std::cout << PrintStmt::toString(this->propagatedExpr) << std::endl;
            //  TERMINATE("substitutionError!, oldExpr was not found in stmt");
        }
    }
}


DESCAM::Stmt *DESCAM::ExpressionSubstitution::substituteExpr(DESCAM::Stmt *stmt, DESCAM::Expr *oldExpr, DESCAM::Expr *newExpr) {
    ExpressionSubstitution expressionSubstitution(stmt, oldExpr, newExpr);
    return expressionSubstitution.newStmt;
}


DESCAM::Expr *DESCAM::ExpressionSubstitution::substituteExpr(DESCAM::Expr *expr, DESCAM::Expr *oldExpr, DESCAM::Expr *newExpr) {
    DESCAM::ExpressionSubstitution expressionSubstitution(expr, oldExpr, newExpr);
    return expressionSubstitution.propagatedExpr;
}


DESCAM::Stmt *DESCAM::ExpressionSubstitution::getNewStmt() const {
    return this->newStmt;
}

DESCAM::Stmt *DESCAM::ExpressionSubstitution::getModifiedExpr() const {
    return this->propagatedExpr;
}

void DESCAM::ExpressionSubstitution::visit(DESCAM::VariableOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct IntegerValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct UnsignedValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct BoolValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct EnumValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct CompoundValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Assignment &node) {
    auto lhs = node.getLhs();
    auto rhs = node.getRhs();
    if (*lhs == *this->oldExpr) {
        lhs = this->newExpr;
    }
    if (*rhs == *this->oldExpr) {
        rhs = this->newExpr;
        this->newStmt = new Assignment(lhs, rhs);
        return;
    } else {
        this->propagatedExpr = node.getRhs();
        node.getRhs()->accept(*this);
        if (*this->propagatedExpr == *node.getRhs()) {
            if (*lhs == *node.getLhs()) {
                this->newStmt = &node;
            } else {
                this->newStmt = new Assignment(lhs, node.getRhs());
            }
        } else {
            this->newStmt = new Assignment(lhs, this->propagatedExpr);
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct UnaryExpr &node) {
    auto exprInsideUnary = node.getExpr();
    if (*exprInsideUnary == *this->oldExpr) {
        this->propagatedExpr = new UnaryExpr(node.getOperation(), this->newExpr);
    } else {
        this->propagatedExpr = exprInsideUnary;
        exprInsideUnary->accept(*this);
        if (*this->propagatedExpr == *exprInsideUnary) {
            this->propagatedExpr = &node;
        } else {
            this->propagatedExpr = new UnaryExpr(node.getOperation(), this->propagatedExpr);
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct If &node) {
    auto expressionInsideIf = node.getConditionStmt();
    if (*expressionInsideIf == *this->oldExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr);
    } else {
        this->propagatedExpr = expressionInsideIf;
        expressionInsideIf->accept(*this);
        if (*this->propagatedExpr == *expressionInsideIf) {
            this->newStmt = &node;
        } else {
            assert(this->propagatedExpr->getDataType() == DataTypes::getDataType("bool"));
            this->newStmt = new If(this->propagatedExpr);
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Read &node) {
    if (node.getVariableOperand() == this->oldExpr) {
        if (auto varOp = dynamic_cast<DESCAM::VariableOperand *>(this->newExpr)) {
            this->newStmt = new Read(node.getPort(), varOp, node.isNonBlockingAccess(), node.getStatusOperand());
        } else { TERMINATE("Expected a variable operand!"); }
    } else {
        this->newStmt = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Write &node) {
    if (*node.getValue() == *this->oldExpr) {
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
    } else {
        this->propagatedExpr = node.getValue();
        node.getValue()->accept(*this);
        if (*this->propagatedExpr == *node.getValue()) {
            this->newStmt = &node;
        } else {
            this->newStmt = new Write(node.getPort(), this->propagatedExpr, node.isNonBlockingAccess(),
                                      node.getStatusOperand());
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Arithmetic &node) {
    auto lhs = node.getLhs();
    auto rhs = node.getRhs();
    if (*lhs == *this->oldExpr) {
        lhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getLhs();
        lhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getLhs())) {
            lhs = this->propagatedExpr;
        }
    }
    if (*rhs == *this->oldExpr) {
        rhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getRhs();
        rhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getRhs())) {
            rhs = this->propagatedExpr;
        }
    }
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getLhs()))) {
        this->propagatedExpr = new Arithmetic(lhs, node.getOperation(), rhs);
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Logical &node) {
    auto lhs = node.getLhs();
    auto rhs = node.getRhs();
    if (*lhs == *this->oldExpr) {
        lhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getLhs();
        lhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getLhs())) {
            lhs = this->propagatedExpr;
        }
    }
    if (*rhs == *this->oldExpr) {
        rhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getRhs();
        rhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getRhs())) {
            rhs = this->propagatedExpr;
        }
    }
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getLhs()))) {
        this->propagatedExpr = new Logical(lhs, node.getOperation(), rhs);
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Relational &node) {
    auto lhs = node.getLhs();
    auto rhs = node.getRhs();
    if (*lhs == *this->oldExpr) {
        lhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getLhs();
        lhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getLhs())) {
            lhs = this->propagatedExpr;
        }
    }
    if (*rhs == *this->oldExpr) {
        rhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getRhs();
        rhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getRhs())) {
            rhs = this->propagatedExpr;
        }
    }
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getLhs()))) {
        this->propagatedExpr = new Relational(lhs, node.getOperation(), rhs);
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Bitwise &node) {
    auto lhs = node.getLhs();
    auto rhs = node.getRhs();
    if (*lhs == *this->oldExpr) {
        lhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getLhs();
        lhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getLhs())) {
            lhs = this->propagatedExpr;
        }
    }
    if (*rhs == *this->oldExpr) {
        rhs = this->newExpr;
    } else {
        this->propagatedExpr = node.getRhs();
        rhs->accept(*this);
        if (!(*this->propagatedExpr == *node.getRhs())) {
            rhs = this->propagatedExpr;
        }
    }
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getLhs()))) {
        this->propagatedExpr = new Bitwise(lhs, node.getOperation(), rhs);
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Cast &node) {
    if (*node.getSubExpr() == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = node.getSubExpr();
        node.getSubExpr()->accept(*this);
        if (*this->propagatedExpr == *node.getSubExpr()) {
            this->propagatedExpr = &node;
        } else {
            this->propagatedExpr = new Cast(this->propagatedExpr, node.getDataType());
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(DESCAM::FunctionOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool paramMapChanged = false;
        std::map<std::string, DESCAM::Expr *> newParamMap;
        for (auto subVar: node.getParamValueMap()) {
            if (*subVar.second == *this->oldExpr) {
                paramMapChanged = true;
                newParamMap.insert(std::make_pair(subVar.first, this->newExpr));
            } else {
                this->propagatedExpr = subVar.second;
                subVar.second->accept(*this);
                if (*this->propagatedExpr == *subVar.second) {
                    newParamMap.insert(std::make_pair(subVar.first, subVar.second));
                } else {
                    paramMapChanged = true;
                    newParamMap.insert(std::make_pair(subVar.first, this->propagatedExpr));
                }
            }
        }
        if (paramMapChanged) {
            this->propagatedExpr = new FunctionOperand(node.getFunction(), newParamMap);
        } else {
            this->propagatedExpr = &node;
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct ArrayOperand &node) {
    if (*node.getIdx() == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = node.getIdx();
        node.getIdx()->accept(*this);
        if (*this->propagatedExpr == *node.getIdx()) {
            this->propagatedExpr = &node;
        } else {
            this->propagatedExpr = new ArrayOperand(node.getArrayOperand(), this->propagatedExpr);
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct CompoundExpr &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool valueMapChanged = false;
        std::map<std::string, DESCAM::Expr *> newValueMap;
        for (auto subVar: node.getValueMap()) {
            if (*subVar.second == *this->oldExpr) {
                valueMapChanged = true;
                newValueMap.insert(std::make_pair(subVar.first, this->newExpr));
            } else {
                this->propagatedExpr = subVar.second;
                subVar.second->accept(*this);
                if (*this->propagatedExpr == *subVar.second) {
                    newValueMap.insert(std::make_pair(subVar.first, subVar.second));
                } else {
                    valueMapChanged = true;
                    newValueMap.insert(std::make_pair(subVar.first, this->propagatedExpr));
                }
            }
        }
        if (valueMapChanged) {
            this->propagatedExpr = new CompoundExpr(newValueMap, node.getDataType());
        } else {
            this->propagatedExpr = &node;
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(struct ParamOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void DESCAM::ExpressionSubstitution::visit(struct Return &node) {
    if (*node.getReturnValue() == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = node.getReturnValue();
        node.getReturnValue()->accept(*this);
        if (*this->propagatedExpr == *node.getReturnValue()) {
            this->newStmt = &node;
        } else {
            this->newStmt = new Return(this->propagatedExpr);
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(DESCAM::ArrayExpr &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool valueMapChanged = false;
        std::map<std::string, DESCAM::Expr *> newValueMap;
        for (auto subVar: node.getValueMap()) {
            if (*subVar.second == *this->oldExpr) {
                valueMapChanged = true;
                newValueMap.insert(std::make_pair(subVar.first, this->newExpr));
            } else {
                this->propagatedExpr = subVar.second;
                subVar.second->accept(*this);
                if (*this->propagatedExpr == *subVar.second) {
                    newValueMap.insert(std::make_pair(subVar.first, subVar.second));
                } else {
                    valueMapChanged = true;
                    newValueMap.insert(std::make_pair(subVar.first, this->propagatedExpr));
                }
            }
        }
        if (valueMapChanged) {
            this->propagatedExpr = new ArrayExpr(newValueMap, node.getDataType());
        } else {
            this->propagatedExpr = &node;
        }
    }
}

void DESCAM::ExpressionSubstitution::visit(DESCAM::Ternary &node) {
    auto condition = node.getCondition();
    auto trueExpr = node.getTrueExpr();
    auto falseExpr = node.getFalseExpr();
    if (*condition == *this->oldExpr) {
        condition = this->newExpr;
    } else {
        this->propagatedExpr = condition;
        condition->accept(*this);
        if (!(*this->propagatedExpr == *condition)) {
            condition = this->propagatedExpr;
        }
    }
    if (*trueExpr == *this->oldExpr) {
        trueExpr = this->newExpr;
    } else {
        this->propagatedExpr = trueExpr;
        trueExpr->accept(*this);
        if (!(*this->propagatedExpr == *trueExpr)) {
            trueExpr = this->propagatedExpr;
        }
    }
    if (*falseExpr == *this->oldExpr) {
        falseExpr = this->newExpr;
    } else {
        this->propagatedExpr = falseExpr;
        falseExpr->accept(*this);
        if (!(*this->propagatedExpr == *falseExpr)) {
            falseExpr = this->propagatedExpr;
        }
    }
    if (!(*condition == *node.getCondition()) || !(*trueExpr == *node.getTrueExpr()) ||
        !(*falseExpr == *node.getFalseExpr()))
        this->newExpr = new DESCAM::Ternary(condition, trueExpr, falseExpr, node.getStmtInfo());
    else this->propagatedExpr = &node;
}


