//
// Created by tobias on 01.04.20.
//

#include <OperationOptimizations/TernaryOptimizer.h>
#include <CreatePropertySuite.h>
#include <thread>
#include "../parser/CommandLineParameter.h"
#include "CreateOperationsSlave.h"
#include "PropertySuite.h"
#include "OperationOptimizations/OptimizeOperations2.h"
#include "OperationOptimizations/AssignmentOptimizer2.h"
#include "OperationOptimizations/ConditionOptimizer2.h"
#include "ValidOperations.h"
#include "ReconstructOperations.h"
#include "CreateOperations.h"
#include "FindOperations.h"
#include <PrintITL/DatapathVisitor.h>
#include <PrintITL/ConditionVisitor.h>
#include <PrintStmt.h>
#include <OperationFactory.h>
#include "TernaryOptimizer.h"

SCAM::TernaryOptimizer::TernaryOptimizer(SCAM::Stmt *stmt, SCAM::Module *module) :
        module(module) {
    stmt->accept(*this);
}


void SCAM::TernaryOptimizer::visit(struct VariableOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct IntegerValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct UnsignedValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct BoolValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct EnumValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::CompoundValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct PortOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if ((*node.getRhs() == *rhs) && (*node.getLhs() == *lhs)) {
        this->stmt = &node;
    } else {
        this->stmt = new Assignment(lhs, rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
    auto unaryExpr = this->expr;

    if ((*node.getExpr() == *unaryExpr)) {
        this->expr = &node;
    } else if (isTrue(unaryExpr) || isFalse(unaryExpr)) {
        SCAM::ConditionOptimizer2 conditionOptimizer2({new UnaryExpr(node.getOperation(), unaryExpr)}, this->module);
        if (conditionOptimizer2.getNewConditionList().empty()) {
            this->expr = new BoolValue(true);
        } else if (conditionOptimizer2.getNewConditionList().size() == 1) this->expr = conditionOptimizer2.getNewConditionList().back();
        else this->expr = new UnaryExpr(node.getOperation(), unaryExpr);

    } else {
        this->expr = new UnaryExpr(node.getOperation(), unaryExpr);
    }
}

void SCAM::TernaryOptimizer::visit(struct While &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct If &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct SectionOperand &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct SectionValue &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct ITE &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct Branch &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct Arithmetic &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if ((*node.getRhs() == *rhs) && (*node.getLhs() == *lhs)) {
        this->expr = &node;
    } else {
        this->expr = new Arithmetic(lhs, node.getOperation(), rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    if ((*node.getRhs() == *rhs) && (*node.getLhs() == *lhs)) {
        this->expr = &node;
    } else {
        this->expr = new Logical(lhs, node.getOperation(), rhs);
    }
    SCAM::ConditionOptimizer2 conditionOptimizer2({this->expr}, this->module);
    if (conditionOptimizer2.getNewConditionList().empty()) {
        this->expr = new BoolValue(true);
    } else if (conditionOptimizer2.getNewConditionList().size() == 1) {
        this->expr = conditionOptimizer2.getNewConditionList().back();
    } else {
        auto ele1 = conditionOptimizer2.getNewConditionList().at(0);
        auto ele2 = conditionOptimizer2.getNewConditionList().at(1);
        this->expr = new Logical(ele1, "and", ele2);
        for (int i = 2; i < conditionOptimizer2.getNewConditionList().size(); i++) {
            auto element = conditionOptimizer2.getNewConditionList().at(i);
            this->expr = new Logical(this->expr, "and", element);
        }
    }
}

bool SCAM::TernaryOptimizer::isTrue(SCAM::Expr *expr) const {
    return *expr == SCAM::BoolValue(true);
}

bool SCAM::TernaryOptimizer::isFalse(SCAM::Expr *expr) const {
    return *expr == SCAM::BoolValue(false);
}

void SCAM::TernaryOptimizer::visit(struct Relational &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if ((*node.getRhs() == *rhs) && (*node.getLhs() == *lhs)) {
        this->expr = &node;
    } else {
        this->expr = new Relational(lhs, node.getOperation(), rhs);
    }
}


void SCAM::TernaryOptimizer::visit(struct Bitwise &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if ((*node.getRhs() == *rhs) && (*node.getLhs() == *lhs)) {
        this->expr = &node;
    } else {
        this->expr = new Bitwise(lhs, node.getOperation(), rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    auto unaryExpr = this->expr;

    if ((*node.getSubExpr() == *unaryExpr)) {
        this->expr = &node;
    } else {
        this->expr = new Cast(unaryExpr, node.getDataType());
    }
}

void SCAM::TernaryOptimizer::visit(SCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    auto idx = this->expr;

    if ((*node.getIdx() == *idx)) {
        this->expr = &node;
    } else {
        this->expr = new ArrayOperand(node.getArrayOperand(), idx);
    }
}


void SCAM::TernaryOptimizer::visit(struct Read &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(SCAM::Wait &node) {
    TERMINATE("not implemented");
}

void SCAM::TernaryOptimizer::visit(SCAM::Peek &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct Write &node) {
    TERMINATE("not implemented");
}

SCAM::Stmt *SCAM::TernaryOptimizer::getStmt() const {
    return stmt;
}

void SCAM::TernaryOptimizer::visit(struct SyncSignal &node) {
    if (isTrivialTrue(assumptionList, &node)) {
        this->expr = new BoolValue(true);
    } else if (isTrivialFalse(assumptionList, &node)) {
        this->expr = new BoolValue(false);
    } else this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct DataSignalOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::FunctionOperand &node) {
    std::map<std::string, SCAM::Expr *> newParamMap;
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
        newParamMap.insert(std::make_pair(param.first, this->expr));
    }
    node.setParamValueMap(newParamMap);
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::ArrayExpr &node) {
    //TODO
    std::cout << "-W- " << node << " not optmized" << std::endl;
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::CompoundExpr &node) {
    std::cout << "-W- " << node << " not optmized" << std::endl;
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::ParamOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::Return &node) {
    std::cout << "-W- " << node << " not optmized" << std::endl;
    node.getReturnValue()->accept(*this);
    this->stmt = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::Notify &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct TimePointOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::Ternary &node) {
    node.getTrueExpr()->accept(*this);
    auto trueExpr = this->expr;
    node.getFalseExpr()->accept(*this);
    auto falseExpr = this->expr;
    node.getCondition()->accept(*this);
    auto condExpr = this->expr;


    if (*condExpr == BoolValue(true)) {
        this->expr = trueExpr;
    } else if (*condExpr == BoolValue(false)) {
        this->expr = falseExpr;
    } else if (*trueExpr == *falseExpr || *node.getTrueExpr() == *node.getFalseExpr() || *trueExpr == *node.getFalseExpr() || *falseExpr == *node.getTrueExpr()) {
        this->expr = trueExpr;
    } else {
        if (*node.getTrueExpr() == *trueExpr && *node.getFalseExpr() == *falseExpr && *node.getCondition() == *condExpr) {
            this->expr = &node;
        } else {
            this->expr = new Ternary(condExpr, trueExpr, falseExpr);
        }
    }
}

SCAM::Expr *SCAM::TernaryOptimizer::getExpr() const {
    return expr;
}

SCAM::TernaryOptimizer::TernaryOptimizer(SCAM::Stmt *stmt, std::vector<Expr *> assumptionList, Module *module) :
        module(module),
        assumptionList(assumptionList) {
    stmt->accept(*this);
}

/***
 *  Idea: check for satisfiability of not(assumptions_of_operation -> assumption_of_ternary)
    If no model exist, the the condition of ternary is always true (IPC idea)
 * @param assumptionList
 * @param expr
 * @return returns if a statement is true or not
 */
bool SCAM::TernaryOptimizer::isTrivialTrue(const std::vector<Expr *> &assumptionList, Expr *expr) {
    z3::context context;
    z3::solver solver(context);
    ExprTranslator translator(&context);

    z3::expr z3_expr(context);
    z3_expr = context.bool_val(true);
    for (auto condition: assumptionList) {
        z3_expr = z3_expr && translator.translate(condition);
    }
    z3_expr = !z3_expr || translator.translate(expr);
    solver.add(!z3_expr);

    // Check for SAT if unsat -> erase path
    if ((solver.check() == z3::unsat)) {
        return true;
    }
    return false;
}

bool SCAM::TernaryOptimizer::isTrivialFalse(const std::vector<Expr *> &assumptionList, Expr *expr) {
    z3::context context;
    z3::solver solver(context);
    ExprTranslator translator(&context);
    //Idea: check for satisfiability of assumptions_of_operation & assumption_of_ternary
    //If unsat -> always false
    //Translate each expression with the ExprtTranslator and add to solver
    for (auto condition: assumptionList) {
        solver.add(translator.translate(condition));
    }
    solver.add(translator.translate(expr));
    // Check for SAT if unsat -> erase path
    if ((solver.check() == z3::unsat)) {
        //expr->setTrivialFalse();
        return true;
    }
    return false;
}


