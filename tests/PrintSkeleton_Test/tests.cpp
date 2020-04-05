//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>

#include "PrintSkeleton_Test.h"

int main(int argc, char **argv) {
    std::vector<const char *> commandLineArugmentsVector;

    //Binaray
    std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
    std::string file_path = std::string(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/Tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }
    SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]);


    for(auto module: ModelGlobal::getModel()->getModules()){
        {
            CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
            CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
            PrintSkeleton printSkeleton;
            auto result = printSkeleton.printModule(module.second);
            std::ofstream moduleString;
            moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
            moduleString << result.second;
            moduleString.close();

            result = printSkeleton.printLocalTypes(module.second);
            std::ofstream functionString;
            functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
            functionString << result.second;
            functionString.close();
        }

        {
            CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
            CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

            PrintSkeleton printSkeleton;
            auto result = printSkeleton.printModule(module.second);
            std::ofstream moduleString;
            moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
            moduleString << result.second;
            moduleString.close();

            result = printSkeleton.printLocalTypes(module.second);
            std::ofstream functionString;
            functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
            functionString << result.second;
            functionString.close();
        }
    }

    testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}
