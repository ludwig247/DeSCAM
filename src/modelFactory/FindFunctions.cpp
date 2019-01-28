//
// Created by tobias on 17.07.18.
//

#include <iostream>
#include "FindFunctions.h"

SCAM::FindFunctions::FindFunctions(clang::CXXRecordDecl *recordDecl) {
        TraverseDecl(recordDecl);
}

bool SCAM::FindFunctions::VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) {

    if(methodDecl->isConst()){
        std::string name = methodDecl->getName().str();

        if(methodDecl->getResultType()->isVoidType()) throw std::runtime_error("Method: " + name + " is type void! Void is not allowed");
        this->functionMap.insert(std::make_pair(name,methodDecl));

        //Return type
        this->functionReturnTypeMap.insert(std::make_pair(name, this->clangToScamType(methodDecl->getResultType())));

        //Param name and param type
        std::vector<std::string> paramNameList;
        std::vector<std::string> paramTypeList;
        for(int i=0;i<methodDecl->getNumParams();i++){
            auto param = methodDecl->getParamDecl(i);
            paramNameList.push_back(param->getName().str());
            paramTypeList.push_back(this->clangToScamType(param->getType()));
        }
        this->functionParamNameMap.insert(std::make_pair(name,paramNameList));
        this->functionParamTypeMap.insert(std::make_pair(name,paramTypeList));

    }

    return true;

}

const std::map<std::string, clang::CXXMethodDecl*> &SCAM::FindFunctions::getFunctionMap() const {
    return functionMap;
}

std::string SCAM::FindFunctions::clangToScamType(clang::QualType qualType) {
    auto return_type = qualType.getAsString();
    if(qualType->isRecordType()){
        return_type = qualType->getAsCXXRecordDecl()->getName();
    }else if(qualType->isBuiltinType()){
        if(qualType->isBooleanType()){
            return_type = "bool";
        }else if(qualType->isUnsignedIntegerType()){
            return_type = "unsigned";
        }
    }else if(qualType->isEnumeralType()){
        const clang::EnumType *enumType = qualType->getAs<clang::EnumType>();
        return_type = enumType->getDecl()->getName().str();
    }
    return return_type;
}

const std::map<std::string, std::string> &SCAM::FindFunctions::getFunctionReturnTypeMap() const {
    return functionReturnTypeMap;
}

const std::map<std::string, std::vector<std::string>> &SCAM::FindFunctions::getFunctionParamNameMap() const {
    return functionParamNameMap;
}

const std::map<std::string, std::vector<std::string>> &SCAM::FindFunctions::getFunctionParamTypeMap() const {
    return functionParamTypeMap;
}

