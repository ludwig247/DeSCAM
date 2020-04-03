//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/22/19.
//


#include <PrintStmt.h>
#include <PrintITL/ConditionVisitor.h>
#include <PrintITL/DatapathVisitor.h>
#include "OperationFactory.h"
#include "FindOperations.h"
#include "CreateOperations.h"
#include "ReconstructOperations.h"
#include "ValidOperations.h"
#include "OperationOptimizations/ConditionOptimizer2.h"
#include "OperationOptimizations/AssignmentOptimizer2.h"
#include "OperationOptimizations/OptimizeOperations2.h"
#include "PropertySuite.h"
#include "CreateOperationsSlave.h"
#include "../parser/CommandLineParameter.h"
#include <thread>
#include <CreatePropertySuite.h>
#include <OperationOptimizations/TernaryOptimizer.h>

namespace SCAM {
    OperationFactory::OperationFactory(std::map<int, SCAM::CfgNode *> controlFlowMap, SCAM::Module *module) :
            module(module),
            cfg(std::move(controlFlowMap)) {
        std::cout << "======================" << std::endl;
        std::cout << "Operations generation:" << std::endl;
        std::cout << "----------------------" << std::endl;
        std::cout << "Find Operations:" << std::endl;
        this->findOperations();
        std::cout << "\tFound: " << this->rawOperations.size() << std::endl;
        std::cout << "Create Operations: " << std::endl;
        this->createOperations();
        std::cout << "\tCreated: " << this->operations.size() << std::endl;

        std::cout << "Reconstruct Operations: " << std::endl;
        this->reconstructOperations();
        std::cout << "Valid Operations: " << std::endl;
        this->findValidOperations();
        std::cout << "\tValid: " << this->operations.size() << std::endl;
        this->checkStates();
        auto optimizerOptionsSet = CommandLineParameter::getOptimizeOptionsSet();
        if (optimizerOptionsSet.find("all") == optimizerOptionsSet.end() && optimizerOptionsSet.find("are") == optimizerOptionsSet.end()) {
            std::cout << "Optimizing conditions" << std::endl;
            this->optimizeConditions();
        }
        if (optimizerOptionsSet.find("all") == optimizerOptionsSet.end() && optimizerOptionsSet.find("sim") == optimizerOptionsSet.end()) {
            std::cout << "Optimizing Assignments" << std::endl;
            this->optimizeAssignments();
        }
        std::cout << "Simplify Ternary Operations " << std::endl;
        this->optimizeTernary();
        std::cout << "Reduce operations:" << std::endl;
        this->optimizeOperations();
        std::cout << "Generating PropertySuite:" << std::endl;
        std::map<int, State *> stateMap;
        for (auto state: this->statesMap) {
            state.second->setName(state.second->getName() + "_" + std::to_string(state.second->getStateId()));
            stateMap.insert(std::make_pair(state.second->getStateId(), state.second));
        }
        this->module->getFSM()->setStateMap(stateMap);
        this->module->setVariableMap(this->varMap);
    }

    void OperationFactory::findOperations() {
        SCAM::FindOperations ctest(cfg, this->module);
        this->statesMap = ctest.getStatesMap();
        this->rawOperations = ctest.getOperations();
    }

    void OperationFactory::createOperations() {
        if (this->module->isSlave()) {
            SCAM::CreateOperationsSlave cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        } else {
            SCAM::CreateOperations cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        }
    }

    void OperationFactory::reconstructOperations() {
        SCAM::ReconstructOperations rOperations(this->statesMap, this->module);
        for (auto op : this->operations) {
            rOperations.sortOperation(op);
        }
    }

    void OperationFactory::findValidOperations() {
        std::vector<SCAM::Operation *> validOperations;
        for (auto op : this->operations) {
            if (SCAM::ValidOperations::isOperationReachable(op)) {
                validOperations.push_back(op);
            } else {
                /// Remove from stateList operations
                auto state = op->getState();
                state->removeOutgoingOperation(op);

                state = op->getNextState();
                state->removeIncomingOperation(op);
            }
        }
        this->operations = validOperations;
    }

    void OperationFactory::checkStates() {
        for (const auto &state : this->statesMap) {
            if (state.second->isInit()) continue;

            if (state.second->getIncomingOperationsList().empty())
                std::cout << "\t\033[1;33mWarning\033[0m: (" << state.first << ") is unreachable! consider removing it.\n";
        }
    }

    void OperationFactory::optimizeConditions() {
        for (auto operation : operations) {
            ConditionOptimizer2 conditionOptimizer2(operation->getAssumptionsList(), module);
            operation->setAssumptionsList(conditionOptimizer2.getNewConditionList());
        }
    }

    void OperationFactory::optimizeAssignments() {

        for (auto op : operations) {
            AssignmentOptimizer2 assignmentOptimizer2(op->getCommitmentsList(), module);
            op->setCommitmentsList(assignmentOptimizer2.getNewAssignmentsList());
        }
    }

    void OperationFactory::optimizeOperations() {
        SCAM::OptimizeOperations2 oOperations(this->operations, module);
        this->varMap = oOperations.getNewVarMap();
    }

