//
// Created by M.I.Alkoudsi on 08.08.19.
//

#include "Optimizer.h"



SCAM::Optimizer::Optimizer(std::map<int, SCAM::CfgBlock *> CFG, SCAM::Module *module) : blockCFG(std::move(CFG)),
                                                                                        module(module) {

//-------------------------Block CFG optimizations--------------------------
//    std::cout << SCAM::OptUtilities::printCFG(this->blockCFG);

    SCAM::RemoveEmptyNodes rem(this->blockCFG);

    SCAM::MergeRedundantIfElse sie(rem.getNewBlockCFG());

    SCAM::RenumberCFG renumBlockCFG(sie.getNewBlockCFG());

    SCAM::FindUnusedFunctions uff(renumBlockCFG.getNewBlockCFG(), module);

    CreateRealCFG crNodeCFG(
            renumBlockCFG.getNewBlockCFG());
    module->setCFG(crNodeCFG.getCFG());

    SCAM::FindReadVariables frv(crNodeCFG.getCFG());

    SCAM::FindCfgPaths fcp(crNodeCFG.getCFG(), 0);

    SCAM::LocalValuePropagation lvp(crNodeCFG.getCFG());

    SCAM::GlobalConstantPropagation gcp(lvp.getCFG(), fcp, frv.getReadVariablesSet());

    SCAM::LivenessAnalysis la(gcp.getCFG(), module->getVariableMap(), frv.getReadVariablesSet());

    SCAM::FindCfgPaths fcp2(la.getCFG(), 0);

    SCAM::LocalValuePropagation lvp2(la.getCFG());

    SCAM::GlobalConstantPropagation gcp2(lvp2.getCFG(), fcp2, frv.getReadVariablesSet());

    SCAM::ReachabilityAnalysis ra(gcp2.getCFG(), frv.getReadVariablesSet());

    SCAM::SimplifyExpressions se(ra.getCFG(), module);

    SCAM::OperatorStrengthReduction osr(se.getCFG());

    SCAM::LivenessAnalysis la2(osr.getCFG(), module->getVariableMap(), frv.getReadVariablesSet());

    SCAM::FunctionsOptimizer fo(la2.getCFG(), module, frv.getReadVariablesSet());
    module->setCFG(fo.getCFG());

    SCAM::RenumberCFG rcn(fo.getCFG());

    this->nodeCFG = rcn.getNewNodeCFG();

    SCAM::FindUnusedFunctions uff2(this->nodeCFG, module);

//    std::cout << OptUtilities::printCFG(this->nodeCFG);
    module->setCFG(this->nodeCFG);

//     SCAM::RangeAndBitWidthAnalysis raba(module, frv.getReadVariablesSet());

}

const std::map<int, SCAM::CfgNode *> &SCAM::Optimizer::getCFG() const {
    return this->nodeCFG;
}

