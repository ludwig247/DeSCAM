//



#include <PrintStmt.h>
#include "ConditionOptimizer.h"


// Created by tobias on 13.07.16.
SCAM::ConditionOptimizer::ConditionOptimizer() :
        module(nullptr),
        translator(ExprTranslator(&context)),
        goal(z3::goal(context)) {
    assert(false && "Default constructor of ConditionOptimizer should not be called");
}

SCAM::ConditionOptimizer::ConditionOptimizer(const std::vector<SCAM::Expr *> &conditionList, SCAM::Module *module) :
        module(module),
        translator(ExprTranslator(&context)),
        goal(context) {

    //Translate SCAM::Stmts* to z3:expr and add to goal
    for (auto condition: conditionList) {
        //std::cout << PrintStmt::toString(condition) << std::endl;
        this->goal.add(this->translator.translate(condition));
    }
    //Abort -> no optimization possible(e.g. bitwise operation will be optimized to concatenations)
    if(translator.isAbort()) this->newConditionList = conditionList;
    else this->applyTactics();

    //Abort -> no optimization possible(e.g. bitwise operation will be optimized to concatenations)
    if(translator.isAbort()) this->newConditionList = conditionList;
}

SCAM::ConditionOptimizer::~ConditionOptimizer() {
//    delete  context;
}

std::vector<SCAM::Expr *> SCAM::ConditionOptimizer::getNewConiditionList() {
    return this->newConditionList;
}

void SCAM::ConditionOptimizer::applyTactics() {
    //Context parameters
    this->context.set(":pp-min-alias-size", 1000000);
    this->context.set(":pp-max-depth", 1000000);
    //Parameters for tactis

    //Tactics: with and without eq2ineq
    z3::apply_result result_with = this->runTacticWithEq2Ineq();
    z3::apply_result result_without = this->runTacticWithOutEq2Ineq();

    //Check weired behavior
    if (result_with.size() != 1 || result_without.size() != 1)
        throw std::runtime_error("More than goal, only 1 expected");

    //Only one goal: use this goal
    z3::goal result_with_goal = result_with.operator[](0);
    z3::goal result_without_goal = result_without.operator[](0);
//    std::cout << result_with_goal << std::endl;
//    std::cout << result_without_goal << std::endl;
    //Results with eq2ineq are better
    if (result_with_goal.size() < result_without_goal.size()) {
        for (auto i = 0; i < result_with_goal.size(); i++) {
            //std::cout << result_with_goal.operator[](i) << std::endl;
            auto expr = result_with_goal.operator[](i);
            try{
                auto condition = this->translator.translate(expr, module);
                this->newConditionList.push_back(this->translator.translate(expr, module));
            }catch(std::exception e){
                if(!translator.isAbort()) throw e;

            }
            //translator.reset();
        }
    }
    //Results without eq2ineq are better
    if (result_with_goal.size() >= result_without_goal.size()) {
        for (auto i = 0; i < result_without_goal.size(); i++) {
            auto expr = result_without_goal.operator[](i);
            try{
                //translator.reset();
                auto condition = this->translator.translate(expr, module);
                this->newConditionList.push_back(this->translator.translate(expr, module));
            }catch(std::runtime_error e){
                std::cout << expr << std::endl;
                std::cout << e.what() << std::endl;
                std::cout << translator.isAbort() << std::endl;
                if(!translator.isAbort()) throw std::runtime_error(e.what());
            }

        }
    }
}

z3::apply_result SCAM::ConditionOptimizer::runTacticWithEq2Ineq() {
    z3::params params(this->context);
    //params.set("arith_lhs", true);
    params.set("eq2ineq", true);

    z3::tactic t1 = with(z3::tactic(this->context, "simplify"), params);
    z3::tactic t2(this->context, "propagate-ineqs");
    z3::tactic t3(this->context, "propagate-values");
    z3::tactic t4(this->context, "ctx-solver-simplify");

    z3::apply_result result = (t1 & t2 & t3 & t4)(this->goal);

    return result;
}


z3::apply_result SCAM::ConditionOptimizer::runTacticWithOutEq2Ineq() {

    z3::params params(this->context);
    //params.set("arith_lhs", true);
    z3::tactic t1 = with(z3::tactic(this->context, "simplify"), params);
    z3::tactic t2(this->context, "propagate-ineqs");
    z3::tactic t3(this->context, "propagate-values");
    z3::tactic t4(this->context, "ctx-solver-simplify");

    z3::apply_result result = (t1 & t2 & t3 & t4)(this->goal);
    return result;
}

const SCAM::SectionPathMap SCAM::ConditionOptimizer::optimize(const SCAM::SectionPathMap &sectionPathMap, SCAM::Module *module) {
    SectionPathMap newSectionPatMap = sectionPathMap;

    //Optimize conditions
    for (auto section: newSectionPatMap) {
        for (auto path: section.second) {
//            std::cout << "-----------------Old conditions: " << path->getPathId() << "-----------------------" << std::endl;
//            for (auto stmt: path->getConditionList()) {
//                std::cout << PrintStmt::toString(stmt) << std::endl;
//            }
//            std::cout << "-----------------Optimize conditions: " << path->getPathId() << "-----------------------" << std::endl;
            SCAM::ConditionOptimizer optimizer(path->getConditionList(), module);
            path->setConditionList(optimizer.getNewConiditionList());
        }
    }
    return newSectionPatMap;
}

SCAM::Path *SCAM::ConditionOptimizer::optimize(SCAM::Path *path, SCAM::Module *module) {
    SCAM::ConditionOptimizer optimizer(path->getConditionList(), module);
    path->setConditionList(optimizer.getNewConiditionList());
    return path;
}

