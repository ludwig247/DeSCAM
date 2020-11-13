//
// Created by burr on 16.10.20.
//

#include "GetClangFunctions.h"
#include "FatalError.h"
#include "Logger/Logger.h"

bool DESCAM::GetClangFunctions::VisitCXXMethodDecl(clang::CXXMethodDecl *method_decl) {
  if (method_decl->isConst()) {
    std::string name = method_decl->getName().str();
    // TODO check for correct call: getCallResultType or getReturnType
    if (method_decl->getCallResultType()->isVoidType()) TERMINATE("Method: " + name + " is type void! Void is not allowed")
    this->function_map_.insert(std::make_pair(name, method_decl));

    //Return type
    this->function_return_type_map_.insert(std::make_pair(name, this->clangToScamType(method_decl->getCallResultType())));

    //Param name and param type
    std::vector<std::string> param_name_list;
    std::vector<std::string> param_type_list;
    for (int i = 0; i < method_decl->getNumParams(); i++) {
      auto param = method_decl->getParamDecl(i);
      param_name_list.push_back(param->getName().str());
      param_type_list.push_back(this->clangToScamType(param->getType()));
    }
    this->function_param_name_map_.insert(std::make_pair(name, param_name_list));
    this->function_param_type_map_.insert(std::make_pair(name, param_type_list));

  }

  return true;
}
DESCAM::GetClangFunctions::GetClangFunctions(bool &success, clang::CXXRecordDecl *record_decl) {
  success = TraverseDecl(record_decl);
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
std::string DESCAM::GetClangFunctions::clangToScamType(clang::QualType qual_type) {
  auto return_type = qual_type.getAsString();
  if (qual_type->isRecordType()) {
    return_type = qual_type->getAsCXXRecordDecl()->getName().str();
  } else if (qual_type->isBuiltinType()) {
    if (qual_type->isBooleanType()) {
      return_type = "bool";
    } else if (qual_type->isUnsignedIntegerType()) {
      return_type = "unsigned";
    }
  } else if (qual_type->isEnumeralType()) {
    const clang::EnumType *enumType = qual_type->getAs<clang::EnumType>();
    return_type = enumType->getDecl()->getName().str();
  }
  return return_type;
}
