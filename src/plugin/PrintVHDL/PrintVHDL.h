//
// Created by pmorku on 01.12.17.
//

#ifndef PROJECT_PRINTVHDL_H
#define PROJECT_PRINTVHDL_H


#include <sstream>
#include <PluginFactory.h>
#include "Model.h"

using namespace SCAM;

class PrintVHDL : public PluginFactory {
public:
    PrintVHDL() = default;
    ~PrintVHDL() = default;

    std::map<std::string, std::string> printModel(Model *model);

private:
    Module *currentModule;
    PropertySuite *propertySuite;

    std::set<SyncSignal *> sensListSyncSignals;
    std::set<DataSignal *> sensListDataSignals;
    std::set<Variable *> sensListVars;

    std::string printTypes(Model *model);
    std::string functions();
    std::string includes(Model *model);
    std::string entities();
    std::string architecture();
    std::string printAssumptions(const std::vector<Expr *> &exprList);
    std::string printSensitivityList();
    std::string convertDataTypeConstrained(std::string dataTypeName);
    std::string convertDataType(std::string dataTypeName);
    std::string printCombinatorialLogic();
    std::string mainProcess();
    std::string printDataTypes(const DataType *dataType);
    std::string printInternalSignals();

    // helper functions
    void resolveSensitivityList();
};

#endif //PROJECT_PRINTVHDL_H
