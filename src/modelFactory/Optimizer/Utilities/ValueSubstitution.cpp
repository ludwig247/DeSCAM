//
// Created by M.I.Alkoudsi on 7.7.19.
//

#include <PrintStmt.h>
#include "ValueSubstitution.h"
#include "NodePeekVisitor.h"

SCAM::ValueSubstitution::ValueSubstitution() : oldExpr(nullptr), newExpr(nullptr), varVal(nullptr), oldStmt(nullptr),
                                               newStmt(nullptr) {

}

SCAM::Expr *
SCAM::ValueSubstitution::substituteExpr(SCAM::Expr *oldExpr, std::string varName, SCAM::Expr *varVal) {
    this->newExpr = nullptr;
    this->oldExpr = oldExpr;
    this->varName = varName;
    this->varVal = varVal;

    if (this->oldExpr != nullptr) {
        this->oldExpr->accept(*this);
        if (this->newExpr != nullptr) {
            return newExpr;
        }
    }
    return nullptr;
}

SCAM::Stmt *
SCAM::ValueSubstitution::substituteStmt(SCAM::Stmt *oldStmt, std::string varName, SCAM::Expr *varVal) {
    this->newStmt = nullptr;
    this->oldStmt = oldStmt;
    this->varName = varName;
    this->varVal = varVal;

    if (this->oldStmt != nullptr) {
        this->oldStmt->accept(*this);
        if (this->newStmt != nullptr) {
            return newStmt;
        }
    }
    return nullptr;
}

void SCAM::ValueSubstitution::visit(struct VariableOperand &node) {
    if (node.getVariable()->getFullName() == this->varName) {
        this->newExpr = this->varVal;
    }
}

void SCAM::ValueSubstitution::visit(struct Assignment &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }

    //Create new stmt
    this->newStmt = new SCAM::Assignment(lhs, rhs,node.getStmtInfo());
}

void SCAM::ValueSubstitution::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
    if (this->newExpr != nullptr) {
        if (node.getOperation() == "not") {
            this->newExpr = new UnaryExpr("not", this->newExpr,node.getStmtInfo());
        }else if (node.getOperation() == "~") {
            this->newExpr = new UnaryExpr("~", this->newExpr,node.getStmtInfo());
        } else if (node.getOperation() == "-") {
            if (node.getExpr()->getDataType()->isUnsigned()) {
                this->newExpr = new Arithmetic(this->newExpr, "*", new UnsignedValue(-1),node.getStmtInfo());
            } else {
                this->newExpr = new Arithmetic(this->newExpr, "*", new IntegerValue(-1),node.getStmtInfo());
            }
        } else throw std::runtime_error("Unknown unary operator " + node.getOperation());
    }
}

void SCAM::ValueSubstitution::visit(struct While &node) {
    node.getConditionStmt()->accept(*this);
    if (this->newExpr != nullptr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new While(this->newExpr,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
    if (this->newExpr != nullptr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct Write &node) {
    node.getValue()->accept(*this);
    if (this->newExpr != nullptr) {
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand(),node.getStmtInfo());
    }
}


void SCAM::ValueSubstitution::visit(struct Arithmetic &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }
    if (!(*rhs == *node.getRhs()) || !(*lhs == *node.getLhs())) {
        //Create new stmt
        this->newExpr = new SCAM::Arithmetic(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct Logical &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }
    if (!(*rhs == *node.getRhs()) || !(*lhs == *node.getLhs())) {
        //Create new stmt
        this->newExpr = new SCAM::Logical(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct Relational &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }
    if (!(*rhs == *node.getRhs()) || !(*lhs == *node.getLhs())) {
        //Create new stmt
        this->newExpr = new SCAM::Relational(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct Bitwise &node) {
    //LHS
    this->newExpr = nullptr;
    Expr *lhs = node.getLhs();
    node.getLhs()->accept(*this);
    if (this->newExpr != nullptr) { lhs = this->newExpr; }
    this->newExpr = nullptr;

    //RHS
    Expr *rhs = node.getRhs();
    node.getRhs()->accept(*this);
    if (this->newExpr != nullptr) { rhs = this->newExpr; }
    if (!(*rhs == *node.getRhs()) || !(*lhs == *node.getLhs())) {
        //Create new stmt
        this->newExpr = new SCAM::Bitwise(lhs, node.getOperation(), rhs,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    if (this->newExpr != nullptr) {
        this->newExpr = new Cast(this->newExpr, node.getDataType(),node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct FunctionOperand &node) {
    std::map<std::string, SCAM::Expr *> newParamValueMap;
    for (auto param : node.getParamValueMap()) {
        if (auto varOp = SCAM::NodePeekVisitor::nodePeekVariableOperand(param.second)) {
            varOp->accept(*this);
            if (this->newExpr != nullptr) {
                newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
                this->newExpr = nullptr;
            } else { newParamValueMap.insert(std::make_pair(param.first, param.second)); }
        } else if (auto funOp = SCAM::NodePeekVisitor::nodePeekFunctionOperand(param.second)) {
            funOp->accept(*this);
            if (this->newExpr != nullptr) {
                newParamValueMap.insert(std::make_pair(param.first, this->newExpr));
                this->newExpr = nullptr;
            } else { newParamValueMap.insert(std::make_pair(param.first, param.second)); }

        } else {
            newParamValueMap.insert(std::make_pair(param.first, param.second));
        }
    }
    if (newParamValueMap != node.getParamValueMap()) {
        this->newExpr = new SCAM::FunctionOperand(node.getFunction(), newParamValueMap,node.getStmtInfo());
        this->newStmt = this->newExpr;
    }
}

void SCAM::ValueSubstitution::visit(struct ArrayOperand &node) {
    node.getIdx()->accept(*this);
    if (!(*node.getIdx() == *this->newExpr)) {
        this->newExpr = new ArrayOperand(node.getArrayOperand(), this->newExpr,node.getStmtInfo());
    } else this->newExpr = &node;
}

void SCAM::ValueSubstitution::visit(struct CompoundExpr &node) {
    std::map<std::string, SCAM::Expr *> newValMap;
    for (auto val : node.getValueMap()) {
        this->newExpr = nullptr;
        val.second->accept(*this);
        if (this->newExpr != nullptr) {
            newValMap.insert(std::make_pair(val.first, this->newExpr));
        } else { newValMap.insert(val); }
    }
    if (newValMap != node.getValueMap()) {
        this->newExpr = new SCAM::CompoundExpr(newValMap, node.getDataType(),node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(struct ParamOperand &node) {
    if (node.getOperandName() == this->varName) {
        this->newExpr = this->varVal;
    }
}

void SCAM::ValueSubstitution::visit(struct Return &node) {
    node.getReturnValue()->accept(*this);
    if (newExpr != nullptr) {
        this->newStmt = new Return(this->newExpr,node.getStmtInfo());
    }
}

void SCAM::ValueSubstitution::visit(SCAM::ArrayExpr &node) {
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
        this->newExpr = new SCAM::ArrayExpr(newValMap, node.getDataType(),node.getStmtInfo());
    }else{
        this->newExpr = nullptr;
    }
}

void SCAM::ValueSubstitution::visit(SCAM::Ternary &node) {
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
        this->newExpr = new SCAM::Ternary(condition, trueExpr, falseExpr, node.getStmtInfo());
}




