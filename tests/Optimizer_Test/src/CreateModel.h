//
// Created by mi-alkoudsi on 08.12.19.
//

#ifndef OPTIMIZER_TEST_CREATEMODEL_H
#define OPTIMIZER_TEST_CREATEMODEL_H

#include <PrintITL/PrintITL.h>
#include <Model.h>
#include <ModelFactory.h>
#include <PluginAction.h>
#include <ModelGlobal.h>
#include <fstream>
#include <gtest/gtest.h>
#include <Optimizer/Optimizer.h>


static std::vector<SCAM::Module *> createModel(std::string file_path) {

    SCAM::ModelGlobal::createModel(2, std::string(SCAM_HOME"/bin/SCAM ").c_str(),file_path.c_str());

    std::vector<SCAM::Module *> modulesVector;
    for (const auto& module: SCAM::ModelGlobal::getModel()->getModules()) {
        modulesVector.push_back(module.second);
    }
    return modulesVector;
}

#endif //OPTIMIZER_TEST_CREATEMODEL_H
