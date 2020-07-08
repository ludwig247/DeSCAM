
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>

#include <PrintITL/PrintITL.h>


static std::vector<std::string> parameter() {


    //SRC-File to be analyzed
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/tests.h");

    std::string line;
    std::vector<std::string> header_includes;

    while (std::getline(ifs, line)) {

        if (line.size() > 0 && !(line.find("//") == 0))
            header_includes.push_back(line);
    }
    ifs.close();

    return header_includes;
}

static std::vector<std::string> FuncParameter() {


    //SRC-File to be analyzed
//    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/functionality_tests.h");


    //SRC-File to be analyzed
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/functionality_tests.h");

    std::string line;
    std::vector<std::string> functionality_h;

    while (std::getline(ifs, line)) {

        if (line.size() > 0 && !(line.find("//") == 0))
            functionality_h.push_back(line);
    }
    ifs.close();

    return functionality_h;
}


class ITLTestExamples : public ::testing::TestWithParam<std::string> {

public:
    std::vector<SCAM::Module *> result;

    static void SetUpTestCase() {

    }

    static void TearDownTestCase() {
    }

    virtual void SetUp() {
        const char *commandLineArgumentsArray[2];

        //Binary
        std::string bin = std::string(SCAM_HOME"/bin/SCAM");
        commandLineArgumentsArray[0] = (bin.c_str());
        commandLineArgumentsArray[1] = (GetParam().c_str());

//    add optimizations
//        std::set<std::string> optimizeOptions = {"all"};
//        CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);

        //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
        SCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                       commandLineArgumentsArray[1]);

        for (auto model: SCAM::ModelGlobal::getModel()->getModules()) {
//        SCAM::ModelGlobal::reset();
            result.push_back(model.second);
        }
    }
};

    class ITLTestFunctionality : public ::testing::TestWithParam<std::string> {

    public:
        std::vector<SCAM::Module *> result;
        static void SetUpTestCase() {

        }

        static void TearDownTestCase() {
        }

        virtual void SetUp() {
            const char *commandLineArgumentsArray[2];

            //Binary
            std::string bin = std::string(SCAM_HOME"/bin/SCAM");
            commandLineArgumentsArray[0] = (bin.c_str());
            commandLineArgumentsArray[1] = (GetParam().c_str());

//    add optimizations
//        std::set<std::string> optimizeOptions = {"all"};
//        CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);

            //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
            SCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                           commandLineArgumentsArray[1]);

            for (auto model: SCAM::ModelGlobal::getModel()->getModules()) {
//        SCAM::ModelGlobal::reset();
                result.push_back(model.second);
            }
        }
    virtual void TearDown() {
    }
};

INSTANTIATE_TEST_CASE_P(
        Examples,
        ITLTestExamples,
        testing::ValuesIn(parameter()),
//        testing::PrintToStringParamName()
                );

INSTANTIATE_TEST_CASE_P(
        DISABLED_Functionality,
        ITLTestFunctionality,
        testing::ValuesIn(FuncParameter()
        ));

TEST_P(ITLTestExamples, Examples) {

    ASSERT_TRUE(SCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
    SCAM::Module * module = result.back();
    printITL.printModule(module);
    printITL.print();
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + module->getName() + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;

//    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + module->getName() + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" << module->getName()  << ".vhi";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << module->getName() << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

}

TEST_P(ITLTestFunctionality, Functionality) {
    PrintITL printITL;
    SCAM::Module * module = result.back();
    printITL.printModule(module);
    printITL.print();
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + module->getName() + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;

    //    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + module->getName() + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" << module->getName()  << ".vhi";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << module->getName() << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

    }

#endif //PROJECT_PRINTITL_TEST_H
