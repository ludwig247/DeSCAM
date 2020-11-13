//
// Created by johannes on 05.03.20.
//

#include <Stmts/StmtCastVisitor.h>
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "PropertySuiteHelper.h"

using namespace DESCAM::HLSPlugin;

PropertySuiteHelper::PropertySuiteHelper(PropertySuite const &propertySuite) :
    PropertySuite(propertySuite) {
  addOperationProperties();
  addWaitProperties();
}

std::vector<std::shared_ptr<PropertyHelper>> PropertySuiteHelper::getWaitProperties() const {
  return waitProperties;
}

std::vector<std::shared_ptr<PropertyHelper>> PropertySuiteHelper::getOperationProperties() const {
  return operationProperties;
}

void PropertySuiteHelper::addOperationProperties() {
  for (const auto &property : getProperties()) {
    if (!property->getOperation()->IsWait()) {
      operationProperties.push_back(std::make_shared<PropertyHelper>(property));
    }
  }
}

void PropertySuiteHelper::addWaitProperties() {
  for (const auto &property : getProperties()) {
    if (property->getOperation()->IsWait()) {
      waitProperties.push_back(std::make_shared<PropertyHelper>(property));
    }
  }
}

std::vector<DESCAM::Assignment *> PropertySuiteHelper::getNotifyStatements(std::shared_ptr<Property> property) const {
  std::vector<DESCAM::Assignment *> assignmentList;
  auto temporalExprs = property->getCommitmentList();
  for (auto temporalExpr : temporalExprs) {
    auto timePoint = PrintStmt::toString(temporalExpr->getTimepointList().back());
    if (timePoint != "t_end" && temporalExpr->isDuring()) {
      continue;
    }
    if (auto statement = StmtCastVisitor<Assignment>(temporalExpr->getStatement()).Get()) {
      if (StmtCastVisitor<Notify>(statement->getLhs()).Get()) {
        assignmentList.push_back(statement);
      }
    }
  }
  return assignmentList;
}

std::vector<DESCAM::Assignment *> PropertySuiteHelper::getResetStatements() {
  std::vector<DESCAM::Assignment *> assignmentList;
  auto temporalExprs = getResetProperty()->getCommitmentList();
  for (auto temporalExpr : temporalExprs) {
    if (auto statement = StmtCastVisitor<Assignment>(temporalExpr->getStatement()).Get()) {
      assignmentList.push_back(statement);
    }
  }
  return assignmentList;
}
