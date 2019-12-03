//
// Created by M.I.Alkoudsi on 10.09.19.
//

#ifndef SCAM_VARIABLESRANGEANALYSIS_H
#define SCAM_VARIABLESRANGEANALYSIS_H


#include "z3++.h"
#include "ExprTranslator.h"
#include "Behavior/CfgNode.h"
#include "PrintStmt.h"
#include "AnalyzeCounterVariables.h"
#include "SubstituteFunctionsWithReturnValues.h"
#include "FindVariablesValuesInRelationalExpressions.h"
#include "Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h"
#include "Optimizer/Utilities/DetectCounterVariable.h"
#include "Optimizer/Utilities/ValueSubstitution.h"
#include "Optimizer/Utilities/OptUtilities.h"
#include <algorithm>
#include <utility>
#include <ctgmath>
#include <stack>
#include <set>

namespace SCAM {
    /***
        * \brief: Finds the ranges of unsigned and integer variables, which are not assigned by read operations
        * \author:mi-alkoudsi
        * \inputs:
        *       - std::map<int, SCAM::CfgNode *> CFG;
        *       - std::map<std::string, std::set<SCAM::Expr *>> variablesValuesMap;
        *       - std::set<std::string>& variablesThatHaveReadSet;
        * \outputs:
        *       - std::map<std::string, int> variablesBitwidthMap
        */
    class VariablesRangeAnalysis {
    public:
        VariablesRangeAnalysis() = delete;

        VariablesRangeAnalysis(const std::map<int, SCAM::CfgNode *>& CFG,
                               const std::map<std::string, std::set<SCAM::Expr *>>& variablesValuesMap,
                               const std::set<std::string>& variablesThatHaveReadSet);

        ~VariablesRangeAnalysis() = default;

        const std::map<std::string, int> &getVariableBitWidthMap() const;

    private:
        int currentNodeID{};
        std::map<int, SCAM::CfgNode *> CFG;
        std::set<std::string> variablesThatHaveReadSet;
        std::set<std::string> difficultToAnalyzeVariablesSet;
        std::map<std::string, std::set<SCAM::Expr *>> variablesValuesMap;
        std::set<std::string> toBeAnalysedCounterVariablesSet;
        std::map<std::string, std::set<std::string>> variablesThatAssignedCounterVariablesMap;
        std::map<std::string, std::string> variablesDataTypesMap;
        std::map<std::string, int> variableBitWidthMap;

        std::set<SCAM::Expr *> substituteVariablesWithValues(SCAM::Expr *toBeSubstitutedExpr,
                                                             const std::map<std::string, std::set<SCAM::Expr *>> &substitutionMap);
    };
}

#endif //SCAM_VARIABLESRANGEANALYSIS_H
