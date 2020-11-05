//
// Created by M.I.Alkoudsi on 22.08.19.
//

#ifndef SCAM_FINDVARIABLESVALUES_H
#define SCAM_FINDVARIABLESVALUES_H

#include "Behavior/CfgNode.h"
#include <set>
#include <utility>
#include <Stmts/StmtAbstractVisitor.h>
#include <Stmts/Stmts_all.h>

namespace DESCAM {
/***
* \brief: Collects values from assignments to variables that are not read in the CFG
* \author:mi-alkoudsi
* \inputs:
*    - std::map<int, DESCAM::CfgNode *> cfg;
*    - std::set<std::string> readVariablesSet;
* \outputs:
*    - std::map<std::string, std::set<DESCAM::Expr *>> variableValuesMap;
* \note: compound expressions values are not stored, only the values of their sub variables.
*/

class FindVariablesValues {

 public:
  FindVariablesValues() = delete;

  FindVariablesValues(const std::map<int, CfgNode *> &CFG, const std::set<std::string> &readVariablesSet);

  ~FindVariablesValues() = default;

  const std::map<std::string, std::set<Expr *>> &getVariableValuesMap() const;

 private:
  std::map<int, CfgNode *> CFG;
  std::map<std::string, std::set<Expr *>> variablesValuesMap;
  std::set<std::string> readVariablesSet;
  template<class T>
  void addSubVariablesToValuesMap(VariableOperand *varOp, const std::map<std::string, T *> &compoundValuesMap);
  void addValToVariableValuesMap(Variable *variable, Expr *rhs);
};
}

#endif //SCAM_FINDVARIABLESVALUES_H
