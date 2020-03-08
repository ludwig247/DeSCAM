//
// Created by johannes on 06.03.20.
//

#include "PropertyHelper.h"

using namespace SCAM::HLSPlugin;

OperationHelper * PropertyHelper::getOperationHelper() const {
    return (OperationHelper* ) getOperation();
}