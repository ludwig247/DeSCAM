//
// Created by johannes on 28.11.19.
//

#ifndef DESCAM_HLSMODULE_H
#define DESCAM_HLSMODULE_H

#include <set>
#include <queue>

#include <PluginFactory.h>

class HLSmodule {
public:
    explicit HLSmodule(PropertySuite *propertySuite, Module* module);
    ~HLSmodule() = default;

    std::set<Variable *> getVariables();
    std::set<DataSignal *> getOutputs();
    std::set<DataSignal *> getInputs();

    Variable* getCorrespondingRegister(DataSignal* dataSignal) const;
    std::vector<DataSignal *> getCorrespondingTopSignals(DataSignal* dataSignal) const;
    bool hasOutputReg(DataSignal* dataSignal) const;
    bool isModuleSignal(DataSignal* dataSignal) const;

private:
    PropertySuite *propertySuite;
    Module* module;

    std::set<DataSignal *> moduleOutputs;
    std::map<Variable *, DataSignal *> registerToOutputMap;
    std::map<DataSignal *, Variable *> outputToRegisterMap;
    std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;

    void removeRedundantConditions();
    void mapOutputRegistersToOutput();
    void mapInputRegistersToInputs();
    DataSignal* getCombinedDataSignal(const std::vector<DataSignal*> &dataSignals);
    std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);
};

#endif //DESCAM_HLSMODULE_H
