//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/17/19.
//

#ifndef PROJECT_OPTIMIZEOPERATIONS2_H
#define PROJECT_OPTIMIZEOPERATIONS2_H

#include <Model.h>
#include <Stmt.h>
#include "Behavior/Operation2.h"

namespace SCAM {

class OptimizeOperations2 {
public:
    OptimizeOperations2(const std::vector<SCAM::Operation2*> &opList, SCAM::Module *module);
    ~OptimizeOperations2() = default;

    //Getter
    const std::map<std::string, Variable*> getNewVarMap() const;
    const std::vector<SCAM::Operation2*> getOperationsList() const;

    const std::map<Variable *, bool> &getRemoveGlobalVars() const; //!if true, remove

private:
    std::map<Variable *, bool> removeVars;
    std::map<std::string, Variable*> varMap;
    std::vector<SCAM::Operation2*> operationsList;

};

}

#endif //PROJECT_OPTIMIZEOPERATIONS2_H
