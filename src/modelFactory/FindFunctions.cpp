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
                                     IFindDataFlowFactory *find_data_flow_factory) :
    find_new_datatype_(find_new_datatype),
    find_data_flow_factory_(find_data_flow_factory),
    record_decl_(nullptr),
    get_clang_functions_(nullptr),
    module_(nullptr),
    ci_(nullptr) {
  assert(find_new_datatype);
  assert(find_data_flow_factory);
}

bool DESCAM::FindFunctions::setup(clang::CXXRecordDecl *record_decl,
                                  clang::CompilerInstance *ci,
                                  Module *const module) {
  std::cout << "TEST::Setup\n";
  assert(record_decl);
  assert(module);
  assert(ci);
  if (record_decl_ == record_decl) {
    return true;
  } else {
    delete get_clang_functions_;
    function_map_.clear();

    bool success = true;
    this->module_ = module;
    this->ci_ = ci;
    this->get_clang_functions_ = new GetClangFunctions(success, record_decl);

    if (success) {
      //Add datatypes for functions
      auto functionsMap = get_clang_functions_->getFunctionMap();
      for (const auto &func: functionsMap) {
        auto newType = find_new_datatype_->getDataType(func.second->getResultType());
        if (find_new_datatype_->isGlobal(func.second->getResultType())) {
          DataTypes::addDataType(newType);
        } else DataTypes::addLocalDataType(module_->getName(), newType);
      }

      //Add Structural description of functions to module
      for (const auto &function: get_clang_functions_->getFunctionReturnTypeMap()) {
        DataType *datatype;
        if (DataTypes::isLocalDataType(function.second, module_->getName())) {
          datatype = DataTypes::getLocalDataType(function.second, module_->getName());
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
                        new_function =
                            new Function(function.first, datatype, paramMap, GlobalUtilities::getLocationInfo(
                                functionsMap[function.first], ci));
                      else new_function = new Function(function.first, datatype, paramMap);
                          function_map_.insert(std::make_pair(function.first, new_function)))
      }
    }
    return success;
  }
}

std::map<std::string, Function *> FindFunctions::getFunctionDecls() const {
  std::cout << "TEST::getFunctionDecls Length:" << function_map_.size();
  for (auto const &func:function_map_) {
    std::cout << " |Name:" << func.first << " Name2:" << func.second->getName() << " ReturnType:"
              << func.second->getReturnType()->getName();
    std::cout << " ParamMapLenght:" << func.second->getParamMap().size();
  }
  std::cout << "\n";
  return function_map_;
}

std::map<int, CfgBlock *> FindFunctions::getFunctionBody(std::string name) const {
  auto functions = get_clang_functions_->getFunctionMap();
  auto function = functions.find(name);
  if (function == functions.end()) {
    TERMINATE("Function " + name + " is not part of module " + module_->getName());
  }

  FindDataFlow::functionName = name;
  FindDataFlow::isFunction = true;
  DESCAM::CFGFactory cfgFactory(function->second, ci_, module_, this->find_data_flow_factory_);
  FindDataFlow::functionName = "";
  FindDataFlow::isFunction = false;

  auto flow_map = cfgFactory.getControlFlowMap();
  std::cout << "TEST::getFunctionBody Length:" << flow_map.size();
  for (auto const &flow:flow_map) {
    std::cout << "\n | Flow int:" << flow.first << " BlockID:" << flow.second->getBlockID() << " ClangBlockID:"
              << flow.second->getClangBlockID();
    auto preList = flow.second->getPredecessorList();
    std::cout << "\n | | PredecessorList length:" << preList.size();
    for (auto const &pre:preList) {
      std::cout << "\n | | | BlockID:" << pre->getBlockID();
    }
    auto sucList = flow.second->getSuccessorList();
    std::cout << "\n | | SuccessorList length:" << sucList.size();
    for (auto const &suc:sucList) {
      std::cout << "\n | | | BlockID:" << suc->getBlockID();
    }
    auto stmts = flow.second->getStmtList();
    std::cout << "\n | | StatementList Length:" << stmts.size();
    for (auto const &stmt:stmts) {
      std::cout << "\n | | | Statement:" << *stmt;
    }
    std::cout << "\n | | Has Terminator:" << flow.second->hasTerminator();
  }
  std::cout << "\n";

  return cfgFactory.getControlFlowMap();
}

