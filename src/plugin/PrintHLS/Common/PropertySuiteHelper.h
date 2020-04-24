//
// Created by johannes on 05.03.20.
//

#ifndef DESCAM_PROPERTYSUITEHELPER_H
#define DESCAM_PROPERTYSUITEHELPER_H

#include "PropertySuite.h"
#include "PropertyHelper.h"

namespace SCAM { namespace HLSPlugin {

class PropertySuiteHelper : public PropertySuite {

public:
    explicit PropertySuiteHelper(PropertySuite const& propertySuite);

    std::vector<std::shared_ptr<PropertyHelper>> getWaitProperties() const;
    std::vector<std::shared_ptr<PropertyHelper>> getOperationProperties() const;
    std::vector<Assignment *> getNotifyStatements(std::shared_ptr<Property> property) const;
    std::vector<Assignment *> getResetStatements();

private:
    void addWaitProperties();
    void addOperationProperties();

    std::vector<std::shared_ptr<PropertyHelper>> waitProperties = {};
    std::vector<std::shared_ptr<PropertyHelper>> operationProperties = {};
};

}}

#endif //DESCAM_PROPERTYSUITEHELPER_H
