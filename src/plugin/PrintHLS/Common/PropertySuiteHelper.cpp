//
// Created by johannes on 05.03.20.
//

#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "PropertySuiteHelper.h"

using namespace SCAM::HLSPlugin;

PropertySuiteHelper::PropertySuiteHelper(PropertySuite const& propertySuite) :
    PropertySuite(propertySuite)
{
    addOperationProperties();
    addWaitProperties();
}

std::vector<PropertyHelper *> PropertySuiteHelper::getWaitProperties() const
{
    return waitProperties;
}

std::vector<PropertyHelper *> PropertySuiteHelper::getOperationProperties() const
{
    return operationProperties;
}

void PropertySuiteHelper::addOperationProperties() {
    for (const auto& property : getProperties()) {
        if (!property->getOperation()->IsWait()) {
            auto operationProperty = new PropertyHelper(*property);
            operationProperties.push_back(operationProperty);
        }
    }
}

void PropertySuiteHelper::addWaitProperties() {
    for (const auto& property : getProperties()) {
        if (property->getOperation()->IsWait()) {
            auto waitProperty = new PropertyHelper(*property);
            waitProperties.push_back(waitProperty);
        }
    }
}

std::vector<SCAM::Assignment *> PropertySuiteHelper::getNotifyStatements(Property* property) const
{
    std::vector<SCAM::Assignment *> assignmentList;
    auto temporalExprs = property->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        auto timePoint = PrintStmt::toString(temporalExpr->getTimepointList().back());
        if (timePoint != "t_end" && temporalExpr->isDuring()) {
            continue;
        }
        if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
            auto statement = dynamic_cast<Assignment *>(temporalExpr->getStatement());
            if (NodePeekVisitor::nodePeekNotify(statement->getLhs())) {
                assignmentList.push_back(statement);
            }
        }
    }
    return assignmentList;
}

std::vector<SCAM::Assignment *> PropertySuiteHelper::getResetStatements() {
    std::vector<SCAM::Assignment *> assignmentList;
    auto temporalExprs = getResetProperty()->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
            auto statement = dynamic_cast<Assignment *>(temporalExpr->getStatement());
            assignmentList.push_back(statement);
        }
    }
    return assignmentList;
}
