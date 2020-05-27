//
// Created by johannes on 06.03.20.
//

#include <algorithm>

#include "PropertyHelper.h"

using namespace DESCAM::HLSPlugin;

PropertyHelper::PropertyHelper(std::shared_ptr<Property> property) :
    Property(*property)
{
}

void PropertyHelper::setModifiedCommitmentList(std::vector<Assignment *> &&commitmentList)
{
    modifiedCommitmentList = std::move(commitmentList);
}

std::vector<DESCAM::Assignment *> PropertyHelper::getModifiedCommitmentList()
{
    return modifiedCommitmentList;
}
