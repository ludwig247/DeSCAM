//
// Created by tobias on 13.11.19.
//

#include <iostream>
#include <CFGFactory.h>
#include <FunctionFactory.h>
#include "FindGlobal.h"
#include "IFindDataFlow.h"
#include "FindDataFlowFactory.h"
#include "FindNewDatatype.h"
#include "FatalError.h"


DESCAM::FindGlobal::FindGlobal(clang::TranslationUnitDecl *decl, clang::CompilerInstance &ci) : ci(ci) {}

bool DESCAM::FindGlobal::setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance &ci) {
    assert(!(decl == nullptr));

    this->variableMap.clear();
    this->functionMap.clear();
    this->functionDeclMap.clear();

    this->decl = decl;
    return TraverseDecl(decl);
}

bool DESCAM::FindGlobal::VisitVarDecl(const clang::VarDecl *varDecl) {
  auto type = varDecl->getType();
  auto isConst = type.isConstant(decl->getASTContext());
  auto isBuiltIn = type->isBuiltinType();

  if (isConst && isBuiltIn) {
    if (varDecl->getAnyInitializer(varDecl) != nullptr) {

      auto init = varDecl->getAnyInitializer(varDecl)->IgnoreImpCasts();
      if (init->getType()->isBuiltinType()) {
        auto isUnsigned = varDecl->getType()->isUnsignedIntegerType();
        try {
          std::unique_ptr<IFindDataFlow>
              checkForExpr = FindDataFlowFactory::create(const_cast<clang::Expr *>(init), &module, ci, isUnsigned);
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
            if (type.isConstant(decl->getASTContext())) {
              if (type->isBooleanType()) descam_type = DataTypes::getDataType("bool");
              else if (type->isUnsignedIntegerType()) descam_type = DataTypes::getDataType("unsigned");
              else if (type->isIntegerType()) descam_type = DataTypes::getDataType("int");
              else TERMINATE("Type: " + type.getAsString() + " for var " + name + " is not allowed");
            }

            //Types have to be equivalent
            if (checkForExpr->getExpr()->getDataType() == descam_type) {
              //set initval && create new global constant variable
              if (auto initVal = dynamic_cast<ConstValue *>(checkForExpr->getExpr())) {
                auto var = new Variable(name, descam_type, initVal);
                var->setConstant(true);
                this->variableMap.insert(std::make_pair(name, var));
              } else {
                //std::cout << "Global variable: " << name << " with value " << PrintStmt::toString(checkForExpr.getExpr()) << " is not added as global var." << std::endl;
                //std::cout << "The reason is that the initialvalue has to be of constant and simple type without expressions of any kind" << std::endl;
                //FIXME move back to exception
                //TERMINATE("Init value has to be const");
              }
            }
          }
        } catch (std::runtime_error e) {
          //std::cout << e.what() << std::endl;

        }

      }
    }
  }
  return true;
}

const std::map<std::string, DESCAM::Variable *> &DESCAM::FindGlobal::getVariableMap() const {
  return variableMap;
}

/***
 * Find all relevant functions within an AST
 * Return types are only allowed to be bool or (unisgned) int as well as the parameters
 * Furthermore, the parametrs have to be a call by value
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
    this->functionMap.insert(std::make_pair(name, function));
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
    return functionMap;
}

const std::map<std::string, const clang::FunctionDecl *> &DESCAM::FindGlobal::getFunctionDeclMap() const {
    return functionDeclMap;
}





