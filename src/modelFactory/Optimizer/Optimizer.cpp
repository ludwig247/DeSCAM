//
// Created by M.I.Alkoudsi on 08.08.19.
//


#include "Optimizer.h"

SCAM::Optimizer::Optimizer(std::map<int, SCAM::CfgBlock *> CFG, SCAM::Module *module,
                           SCAM::Model *model,
                           const std::set <std::string> &optimizeOptionsSet) : blockCFG(std::move(CFG)),
                                                                               module(module),
                                                                               globalVariableMap(model->getGlobalVariableMap()),
                                                                               optimizeOptionsSet(optimizeOptionsSet) {


    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("mrc") != this->optimizeOptionsSet.end()) {
        SCAM::RemoveEmptyNodes rem(this->blockCFG);
        SCAM::MergeRedundantIfElse sie(rem.getNewBlockCFG());
        SCAM::RenumberCFG renumBlockCFG(sie.getNewBlockCFG());
        this->blockCFG = renumBlockCFG.getNewBlockCFG();
    }
    SCAM::FindUnusedFunctions uff(this->blockCFG, module);
    CreateRealCFG crNodeCFG(this->blockCFG);
    module->setCFG(crNodeCFG.getCFG());
    SCAM::FindReadVariables frv(crNodeCFG.getCFG());
    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("gvp") != this->optimizeOptionsSet.end()) {
        SCAM::GlobalConstantVariablePropagation gcvp(crNodeCFG.getCFG(), this->globalVariableMap);
        this->nodeCFG = gcvp.getCFG();
    } else {
        this->nodeCFG = crNodeCFG.getCFG();
    }

    for (int i = 0; i < 2; i++) {
        SCAM::FindCfgPaths fcp(crNodeCFG.getCFG(), 0);
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("lvp") != this->optimizeOptionsSet.end()) {
            SCAM::LocalValuePropagation lvp(this->nodeCFG);
            this->nodeCFG = lvp.getCFG();
        }
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("gcp") != this->optimizeOptionsSet.end()) {
            SCAM::GlobalConstantPropagation gcp(this->nodeCFG, fcp, frv.getReadVariablesSet());
            this->nodeCFG = gcp.getCFG();
        }
        if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
            this->optimizeOptionsSet.find("rda") != this->optimizeOptionsSet.end()) {
            SCAM::LivenessAnalysis la(this->nodeCFG, module->getVariableMap());
            this->nodeCFG = la.getCFG();
        }
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("are") != this->optimizeOptionsSet.end()) {
        SCAM::ReachabilityAnalysis ra(this->nodeCFG, frv.getReadVariablesSet());
        this->nodeCFG = ra.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("sim") != this->optimizeOptionsSet.end()) {
        module->setCFG(this->nodeCFG);
        SCAM::SimplifyExpressions se(this->nodeCFG, module);
        this->nodeCFG = se.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("ros") != this->optimizeOptionsSet.end()) {
        SCAM::OperatorStrengthReduction osr(this->nodeCFG);
        this->nodeCFG = osr.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("rda") != this->optimizeOptionsSet.end()) {
        SCAM::LivenessAnalysis la(this->nodeCFG, module->getVariableMap());
        this->nodeCFG = la.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("fun") != this->optimizeOptionsSet.end()) {
        module->setCFG(this->nodeCFG);
        SCAM::FunctionsOptimizer fo(this->nodeCFG, module, model, frv.getReadVariablesSet());
        this->nodeCFG = fo.getCFG();
    }

    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("are") != this->optimizeOptionsSet.end()) {
        SCAM::ReachabilityAnalysis ra(this->nodeCFG, frv.getReadVariablesSet());
        this->nodeCFG = ra.getCFG();
    }

    SCAM::RenumberCFG rcn(this->nodeCFG);
    this->nodeCFG = rcn.getNewNodeCFG();
    SCAM::FindUnusedFunctions uff2(this->nodeCFG, module);
    module->setCFG(this->nodeCFG);
    if (this->optimizeOptionsSet.find("all") != this->optimizeOptionsSet.end() ||
        this->optimizeOptionsSet.find("arb") != this->optimizeOptionsSet.end()) {
        SCAM::RangeAndBitWidthAnalysis raba(module);
        this->variableBitWidthMap = raba.getVariableBitWidthMap();
        this->portBitWidthMap = raba.getPortsBitWidthMap();
    }
}

const std::map<int, SCAM::CfgNode *> &SCAM::Optimizer::getCFG() const {
    return this->nodeCFG;
}

const std::map<std::string, int> &SCAM::Optimizer::getVariableBitWidthMap() const {
    return this->variableBitWidthMap;
}

const std::map<SCAM::Port *, int> &SCAM::Optimizer::getPortsBitWidthMap() const {
    return this->portBitWidthMap;
}
