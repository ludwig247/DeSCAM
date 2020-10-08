//
// Created by tobias on 17.07.18.
//

#include <iostream>
#include "FindFunctions.h"
#include "FatalError.h"
#include "Logger/Logger.h"

DESCAM::FindFunctions::FindFunctions() {}

void DESCAM::FindFunctions::setup(clang::CXXRecordDecl *recordDecl) {
  this->clean();
  TraverseDecl(recordDecl);
}

void DESCAM::FindFunctions::clean() {
  function_map_.clear();
  function_return_type_map_.clear();
  function_param_name_map_.clear();
  function_param_type_map_.clear();
}

bool DESCAM::FindFunctions::VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) {

  if (methodDecl->isConst()) {
    std::string name = methodDecl->getName().str();

    if (methodDecl->getResultType()->isVoidType()) TERMINATE("Method: " + name + " is type void! Void is not allowed");
    this->function_map_.insert(std::make_pair(name, methodDecl));

    //Return type
    this->function_return_type_map_.insert(std::make_pair(name, this->clangToScamType(methodDecl->getResultType())));

    //Param name and param type
    std::vector<std::string> paramNameList;
    std::vector<std::string> paramTypeList;
    for (int i = 0; i < methodDecl->getNumParams(); i++) {
      auto param = methodDecl->getParamDecl(i);
      paramNameList.push_back(param->getName().str());
      paramTypeList.push_back(this->clangToScamType(param->getType()));
    }
    this->function_param_name_map_.insert(std::make_pair(name, paramNameList));
    this->function_param_type_map_.insert(std::make_pair(name, paramTypeList));

  }

  return true;

}

const std::map<std::string, clang::CXXMethodDecl *> &DESCAM::FindFunctions::getFunctionMap() const {
  return function_map_;
}

std::string DESCAM::FindFunctions::clangToScamType(clang::QualType qualType) const {
  auto return_type = qualType.getAsString();
  if (qualType->isRecordType()) {
    return_type = qualType->getAsCXXRecordDecl()->getName();
  } else if (qualType->isBuiltinType()) {
    if (qualType->isBooleanType()) {
      return_type = "bool";
    } else if (qualType->isUnsignedIntegerType()) {
      return_type = "unsigned";
    }
  } else if (qualType->isEnumeralType()) {
    const clang::EnumType *enumType = qualType->getAs<clang::EnumType>();
    return_type = enumType->getDecl()->getName().str();
  }
  return return_type;
}

const std::map<std::string, std::string> &DESCAM::FindFunctions::getFunctionReturnTypeMap() const {
  return function_return_type_map_;
}

const std::map<std::string, std::vector<std::string>> &DESCAM::FindFunctions::getFunctionParamNameMap() const {
  return function_param_name_map_;
}

const std::map<std::string, std::vector<std::string>> &DESCAM::FindFunctions::getFunctionParamTypeMap() const {
  return function_param_type_map_;
}

