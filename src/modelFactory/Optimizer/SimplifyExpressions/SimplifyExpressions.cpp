//
// Created by M.I.Alkoudsi on 05.08.19.
//

#include <Stmts/StmtCastVisitor.h>
#include "SimplifyExpressions.h"
#include "Optimizer/Debug.h"

DESCAM::SimplifyExpressions::SimplifyExpressions(std::map<int, DESCAM::CfgNode *> CFG, DESCAM::Module *module)
        : cfg_(std::move(
        CFG)), module_(module) {
#ifdef DEBUG_SIMPLIFY_EXPRESSIONS
    std::cout << std::endl << "********************** Simplify CFG Expressions ********************** " << std::endl;
#endif
    for (auto node : this->cfg_) {
        auto stmt = node.second->getStmt();
        if (stmt != nullptr) {
            this->new_stmt_ = nullptr;
            this->new_expr_ = nullptr;
            stmt->accept(*this);
            if (this->new_stmt_ != nullptr) {
                if (!(*this->new_stmt_ == *stmt)) {
#ifdef DEBUG_SIMPLIFY_EXPRESSIONS
                    std::cout << "Statement: " << DESCAM::PrintStmt::toString(stmt) << " is changed into "
                              << DESCAM::PrintStmt::toString(this->newStmt) << std::endl;
#endif
                    this->cfg_.at(node.first)->setStmt(this->new_stmt_);
                }
            }
        }
    }
#ifdef DEBUG_SIMPLIFY_EXPRESSIONS
    std::cout << "***************************************************************** " << std::endl;
#endif
}

DESCAM::SimplifyExpressions::SimplifyExpressions(
        std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> returnValueConditionList,
        DESCAM::Module *module) : return_value_condition_list_(std::move(returnValueConditionList)),
                                  module_(module), new_stmt_(nullptr) {
    std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> newReturnValueConditionList;
    for (const auto &pair : this->return_value_condition_list_) {
        std::vector<DESCAM::Expr *> simplifiedExpressions;
        for (auto expr : pair.second) {
            if (!expr) { continue; }
            this->new_expr_ = nullptr;
            translateExpression(expr);
            if (this->new_expr_) {
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
                std::cout << "Expression: " << DESCAM::PrintStmt::toString(expr) << " is changed into "
                          << DESCAM::PrintStmt::toString(this->newExpr) << std::endl;
#endif
                simplifiedExpressions.push_back(this->new_expr_);
            } else {
                this->new_expr_= nullptr;
                expr->accept(*this);
                if (this->new_expr_) {
                    simplifiedExpressions.push_back(this->new_expr_);
                }else {
                    simplifiedExpressions.push_back(expr);
                }
            }
        }
        if (!pair.first->getReturnValue()) { continue; }
        this->new_expr_ = nullptr;
        translateExpression(pair.first->getReturnValue());
        if (this->new_expr_) {
            auto newReturn = new Return(this->new_expr_, pair.first->getStmtInfo());
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
            std::cout << "Statement: " << DESCAM::PrintStmt::toString(pair.first) << " is changed into "
                      << DESCAM::PrintStmt::toString(newReturn) << std::endl;
#endif
            newReturnValueConditionList.emplace_back(newReturn, simplifiedExpressions);
        } else {
            this->new_expr_ = nullptr;
            pair.first->getReturnValue()->accept(*this);
            if(this->new_expr_){
                auto newReturn = new Return(this->new_expr_, pair.first->getStmtInfo());
                newReturnValueConditionList.emplace_back(newReturn, simplifiedExpressions);
            }else{
                newReturnValueConditionList.emplace_back(pair.first, simplifiedExpressions);
            }
        }
    }
    this->return_value_condition_list_ = newReturnValueConditionList;
}

const std::map<int, DESCAM::CfgNode *> &DESCAM::SimplifyExpressions::getCFG() const {
    return this->cfg_;
}

const std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> &
DESCAM::SimplifyExpressions::getReturnValueConditionList() const {
    return this->return_value_condition_list_;
}

