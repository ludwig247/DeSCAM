//
// Created by tobias on 17.07.18.
//

#include <iostream>
#include "FindFunctions.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::FindFunctions::FindFunctions(clang::CXXRecordDecl *recordDecl) {
        TraverseDecl(recordDecl);
}

bool DESCAM::FindFunctions::VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) {

    if(methodDecl->isConst()){
        std::string name = methodDecl->getName().str();

        if(methodDecl->getResultType()->isVoidType()) TERMINATE("Method: " + name + " is type void! Void is not allowed");
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

    }else if(methodDecl->getResultType()->isVoidType() && dynamic_cast<clang::CXXConstructorDecl*>(methodDecl) == nullptr){

        std::string name = methodDecl->getNameAsString();
        this->functionMap.insert(std::make_pair(name,methodDecl));
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

const std::map<std::string, clang::CXXMethodDecl*> &DESCAM::FindFunctions::getFunctionMap() const {
    return functionMap;
}

std::string DESCAM::FindFunctions::clangToScamType(clang::QualType qualType) {
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

const std::map<std::string, std::string> &DESCAM::FindFunctions::getFunctionReturnTypeMap() const {
    return functionReturnTypeMap;
}

const std::map<std::string, std::vector<std::string>> &DESCAM::FindFunctions::getFunctionParamNameMap() const {
    return functionParamNameMap;
}

const std::map<std::string, std::vector<std::string>> &DESCAM::FindFunctions::getFunctionParamTypeMap() const {
    return functionParamTypeMap;
}

