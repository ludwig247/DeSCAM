//
// Created by johannes on 06.03.20.
//

#ifndef DESCAM_PROPERTYHELPER_H
#define DESCAM_PROPERTYHELPER_H

#include "Property.h"
#include "OperationHelper.h"

namespace SCAM { namespace HLSPlugin {

class PropertyHelper : public Property {

public:
    OperationHelper* getOperationHelper() const;

private:

};

}}

#endif //DESCAM_PROPERTYHELPER_H