void DESCAM::SimplifyExpressions::translateExpression(DESCAM::Expr *expr) {
    try {
        z3::context contxt;
        z3::params params(contxt);
        params.set("arith_lhs", false);
        params.set("eq2ineq", false);
        params.set("elim_and", false);
        params.set("elim_sign_ext", false);
        params.set("mul2concat", false);
        params.set("flat", true);
        params.set("algebraic_number_evaluator", false);
        DESCAM::ExprTranslator translator(&contxt);
        z3::expr z3Expr(contxt);
        z3Expr = translator.translate(expr);
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
        //        std::cout << "before simplification Expr is " << z3Expr << std::endl;
#endif
        z3Expr = z3Expr.simplify(params);
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
        //        std::cout << "after simplification Expr is " << z3Expr << std::endl;
#endif
        bool abort = DESCAM::GlobalUtilities::isAbortTranslation(z3Expr);
        if (abort) {
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
            //            std::cout << "translation aborted" << std::endl;
#endif
            this->new_expr_ = nullptr;
            return;
        }
        this->new_expr_ = translator.translate(z3Expr, module_);
        auto locationInfo = expr->getStmtInfo();
        this->new_expr_->setStmtInfo(locationInfo);
        if (translator.isAbort() || *expr == *this->new_expr_) {
            this->new_expr_ = nullptr;
            return;
        }
        if (PrintStmt::toString(this->new_expr_).find("*") != std::string::npos) { this->new_expr_ = nullptr; }
    }
    catch (z3::exception e) {
        this->new_expr_ = nullptr;
        return;
    }
    catch (std::runtime_error e) {
        this->new_expr_ = nullptr;
        return;
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Assignment &node) {
    if (StmtCastVisitor<DESCAM::VariableOperand>(node.getLhs()).Get()) {
      const auto rhs = node.getRhs();
      translateExpression(rhs);
      //FIXME Refactor..this still doesn't look like the straightforward solution
      if (this->new_expr_ && !((*this->new_expr_) == (*rhs))) {
        this->new_stmt_ = new DESCAM::Assignment(node.getLhs(), this->new_expr_, node.getStmtInfo());
      } else {
        rhs->accept(*this);
        if (this->new_expr_ && !((*this->new_expr_) == (*rhs)))
          this->new_stmt_ = new DESCAM::Assignment(node.getLhs(), this->new_expr_, node.getStmtInfo());
      }
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::If &node) {
    translateExpression(node.getConditionStmt());
    if (this->new_expr_) {
        assert(this->new_expr_->getDataType() == DataTypes::getDataType("bool"));
        this->new_stmt_ = new If(this->new_expr_);
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Write &node) {
    auto exprInsideWrite = node.getValue();
    translateExpression(exprInsideWrite);
  //FIXME Refactor..remove code duplication
    if (this->new_expr_ && !((*this->new_expr_) == (*exprInsideWrite))){
        this->new_stmt_ = new Write(node.getPort(), this->new_expr_, node.isNonBlockingAccess(), node.getStatusOperand());
        return;
    }
    node.getValue()->accept(*this);
    if (this->new_expr_ && !((*this->new_expr_) == (*exprInsideWrite))){
        this->new_stmt_ = new Write(node.getPort(), this->new_expr_, node.isNonBlockingAccess(), node.getStatusOperand());
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Arithmetic &node) {
    //TODO refactor: this code snippet is duplicated multiple times
    translateExpression(&node);
    if (this->new_expr_) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->new_expr_) lhs = this->new_expr_;
    this->new_expr_ = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->new_expr_) rhs = this->new_expr_;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->new_expr_ = new DESCAM::Arithmetic(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Logical &node) {
  //TODO refactor: this code snippet is duplicated multiple times
    translateExpression(&node);
    if (this->new_expr_) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->new_expr_) lhs = this->new_expr_;
    this->new_expr_ = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->new_expr_) rhs = this->new_expr_;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->new_expr_ = new DESCAM::Logical(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Relational &node) {
  //TODO refactor: this code snippet is duplicated multiple times
    translateExpression(&node);
    if (this->new_expr_) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->new_expr_) lhs = this->new_expr_;
    this->new_expr_ = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->new_expr_) rhs = this->new_expr_;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->new_expr_ = new DESCAM::Relational(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Bitwise &node) {
  //TODO refactor: this code snippet is duplicated multiple times
    translateExpression(&node);
    if (this->new_expr_) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->new_expr_) lhs = this->new_expr_;
    this->new_expr_ = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->new_expr_) rhs = this->new_expr_;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->new_expr_ = new DESCAM::Bitwise(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Ternary &node) {
    translateExpression(&node);
    if(this->new_expr_) return;
    this->new_expr_ = nullptr;
    auto condition = node.getCondition();
    auto trueExpr = node.getTrueExpr();
    auto falseExpr = node.getFalseExpr();
    node.getCondition()->accept(*this);
    if (this->new_expr_) condition = this->new_expr_;
    this->new_expr_ = nullptr;
    node.getTrueExpr()->accept(*this);
    if (this->new_expr_) trueExpr = this->new_expr_;
    this->new_expr_ = nullptr;
    node.getFalseExpr()->accept(*this);
    if (this->new_expr_) falseExpr = this->new_expr_;
    if (!(*condition == *node.getCondition()) || !(*trueExpr == *node.getTrueExpr()) ||
        !(*falseExpr == *node.getFalseExpr()))
        this->new_expr_ = new DESCAM::Ternary(condition, trueExpr, falseExpr, node.getStmtInfo());
}

