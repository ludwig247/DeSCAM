//
// Created by M.I.Alkoudsi on 11.09.19.
//

#include "ExpressionSubstitution.h"

SCAM::ExpressionSubstitution::ExpressionSubstitution(SCAM::Stmt *stmt, SCAM::Expr *oldExpr, SCAM::Expr *newExpr) {
    this->oldExpr = oldExpr;
    this->newExpr = newExpr;
    this->oldStmt = stmt;
    this->newStmt = nullptr;
    this->propagatedExpr = nullptr;
    if (this->oldStmt) {
        stmt->accept(*this);
        if (*stmt == *this->newStmt) {
            std::cout << "oldExpr " <<  PrintStmt::toString(this->oldExpr) << std::endl;
            std::cout << "newExpr " <<  PrintStmt::toString(this->newExpr) << std::endl;
            std::cout << PrintStmt::toString(this->newStmt) << std::endl;
        //    throw std::runtime_error("substitutionError!, oldExpr was not found in stmt");
        }
    }
}

SCAM::ExpressionSubstitution::ExpressionSubstitution(SCAM::Expr *expr, SCAM::Expr *oldExpr, SCAM::Expr *newExpr) {
    this->oldExpr = oldExpr;
    this->newExpr = newExpr;
    this->oldStmt = nullptr;
    this->newStmt = nullptr;
    this->propagatedExpr = nullptr;
    if (expr) {
        expr->accept(*this);
        if (*expr == *this->propagatedExpr) {
            std::cout << "oldExpr " <<  PrintStmt::toString(this->oldExpr) << std::endl;
            std::cout << "newExpr " <<  PrintStmt::toString(this->newExpr) << std::endl;
            std::cout << PrintStmt::toString(this->propagatedExpr) << std::endl;
          //  throw std::runtime_error("substitutionError!, oldExpr was not found in stmt");
        }
    }
}


SCAM::Stmt *SCAM::ExpressionSubstitution::substituteExpr(SCAM::Stmt *stmt, SCAM::Expr *oldExpr, SCAM::Expr *newExpr) {
    ExpressionSubstitution expressionSubstitution(stmt, oldExpr, newExpr);
    return expressionSubstitution.newStmt;
}


SCAM::Expr *SCAM::ExpressionSubstitution::substituteExpr(SCAM::Expr *expr, SCAM::Expr *oldExpr, SCAM::Expr *newExpr) {
    SCAM::ExpressionSubstitution expressionSubstitution(expr, oldExpr, newExpr);
    return expressionSubstitution.propagatedExpr;
}


SCAM::Stmt *SCAM::ExpressionSubstitution::getNewStmt() const {
    return this->newStmt;
}

SCAM::Stmt *SCAM::ExpressionSubstitution::getModifiedExpr() const {
    return this->propagatedExpr;
}

void SCAM::ExpressionSubstitution::visit(SCAM::VariableOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct IntegerValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct UnsignedValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct BoolValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct EnumValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct CompoundValue &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct Assignment &node) {
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

void SCAM::ExpressionSubstitution::visit(struct UnaryExpr &node) {
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

void SCAM::ExpressionSubstitution::visit(struct If &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Read &node) {
    if (node.getVariableOperand() == this->oldExpr) {
        if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(this->newExpr)) {
            this->newStmt = new Read(node.getPort(), varOp, node.isNonBlockingAccess(), node.getStatusOperand());
        } else { throw std::runtime_error("Expected a variable operand!"); }
    } else {
        this->newStmt = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct Write &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Arithmetic &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Logical &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Relational &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Bitwise &node) {
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

void SCAM::ExpressionSubstitution::visit(struct Cast &node) {
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

void SCAM::ExpressionSubstitution::visit(SCAM::FunctionOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool paramMapChanged = false;
        std::map<std::string, SCAM::Expr *> newParamMap;
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

void SCAM::ExpressionSubstitution::visit(struct ArrayOperand &node) {
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

void SCAM::ExpressionSubstitution::visit(struct CompoundExpr &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool valueMapChanged = false;
        std::map<std::string, SCAM::Expr *> newValueMap;
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

void SCAM::ExpressionSubstitution::visit(struct ParamOperand &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        this->propagatedExpr = &node;
    }
}

void SCAM::ExpressionSubstitution::visit(struct Return &node) {
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

void SCAM::ExpressionSubstitution::visit(SCAM::ArrayExpr &node) {
    if (node == *this->oldExpr) {
        this->propagatedExpr = this->newExpr;
    } else {
        bool valueMapChanged = false;
        std::map<std::string, SCAM::Expr *> newValueMap;
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

void SCAM::ExpressionSubstitution::visit(SCAM::Ternary &node) {
    throw std::runtime_error("Compare operator and -Optimize is not allwoed together");

}


