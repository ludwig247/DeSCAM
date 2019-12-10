//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <set>
#include <queue>

#include <PluginFactory.h>

class OptimizeForHLS {

public:
    explicit OptimizeForHLS(PropertySuite *propertySuite, Module* module);
    ~OptimizeForHLS();

    std::set<DataSignal *> getOutputs();
    std::set<DataSignal *> getInputs();
    std::set<Variable *> getVariables();
    std::set<Variable *> getInternalRegisterIn();
    std::set<Variable *> getInternalRegisterOut();

private:
    PropertySuite *propertySuite;
    std::queue<std::vector<Assignment* >> originalCommitmentLists;
    Module* module;

    std::set<DataSignal *> moduleOutputs;
    std::map<Variable *, DataSignal *> registerToOutputMap;
    std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;

    std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);

    void replaceDataSignals(const std::map<DataSignal *, DataSignal *> &dataSignalMap);
    void replaceVariables();
    DataSignal* getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);
    void removeRedundantConditions();
    void mapOutputRegistersToOutput();

    template <typename Key, typename Value>
    std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
};

#endif //SCAM_UTILITIES_HLS_H
