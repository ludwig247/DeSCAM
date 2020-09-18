
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include <algorithm>
#include <vector>


#include <PrintITL/PrintITL.h>

struct Param
{
    std::string FilePath;
    std::string Name;
    std::string vhi;
    DESCAM::Module * result;

    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.FilePath;}
};



static std::vector<Param> parameter(const char* header_list) {


    //SRC-File to be analyzed
    std::ifstream ifs(header_list);
    std::set<std::string> param_names;
    std::set<std::string> filepaths;

    std::string line;
    std::vector<Param> includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (!line.empty() && (line.find("//") != 0) && (filepaths.count(line) == 0)){
            size_t pos;

            pos = line.rfind("/ESL");
            if (line.rfind("/ESL") == std::string::npos )
                pos = line.rfind("/TestCases");


            const size_t lpos = line.find_last_of('/', pos-1);
            std::string test_name = line.substr( lpos + 1, pos - lpos - 1);
            std::cout << test_name << " at " << pos << " or " << lpos << std::endl;

            const char *commandLineArgumentsArray[2];
            //Binary
            std::string bin = std::string(SCAM_HOME"/bin/SCAM");
            commandLineArgumentsArray[0] = (bin.c_str());
            commandLineArgumentsArray[1] = (line.c_str());

//    add optimizations
//        std::set<std::string> optimizeOptions = {"all"};
//        CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);

            //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit

            try{DESCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                           commandLineArgumentsArray[1]);}
            catch(FatalError & e){}

            for (auto model: DESCAM::ModelGlobal::getModel()->getModules()) {
//        DESCAM::ModelGlobal::reset();
                includes.push_back(Param());
                includes[i].FilePath = line;
                includes[i].result = (model.second);
                if(param_names.count(model.second->getName()) == 1){
                    std::cout<< "Warning: possible duplicate of test name" << includes[i].Name << std::endl;
                    includes[i].Name = model.second->getName();
                    includes[i].Name.append("_" + test_name );
                }
                else  includes[i].Name = model.second->getName();

                includes[i].vhi = model.second->getName();
                param_names.insert(model.second->getName());
                filepaths.insert(line);


//                std::cout<< "gets called " << includes[i].Name << std::endl;
                i++;
            }
        }
    }
    ifs.close();

    return includes;
}


class ITLTest : public ::testing::TestWithParam<Param> {

public:
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

std::vector<Param> example_headers, funct_headers;

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Examples,
        Examples,
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


    ASSERT_TRUE(DESCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
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
    ASSERT_TRUE(DESCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
    printITL.printModule(GetParam().result);
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
