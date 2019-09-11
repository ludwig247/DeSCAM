//
// Created by ludwig on 04.08.16.
//

#ifndef SCAM_DATAPATHOPTIMIZER_H
#define SCAM_DATAPATHOPTIMIZER_H

#include <vector>
#include <ExprTranslator.h>
#include "Path.h"


namespace SCAM{



/** \brief Optimize value of for assignment   
 *
 * Translate a datapath assignment e.g. x = x + 1 + 1 into result == ( x+1+1 )
 * Simplify this expr using tactic("simplify") into result == (x+2)
 * Now translate rhs(x+2) into a SCAM::Stmt* and this is the new value for the assignment
 *
 * ------------------------------------------------------
 * STEP 1: SCAM::Stmt to z3::expr
 * ------------------------------------------------------
 * Z3Interface impelents a visitor for the StmtAbstractVisitor which allows a translation of SCAM::Stmt to z3::exprs
 * Afterwards the expr is simplified using the z3 simplify tactics
 *  -----------------------------------------------------
 * STEP 2: z3::expr to SCAM::Stmt
 * ------------------------------------------------------
 * Translating the expr to a SCAM::Stmt is done by  the method exprToStmt
 * That method is a recursive method and necessary because of the lack of a visitor pattern for the exprs.
 *
 */
    typedef std::map<std::string, std::vector<SCAM::Path *> > SectionPathMap;
class DataPathOptimizer{
public:

    virtual ~DataPathOptimizer();
    static const SectionPathMap optimize(const SectionPathMap& sectionPathMap,SCAM::Module * module);
    static Path * optimize(Path *path, SCAM::Module *module);
    static Assignment * optimize(Assignment * assignment, SCAM::Module *module);
private:
    std::vector<SCAM::Assignment *> getNewDataPathList();
    DataPathOptimizer(const std::vector<SCAM::Assignment *> & dataPathList,SCAM::Module * module);
    z3::context  context;
    ExprTranslator translator;
    SCAM::Module * module;
    z3::expr lhsToExpr(SCAM::Expr *expr, bool bitvector_flag);
    std::vector<SCAM::Assignment *>  newDataPathList;
    SCAM::Assignment * applyTactics(SCAM::Assignment *);


    Assignment * optimizeAssignment(Assignment *assignment);
};

}
#endif //SCAM_DATAPATHOPTIMIZER_H
