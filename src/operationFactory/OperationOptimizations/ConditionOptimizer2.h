//
// Created by tobias on 13.07.16.
//

#ifndef SCAM_CONDITIONOPTIMIZER2_H
#define SCAM_CONDITIONOPTIMIZER2_H

#include <ExprTranslator.h>
#include <vector>
#include "Behavior/Operation.h"

namespace SCAM{
    /*!
     * \brief Class that optimizes conditions of paths
     *
     * Each path has a set of conditions, the goal is simplify them as much as possible
     * This is achieved by translating each condition to a z3::expr,
     * use the supplied solvers and translate the simplified z3::expr back to a SCAM::Stmt
     *
     * ------------------------------------------------------
     * STEP 1: SCAM::Stmt to z3::expr
     * ------------------------------------------------------
     * Z3Interface implements a visitor for the StmtAbstractVisitor which allows a translation of SCAM::Stmt to z3::exprs
     * Afterwards the expr is simplified using the z3 simplify tactics
     *  -----------------------------------------------------
     * STEP 2: z3::expr to SCAM::Stmt
     * ------------------------------------------------------
     * Translating the expr to a SCAM::Stmt is done by  the method exprToStmt
     * That method is a recursive method and necessary because of the lack of a visitor pattern for the exprs.
     *
     */

    class ConditionOptimizer2{
    public:
        ConditionOptimizer2(const std::vector<SCAM::Expr *> &conditionList, SCAM::Module *module);
        virtual ~ConditionOptimizer2() = default;

        std::vector<SCAM::Expr*> getNewConditionList();
    private:
        ConditionOptimizer2();
        SCAM::Module * module;
        z3::context  context;
        z3::goal goal;
        SCAM::ExprTranslator translator;

        std::vector<SCAM::Expr*> newConditionList;

        void applyTactics();

        z3::apply_result runTacticWithEq2Ineq();
        z3::apply_result runTacticWithOutEq2Ineq();
    };
}


#endif //SCAM_CONDITIONOPTIMIZER2_H
