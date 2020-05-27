//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/10/19.
//

#ifndef PROJECT_REACHABLEOPERATIONS_H
#define PROJECT_REACHABLEOPERATIONS_H

#include <Stmt.h>
#include <Behavior/CfgNode.h>
#include "Behavior/Operation.h"
#include "Behavior/State.h"

namespace DESCAM {

    class ValidOperations {
    public:
        explicit ValidOperations(const std::vector<DESCAM::Operation*> &operationsList, DESCAM::Module * module);
        ~ValidOperations() = default;

        static const bool isOperationReachable(DESCAM::Operation* op);
        static const bool isPathReachable(std::vector<DESCAM::CfgNode* > operationPath, DESCAM::Module * module);
        static const bool isPathReachable(std::vector<DESCAM::Stmt* > assumedStatements, std::vector<DESCAM::CfgNode* > operationPath, DESCAM::Module * module);

        //Getter
        const std::vector<DESCAM::Operation*> getOperationsList() const;

    private:
        std::vector<DESCAM::Operation*> operationsList;
        DESCAM::Module * module;
    };
}

#endif //PROJECT_REACHABLEOPERATIONS_H
