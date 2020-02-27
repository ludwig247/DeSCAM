//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <list>
#include <queue>
#include <set>

#include "PluginFactory.h"
#include "Utilities.h"

namespace SCAM { namespace HLSPlugin { namespace HLS {

    class Optimizer {

    public:
        explicit Optimizer(PropertySuite *propertySuite, Module* module);
        ~Optimizer();

        bool hasOutputReg(DataSignal* dataSignal) ;
        bool isConstant(Variable* variable) const;
        Variable* getCorrespondingRegister(DataSignal* dataSignal) ;

        inline std::set<DataSignal *> getOutputs() const;
        inline std::set<DataSignal *> getInputs() const;
        inline std::set<Variable *> getVariables() const;
        inline std::set<Variable *> getInternalRegisterIn() const;
        inline std::set<Variable *> getInternalRegisterOut() const;
        inline std::map<Port *, std::list<Expr *>> getArrayPorts() const;

    private:
        PropertySuite *propertySuite;
        std::queue<std::vector<Assignment* >> originalCommitmentLists;
        Module* module;

        std::set<DataSignal *> moduleOutputs;
        std::set<DataSignal *> outputs;
        std::set<DataSignal *> inputs;
        std::set<Variable *> variables;
        std::set<Variable *> internalRegisterIn;
        std::set<Variable *> internalRegisterOut;
        std::map<Variable *, DataSignal *> registerToOutputMap;
        std::map<DataSignal *, Variable *> outputToRegisterMap;
        std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;
        std::map<Port *, std::list<Expr *>> arrayPorts;

        std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);

        void replaceDataSignals(const std::map<DataSignal *, DataSignal *> &dataSignalMap);
        void replaceVariables();
        DataSignal* getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);
        void removeRedundantConditions();
        void mapOutputRegistersToOutput();
        void arraySlicing();

        void findOutputs();
        void findInputs();
        void findVariables();
        void findInternalRegisterIn();
        void findInternalRegisterOut();

        template <typename Key, typename Value>
        std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
    };

    std::map<Port *, std::list<Expr *>> Optimizer::getArrayPorts() const {
        return arrayPorts;
    }

    std::set<DataSignal *> Optimizer::getOutputs() const {
        return outputs;
    }

    std::set<DataSignal *> Optimizer::getInputs() const {
        return inputs;
    }

    std::set<Variable *> Optimizer::getVariables() const {
        return variables;
    }

    std::set<Variable *> Optimizer::getInternalRegisterIn() const {
        return internalRegisterIn;
    }

    std::set<Variable *> Optimizer::getInternalRegisterOut() const {
        return internalRegisterOut;
    }

}}}

#endif //SCAM_UTILITIES_HLS_H
