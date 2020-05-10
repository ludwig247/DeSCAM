//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include <PrintITL/PrintITL.h>
//#include "PrintITL_Test.h"
#include <ModelGlobal.h>
#include <fstream>
//TODO: no need for main

std::vector main(int argc, char **argv) {
//    testing::InitGoogleTest(&argc, argv);
//    return RUN_ALL_TESTS();

    std::vector<const char *> commandLineArugmentsVector;

    //Binary
    std::string bin = std::string(SCAM_HOME"/bin/SCAM ");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }

//    add optimizations
//    std::set<std::string> optimizeOptions = {"all"};
//    CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);
    SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]);

    std::vector<SCAM::Module *> result;
    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
        SCAM::DataTypes::reset();
        result.push_back(module.second);
    }
    return 0;
}