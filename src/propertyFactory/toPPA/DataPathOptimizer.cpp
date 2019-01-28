//
// Created by ludwig on 04.08.16.
//

#include <Assignment.h>
#include <PrintAML/PrintAML.h>
#include "DataPathOptimizer.h"


SCAM::DataPathOptimizer::DataPathOptimizer(const std::vector<SCAM::Assignment *> &dataPathList, SCAM::Module *module) :
        translator(ExprTranslator(&context)),
        module(module) {
    //Visit assignment of the datapath
    for (auto assignment: dataPathList) {
        this->newDataPathList.push_back(this->optimizeAssignment(assignment));
    }
}

SCAM::DataPathOptimizer::~DataPathOptimizer() {
}

std::vector<SCAM::Assignment *> SCAM::DataPathOptimizer::getNewDataPathList() {
    return this->newDataPathList;
}

SCAM::Assignment *SCAM::DataPathOptimizer::applyTactics(SCAM::Assignment *assignment) {

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
        if (result.operator[](0).as_expr().num_args() > 2) throw std::runtime_error("Invalid number of or exprs!");
        //Only interested in the simplification of RHS
        //Retrive new RHS
        auto expr = result.operator[](0).as_expr().arg(1);
        SCAM::Expr *newRHS = this->translator.translate(expr, module);
        if (this->translator.isAbort()) return assignment;
        //Create old RHS
        return new Assignment(assignment->getLhs(), newRHS);
    }catch(z3::exception e){

        std::cout << "Translation warning for: " << PrintStmt::toString(assignment) << std::endl;
        std::cout << "\t ->" << e << std::endl;
        return assignment;
    }
}

z3::expr SCAM::DataPathOptimizer::lhsToExpr(SCAM::Expr *expr, bool bitvector_flag) {
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
    else throw std::runtime_error("Type " + expr->getDataType()->getName() + " is not supported for assignment");
}

const SCAM::SectionPathMap SCAM::DataPathOptimizer::optimize(const SCAM::SectionPathMap &sectionPathMap, SCAM::Module *module) {
    SectionPathMap newSectionPatMap = sectionPathMap;
    for (auto section: newSectionPatMap) {
        for (auto path: section.second) {
//            std::cout << "-----------------Old dataPath: " << path->getPathId() << "-----------------------" << std::endl;
//            for (auto stmt: path->getDataPathList()) {
//                std::cout << PrintStmt::toString(stmt) << std::endl;
//            }
//            std::cout << "-----------------Optimize DataPath: " << path->getPathId() << "-----------------------" << std::endl;
            SCAM::DataPathOptimizer optimizer(path->getDataPathList(), module);
            path->setDataPathList(optimizer.getNewDataPathList());
//            std::cout << "-----------------New dataPath: " << path->getPathId() << "-----------------------" << std::endl;
//            for (auto stmt: optimizer.getNewDataPathList()) {
//                std::cout << PrintStmt::toString(stmt) << std::endl;
//            }
//            std::cout << "------------------------------------------------------" << std::endl;
        }
    }
    return newSectionPatMap;
}

SCAM::Path *SCAM::DataPathOptimizer::optimize(SCAM::Path *path, SCAM::Module *module) { //TODO make SCAM::Path * path const?
    SCAM::DataPathOptimizer optimizer(path->getDataPathList(), module);
    path->setDataPathList(optimizer.getNewDataPathList());
    return path;
}

Assignment *DataPathOptimizer::optimize(Assignment *assignment, SCAM::Module *module) {
    DataPathOptimizer dataPathOptimizer({assignment},module);
    return dataPathOptimizer.getNewDataPathList().front();
}

Assignment * DataPathOptimizer::optimizeAssignment(Assignment *assignment) {
    //Check for compound type:  no optimization here
    if (assignment->getRhs() == nullptr) throw std::runtime_error("DataPathOpt: RHS of assign is null");
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


