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


static std::vector<SCAM::Module *> createModules(std::string file_path) {

    SCAM::ModelGlobal::createModel(2, std::string(SCAM_HOME"/bin/SCAM ").c_str(), file_path.c_str());

    std::vector<SCAM::Module *> modulesVector;
    for (const auto &module: SCAM::ModelGlobal::getModel()->getModules()) {
        modulesVector.push_back(module.second);
    }
    return modulesVector;
}

static std::vector<SCAM::Model *>
createModel(std::string file_path, const std::set<std::string> &optimizeOptionsSet = {}) {
    if (!optimizeOptionsSet.empty()) {
        CommandLineParameter::setOptimizeOptionsSet(optimizeOptionsSet);
    }
    SCAM::ModelGlobal::createModel(2, std::string(SCAM_HOME"/bin/SCAM ").c_str(), file_path.c_str());

    std::vector<SCAM::Model *> model;
    model.push_back(SCAM::ModelGlobal::getModel());
    return model;
}

#endif //OPTIMIZER_TEST_CREATEMODEL_H
