//
// Created by johannes on 05.03.20.
//

#ifndef DESCAM_PROPERTYSUITEHELPER_H
#define DESCAM_PROPERTYSUITEHELPER_H

#include "PropertySuite.h"

namespace SCAM { namespace HLSPlugin {

class PropertySuiteHelper : public PropertySuite {

public:
    explicit PropertySuiteHelper(PropertySuite const& propertySuite);

    std::vector<Property*> getWaitProperties() const;
    std::vector<Property*> getOperationProperties() const;
    std::vector<Assignment *> getNotifyStatements(Property* property) const;

private:
    void addWaitProperties();
    void addOperationProperties();

    std::vector<Property *> waitProperties = {};
    std::vector<Property* > operationProperties = {};
};

}}

#endif //DESCAM_PROPERTYSUITEHELPER_H
