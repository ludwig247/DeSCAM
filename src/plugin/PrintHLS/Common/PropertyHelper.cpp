//
// Created by johannes on 06.03.20.
//

#include "PropertyHelper.h"

using namespace SCAM::HLSPlugin;

void PropertyHelper::modifyCommitmentsList(std::vector<Assignment* >&& assignments) {
    if(operationList.size() > 1){
        throw std::runtime_error("Property is build from more then 1 operation. Please use getOperations()");
    }
    Operation operation = *operationList.front();
    operation.setCommitmentsList(assignments);
}