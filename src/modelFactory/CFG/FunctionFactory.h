//
// Created by ludwig on 19.07.18.
//

#ifndef PROJECT_FUNCTIONFACTORY_H
#define PROJECT_FUNCTIONFACTORY_H


#include "SectionFactory.h"

namespace SCAM{
    /***
     * \bref Builds a function from a CFG
     *
     */
class FunctionFactory {
public:
    FunctionFactory(const std::map<int, CFGNode *> &controlFlowMap, Function  * function);

    virtual ~FunctionFactory() = default;

    const std::vector<Stmt *> &getStmtList() const;

private:
    std::vector<Stmt*> stmtList;
};


}


#endif //PROJECT_FUNCTIONFACTORY_H
