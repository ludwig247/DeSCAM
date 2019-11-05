//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_TrueOP_H
#define SCAM_TrueOP_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
//#include <PropertyFactory.h>

class PrintTrueOperation : public PluginFactory {

public:
    PrintTrueOperation() = default;

    ~PrintTrueOperation() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, std::string> printModule(SCAM::Module *node);

    std::string print();

    void findCylces(State2 * current, State2 * start, const std::vector<Operation2*>& opList);

private:
    std::stringstream ss;

    std::string functions();

    std::string convertDataType(std::string dataTypeName);

    std::string location(bool loc);

    std::string propertySuite();

    std::string adjustmacros();

    std::string pipelined();

//        std::string hideConstants();
    SCAM::Module *module;
    std::vector<std::vector<Operation2 *>> cycleMap;

    std::string generatTrueOp(std::vector<Operation2 *> &cycle);

    int cycle_cnt;

    unsigned save = 0;

    bool isRequired(Variable *var, Operation2 *&currentOperation, std::vector<Operation2 *> &cycle);

    bool isRequired2(Variable *const &var, Operation2 *op, std::vector<Operation2 *> &cycle);
};


#endif //SCAM_SYNTHESIZE_H
