#include <utility>

//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#include <PrintStmt.h>
#include "ValidOperations.h"
#include "ExprTranslator.h"
#include "z3++.h"
#include "ReconstructOperations.h"

namespace SCAM {

    SCAM::ValidOperations::ValidOperations(const std::vector<SCAM::Operation *> &operationsList, SCAM::Module * module) : module(module){

        for (auto op : operationsList) {
            if (SCAM::ValidOperations::isOperationReachable(op)) {
                this->operationsList.push_back(op);
            } else {
                /// Remove from stateList operations
                auto state = op->getState();
                state->removeOutgoingOperation(op);

                state = op->getNextState();
                state->removeIncomingOperation(op);
            }
        }
    }


    const bool SCAM::ValidOperations::isOperationReachable(SCAM::Operation* op) {
        z3::context  context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: op->getAssumptionsList()) {
            solver.add(translator.translate(condition));
        }
        // Check for SAT if unsat -> erase path
        return !(solver.check() == z3::unsat);
    }

    const bool SCAM::ValidOperations::isPathReachable(std::vector<SCAM::CfgNode* > operationPath, SCAM::Module * module) {
        z3::context  context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        // Collect statements
        std::vector<SCAM::Stmt*> statementsList;
        auto it = operationPath.begin();
        while (it != operationPath.end() - 1) {
            if((*it)->getStmt() != nullptr) {
                SCAM::Stmt * statement = (*it)->getStmt();
                if ((*it)->getSuccessorList().size() > 1) { /// Branching node (condition)
                    auto * if_statement = (SCAM::If *)((*it)->getStmt());
                    if ( (*(it + 1))->getId() == ((*it)->getId() + 1) ) {
                        statement = if_statement;
                    } else {
                        statement = new If(new UnaryExpr("not", if_statement->getConditionStmt()));
                    }
                }
                statementsList.push_back(statement);
            }
            it++;
        }

        std::vector<Expr *> conditionsList = SCAM::ReconstructOperations::extractConditions(statementsList,module);

        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: conditionsList) {
            solver.add(translator.translate(condition));
            solver.check();
        }
        // Check for SAT if unsat -> erase path
        return !(solver.check() == z3::unsat);
    }

    const bool SCAM::ValidOperations::isPathReachable(std::vector<SCAM::Stmt* > assumedStatements, std::vector<SCAM::CfgNode* > operationPath, SCAM::Module * module) {
        z3::context  context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        // Collect statements
        std::vector<SCAM::Stmt*> statementsList = std::move(assumedStatements);
        auto it = operationPath.begin();
        while (it != operationPath.end() - 1) {
            if((*it)->getStmt() != nullptr) {
                SCAM::Stmt * statement = (*it)->getStmt();
                if ((*it)->getSuccessorList().size() > 1) { /// Branching node (condition)
                    auto * if_statement = (SCAM::If *)((*it)->getStmt());
                    if ( (*(it + 1))->getId() == ((*it)->getId() + 1) ) {
                        statement = if_statement;
                    } else {
                        statement = new If(new UnaryExpr("not", if_statement->getConditionStmt()));
                    }
                }
                statementsList.push_back(statement);
            }
            it++;
        }
        std::vector<Expr *> conditionsList = SCAM::ReconstructOperations::extractConditions(statementsList,module);

        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: conditionsList) {
            solver.add(translator.translate(condition));
        }
        // Check for SAT if unsat -> erase path
        return !(solver.check() == z3::unsat);
    }

    const std::vector<SCAM::Operation*> SCAM::ValidOperations::getOperationsList() const {
        return this->operationsList;
    }
}