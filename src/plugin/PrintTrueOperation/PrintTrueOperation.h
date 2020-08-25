//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_TrueOP_H
#define SCAM_TrueOP_H

#include "ConditionVisitor2.h"
#include "DatapathVisitor.h"

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"


class PrintTrueOperation : public PluginFactory {

public:
    PrintTrueOperation() = default;

    ~PrintTrueOperation() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, std::string> printModule(DESCAM::Module *node);

    std::string print();

    void findCylces(State * current, State * start, const std::vector<Operation*>& opList);

private:
    std::stringstream ss;

    std::string functions();

    std::string convertDataType(std::string dataTypeName);

    std::string location(bool loc);

    std::string propertySuite();

    std::string adjustmacros();

    std::string pipelined();

//        std::string hideConstants();
    DESCAM::Module *module;
    std::vector<std::vector<Operation *>> cycleMap;

    std::string generatTrueOp(std::vector<Operation *> &cycle);

    int cycle_cnt;

    unsigned save = 0;

    bool isRequired(Variable *var, Operation *&currentOperation, std::vector<Operation *> &cycle);

    bool isRequired2(Variable *const &var, Operation *op, std::vector<Operation *> &cycle);
};


#endif //SCAM_SYNTHESIZE_H
