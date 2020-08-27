
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <algorithm>
#include <vector>


#include <PrintITL/PrintITL.h>

struct Param
{
    std::string FilePath;
    std::string Name;
    SCAM::Module * result;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.Name;}
};
std::vector<Param> example_headers, funct_headers;


static std::vector<Param> parameter(const char* header_list) {


    //SRC-File to be analyzed
    std::ifstream ifs(header_list);

    std::string line;
    std::vector<Param> includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (line.size() > 0 && !(line.find("//") == 0)){
//            std::string test_name = line.substr(line.find_last_of("/\\") + 1);
//            const size_t period = test_name.rfind(".");
//            if(std::string::npos != period) test_name.erase(period);
//            if(std::find(header_includes.begin()->Name, header_includes.end()->Name, test_name) != header_includes.end()->Name)
//                header_includes[i].Name = line;
            const char *commandLineArgumentsArray[2];

            //Binary
            std::string bin = std::string(SCAM_HOME"/bin/SCAM");
            commandLineArgumentsArray[0] = (bin.c_str());
            commandLineArgumentsArray[1] = (line.c_str());

//    add optimizations
//        std::set<std::string> optimizeOptions = {"all"};
//        CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);

            //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
            SCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                           commandLineArgumentsArray[1]);

            for (auto model: SCAM::ModelGlobal::getModel()->getModules()) {
//        SCAM::ModelGlobal::reset();
                includes.push_back(Param());
                includes[i].FilePath = line;
                includes[i].result = (model.second);
                includes[i].Name = model.second->getName();
                std::cout<< "gets called " << includes[i].Name << std::endl;
                i++;
            }
        }
    }
    ifs.close();

    return includes;
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
        testing::ValuesIn(example_headers),
        ITLTest::PrintToStringParamName()
                );

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Functionality,
        Functionality,
        ITLTestFunctionality,
        testing::ValuesIn(funct_headers),
        ITLTest::PrintToStringParamName()
        );

TEST_P(ITLTestExamples, Examples) {
//    std::set<std::string> test_param_names;
//    GTEST_CHECK_(test_param_names.count(param_name) == 0)
//                << "Duplicate parameterized test name '" << param_name
//                << "', in " << file << " line " << line << std::endl;
    ASSERT_TRUE(SCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
//    SCAM::Module * module = result.back();
    printITL.printModule(GetParam().result);
    printITL.print();
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + GetParam().Name + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;

//    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + GetParam().Name + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" << GetParam().Name  << ".vhi";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << GetParam().Name << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

}

TEST_P(ITLTestFunctionality, Functionality) {
    ASSERT_TRUE(SCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
//    SCAM::Module * module = result.back();
    printITL.printModule(GetParam().result);
    printITL.print();
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + GetParam().Name + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;

//    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + GetParam().Name + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" << GetParam().Name  << ".vhi";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << GetParam().Name << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

    }

#endif //PROJECT_PRINTITL_TEST_H
