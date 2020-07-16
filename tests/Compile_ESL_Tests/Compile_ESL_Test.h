//
// Created by hesselberg on 05.04.20.
//

#ifndef DESCAM_COMPILE_ESL_TEST_H
#define DESCAM_COMPILE_ESL_TEST_H

#include "rapidjson/document.h"
#include "rapidjson/istreamwrapper.h"
#include <fstream>
#include <Config.h>

using namespace rapidjson;

struct Param
{
    std::string Name;
    bool Success;
};


static std::vector<Param> parameter(const char* json) {


    //SRC-File to be analyzed
    std::ifstream ifs(json);
    IStreamWrapper isw(ifs);
    Document JSON;
    JSON.ParseStream(isw);

    if(JSON.IsNull()){
        std::cout << "Document" << json <<" does not exist"<< std::endl;
    std::terminate();}



    std::vector<Param> JSON_vector;


for(SizeType i; i< JSON["compile_output"].Size(); i++){
            JSON_vector.push_back(Param());
            JSON_vector[i].Success = JSON["compile_output"][i]["success"].GetBool();
            JSON_vector[i].Name = JSON["compile_output"][i]["test_name"].GetString();
        }


    return JSON_vector;
}


class CompileESL : public ::testing::TestWithParam<Param> {

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
    static void SetUpTestCase() {
        #define SHELLSCRIPT "cmake --build ../cmake-build-debug --target Compile_ESL_Test_Run"
        system(SHELLSCRIPT);
    }

    static void TearDownTestCase() {
    }
};

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Basic,
        Basic,
        CompileESL,
        testing::ValuesIn(parameter(SCAM_HOME "/tests/Compile_ESL_Tests/json_output_files/error_compilation.json")),
        CompileESL::PrintToStringParamName()
);

TEST_P(CompileESL, Basic){

EXPECT_TRUE(GetParam().Success);

}

#endif //DESCAM_COMPILE_ESL_TEST_H
