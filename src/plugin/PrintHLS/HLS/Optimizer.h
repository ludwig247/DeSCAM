//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <list>
#include <queue>
#include <set>

#include <PluginFactory.h>

namespace SCAM { namespace HLSPlugin { namespace HLS {

    class Optimizer {

    public:
        explicit Optimizer(PropertySuite *propertySuite, Module* module);
        ~Optimizer();

        std::set<DataSignal *> getOutputs();
        std::set<DataSignal *> getInputs();
        std::set<Variable *> getVariables();
        std::set<Variable *> getInternalRegisterIn();
        std::set<Variable *> getInternalRegisterOut();
        bool isConstant(Variable* variable);

        bool hasOutputReg(DataSignal* dataSignal) ;
        Variable* getCorrespondingRegister(DataSignal* dataSignal) ;

        inline std::map<Port *, std::list<Expr *>> getArrayPorts() const;

    private:
        PropertySuite *propertySuite;
        std::queue<std::vector<Assignment* >> originalCommitmentLists;
        Module* module;

        std::set<DataSignal *> moduleOutputs;
        std::map<Variable *, DataSignal *> registerToOutputMap;
        std::map<DataSignal *, Variable *> outputToRegisterMap;
        std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;
        std::map<Port *, std::list<Expr *>> arrayPorts;

        std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);
        std::set<Port *> setArrayPorts();

        void replaceDataSignals(const std::map<DataSignal *, DataSignal *> &dataSignalMap);
        void replaceVariables();
        DataSignal* getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);
        void removeRedundantConditions();
        void mapOutputRegistersToOutput();
        void arraySlicing();

        template <typename Key, typename Value>
        std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
    };

    std::map<Port *, std::list<Expr *>> Optimizer::getArrayPorts() const {
        return arrayPorts;
    }

}}}

#endif //SCAM_UTILITIES_HLS_H