    void OperationFactory::optimizeTernary() {
        for (auto op:operations) {
            auto conditionList = op->getAssumptionsList();
            //FIXME: this is the weiredest thing ever ... I cant use a range based loop without getting an exception ... why?
            for (int i = 0; i < op->getCommitmentsList().size(); i++) {
                auto commitment = op->getCommitmentsList().at(i);
                if (ExprVisitor::isTernary(commitment->getRhs())) {
                    //Idea: get all compare operations.
                    auto compareSet = ExprVisitor::getUsedTernaryOperators(commitment->getRhs());
                    for (auto comp: compareSet) {
                        bool trivialFalse = false;
                        bool trivialTrue = false;
                        auto cList = conditionList;
                        cList.push_back(comp->getCondition());
                        {
                            z3::context context;
                            z3::solver solver(context);
                            ExprTranslator translator(&context);
                            //Idea: check for satisfiability of assumptions_of_operation & assumption_of_ternary
                            //If unsat -> always false
                            //Translate each expression with the ExprtTranslator and add to solver
                            for (auto condition: conditionList) {
                                solver.add(translator.translate(condition));
                            }
                            solver.add(translator.translate(comp->getCondition()));
                            // Check for SAT if unsat -> erase path
                            if ((solver.check() == z3::unsat)) {
                                comp->setTrivialFalse();
                                trivialFalse = true;
                            }
                        }
                        {
                            z3::context context;
                            z3::solver solver(context);
                            ExprTranslator translator(&context);

                            //Idea: check for satisfiability of not(assumptions_of_operation -> assumption_of_ternary)
                            //If no model exist, the the condition of ternary is always true (IPC idea)
                            z3::expr expr(context);
                            expr = context.bool_val(true);
                            for (auto condition: conditionList) {
                                expr = expr && translator.translate(condition);
                            }
                            expr = !expr || translator.translate(comp->getCondition());
                            solver.add(!expr);

                            // Check for SAT if unsat -> erase path
                            if ((solver.check() == z3::unsat)) {
                                comp->setTrivialTrue();
                                trivialTrue = true;
                            }
                        }
                        assert(!(trivialTrue && trivialFalse) && "Ternary can't be trivial true and trivial false at the same time");
                    }
                }
            }
        }

        //Optmize assignments with trival true/false ternary
        for (auto op : operations) {
            std::vector<Assignment *> newCommList;
            for (auto stmt: op->getCommitmentList()) {
                TernaryOptimizer ternaryOptimizer(stmt);
                if (NodePeekVisitor::nodePeekAssignment(ternaryOptimizer.getStmt())) {
                    newCommList.push_back(NodePeekVisitor::nodePeekAssignment(ternaryOptimizer.getStmt()));
                } else throw std::runtime_error("Commitment has to be a statement");
            }
            op->setCommitmentsList(newCommList);
        }

        for (auto op : operations) {
            std::vector<Expr *> newAssumptionList;
            for (auto stmt: op->getAssumptionsList()) {
                TernaryOptimizer ternaryOptimizer(stmt);

                if (ternaryOptimizer.getExpr() != nullptr && ternaryOptimizer.getExpr()->getDataType()->isBoolean()) {
                    newAssumptionList.push_back(ternaryOptimizer.getExpr());
                } else throw std::runtime_error("Assumption has to be boolean");
            }
            op->setAssumptionsList(newAssumptionList);
        }

        for (auto op : operations) {
            for (int i = 0; i < op->getAssumptionsList().size(); i++) {
                auto assumption = op->getAssumptionsList().at(i);
                if (ExprVisitor::isTernary(assumption)) {
                    //Idea: get all compare operations.
                    auto compareSet = ExprVisitor::getUsedTernaryOperators(assumption);
                    for (auto comp: compareSet) {
                        bool trivialFalse = false;
                        bool trivialTrue = false;
                        auto cList = op->getAssumptionsList();
                        cList.push_back(comp->getCondition());
                        {
                            z3::context context;
                            z3::solver solver(context);
                            ExprTranslator translator(&context);
                            //Idea: check for satisfiability of assumptions_of_operation & assumption_of_ternary
                            //If unsat -> always false
                            //Translate each expression with the ExprtTranslator and add to solver
                            for (auto condition: op->getAssumptionsList()) {
                                solver.add(translator.translate(condition));
                            }
                            solver.add(translator.translate(comp->getCondition()));
                            // Check for SAT if unsat -> erase path
                            if ((solver.check() == z3::unsat)) {
                                comp->setTrivialFalse();
                                trivialFalse = true;
                            }
                        }
                        {
                            z3::context context;
                            z3::solver solver(context);
                            ExprTranslator translator(&context);

                            //Idea: check for satisfiability of not(assumptions_of_operation -> assumption_of_ternary)
                            //If no model exist, the the condition of ternary is always true (IPC idea)
                            z3::expr expr(context);
                            expr = context.bool_val(true);
                            for (auto condition: op->getAssumptionsList()) {
                                expr = expr && translator.translate(condition);
                            }
                            expr = !expr || translator.translate(comp->getCondition());
                            solver.add(!expr);

                            // Check for SAT if unsat -> erase path
                            if ((solver.check() == z3::unsat)) {
                                comp->setTrivialTrue();
                                trivialTrue = true;
                            }
                        }
                        assert(!(trivialTrue && trivialFalse) && "Ternary can't be trivial true and trivial false at the same time");
                    }
                }
            }
        }

        for (auto op : operations) {
            std::vector<Expr *> newAssumptionList;
            for (auto stmt: op->getAssumptionsList()) {
                ConditionOptimizer2 conditionOptimizer2({stmt},module);
                if(!conditionOptimizer2.getNewConditionList().empty()){
                    auto expr = conditionOptimizer2.getNewConditionList().back();
                    if(!(*expr == BoolValue((true)))){
                        newAssumptionList.push_back(expr);
                    }
                }
            }
            op->setAssumptionsList(newAssumptionList);
        }


    }
}