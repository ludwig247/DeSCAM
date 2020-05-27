//
// Created by tobias on 13.07.16.
//

#ifndef SCAM_CONDITIONOPTIMIZER2_H
#define SCAM_CONDITIONOPTIMIZER2_H

#include <ExprTranslator.h>
#include <vector>
#include "Behavior/Operation.h"
#include "FatalError.h"
#include "Logger/Logger.h"


namespace DESCAM{
    /*!
     * \brief Class that optimizes conditions of paths
     *
     * Each path has a set of conditions, the goal is simplify them as much as possible
     * This is achieved by translating each condition to a z3::expr,
     * use the supplied solvers and translate the simplified z3::expr back to a DESCAM::Stmt
     *
     * ------------------------------------------------------
     * STEP 1: DESCAM::Stmt to z3::expr
     * ------------------------------------------------------
     * Z3Interface implements a visitor for the StmtAbstractVisitor which allows a translation of DESCAM::Stmt to z3::exprs
     * Afterwards the expr is simplified using the z3 simplify tactics
     *  -----------------------------------------------------
     * STEP 2: z3::expr to DESCAM::Stmt
     * ------------------------------------------------------
     * Translating the expr to a DESCAM::Stmt is done by  the method exprToStmt
     * That method is a recursive method and necessary because of the lack of a visitor pattern for the exprs.
     *
     */

    class ConditionOptimizer2{
    public:
        ConditionOptimizer2(const std::vector<DESCAM::Expr *> &conditionList, DESCAM::Module *module);
        virtual ~ConditionOptimizer2() = default;

        std::vector<DESCAM::Expr*> getNewConditionList();
    private:
        ConditionOptimizer2();
        DESCAM::Module * module;
        z3::context  context;
        z3::goal goal;
        DESCAM::ExprTranslator translator;

        std::vector<DESCAM::Expr*> newConditionList;

        void applyTactics();

        z3::apply_result runTacticWithEq2Ineq();
        z3::apply_result runTacticWithOutEq2Ineq();
    };
}


#endif //SCAM_CONDITIONOPTIMIZER2_H
