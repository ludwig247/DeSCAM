//
// Created by johannes on 06.03.20.
//

#include <algorithm>

#include "PropertyHelper.h"

using namespace SCAM::HLSPlugin;

PropertyHelper::PropertyHelper(const SCAM::Property& property) :
    Property(property)
{
}

void PropertyHelper::setModifiedCommitmentList(std::vector<Assignment *> &&commitmentList)
{
    modifiedCommitmentList = std::move(commitmentList);
}

std::vector<SCAM::Assignment *> PropertyHelper::getModifiedCommitmentList()
{
    return modifiedCommitmentList;
}
