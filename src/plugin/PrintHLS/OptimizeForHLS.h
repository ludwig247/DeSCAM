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

    std::set<DataSignal*> getOutputs();
    std::set<Variable* > getVariables();

    inline std::set<DataSignal*> getModuleOutputs() const ;

private:
    PropertySuite *propertySuite;
    std::queue<std::vector<Assignment* > > originalCommitmentLists;
    Module* module;

    std::set<DataSignal*> moduleOutputs;
    std::map<Variable*, DataSignal*> registerToOutputMap;
    std::map<DataSignal*, Variable*> outputToRegisterMap;

    std::multimap<Variable*, DataSignal*> getParentMap(const std::multimap<Variable*, DataSignal*> &multimap);

    void replaceDataSignals(const std::map<DataSignal*, DataSignal*> &dataSignalMap);
    void replaceVariables();
    DataSignal* getCombinedDataSignal(const std::vector<DataSignal*> &dataSignals);
    void removeRedundantConditions();
    void mapOutputRegistersToOutput();

    template <typename Key, typename Value>
    std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
};

inline std::set<DataSignal* > OptimizeForHLS::getModuleOutputs() const {
    return moduleOutputs;
}

#endif //SCAM_UTILITIES_HLS_H
