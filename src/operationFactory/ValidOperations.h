//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#ifndef PROJECT_REACHABLEOPERATIONS_H
#define PROJECT_REACHABLEOPERATIONS_H

#include <Stmt.h>
#include <Behavior/CfgNode.h>
#include "Behavior/Operation.h"
#include "Behavior/State.h"

namespace SCAM {

    class ValidOperations {
    public:
        explicit ValidOperations(const std::vector<SCAM::Operation*> &operationsList, SCAM::Module * module);
        ~ValidOperations() = default;

        static const bool isOperationReachable(SCAM::Operation* op);
        static const bool isPathReachable(std::vector<SCAM::CfgNode* > operationPath, SCAM::Module * module);
        static const bool isPathReachable(std::vector<SCAM::Stmt* > assumedStatements, std::vector<SCAM::CfgNode* > operationPath, SCAM::Module * module);

        //Getter
        const std::vector<SCAM::Operation*> getOperationsList() const;

    private:
        std::vector<SCAM::Operation*> operationsList;
        SCAM::Module * module;
    };
}

#endif //PROJECT_REACHABLEOPERATIONS_H
