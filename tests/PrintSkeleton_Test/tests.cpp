//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>

#include "PrintSkeleton_Test.h"

int main(int argc, char **argv) {
    std::vector<const char *> commandLineArugmentsVector;

    //Binaray
    std::string bin = std::string(SCAM_HOME"/bin/SCAM ");
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

    testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}
