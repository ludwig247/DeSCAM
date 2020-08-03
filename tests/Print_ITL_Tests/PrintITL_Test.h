
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>

#include <PrintITL/PrintITL.h>

struct Param
{
    std::string FilePath;
    std::string Name;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.FilePath;}
};


static std::vector<Param> parameter(const char* header_list) {


    //SRC-File to be analyzed
    std::ifstream ifs(header_list);

    std::string line;
    std::vector<Param> header_includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (line.size() > 0 && !(line.find("//") == 0)){
            std::string test_name = line.substr(line.find_last_of("/\\") + 1);
            const size_t period = test_name.rfind(".");
            if(std::string::npos != period) test_name.erase(period);
            header_includes.push_back(Param());
            header_includes[i].FilePath = line;
            header_includes[i].Name = test_name;
            i++;
        }
    }
    ifs.close();

    return header_includes;
}


class ITLTest : public ::testing::TestWithParam<Param> {

public:
    std::vector<SCAM::Module *> result;
    struct PrintToStringParamName
    {
        template <class ParamType>
        std::string operator()( const testing::TestParamInfo<ParamType>& info ) const
        {
            auto Parameter = static_cast<Param>(info.param);
            return Parameter.Name;
        }
    };
    void SetUp() {
        const char *commandLineArgumentsArray[2];

        //Binary
        std::string bin = std::string(SCAM_HOME"/bin/SCAM");
        commandLineArgumentsArray[0] = (bin.c_str());
        commandLineArgumentsArray[1] = (GetParam().FilePath.c_str());

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
    void TearDown() {
    }
};


class ITLTestExamples : public ITLTest {};

class ITLTestFunctionality : public ITLTest {};

INSTANTIATE_TEST_CASE_P(
        DISABLED_Examples,
//        Examples,
        ITLTestExamples,
        testing::ValuesIn(parameter(SCAM_HOME"/tests/Print_ITL_Tests/tests.h")),
        ITLTest::PrintToStringParamName()
                );

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Functionality,
        Functionality,
        ITLTestFunctionality,
        testing::ValuesIn(parameter(SCAM_HOME"/tests/Print_ITL_Tests/functionality_tests.h")),
        ITLTest::PrintToStringParamName()
        );

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
