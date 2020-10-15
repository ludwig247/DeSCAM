//
// Created by tobias on 13.11.19.
//

#include <iostream>
#include <FunctionFactory.h>
#include "FindGlobal.h"
#include "IFindDataFlow.h"
#include "FindDataFlowFactory.h"
#include "FindNewDatatype.h"
#include "FatalError.h"

bool DESCAM::FindGlobal::setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci,IFindDataFlowFactory * find_data_flow_factory) {
  assert(!(decl == nullptr));
  assert(ci);

  this->find_data_flow_factory_ = find_data_flow_factory;
  this->variable_map_.clear();
  this->function_map_.clear();
  this->functionDeclMap.clear();

  this->decl_ = decl;
  this->ci_ = ci;

  return TraverseDecl(decl);
}

bool DESCAM::FindGlobal::VisitVarDecl(const clang::VarDecl *varDecl) {
  auto type = varDecl->getType();
  auto isConst = type.isConstant(decl_->getASTContext());
  auto isBuiltIn = type->isBuiltinType();

  if (isConst && isBuiltIn) {
    if (varDecl->getAnyInitializer(varDecl) != nullptr) {

      auto init = varDecl->getAnyInitializer(varDecl)->IgnoreImpCasts();
      if (init->getType()->isBuiltinType()) {
        auto isUnsigned = varDecl->getType()->isUnsignedIntegerType();
        try {
          auto checkForExpr = find_data_flow_factory_->create_new(const_cast<clang::Expr *>(init), &module_, ci_,find_data_flow_factory_, isUnsigned);
          Logger::clear();
          if (checkForExpr->getExpr()) {
            std::string typeName = init->getType().getAsString();
            if (typeName == "_Bool") typeName = "bool";
            else if (varDecl->getType()->isUnsignedIntegerType()) {
              typeName = "unsigned";
            } else if (varDecl->getType()->isIntegerType()) {
              typeName = "int";
            } else TERMINATE("unsupported type")

            std::string name = varDecl->getName().str();
            std::string value = PrintStmt::toString(checkForExpr->getExpr());

            //Determine type
            auto type = varDecl->getType();
            DataType *descam_type;
            if (type.isConstant(decl_->getASTContext())) {
              if (type->isBooleanType()) descam_type = DataTypes::getDataType("bool");
              else if (type->isUnsignedIntegerType()) descam_type = DataTypes::getDataType("unsigned");
              else if (type->isIntegerType()) descam_type = DataTypes::getDataType("int");
              else TERMINATE("Type: " + type.getAsString() + " for var " + name + " is not allowed");
            }

            //Types have to be equivalent
            if (checkForExpr->getExpr()->getDataType() == descam_type) {
              //set initial && create new global constant variable
              if (auto initVal = dynamic_cast<ConstValue *>(checkForExpr->getExpr())) {
                auto var = new Variable(name, descam_type, initVal);
                var->setConstant(true);
                this->variable_map_.insert(std::make_pair(name, var));
              } else {
                //std::cout << "Global variable: " << name << " with value " << PrintStmt::toString(checkForExpr.getExpr()) << " is not added as global var." << std::endl;
                //std::cout << "The reason is that the initial value has to be of constant and simple type without expressions of any kind" << std::endl;
                //FIXME move back to exception
                //TERMINATE("Init value has to be const");
              }
            }
          }
        } catch (std::runtime_error &e) {
          //std::cout << e.what() << std::endl;

        }

      }
    }
  }
  return true;
}

const std::map<std::string, DESCAM::Variable *> &DESCAM::FindGlobal::getVariableMap() const {
  return variable_map_;
}

/***
 * Find all relevant functions within an AST
 * Return types are only allowed to be bool or (unsigned) int as well as the parameters
 * Furthermore, the parameters have to be a call by value
 *
 * @param funDecl
 * @return
 */

bool DESCAM::FindGlobal::VisitFunctionDecl(const clang::FunctionDecl *funDecl) {
  //Define lambdas for checking the function
  auto valid_result_type = [=]() {
    auto res = funDecl->getResultType();
    return ((res->isIntegerType() || res->isBooleanType()) && !res->isReferenceType() && !res->isAnyPointerType()
        && !res->isEnumeralType());
  };

  auto valid_function_type = [=]() {
    return funDecl->isGlobal() && funDecl->isUsed() && !funDecl->isCXXClassMember();
  };

  auto valid_parameters = [=]() {
    for (int i = 0; i < funDecl->getNumParams(); i++) {
      auto type = funDecl->getParamDecl((i))->getType().getCanonicalType();
      if (!type->isIntegerType() && !type->isBooleanType() && !type->isEnumeralType()) {
        return false;
      }
    }
    return true;
  };

  //Ensure, that all conditions are correct
  if (valid_result_type() && valid_function_type() && valid_parameters()) {
    std::map<std::string, Parameter *> parameterMap;
    for (int i = 0; i < funDecl->getNumParams(); i++) {
      auto param = funDecl->getParamDecl(i);
      std::string paraName = param->getNameAsString();
      auto newParam = new Parameter(paraName, getDataType(param->getType()));
      parameterMap.insert(std::make_pair(paraName, newParam));
    }
    std::string name = funDecl->getNameAsString();
    auto function = new Function(name, getDataType(funDecl->getResultType()), parameterMap);
    this->function_map_.insert(std::make_pair(name, function));
    this->functionDeclMap.insert(std::make_pair(name, funDecl));
  }
  return true;
}

DESCAM::DataType *DESCAM::FindGlobal::getDataType(const clang::QualType &type) const {
  DESCAM::DataType *dataType;
  if (type->isBooleanType()) {
    dataType = DESCAM::DataTypes::getDataType("bool");
  } else if (type->isUnsignedIntegerType()) {
    dataType = DESCAM::DataTypes::getDataType("unsigned");
  } else if (type->isIntegerType()) {
    dataType = DESCAM::DataTypes::getDataType("int");
  } else TERMINATE("Type: " + type.getAsString() + "not allowed");
  return dataType;
}

const std::map<std::string, DESCAM::Function *> &DESCAM::FindGlobal::getFunctionMap() const {
  return function_map_;
}

const std::map<std::string, const clang::FunctionDecl *> &DESCAM::FindGlobal::getFunctionDeclMap() const {
  return functionDeclMap;
}





