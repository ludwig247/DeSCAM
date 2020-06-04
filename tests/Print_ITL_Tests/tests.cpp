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
    //SRC-File to be analyzed
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");

    std::string line;
    std::vector<std::string> header_includes;

    while (std::getline(ifs, line)) {

        if (line.size() > 0 && !(line.find("//") == 0))
            header_includes.push_back(line);
    }
    ifs.close();


for(int i = 0; i < header_includes.size(); i++) {
    //Binary
    std::string bin = std::string(SCAM_HOME"/bin/SCAM");
    commandLineArugmentsVector.push_back(bin.c_str());

//    for (int i = 0; i < header_includes.size(); i++) {
        commandLineArugmentsVector.push_back(header_includes[i].c_str());
//std::cout<<commandLineArugmentsVector[i]<<std::endl;
//        ./DESCAM path
//        .DESCAM/ foreach path in paths
//    }

//    add optimizations
    std::set<std::string> optimizeOptions = {"all"};
    CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);


//    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");
//    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
        std::cout << commandLineArgumentsArray[i] << std::endl;
    }




//    for (int i = 1; i < commandLineArugmentsVector.size(); i++) {
        SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],
                                       commandLineArgumentsArray[1]);
        SCAM::ModelGlobal::reset();
//    }
//header_includes.clear();
commandLineArugmentsVector.clear();
}
    std::vector<SCAM::Module*> result;
for (auto model: SCAM::ModelGlobal::getModel()->getModules()) {
        SCAM::DataTypes::reset();
        result.push_back(model.second);
    }

    for(int i =0; i< result.size(); i++){
        std::cout << result[i] <<"\n"<<std::endl;
    }


}