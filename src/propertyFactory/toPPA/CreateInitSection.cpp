//
// Created by ludwig on 19.01.18.
//


#include "CreateInitSection.h"


std::vector<SCAM::Stmt *> SCAM::CreateInitSection::createInitSection(const SCAM::Module & module) {
    //Create empty StmtList
    std::vector<SCAM::Stmt *> initList;

    //Add nextSection assignement;
    auto nextSectionVariable = module.getFSM()->getNextSectionVariable();
    auto nextSectionOperand = new SectionOperand(nextSectionVariable);
    auto nextSectionValue = new SectionValue(nextSectionVariable->getInitialValue());

    initList.push_back(new Assignment(nextSectionOperand, nextSectionValue));

    //Assign initial values to variables
    for (auto var: module.getVariableMap()) {
        //Compound type
        if (var.second->isCompoundType()) {
            for (auto subvar: var.second->getSubVarList()) {
                initList.push_back(new Assignment(new VariableOperand(subvar), const_cast<ConstValue *>(subvar->getInitialValue())));
            }
            //Regular var
        } else {
            initList.push_back(new Assignment(new VariableOperand(var.second), const_cast<ConstValue *>(var.second->getInitialValue())));
        }
    }

    //Set outputs for shareds
    for (auto port: module.getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared() && interface->isOutput()) {
            auto datatype = port.second->getDataType();
            initList.push_back(new NBWrite(port.second, datatype->getDefaultVal()));

        }
    }
    return initList;
}


