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
    addUniqueState();
    addOperationProperties();
    addWaitProperties();
}

std::vector<SCAM::Property*> PropertySuiteHelper::getWaitProperties() const
{
    return waitProperties;
}

std::vector<SCAM::Property*> PropertySuiteHelper::getOperationProperties() const
{
    return operationProperties;
}

std::set<SCAM::State *> PropertySuiteHelper::getUniqueStates() const
{
    return uniqueStates;
}

void PropertySuiteHelper::addOperationProperties() {
    for (const auto& property : getProperties()) {
        if (!property->getOperation()->IsWait()) {
            operationProperties.push_back(property);
        }
    }
}

void PropertySuiteHelper::addWaitProperties() {
    for (const auto& property : getProperties()) {
        if (property->getOperation()->IsWait()) {
            waitProperties.push_back(property);
        }
    }
}

void PropertySuiteHelper::addUniqueState() {
    for (const auto &property : getProperties()) {
        uniqueStates.insert(property->getOperation()->getState());
    }
}

std::vector<SCAM::Assignment *> PropertySuiteHelper::getNotifyStatements(Property* property) const
{
    std::vector<SCAM::Assignment *> assignmentList;
    auto temporalExprs = property->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        auto timePoint = PrintStmt::toString(temporalExpr->getTimepointList().back());
        if (timePoint != "t_end") {
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
