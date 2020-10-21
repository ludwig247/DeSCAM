//
// Created by tobias on 25.11.19.
//

#include "FindStateName.h"

bool DESCAM::FindStateName::VisitStringLiteral(clang::StringLiteral *stringLiteral) {
  this->state_name_ = stringLiteral->getString().str();
  this->is_set_ = true;
  return false;
}

const std::string &DESCAM::FindStateName::getStateName() const {
  return state_name_;
}

bool DESCAM::FindStateName::hasStateName() const {
  return this->is_set_;
}
bool DESCAM::FindStateName::setup(clang::Stmt *stmt) {
  state_name_ = "";
  is_set_ = false;
  TraverseStmt(stmt);
  return true;
}

