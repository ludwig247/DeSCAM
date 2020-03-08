//
// Created by johannes on 05.03.20.
//

#ifndef DESCAM_PROPERTYSUITEHELPER_H
#define DESCAM_PROPERTYSUITEHELPER_H

#include "PropertySuite.h"
#include "OperationHelper.h"

namespace SCAM { namespace HLSPlugin {

class PropertySuiteHelper : public PropertySuite {

public:
    PropertySuiteHelper(PropertySuite const& propertySuite);

    std::vector<Property*> getWaitProperties() const;
    std::vector<Property*> getOperationProperties() const;
    std::set<State* > getUniqueStates() const;
    std::vector<Assignment *> getNotifyStatements(Property* property) const;

private:
    void addWaitProperties();
    void addOperationProperties();
    void addUniqueState();

    std::vector<Property *> waitProperties = {};
    std::vector<Property* > operationProperties = {};
    std::set<State* > uniqueStates = {};
};

}}

#endif //DESCAM_PROPERTYSUITEHELPER_H
