//
// Created by M.I.Alkoudsi on 08.08.19.
//


#include "Optimizer.h"

DESCAM::Optimizer::Optimizer(std::map<int, DESCAM::CfgBlock *> CFG, DESCAM::Module *module,
                           DESCAM::Model *model,
                           const std::set<std::string> &optimizeOptionsSet) : blockCFG(std::move(CFG)),
                                                                              module(module),
                                                                              globalVariableMap(
                                                                                      model->getGlobalVariableMap()),
                                                                              optimizeOptionsSet(optimizeOptionsSet) {
    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("mrc") != this->optimizeOptionsSet.end()) {
        DESCAM::RemoveEmptyNodes rem(this->blockCFG);
        DESCAM::MergeRedundantIfElse sie(rem.getNewBlockCFG());
        DESCAM::RenumberCFG renumBlockCFG(sie.getNewBlockCFG());
        this->blockCFG = renumBlockCFG.getNewBlockCFG();
    }
    DESCAM::FindUnusedFunctions uff(this->blockCFG, module);
    CreateRealCFG crNodeCFG(this->blockCFG);
    module->setCFG(crNodeCFG.getCFG());
    DESCAM::FindReadVariables frv(crNodeCFG.getCFG());
    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("gvp") != this->optimizeOptionsSet.end()) {
        DESCAM::GlobalConstantVariablePropagation gcvp(crNodeCFG.getCFG(), this->globalVariableMap);
        this->nodeCFG = gcvp.getCFG();
    } else {
        this->nodeCFG = crNodeCFG.getCFG();
    }

    for (int i = 0; i < 2; i++) {
        DESCAM::FindCfgPaths fcp(crNodeCFG.getCFG(), 0);
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("lvp") != this->optimizeOptionsSet.end()) {
            DESCAM::LocalValuePropagation lvp(this->nodeCFG);
            this->nodeCFG = lvp.getCFG();
        }
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("gcp") != this->optimizeOptionsSet.end()) {
            DESCAM::GlobalConstantPropagation gcp(this->nodeCFG, fcp, frv.getReadVariablesSet());
            this->nodeCFG = gcp.getCFG();
        }
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("rda") != this->optimizeOptionsSet.end()) {
            DESCAM::LivenessAnalysis la(this->nodeCFG, module->getVariableMap());
            this->nodeCFG = la.getCFG();
        }
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("are") != this->optimizeOptionsSet.end()) {
        DESCAM::ReachabilityAnalysis ra(this->nodeCFG, frv.getReadVariablesSet());
        this->nodeCFG = ra.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("sim") != this->optimizeOptionsSet.end()) {
        module->setCFG(this->nodeCFG);
        DESCAM::SimplifyExpressions se(this->nodeCFG, module);
        this->nodeCFG = se.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("ros") != this->optimizeOptionsSet.end()) {
        DESCAM::OperatorStrengthReduction osr(this->nodeCFG);
        this->nodeCFG = osr.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("rda") != this->optimizeOptionsSet.end()) {
        DESCAM::LivenessAnalysis la(this->nodeCFG, module->getVariableMap());
        this->nodeCFG = la.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("fun") != this->optimizeOptionsSet.end()) {
        module->setCFG(this->nodeCFG);
        DESCAM::FunctionsOptimizer fo(this->nodeCFG, module, model, frv.getReadVariablesSet());
        this->nodeCFG = fo.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("are") != this->optimizeOptionsSet.end()) {
        DESCAM::ReachabilityAnalysis ra(this->nodeCFG, frv.getReadVariablesSet());
        this->nodeCFG = ra.getCFG();
    }

    DESCAM::RenumberCFG rcn(this->nodeCFG);
    this->nodeCFG = rcn.getNewNodeCFG();
    DESCAM::FindUnusedFunctions uff2(this->nodeCFG, module);
    module->setCFG(this->nodeCFG);
    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("arb") != this->optimizeOptionsSet.end()) {
        DESCAM::RangeAndBitWidthAnalysis raba(module);
        this->variableBitWidthMap = raba.getVariableBitWidthMap();
        this->portBitWidthMap = raba.getPortsBitWidthMap();
    }
}

const std::map<int, DESCAM::CfgNode *> &DESCAM::Optimizer::getCFG() const {
    return this->nodeCFG;
}

const std::map<std::string, int> &DESCAM::Optimizer::getVariableBitWidthMap() const {
    return this->variableBitWidthMap;
}

const std::map<DESCAM::Port *, int> &DESCAM::Optimizer::getPortsBitWidthMap() const {
    return this->portBitWidthMap;
}
