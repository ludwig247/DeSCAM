//
// Created by burr on 16.10.20.
//

#include "GetClangFunctions.h"
#include "FatalError.h"
#include "Logger/Logger.h"

bool DESCAM::GetClangFunctions::VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) {
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
DESCAM::GetClangFunctions::GetClangFunctions(clang::CXXRecordDecl *record_decl) {
  TraverseDecl(record_decl);
}
const std::map<std::string, clang::CXXMethodDecl *> &DESCAM::GetClangFunctions::getFunctionMap() const {
  return function_map_;
}
const std::map<std::string, std::string> &DESCAM::GetClangFunctions::getFunctionReturnTypeMap() const {
  return function_return_type_map_;
}
const std::map<std::string, std::vector<std::string>> &DESCAM::GetClangFunctions::getFunctionParamNameMap() const {
  return function_param_name_map_;
}
const std::map<std::string, std::vector<std::string>> &DESCAM::GetClangFunctions::getFunctionParamTypeMap() const {
  return function_param_type_map_;
}
std::string DESCAM::GetClangFunctions::clangToScamType(clang::QualType qualType) const {
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
