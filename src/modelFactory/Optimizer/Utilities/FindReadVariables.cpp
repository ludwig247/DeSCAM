//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include <Stmts/StmtCastVisitor.h>
#include "FindReadVariables.h"

DESCAM::FindReadVariables::FindReadVariables(const std::map<int, CfgNode *> &CFG) : CFG(CFG) {

  for (auto node: CFG) {
    if (auto statement = node.second->getStmt()) {
      if (auto readStmt = StmtCastVisitor<DESCAM::Read>(statement).Get()) {
        //variable operand
        const auto &variable_operand = readStmt->getVariableOperand()->getVariable();
        if (variable_operand->isSubVar()) {
          auto parentVar = variable_operand->getParent();
          this->readVariablesSet.insert(parentVar->getFullName());
          for (auto subVar : parentVar->getSubVarList()) {
            this->readVariablesSet.insert(subVar->getFullName());
          }
        } else if (variable_operand->isCompoundType() || variable_operand->isArrayType()) {
          this->readVariablesSet.insert(variable_operand->getFullName());
          for (auto subVar : variable_operand->getSubVarList()) {
            this->readVariablesSet.insert(subVar->getFullName());
          }
        } else {
          this->readVariablesSet.insert(variable_operand->getFullName());
        }
        //status operand
        if (readStmt->getStatusOperand()) {
          const auto &status_operand = readStmt->getStatusOperand()->getVariable();
          if (status_operand->isSubVar()) {
            auto parentVar = status_operand->getParent();
            this->readVariablesSet.insert(parentVar->getFullName());
            this->readVariablesSet.insert(status_operand->getFullName());
          } else if (status_operand->isCompoundType() || status_operand->isArrayType()) {
            this->readVariablesSet.insert(status_operand->getFullName());
            for (auto subVar : status_operand->getSubVarList()) {
              this->readVariablesSet.insert(subVar->getFullName());
            }
          } else {
            this->readVariablesSet.insert(status_operand->getFullName());
          }
        }
      } else if (auto writeStmt = StmtCastVisitor<DESCAM::Write>(statement).Get()) {
        //status operand
        if (writeStmt->getStatusOperand()) {
          const auto &status_operand = writeStmt->getStatusOperand()->getVariable();
          if (status_operand->isSubVar()) {
            auto parentVar = status_operand->getParent();
            this->readVariablesSet.insert(parentVar->getFullName());
            this->readVariablesSet.insert(status_operand->getFullName());
          } else if (status_operand->isCompoundType() || status_operand->isArrayType()) {
            //Fixme it seems that write and read require the same (currently duplicated) code, except one line is missing here? Is this correct?
            for (auto subVar : status_operand->getSubVarList()) {
              this->readVariablesSet.insert(subVar->getFullName());
            }
          } else {
            this->readVariablesSet.insert(status_operand->getFullName());
          }
        }
      }
    }
  }

#ifdef DEBUG_FIND_READ_VARIABLES
  std::cout << "Read Variables Set:" << std::endl;
  for (const auto &variable : this->readVariablesSet) {
      std::cout << variable << " ";
  }
  std::cout << std::endl;
#endif
}

const std::set<std::string> &DESCAM::FindReadVariables::getReadVariablesSet() const {
  return this->readVariablesSet;
}

