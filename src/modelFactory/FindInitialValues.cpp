//
// Created by ludwig on 09.11.15.
//

#include <sstream>
#include <Stmts/IntegerValue.h>
#include <PrintStmt.h>
#include <OperationOptimizations/AssignmentOptimizer2.h>
#include "FindInitialValues.h"
#include "FindNewDatatype.h"
#include "IFindDataFlow.h"
#include "FindDataFlowFactory.h"

DESCAM::FindInitialValues::FindInitialValues() {}

void DESCAM::FindInitialValues::setup(clang::CXXRecordDecl *recordDecl,
                                      clang::FieldDecl *fieldDecl,
                                      DESCAM::Module *module,
                                      clang::CompilerInstance *ci) {
  this->clean();
  this->module_ = module;
  this->field_decl_ = fieldDecl;
  this->init_value_ = nullptr;
  this->pass_ = 0;
  this->ci_ = ci;
  TraverseDecl(recordDecl);
}

void DESCAM::FindInitialValues::clean(){
  field_decl_ = nullptr;
  init_value_ = nullptr;
  pass_ = 0;
  module_ = nullptr;
  ci_ = nullptr;
}

bool DESCAM::FindInitialValues::VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) {
  //Check whether constructor body is empty
  int cnt = 0;
  for (auto it = constructorDecl->getBody()->children().first; it != constructorDecl->getBody()->children().second;
       it++) {
    cnt++;
    if (cnt > 2) TERMINATE("The body of the constructor has to remain empty and is not analyzed."
                           "\n Please use a section to initialize your systems instead of the constructor body\n");
  }
  //Only one Constructor allowed
  if (pass_ == 0) {
    //Increase pass
    pass_ = 1;
    //Iterate over each initializer of initializerlist
    for (clang::CXXConstructorDecl::init_iterator initList = constructorDecl->init_begin();
         initList != constructorDecl->init_end(); initList++) {
      clang::CXXCtorInitializer *initializer = *initList;
      //Check whether initializer intializes a member: other possibilites are base classes ...
      if (initializer->isMemberInitializer()) {
        //Name of member
        std::string varName = initializer->getMember()->getNameAsString();
        //Find Variable in Variable(not ports) and assign initial value
        auto variable = field_decl_;
        //If type is compound -> skip
        //Find values
        if (varName == variable->getName().str()) {
          auto type = variable->getType();
          if (!type->isBuiltinType() && !type->isEnumeralType()) {
            std::cout << "-I- Default init value for variable " << varName << std::endl;
            continue;
          }
          //Find value and store in this->value
          //If something goes wrong
          try {
            std::unique_ptr<IFindDataFlow>
                findDataFlow = FindDataFlowFactory::create(initializer->getInit(), module_, ci_);

            auto initExpr = findDataFlow->getExpr();
            if (initExpr != nullptr) {
              //Part start:
              DataType *place_holder_type = const_cast<DataType *>(initExpr->getDataType());
              Variable place_holder_variable("foo", place_holder_type);
              VariableOperand variableOperand(&place_holder_variable);
              auto assignment = Assignment(&variableOperand, findDataFlow->getExpr());
              auto result = DESCAM::AssignmentOptimizer2::optimizeAssignment(&assignment, module_);
              if (auto *valueT = dynamic_cast<ConstValue *>(result->getRhs())) {
                this->init_value_ = valueT;
              } else TERMINATE("All intializer are required to have a constant value");

            } else std::cout << "-I- Default init value for variable " << varName << std::endl;
          } catch (std::runtime_error error) {
            std::string msg = "Error for initialization of variable " + varName;
            TERMINATE(msg + error.what());
          }
        }
      }
    }
  } else TERMINATE("Only one constructor allowed");

  return false;
}

DESCAM::ConstValue *DESCAM::FindInitialValues::getInitValue() {
  return init_value_;
}



