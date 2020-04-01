//
// Created by ludwig on 04.08.16.
//

#ifndef SCAM_ASSIGNMENTOPTIMIZER2_H
#define SCAM_ASSIGNMENTOPTIMIZER2_H

#include <vector>
#include <ExprTranslator.h>
#include "Behavior/Operation.h"
#include <GlobalUtilities.h>

namespace SCAM {

/** \brief Optimize value of for assignment   
 *
 * Translate a datapath assignment e.g. x = x + 1 + 1 into result == ( x+1+1 )
 * Simplify this expr using tactic("simplify") into result == (x+2)
 * Now translate rhs(x+2) into a SCAM::Stmt* and this is the new value for the assignment
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
    class AssignmentOptimizer2 {
    public:
        AssignmentOptimizer2(const std::vector<SCAM::Assignment *> &assignmentsList, SCAM::Module *module);
        AssignmentOptimizer2(const Operation * operation, SCAM::Module *module);
        static SCAM::Assignment * optimizeAssignment(SCAM::Assignment * assignment, SCAM::Module *module);

        virtual ~AssignmentOptimizer2() = default;

        std::vector<SCAM::Assignment *> getNewAssignmentsList();

    private:
        z3::context context;
        ExprTranslator translator;
        SCAM::Module *module;

        z3::expr lhsToExpr(SCAM::Expr *expr, bool bitvector_flag);

        std::vector<SCAM::Assignment *> newAssignmentsList;

        Assignment *applyTactics(SCAM::Assignment *);

        Assignment *optimizeAssignment(Assignment *assignment);
    };

}
#endif //SCAM_ASSIGNMENTOPTIMIZER_H
