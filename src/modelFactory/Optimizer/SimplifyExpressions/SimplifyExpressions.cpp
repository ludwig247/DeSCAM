//
// Created by M.I.Alkoudsi on 05.08.19.
//

#include "SimplifyExpressions.h"
#include "Optimizer/Debug.h"

DESCAM::SimplifyExpressions::SimplifyExpressions(std::map<int, DESCAM::CfgNode *> CFG, DESCAM::Module *module)
        : CFG(std::move(
        CFG)), module(module) {
#ifdef DEBUG_SIMPLIFY_EXPRESSIONS
    std::cout << std::endl << "********************** Simplify CFG Expressions ********************** " << std::endl;
#endif
    for (auto node : this->CFG) {
        auto stmt = node.second->getStmt();
        if (stmt != nullptr) {
            this->newStmt = nullptr;
            this->newExpr = nullptr;
            stmt->accept(*this);
            if (this->newStmt != nullptr) {
                if (!(*this->newStmt == *stmt)) {
#ifdef DEBUG_SIMPLIFY_EXPRESSIONS
                    std::cout << "Statement: " << DESCAM::PrintStmt::toString(stmt) << " is changed into "
                              << DESCAM::PrintStmt::toString(this->newStmt) << std::endl;
#endif
                    this->CFG.at(node.first)->setStmt(this->newStmt);
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
        DESCAM::Module *module) : returnValueConditionList(std::move(returnValueConditionList)),
                                module(module), newStmt(nullptr) {
    std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> newReturnValueConditionList;
    for (const auto &pair : this->returnValueConditionList) {
        std::vector<DESCAM::Expr *> simplifiedExpressions;
        for (auto expr : pair.second) {
            if (!expr) { continue; }
            this->newExpr = nullptr;
            translateExpression(expr);
            if (this->newExpr) {
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
                std::cout << "Expression: " << DESCAM::PrintStmt::toString(expr) << " is changed into "
                          << DESCAM::PrintStmt::toString(this->newExpr) << std::endl;
#endif
                simplifiedExpressions.push_back(this->newExpr);
            } else {
                this->newExpr= nullptr;
                expr->accept(*this);
                if (this->newExpr) {
                    simplifiedExpressions.push_back(this->newExpr);
                }else {
                    simplifiedExpressions.push_back(expr);
                }
            }
        }
        if (!pair.first->getReturnValue()) { continue; }
        this->newExpr = nullptr;
        translateExpression(pair.first->getReturnValue());
        if (this->newExpr) {
            auto newReturn = new Return(this->newExpr,pair.first->getStmtInfo());
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
            std::cout << "Statement: " << DESCAM::PrintStmt::toString(pair.first) << " is changed into "
                      << DESCAM::PrintStmt::toString(newReturn) << std::endl;
#endif
            newReturnValueConditionList.emplace_back(newReturn, simplifiedExpressions);
        } else {
            this->newExpr = nullptr;
            pair.first->getReturnValue()->accept(*this);
            if(this->newExpr){
                auto newReturn = new Return(this->newExpr,pair.first->getStmtInfo());
                newReturnValueConditionList.emplace_back(newReturn, simplifiedExpressions);
            }else{
                newReturnValueConditionList.emplace_back(pair.first, simplifiedExpressions);
            }
        }
    }
    this->returnValueConditionList = newReturnValueConditionList;
}

const std::map<int, DESCAM::CfgNode *> &DESCAM::SimplifyExpressions::getCFG() const {
    return this->CFG;
}

const std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> &
DESCAM::SimplifyExpressions::getReturnValueConditionList() const {
    return this->returnValueConditionList;
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
            this->newExpr = nullptr;
            return;
        }
        this->newExpr = translator.translate(z3Expr, module);
        auto locationInfo = expr->getStmtInfo();
        this->newExpr->setStmtInfo(locationInfo);
        if (translator.isAbort() || *expr == *this->newExpr) {
            this->newExpr = nullptr;
            return;
        }
        if (PrintStmt::toString(this->newExpr).find("*") != std::string::npos) { this->newExpr = nullptr; }
    }
    catch (z3::exception e) {
        this->newExpr = nullptr;
        return;
    }
    catch (std::runtime_error e) {
        this->newExpr = nullptr;
        return;
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Assignment &node) {
    if (!dynamic_cast<DESCAM::VariableOperand *>(node.getLhs())) return;
    auto rhs = node.getRhs();
    translateExpression(rhs);
    if (this->newExpr && !((*this->newExpr) == (*rhs))){
        this->newStmt = new DESCAM::Assignment(node.getLhs(), this->newExpr,node.getStmtInfo());
        return;}
    rhs->accept(*this);
    if (this->newExpr && !((*this->newExpr) == (*rhs)))
        this->newStmt = new DESCAM::Assignment(node.getLhs(), this->newExpr,node.getStmtInfo());
}

void DESCAM::SimplifyExpressions::visit(DESCAM::If &node) {
    translateExpression(node.getConditionStmt());
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr);
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Write &node) {
    auto exprInsideWrite = node.getValue();
    translateExpression(exprInsideWrite);
    if (this->newExpr && !((*this->newExpr) == (*exprInsideWrite))){
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
        return;
    }
    node.getValue()->accept(*this);
    if (this->newExpr && !((*this->newExpr) == (*exprInsideWrite))){
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
    }
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Arithmetic &node) {
    translateExpression(&node);
    if (this->newExpr) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->newExpr) lhs = this->newExpr;
    this->newExpr = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->newExpr) rhs = this->newExpr;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->newExpr = new DESCAM::Arithmetic(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Logical &node) {
    translateExpression(&node);
    if (this->newExpr) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->newExpr) lhs = this->newExpr;
    this->newExpr = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->newExpr) rhs = this->newExpr;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->newExpr = new DESCAM::Logical(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Relational &node) {
    translateExpression(&node);
    if (this->newExpr) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->newExpr) lhs = this->newExpr;
    this->newExpr = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->newExpr) rhs = this->newExpr;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->newExpr = new DESCAM::Relational(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Bitwise &node) {
    translateExpression(&node);
    if (this->newExpr) return;
    auto lhs = node.getLhs();
    lhs->accept(*this);
    if (this->newExpr) lhs = this->newExpr;
    this->newExpr = nullptr;
    auto rhs = node.getRhs();
    rhs->accept(*this);
    if (this->newExpr) rhs = this->newExpr;
    if ((!(*lhs == *node.getLhs())) || (!(*rhs == *node.getRhs())))
        this->newExpr = new DESCAM::Bitwise(lhs, node.getOperation(), rhs);
}

void DESCAM::SimplifyExpressions::visit(DESCAM::Ternary &node) {
    translateExpression(&node);
    if(this->newExpr) return;
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

