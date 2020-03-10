//
// Created by johannes on 06.03.20.
//

#ifndef DESCAM_PROPERTYHELPER_H
#define DESCAM_PROPERTYHELPER_H

#include "Property.h"

namespace SCAM { namespace HLSPlugin {

class PropertyHelper : public Property {

public:
    explicit PropertyHelper(Property const& property);

    std::vector<Assignment *> getModifiedCommitmentList();

    void setModifiedCommitmentList(std::vector<Assignment *> &&commitmentList);

private:
    std::vector<Assignment *> modifiedCommitmentList = {};
};

}}

#endif //DESCAM_PROPERTYHELPER_H
