#include <utility>

//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#include <PrintStmt.h>
#include "ValidOperations.h"
#include "ExprTranslator.h"
#include "z3++.h"
#include "ReconstructOperations.h"

namespace DESCAM {

    DESCAM::ValidOperations::ValidOperations(const std::vector<DESCAM::Operation *> &operationsList, DESCAM::Module * module) : module(module){

        for (auto op : operationsList) {
            if (DESCAM::ValidOperations::isOperationReachable(op)) {
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


    const bool DESCAM::ValidOperations::isOperationReachable(DESCAM::Operation* op) {
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

    const bool DESCAM::ValidOperations::isPathReachable(std::vector<DESCAM::CfgNode* > operationPath, DESCAM::Module * module) {
        z3::context  context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        // Collect statements
        std::vector<DESCAM::Stmt*> statementsList;
        auto it = operationPath.begin();
        while (it != operationPath.end() - 1) {
            if((*it)->getStmt() != nullptr) {
                DESCAM::Stmt * statement = (*it)->getStmt();
                if ((*it)->getSuccessorList().size() > 1) { /// Branching node (condition)
                    auto * if_statement = (DESCAM::If *)((*it)->getStmt());
                    if ( (*(it + 1))->getId() == ((*it)->getId() + 1) ) {
                        statement = if_statement;
                    } else {
                        statement = new If(new UnaryExpr("not", if_statement->getConditionStmt(),if_statement->getStmtInfo()),if_statement->getStmtInfo());
                    }
                }
                statementsList.push_back(statement);
            }
            it++;
        }

        std::vector<Expr *> conditionsList = DESCAM::ReconstructOperations::extractConditions(statementsList,module);

        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: conditionsList) {
            //if(ExprVisitor::isTernary(condition)) return true; //TODO: remove
            solver.add(translator.translate(condition));
            solver.check();
        }
        // Check for SAT if unsat -> erase path
        return !(solver.check() == z3::unsat);
    }

    const bool DESCAM::ValidOperations::isPathReachable(std::vector<DESCAM::Stmt* > assumedStatements, std::vector<DESCAM::CfgNode* > operationPath, DESCAM::Module * module) {
        z3::context  context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        // Collect statements
        std::vector<DESCAM::Stmt*> statementsList = std::move(assumedStatements);
        auto it = operationPath.begin();
        while (it != operationPath.end() - 1) {
            if((*it)->getStmt() != nullptr) {
                DESCAM::Stmt * statement = (*it)->getStmt();
                if ((*it)->getSuccessorList().size() > 1) { /// Branching node (condition)
                    auto * if_statement = (DESCAM::If *)((*it)->getStmt());
                    if ( (*(it + 1))->getId() == ((*it)->getId() + 1) ) {
                        statement = if_statement;
                    } else {
                        statement = new If(new UnaryExpr("not", if_statement->getConditionStmt(),if_statement->getStmtInfo()),if_statement->getStmtInfo());
                    }
                }
                statementsList.push_back(statement);
            }
            it++;
        }
        std::vector<Expr *> conditionsList = DESCAM::ReconstructOperations::extractConditions(statementsList,module);

        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: conditionsList) {
            //if(ExprVisitor::isTernary(condition)) continue; //TODO: remove
            solver.add(translator.translate(condition));
        }
        // Check for SAT if unsat -> erase path
        return !(solver.check() == z3::unsat);
    }

    const std::vector<DESCAM::Operation*> DESCAM::ValidOperations::getOperationsList() const {
        return this->operationsList;
    }

}