//
// Created by ludwig on 04.08.16.
//

#ifndef SCAM_ASSIGNMENTOPTIMIZER2_H
#define SCAM_ASSIGNMENTOPTIMIZER2_H

#include <vector>
#include <ExprTranslator.h>
#include "Behavior/Operation.h"
#include <GlobalUtilities.h>

namespace DESCAM {

/** \brief Optimize value of for assignment   
 *
 * Translate a datapath assignment e.g. x = x + 1 + 1 into result == ( x+1+1 )
 * Simplify this expr using tactic("simplify") into result == (x+2)
 * Now translate rhs(x+2) into a DESCAM::Stmt* and this is the new value for the assignment
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
    class AssignmentOptimizer2 {
    public:
        AssignmentOptimizer2(const std::vector<DESCAM::Assignment *> &assignmentsList, DESCAM::Module *module);
        AssignmentOptimizer2(const Operation * operation, DESCAM::Module *module);
        static DESCAM::Assignment * optimizeAssignment(DESCAM::Assignment * assignment, DESCAM::Module *module);

        virtual ~AssignmentOptimizer2() = default;

        std::vector<DESCAM::Assignment *> getNewAssignmentsList();

    private:
        z3::context context;
        ExprTranslator translator;
        DESCAM::Module *module;

        z3::expr lhsToExpr(DESCAM::Expr *expr, bool bitvector_flag);

        std::vector<DESCAM::Assignment *> newAssignmentsList;

        Assignment *applyTactics(DESCAM::Assignment *);

        Assignment *optimizeAssignment(Assignment *assignment);
    };

}
#endif //SCAM_ASSIGNMENTOPTIMIZER_H
