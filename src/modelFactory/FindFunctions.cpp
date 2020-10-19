//
// Created by tobias on 17.07.18.
//

#include <iostream>
#include <GlobalUtilities.h>
#include "FindFunctions.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "FindDataFlow.h"
#include "CFGFactory.h"
#include "FunctionFactory.h"

using namespace DESCAM;

DESCAM::FindFunctions::FindFunctions(IFindNewDatatype *find_new_datatype,
                                     IFindDataFlowFactory *find_data_flow_factory) {
  this->find_new_datatype_ = find_new_datatype;
  this->record_decl_ = nullptr;
  this->get_clang_functions_ = nullptr;
  this->find_data_flow_factory_ = find_data_flow_factory;
}

bool DESCAM::FindFunctions::setup(clang::CXXRecordDecl *record_decl,
                                  clang::CompilerInstance *ci,
                                  std::string module_name,
                                  Module *module) {
  assert(record_decl);
  if (record_decl_ == record_decl) {
    return true;
  } else {
    delete get_clang_functions_;

    function_map_.clear();

    this->get_clang_functions_ = new GetClangFunctions(record_decl);

    //Add datatypes for functions
    auto functionsMap = get_clang_functions_->getFunctionMap();
    for (const auto &func: functionsMap) {
      auto newType = find_new_datatype_->getDataType(func.second->getResultType());
      if (find_new_datatype_->isGlobal(func.second->getResultType())) {
        DataTypes::addDataType(newType);
      } else DataTypes::addLocalDataType(module_name, newType);
    }

    //Add Structural description of functions to module
    for (const auto &function: get_clang_functions_->getFunctionReturnTypeMap()) {
      DataType *datatype;
      if (DataTypes::isLocalDataType(function.second, module_name)) {
        datatype = DataTypes::getLocalDataType(function.second, module_name);
      } else datatype = DataTypes::getDataType(function.second);

      //Parameter
      std::map<std::string, Parameter *> paramMap;
      auto paramList = get_clang_functions_->getFunctionParamNameMap().find(function.first)->second;
      auto paramTypeList = get_clang_functions_->getFunctionParamTypeMap().find(function.first)->second;
      if (paramList.size() != paramTypeList.size()) TERMINATE("Parameter: # of names and types not equal");
      for (int i = 0; i < paramList.size(); i++) {
        auto param = new Parameter(paramList.at(i), DataTypes::getDataType(paramTypeList.at(i)));
        paramMap.insert(std::make_pair(paramList.at(i), param));
      }
      Function *new_function = nullptr;
      DESCAM_ASSERT(if (functionsMap.find(function.first) != functionsMap.end())
                      new_function = new Function(function.first, datatype, paramMap, GlobalUtilities::getLocationInfo(
                          functionsMap[function.first], ci));
                    else new_function = new Function(function.first, datatype, paramMap);
                        function_map_.insert(std::make_pair(function.first,new_function)))
    }
  }
}
const std::map<std::string, clang::CXXMethodDecl *> &FindFunctions::getFunctionMap() const {
  return get_clang_functions_->getFunctionMap();
}
const std::map<std::string, std::string> &FindFunctions::getFunctionReturnTypeMap() const {
  return get_clang_functions_->getFunctionReturnTypeMap();
}
const std::map<std::string, std::vector<std::string>> &FindFunctions::getFunctionParamNameMap() const {
  return get_clang_functions_->getFunctionParamNameMap();
}
const std::map<std::string, std::vector<std::string>> &FindFunctions::getFunctionParamTypeMap() const {
  return get_clang_functions_->getFunctionParamTypeMap();
}
std::map<std::string, Function *> FindFunctions::getFunctions() const {
  return function_map_;
}

