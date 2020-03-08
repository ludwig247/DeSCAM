//
// Created by johannes on 06.03.20.
//

#ifndef DESCAM_OPERATIONHELPER_H
#define DESCAM_OPERATIONHELPER_H

#include "Behavior/Operation.h"

namespace SCAM { namespace HLSPlugin {

class OperationHelper : public Operation {

public:
    void setModifiedCommitmentsList(std::vector<Assignment *> commitmentsList);

    std::vector<Assignment*>& getModifiedCommitmentsList() const;

private:
    std::vector<Assignment*> modifiedCommitentsList;
};

}}

#endif //DESCAM_OPERATIONHELPER_H
