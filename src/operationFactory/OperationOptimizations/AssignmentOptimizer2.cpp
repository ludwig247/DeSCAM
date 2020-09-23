//
// Created by ludwig on 04.08.16.
//

#include <Assignment.h>
#include "AssignmentOptimizer2.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::AssignmentOptimizer2::AssignmentOptimizer2(const std::vector<DESCAM::Assignment *> &assignmentsList, DESCAM::Module *module) :
        translator(ExprTranslator(&context)),
        module(module) {
    //Visit assignment of the assignmentsList
    int i=0;
    for (auto assignment: assignmentsList) {
        if(i++ == 59){
            std::cout << *assignment << std::endl;

        }
        this->newAssignmentsList.push_back(this->optimizeAssignment(assignment));
    }
}

DESCAM::AssignmentOptimizer2::AssignmentOptimizer2(const DESCAM::Operation *operation, DESCAM::Module *module):
        translator(ExprTranslator(&context)),
        module(module){


    for (auto assignment: operation->getCommitmentsList()) {

        this->newAssignmentsList.push_back(this->optimizeAssignment(assignment));
    }

}

std::vector<DESCAM::Assignment *> DESCAM::AssignmentOptimizer2::getNewAssignmentsList() {
    return this->newAssignmentsList;
}

DESCAM::Assignment *DESCAM::AssignmentOptimizer2::applyTactics(DESCAM::Assignment *assignment) {
    z3::params params(context);
    params.set("arith_lhs",false);
    params.set("eq2ineq",false);
    params.set("elim_and",false);
    params.set("elim_sign_ext",false);
    params.set("mul2concat",false);
    params.set("flat",true);
    params.set("algebraic_number_evaluator",false);
    params.set("bvnot2arith",false);
    params.set("split_concat_eq",false);
    try {
        //params.set("arith_lhs", true);
        //Assume lhs to be any variable
        z3::goal goal(this->context);

        //Rhs is the translated stmt
        try{
            z3::expr rhs = this->translator.translate(assignment->getRhs());
            if (this->translator.isAbort()) return assignment;
            //Lhs to expr;
            z3::expr lhs = this->lhsToExpr(assignment->getLhs(), rhs.is_bv());

            //Add result == rhs as goal (only 1 goal)
            goal.add(lhs == rhs);
            //Simplify
            z3::tactic t1 = with(z3::tactic(context, "simplify"), params);
            z3::apply_result result = (t1)(goal);
            //Clear goals
            goal.reset();

            //Only interested in the simplification of RHS
            // In case varName == true or varName == false is passed
            if (result.operator[](0).as_expr().num_args() <= 1) {
                //TODO: Warning msg for this case
                return assignment;
            }
            //Sanity check: in case some weired assignment is passed
            if (result.operator[](0).as_expr().num_args() > 2) TERMINATE("Invalid number of or exprs!");
            //Only interested in the simplification of RHS
            //Retrive new RHS
            auto expr = result.operator[](0).as_expr().arg(1);
            if(DESCAM::GlobalUtilities::isAbortTranslation(expr)) return assignment;
            DESCAM::Expr *newRHS = this->translator.translate(expr, module);
            if (this->translator.isAbort()) return assignment;
            //Create old RHS
            return new Assignment(assignment->getLhs(), newRHS,assignment->getStmtInfo());
        }catch(std::exception e){
            //TODO: should I do this?
            return assignment;
        }

    }catch(z3::exception e){
        std::string msg = "Translation warning for: " + PrintStmt::toString(assignment);
        LocationInfo locationInfo = assignment->getStmtInfo();
        auto sl = DESCAM::LoggerMsg::SeverityLevel::Warning;
        auto vt = DESCAM::LoggerMsg::ViolationType::NA;
        auto pl = DESCAM::Logger::getCurrentProcessedLocation();
        DESCAM::LoggerMsg lmsg(msg, locationInfo,sl,vt,pl);
        DESCAM::Logger::addMsg(lmsg);
        return assignment;
    }
}


z3::expr DESCAM::AssignmentOptimizer2::lhsToExpr(DESCAM::Expr *expr, bool bitvector_flag) {
    //Determine datatype of stmt -> throws an execption if stmt is not a variable

    //Create expr depending on type
    //Case: bool(Default)

    if (expr->getDataType()->getName() == "bool") return context.bool_const("result");
        //Case: int
    else if (expr->getDataType()->getName() == "int") {
        if (bitvector_flag) return context.bv_const("result", 32);
        else return context.int_const("result");
    }
        //Case: unsigned
    else if (expr->getDataType()->getName() == "unsigned") {
        if (bitvector_flag) return context.bv_const("result", 32);
        else return context.int_const("result"); //TODO: is this correct?
    }
        //Case: Unknown
    else {
        TERMINATE("Type " + expr->getDataType()->getName() + " is not supported for assignment");
    }
}

DESCAM::Assignment * DESCAM::AssignmentOptimizer2::optimizeAssignment(DESCAM::Assignment *assignment) {
    //Check for compound type:  no optimization here
    if (assignment->getRhs() == nullptr) {TERMINATE("DataPathOpt: RHS of assign is null")}
    else if (assignment->getRhs()->getDataType()->isCompoundType()) {
        return assignment;
    }
    else if (assignment->getRhs()->getDataType()->isEnumType()) {
        return assignment;
    }
    //Try to optimize stmt
    Assignment * optimizedAssignment = applyTactics(assignment);
    translator.reset();
    return optimizedAssignment;

}

DESCAM::Assignment * DESCAM::AssignmentOptimizer2::optimizeAssignment(DESCAM::Assignment *assignment, DESCAM::Module *module) {
    AssignmentOptimizer2 assignmentOptimizer2({assignment},module);
    return assignmentOptimizer2.getNewAssignmentsList().front();
}






