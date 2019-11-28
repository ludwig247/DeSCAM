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
    ~HLSmodule();

    bool getCorrespondingRegisterName(const std::string& outputName, std::string& registerName);

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

    DataSignal* getCombinedDataSignal(const std::vector<DataSignal*> &dataSignals);
    void removeRedundantConditions();
    void mapOutputRegistersToOutput();

    template <typename Key, typename Value>
    std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
};

inline std::set<DataSignal* > HLSmodule::getModuleOutputs() const {
    return moduleOutputs;
}

#endif //DESCAM_HLSMODULE_H
