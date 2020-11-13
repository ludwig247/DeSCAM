//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include <PrintStmt.h>
#include <Stmts/StmtCastVisitor.h>
#include "FindVariablesValues.h"
#include "FatalError.h"
#include "Logger/Logger.h"

DESCAM::FindVariablesValues::FindVariablesValues(const std::map<int, DESCAM::CfgNode *> &CFG,
                                                 const std::set<std::string> &readVariablesSet) : readVariablesSet(
    readVariablesSet) {
  std::map<std::string, std::map<std::string, std::set<DESCAM::Expr *>>> compoundVariablesT;
  for (auto node: CFG) {
    auto statement = node.second->getStmt();
    if (statement != nullptr) {
      if (auto assignment = StmtCastVisitor<DESCAM::Assignment>(statement).Get()) {
        if (auto varOp = StmtCastVisitor<DESCAM::VariableOperand>(assignment->getLhs()).Get()) {
          if (this->readVariablesSet.find(varOp->getVariable()->getFullName()) !=
              this->readVariablesSet.end()) { continue; }
          if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
            if (StmtCastVisitor<DESCAM::VariableOperand>(assignment->getRhs()).Get()) {
            } else if (auto compoundValue = StmtCastVisitor<DESCAM::CompoundValue>(assignment->getRhs()).Get()) {
              addSubVariablesToValuesMap(varOp, compoundValue->getValues());
            } else if (auto compoundExpression = StmtCastVisitor<DESCAM::CompoundExpr>(assignment->getRhs()).Get()) {
              addSubVariablesToValuesMap(varOp, compoundExpression->getValueMap());
            } else if (auto arrayExpression = StmtCastVisitor<DESCAM::ArrayExpr>(assignment->getRhs()).Get()) {
              addSubVariablesToValuesMap(varOp, arrayExpression->getValueMap());
            } else {
              TERMINATE(
                  "unexpected rhs of an assignment to a compound or array expression")
            }
          }
          if (auto ternaryExpr = StmtCastVisitor<DESCAM::Ternary>(assignment->getRhs()).Get()) {
            addValToVariableValuesMap(varOp->getVariable(), ternaryExpr->getTrueExpr());
            addValToVariableValuesMap(varOp->getVariable(), ternaryExpr->getFalseExpr());
          } else {
            addValToVariableValuesMap(varOp->getVariable(), assignment->getRhs());
          }
        }
      }
    }
  }

#ifdef DEBUG_FIND_VARIABLES_VALUES
  std::cout << "---------------Find Variables Values---------------" << std::endl;
  for(auto variable : this->variablesValuesMap)
      {   std::cout << "Variable " << variable.first << ": ";
          for(auto value : variable.second){
              std::cout << DESCAM::PrintStmt::toString(value)  << ", " ;
          }
          std::cout << std::endl;
      }
#endif
}

const std::map<std::string, std::set<DESCAM::Expr *>> &DESCAM::FindVariablesValues::getVariableValuesMap() const {
  return this->variablesValuesMap;
}

void DESCAM::FindVariablesValues::addValToVariableValuesMap(DESCAM::Variable *variable, DESCAM::Expr *rhs) {
  if (this->variablesValuesMap.find(variable->getFullName()) !=
      this->variablesValuesMap.end()) {
    bool valAlreadyInSet = false;
    for (auto val : this->variablesValuesMap.at(variable->getFullName())) {
      if (*val == *rhs) {
        valAlreadyInSet = true;
        break;
      }
    }
    if (!valAlreadyInSet) {
      this->variablesValuesMap.at(variable->getFullName()).insert(
          rhs);
    }
  } else {
    std::set<DESCAM::Expr *> valuesSet;
    valuesSet.insert(rhs);
    this->variablesValuesMap.insert(std::make_pair(variable->getFullName(), valuesSet));
  }
}

template<class T>
void DESCAM::FindVariablesValues::addSubVariablesToValuesMap(DESCAM::VariableOperand *varOp,
                                                             const std::map<std::string, T *> &compoundValuesMap) {
  //FIXME this is not covered by our current test cases!
  //TODO Refactor. purpose of loop structure unclear
  auto valItr = compoundValuesMap.begin();
  for (auto &subVar : varOp->getVariable()->getSubVarList()) {
    if (valItr != compoundValuesMap.end()) {
      if (auto subVarVal = StmtCastVisitor<DESCAM::Expr>((*valItr++).second).Get()) {
        addValToVariableValuesMap(subVar, subVarVal);
      }
    }
  }
}