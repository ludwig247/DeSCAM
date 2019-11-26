//
// Created by M.I.Alkoudsi on 05.08.19.
//

#include "SimplifyExpressions.h"
#include "Optimizer/Debug.h"

SCAM::SimplifyExpressions::SimplifyExpressions(std::map<int, SCAM::CfgNode *> CFG, SCAM::Module *module)
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
                    std::cout << "Statement: " << SCAM::PrintStmt::toString(stmt) << " is changed into "
                              << SCAM::PrintStmt::toString(this->newStmt) << std::endl;
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

SCAM::SimplifyExpressions::SimplifyExpressions(
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList,
        SCAM::Module *module) : returnValueConditionList(std::move(returnValueConditionList)),
                                module(module), newStmt(nullptr) {
    std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> newReturnValueConditionList;
    for (const auto &pair : this->returnValueConditionList) {
        std::vector<SCAM::Expr *> simplifiedExpressions;
        for (auto expr : pair.second) {
            if (!expr) { continue; }
            this->newExpr = nullptr;
            translateExpression(expr);
            if (this->newExpr) {
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
                std::cout << "Expression: " << SCAM::PrintStmt::toString(expr) << " is changed into "
                          << SCAM::PrintStmt::toString(this->newExpr) << std::endl;
#endif
                simplifiedExpressions.push_back(this->newExpr);
            } else {
                simplifiedExpressions.push_back(expr);
            }
        }
        if (!pair.first->getReturnValue()) { continue; }
        this->newExpr = nullptr;
        translateExpression(pair.first->getReturnValue());
        if (this->newExpr) {
            auto newReturn = new Return(this->newExpr);
#ifdef DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS
            std::cout << "Statement: " << SCAM::PrintStmt::toString(pair.first) << " is changed into "
                      << SCAM::PrintStmt::toString(newReturn) << std::endl;
#endif
            newReturnValueConditionList.emplace_back(newReturn, simplifiedExpressions);
        } else {
            newReturnValueConditionList.emplace_back(pair.first, simplifiedExpressions);
        }
    }
    this->returnValueConditionList = newReturnValueConditionList;
}

const std::map<int, SCAM::CfgNode *> &SCAM::SimplifyExpressions::getCFG() const {
    return this->CFG;
}

const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &
SCAM::SimplifyExpressions::getReturnValueConditionList() const {
    return this->returnValueConditionList;
}

void SCAM::SimplifyExpressions::translateExpression(SCAM::Expr *expr) {
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
        SCAM::ExprTranslator translator(&contxt);
        z3::expr z3Expr(contxt);
        z3Expr = translator.translate(expr);
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
//        std::cout << "before simplification Expr is " << z3Expr << std::endl;
#endif
        z3Expr = z3Expr.simplify(params);
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
//        std::cout << "after simplification Expr is " << z3Expr << std::endl;
#endif
        bool abort = SCAM::OptUtilities::isAbortTranslation(z3Expr);
        if (abort) {
#if defined(DEBUG_SIMPLIFY_EXPRESSIONS) || defined(DEBUG_FUNCTIONS_SIMPLIFY_EXPRESSIONS)
//            std::cout << "translation aborted" << std::endl;
#endif
            return;
        }
        this->newExpr = translator.translate(z3Expr, module);
        if (translator.isAbort() || *expr == *this->newExpr) {
            this->newExpr = nullptr;
            return;
        }
        if(PrintStmt::toString(this->newExpr).find("*")!=std::string::npos){this->newExpr = nullptr;}
    }
    catch (z3::exception e) {
        std::cout << "Translation warning for: " << PrintStmt::toString(expr) << std::endl;
        std::cout << "\t ->" << e << std::endl;
        this->newExpr = nullptr;
        return;
    }
    catch (std::runtime_error e){
        this->newExpr = nullptr;
        return;
    }
}

void SCAM::SimplifyExpressions::visit(SCAM::Assignment &node) {
    if (!dynamic_cast<SCAM::VariableOperand *>(node.getLhs())) { return; }
    translateExpression(node.getRhs());
    if (this->newExpr) {
        this->newStmt = new SCAM::Assignment(node.getLhs(), this->newExpr);
    }
}

void SCAM::SimplifyExpressions::visit(SCAM::If &node) {
    translateExpression(node.getConditionStmt());
    if (this->newExpr) {
        assert(this->newExpr->getDataType() == DataTypes::getDataType("bool"));
        this->newStmt = new If(this->newExpr);
    }
}

void SCAM::SimplifyExpressions::visit(SCAM::Write &node) {
    translateExpression(node.getValue());
    if (this->newExpr) {
        this->newStmt = new Write(node.getPort(), this->newExpr, node.isNonBlockingAccess(), node.getStatusOperand());
    }
}

