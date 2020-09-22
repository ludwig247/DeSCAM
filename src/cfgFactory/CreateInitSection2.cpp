//
// Created by ludwig on 19.01.18.
//


#include <PrintStmt.h>
#include "CreateInitSection2.h"


std::vector<DESCAM::Stmt *> DESCAM::CreateInitSection2::createInitSection2(const DESCAM::Module *module) {
    //Create empty StmtList
    std::vector<DESCAM::Stmt *> initList;

    //Add nextSection assignement;
    auto nextSectionVariable = module->getFSM()->getNextSectionVariable();
    if (nextSectionVariable != nullptr) {
        auto nextSectionOperand = new SectionOperand(nextSectionVariable);
        auto nextSectionValue = new SectionValue(nextSectionVariable->getInitialValue());

        initList.push_back(new Assignment(nextSectionOperand, nextSectionValue));
    }

    //Assign initial values to variables
    for (auto var: module->getVariableMap()) {
        //Compound type
        if (var.second->isCompoundType() || var.second->isArrayType()) {
            for (auto subvar: var.second->getSubVarList()) {
                initList.push_back(new Assignment(new VariableOperand(subvar), const_cast<ConstValue *>(subvar->getInitialValue())));
            }
            //Regular var
        }else if(var.second->getDataType()->getName() == "event") {
            continue;
        }else {
            initList.push_back(new Assignment(new VariableOperand(var.second), const_cast<ConstValue *>(var.second->getInitialValue())));
        }
    }

    //Set outputs for shareds
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if ((interface->isShared() || interface->isSlave()) && interface->isOutput()) {
            auto datatype = port.second->getDataType();
            initList.push_back(new Write(port.second, datatype->getDefaultVal(), true));
        }
    }
    return initList;
}


