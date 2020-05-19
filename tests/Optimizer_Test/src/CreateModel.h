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


static std::vector<DESCAM::Module *> createModules(std::string file_path) {

    DESCAM::ModelGlobal::createModel(2, "DESCAM", file_path.c_str(),true);

    std::vector<DESCAM::Module *> modulesVector;
    for (const auto &module: DESCAM::ModelGlobal::getModel()->getModules()) {
        modulesVector.push_back(module.second);
    }
    return modulesVector;
}

static std::vector<DESCAM::Model *>
createModel(std::string file_path, const std::set<std::string> &optimizeOptionsSet = {}, bool isWrapper = true) {
    if (!optimizeOptionsSet.empty()) {
        CommandLineParameter::setOptimizeOptionsSet(optimizeOptionsSet);
    }
    DESCAM::ModelGlobal::createModel(2, "DESCAM", file_path.c_str(), isWrapper);

    std::vector<DESCAM::Model *> model;
    model.push_back(DESCAM::ModelGlobal::getModel());
    return model;
}

#endif //OPTIMIZER_TEST_CREATEMODEL_H
