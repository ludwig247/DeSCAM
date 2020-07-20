//
// Created by hesselberg on 05.04.20.
//

#ifndef DESCAM_COMPILE_ESL_TEST_H
#define DESCAM_COMPILE_ESL_TEST_H

#include <gtest/gtest.h>
#include "rapidjson/document.h"
#include "rapidjson/istreamwrapper.h"
#include <fstream>
#include <ostream>
#include <Config.h>

using namespace rapidjson;

struct Param
{
    std::string Name;
    bool Success;
    std::vector<std::string> Errors;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.Name << " was not compiled";}
};


static std::vector<Param> parameter(const char* json) {


    //SRC-File to be analyzed
    std::ifstream ifs(json);
    IStreamWrapper isw(ifs);
    Document JSON;
    JSON.ParseStream(isw);

    if(JSON.IsNull()){
        std::cout << "WARNING!!: Document" << json <<" does not exist"<< std::endl;
    std::terminate();}



    std::vector<Param> JSON_vector;


    for(SizeType i = 0; i< JSON["compile_output"].Size(); i++){
            JSON_vector.push_back(Param());
            JSON_vector[i].Success = JSON["compile_output"][i]["success"].GetBool();
            JSON_vector[i].Name = JSON["compile_output"][i]["test_name"].GetString();
            if(!JSON["compile_output"][i]["success"].GetBool())
                for(SizeType x = 0; x < JSON["compile_output"][i]["errors"].Size(); x++)
                    JSON_vector[i].Errors.push_back(JSON["compile_output"][i]["errors"][x].GetString());
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
};

::testing::AssertionResult CompileTest(Param s) {
    if (s.Success){
        return ::testing::AssertionSuccess() <<"Compilation of " << s.Name << "successful!";}
    else{
        for (auto &i : s.Errors)
            std::cout << "Error "<< i <<std::endl;
        return ::testing::AssertionFailure() << "compilation of " << s.Name << " failed";}
}
std::string printer(Param s){
for (auto &i : s.Errors)
return i;
}

INSTANTIATE_TEST_CASE_P(
        Basic,
//        DISABLED_Basic,
        CompileESL,
        testing::ValuesIn(parameter(SCAM_HOME "/tests/Compile_ESL_Tests/json_output_files/error_compilation.json")),
        CompileESL::PrintToStringParamName()
);

TEST_P(CompileESL,Basic){



EXPECT_TRUE(GetParam().Success)<<(GetParam())<<std::endl<< "Errors: "<<printer(GetParam());

//for (auto &i : GetParam().Errors)
//        std::cout << "Error "<< i <<std::endl;
if(GetParam().Success) std::cout << "Compilation of "<<GetParam().Name << " succeeded"<< std::endl;



}

#endif //DESCAM_COMPILE_ESL_TEST_H
