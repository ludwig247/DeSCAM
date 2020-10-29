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

bool DESCAM::FindGlobal::setup(clang::TranslationUnitDecl *decl,
                               clang::CompilerInstance *ci,
                               IFindDataFlowFactory *find_data_flow_factory) {
  assert(!(decl == nullptr));
  assert(ci);

  this->find_data_flow_factory_ = find_data_flow_factory;
  this->variable_map_.clear();
  this->function_map_.clear();
  this->function_decl_map_.clear();

  this->decl_ = decl;
  this->ci_ = ci;

  return TraverseDecl(decl);
}

bool DESCAM::FindGlobal::VisitVarDecl(const clang::VarDecl *var_decl) {
  auto type = var_decl->getType();
  auto is_constant = type.isConstant(decl_->getASTContext());
  auto is_built_in = type->isBuiltinType();

  if (is_constant && is_built_in) {
    if (var_decl->getAnyInitializer(var_decl) != nullptr) {

      auto init = var_decl->getAnyInitializer(var_decl)->IgnoreImpCasts();
      if (init->getType()->isBuiltinType()) {
        auto is_unsigned = var_decl->getType()->isUnsignedIntegerType();
        try {
          auto check_for_expr =
              find_data_flow_factory_->create_new(const_cast<clang::Expr *>(init), &module_, ci_, is_unsigned);
          Logger::clear();
          if (check_for_expr->getExpr()) {
            std::string type_name = init->getType().getAsString();
            if (type_name == "_Bool") type_name = "bool";
            else if (var_decl->getType()->isUnsignedIntegerType()) {
              type_name = "unsigned";
            } else if (var_decl->getType()->isIntegerType()) {
              type_name = "int";
            } else TERMINATE("unsupported type")

            std::string name = var_decl->getName().str();
            std::string value = PrintStmt::toString(check_for_expr->getExpr());

            //Determine type
            type = var_decl->getType();
            // TODO init descam_type or restructure code
            DataType *descam_type;
            if (type.isConstant(decl_->getASTContext())) {
              if (type->isBooleanType()) descam_type = DataTypes::getDataType("bool");
              else if (type->isUnsignedIntegerType()) descam_type = DataTypes::getDataType("unsigned");
              else if (type->isIntegerType()) descam_type = DataTypes::getDataType("int");
              else TERMINATE("Type: " + type.getAsString() + " for var " + name + " is not allowed")
            }

            //Types have to be equivalent
            if (check_for_expr->getExpr()->getDataType() == descam_type) {
              //set initial && create new global constant variable
              if (auto init_val = dynamic_cast<ConstValue *>(check_for_expr->getExpr())) {
                auto var = new Variable(name, descam_type, init_val);
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
 * @param function_decl
 * @return
 */

bool DESCAM::FindGlobal::VisitFunctionDecl(const clang::FunctionDecl *function_decl) {
  //Define lambdas for checking the function
  auto valid_result_type = [=]() {
// TODO check for correct call: getCallResultType or getReturnType
    auto res = function_decl->getCallResultType();
    return ((res->isIntegerType() || res->isBooleanType()) && !res->isReferenceType() && !res->isAnyPointerType()
        && !res->isEnumeralType());
  };

  auto valid_function_type = [=]() {
    return function_decl->isGlobal() && function_decl->isUsed() && !function_decl->isCXXClassMember();
  };

  auto valid_parameters = [=]() {
    for (int i = 0; i < function_decl->getNumParams(); i++) {
      auto type = function_decl->getParamDecl((i))->getType().getCanonicalType();
      if (!type->isIntegerType() && !type->isBooleanType() && !type->isEnumeralType()) {
        return false;
      }
    }
    return true;
  };

  //Ensure, that all conditions are correct
  if (valid_result_type() && valid_function_type() && valid_parameters()) {
    std::map<std::string, Parameter *> parameter_map;
    for (int i = 0; i < function_decl->getNumParams(); i++) {
      auto param = function_decl->getParamDecl(i);
      std::string parameter_name = param->getNameAsString();
      auto new_param = new Parameter(parameter_name, getDataType(param->getType()));
      parameter_map.insert(std::make_pair(parameter_name, new_param));
    }
    std::string name = function_decl->getNameAsString();
    // TODO check for correct call: getCallResultType or getReturnType
    auto function = new Function(name, getDataType(function_decl->getCallResultType()), parameter_map);
    this->function_map_.insert(std::make_pair(name, function));
    this->function_decl_map_.insert(std::make_pair(name, function_decl));
  }
  return true;
}

DESCAM::DataType *DESCAM::FindGlobal::getDataType(const clang::QualType &type) {
  DESCAM::DataType *data_type;
  if (type->isBooleanType()) {
    data_type = DESCAM::DataTypes::getDataType("bool");
  } else if (type->isUnsignedIntegerType()) {
    data_type = DESCAM::DataTypes::getDataType("unsigned");
  } else if (type->isIntegerType()) {
    data_type = DESCAM::DataTypes::getDataType("int");
  } else TERMINATE("Type: " + type.getAsString() + "not allowed")
  return data_type;
}

const std::map<std::string, DESCAM::Function *> &DESCAM::FindGlobal::getFunctionMap() const {
  return function_map_;
}

const std::map<std::string, const clang::FunctionDecl *> &DESCAM::FindGlobal::getFunctionDeclMap() const {
  return function_decl_map_;
}





