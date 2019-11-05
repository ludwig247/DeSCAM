//
// Created by M.I.Alkoudsi on 11.06.19.
//

#ifndef SCAM_REACHABILITYANALYSIS_H
#define SCAM_REACHABILITYANALYSIS_H


#include "z3++.h"
#include "Behavior/CfgNode.h"
#include "ExprTranslator.h"
#include "Optimizer/Utilities/FindVariablesValues.h"
#include "Optimizer/Utilities/FindCfgPaths.h"
#include "Optimizer/Utilities/PropagateConstantValue.h"
#include <Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h>
#include "Optimizer/Utilities/ValueSubstitution.h"
#include "Optimizer/Utilities/OptUtilities.h"
#include <utility>


namespace SCAM {

    class ReachabilityAnalysis {
    public:
        ReachabilityAnalysis() = delete;

        ReachabilityAnalysis(const std::map<int, CfgNode *> &CFG,
                             std::set<std::string> variablesThatHaveReadSet);

        ReachabilityAnalysis(
                std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList,
                std::map<std::string, std::set<SCAM::Expr *>> allVarValuesMap,
                std::set<std::string> variablesThatHaveReadSet);

        const std::map<int, CfgNode *> &getCFG() const;
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> getReturnValueConditionList() const;

    private:
        bool RA_hasRead;
        int whileNodeID;
        int currentNodeID;
        z3::expr z3Expr;
        std::map<int, CfgNode *> CFG;
        std::map<int, std::vector<SCAM::CfgNode *>> pathsToIfMap;                     //Stores the paths from while to if statement
        std::map<std::string, std::set<SCAM::Expr *>> assignmentsToIfValuesMap;       //Stores last assignments from while to if statements
        std::map<std::string, std::set<SCAM::Expr *>> allVarValuesMap;                //Contains all possible values that all variable can take
        std::set<std::string> variablesThatHaveReadSet;                               //All variables that can't be optimized due to interprocedural behaviour
        std::map<std::string, z3::expr> substitutionMap;                              //variables to be substituted in each if statement
        std::set<int> unreachableNodes;                                               //The entry node to the path where the preceding if statement never leads to it
        std::set<int> ifNodesToBeDeleted;                                             //Nodes with if statements that should be deleted
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList;
        std::set<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> toBeDeletedPair;

        void checkAndAddVariableToSubstitutionMap(SCAM::VariableOperand *varOp);

        std::vector<z3::expr> substituteVariablesInsideIfExpressionWithTheirValues(SCAM::Expr *ExpressionInsideIf);

        void printWarning(SCAM::Expr *insideIfExpression, bool cannotBe);

        void removeDeadIfStatementsAndReplaceItInPredecessorsAndSuccessors();

        void removeDeadPathsOfDeadIfStatements();

    };
}
#endif //SCAM_REACHABILITYANALYSIS_H
