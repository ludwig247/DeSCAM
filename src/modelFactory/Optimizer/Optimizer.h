//
// Created by M.I.Alkoudsi on 08.08.19.
//

#ifndef SCAM_OPTIMIZER_H
#define SCAM_OPTIMIZER_H

#include "ModelGlobal.h"
#include <CfgBlock.h>
#include "Optimizer/Utilities/RemoveEmptyNodes.h"
#include "Optimizer/Utilities/RenumberCFG.h"
#include "Optimizer/MergeRedundantIfElse/MergeRedundantIfElse.h"
#include "Optimizer/Utilities/FindUnusedFunctions.h"
#include "Behavior/CfgNode.h"
#include <CreateRealCFG.h>
#include "Optimizer/Utilities/FindReadVariables.h"
#include "Optimizer/Utilities/CfgPath.h"
#include "Optimizer/Utilities/FindCfgPaths.h"
#include "Optimizer/Utilities/PropagateConstantValue.h"
#include "Optimizer/ValuePropagation/LocalValuePropagation.h"
#include "Optimizer/ValuePropagation/GlobalConstantPropagation.h"
#include "Optimizer/VariablesLivenessAnalysis/LivenessAnalysis.h"
#include "Optimizer/ReachabilityAnalysis/ReachabilityAnalysis.h"
#include "Optimizer/SimplifyExpressions/SimplifyExpressions.h"
#include "Optimizer/FunctionsOptimizer/FunctionOptimizer.h"
#include "Optimizer/OperatorStrengthReduction/OperatorStrengthReduction.h"
#include "RangeAnalysis/RangeAndBitwidthAnalysis.h"
#include "Optimizer/Utilities/OptUtilities.h"
#include <utility>


namespace SCAM {
    /***
     * \brief: Performs optimizations on the control flow graph(CFG)
     *
     * \author: mi-alkoudsi
     *
     * \input:
     *      - std::map<int, SCAM::CfgNode *> cfg;
     *      - SCAM::Module * module;
     *      - std::set<std::string> optimizeOptionsSet;
     * \output:
     *      - std::map<int, CfgNode *> optimizedCFG;
     *      - std::map<std::string, int> deducedVariablesBitwidth;
     *      - std::map<SCAM::Port *, int> deducedOutputPortsBitwidth;
     *
     * \details: Performs some or all of the following optimizations depending on the given optimization options
     * Merge redundant conditions
     * Local value propagation
     * Global value propagation
     * Variables liveness analysis
     * Reachability analysis
     * Functions optimization
     * Operator strength reduction
     * Simplify expressions
     * Range and bitwidth analysis
     */

    class Optimizer {
    public:
        Optimizer() = delete;

        Optimizer(std::map<int, SCAM::CfgBlock *> CFG,
                  SCAM::Module *module, const std::set<std::string>& optimizeOptionsSet);

        ~Optimizer() = default;

        const std::map<int, CfgNode *> &getCFG() const;

        const std::map<std::string, int> &getVariableBitWidthMap() const;

        const std::map<SCAM::Port *, int> &getPortsBitWidthMap() const;

    private:
        std::map<int, SCAM::CfgBlock *> blockCFG;
        std::map<int, SCAM::CfgNode *> nodeCFG;
        SCAM::Module *module;
        std::set<std::string> optimizeOptionsSet;
        std::map<std::string, int> variableBitWidthMap;
        std::map<SCAM::Port *, int> portBitWidthMap;
    };
}

#endif //SCAM_OPTIMIZER_H
