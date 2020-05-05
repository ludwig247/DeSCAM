//
// Created by tobias on 11.04.20.
//

#include <z3++.h>
#include <OperationOptimizations/ConditionOptimizer2.h>
#include "Completeness.h"
#include "ExprTranslator.h"

/**
 * 1) builds an smt with a conjunction of each assumption of each operation
 *  all_assumptions = (assumption_op1 || assumptin_op2 || ... assumptions_opN)
 * 2) prove there no model for !all_assumptions exist
 *  =>  if thise the case the method is trivial true
 * @param operations
 * @return true, if case split test for assumptions of operations holds
 */
bool SCAM::Completeness::checkCaseSplit(const std::vector<SCAM::Operation *> &operations, Module *module) {
    //Case split check
    z3::context context;
    z3::solver solver(context);
    SCAM::ExprTranslator translator(&context);
    z3::expr all_assumptions(context);
    all_assumptions = context.bool_val(false);

    for (auto op: operations) {
        if (op->getId() == 1) continue;
        z3::expr assumption(context);
        z3::expr expr = context.bool_val(!op->getState()->isInit());
        for (auto assumption: op->getAssumptionsList()) {
            expr = expr && translator.translate(assumption);
        }
        all_assumptions = all_assumptions || expr;
    }
    all_assumptions = all_assumptions != context.bool_val(true);
    solver.add(all_assumptions);

    // Check for SAT if unsat -> erase path
    if ((solver.check() == z3::unsat)) {
        //expr->setTrivialFalse();
        std::cout << "Case-split test passed!" << std::endl;
        std::cout << "There is no model for !(disjunction_of_all_assumptions)" << std::endl;
    } else {
        std::cout << "Case-split test failed!" << std::endl;
        std::cout << "Model:" << std::endl;
        std::cout << solver.get_model() << std::endl;
    }
}
