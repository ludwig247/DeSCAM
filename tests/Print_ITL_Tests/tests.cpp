//
// Created by tobias on 11.04.17.
//
//#include <gtest/gtest.h>
//
//#include "PrintITL_Test.h"
#include <ModelGlobal.h>
#include <fstream>

#include <PrintITL/PrintITL.h>


//TODO: no need for main

int main(int argc, char **argv) {
//   testing::InitGoogleTest(&argc, argv);
//  return RUN_ALL_TESTS();
    std::vector<const char *> commandLineArugmentsVector;

    //Binary
    std::string bin = std::string(SCAM_HOME"/bin/SCAM");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
//    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");
//
//    std::string line;
//    std::vector<std::string> header_includes;
//
//    while(std::getline(ifs, line))
//    {
//
//        if(line.size() > 0 && !(line.find("//") == 0))
//            header_includes.push_back(line);
//    }
//    for(int i = 0; i < header_includes.size(); i++) {
//        commandLineArugmentsVector.push_back(header_includes[i].c_str());
//    }



    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
        std::cout<<commandLineArugmentsVector[i]<<std::endl;
    }

//    add optimizations
    std::set<std::string> optimizeOptions = {"all"};
    CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);

    for (int i = 1; i < commandLineArugmentsVector.size(); i++) {
        SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],
                                       commandLineArgumentsArray[i]);
    }

    std::vector<SCAM::Module *> result;
    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
        SCAM::DataTypes::reset();
        result.push_back(module.second);
    }

}