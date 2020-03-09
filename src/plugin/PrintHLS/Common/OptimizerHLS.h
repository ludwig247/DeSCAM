//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <list>
#include <memory>
#include <set>

#include "PluginFactory.h"
#include "PropertySuiteHelper.h"

namespace SCAM { namespace HLSPlugin {

    class OptimizerHLS {

    public:
        OptimizerHLS(std::shared_ptr<PropertySuiteHelper>& propertyHelper, Module* module);
        ~OptimizerHLS() = default;

        bool hasOutputReg(DataSignal* dataSignal) ;
        bool isConstant(Variable* variable) const;
        bool isModuleSignal(DataSignal *dataSignal) const;

        Variable* getCorrespondingRegister(DataSignal* dataSignal) ;

        inline std::set<DataSignal *> getOutputs() const;
        inline std::set<DataSignal *> getInputs() const;
        inline std::set<Variable *> getVariables() const;
        inline std::set<Variable *> getInternalRegisterIn() const;
        inline std::set<Variable *> getInternalRegisterOut() const;
        inline std::set<Variable *> getConstantVariables() const;

        inline std::map<Port *, std::list<Expr *>> getArrayPorts() const;
        inline std::vector<DataSignal *> getCorrespondingTopSignals(DataSignal *dataSignal) const;

    private:
        std::shared_ptr<PropertySuiteHelper> propertySuiteHelper;
        Module* module;

        std::set<DataSignal *> moduleOutputs;
        std::set<DataSignal *> outputs;
        std::set<DataSignal *> inputs;
        std::set<Variable *> variables;
        std::set<Variable *> internalRegisterIn;
        std::set<Variable *> internalRegisterOut;
        std::set<Variable *> constantVariables;

        std::map<Variable *, DataSignal *> registerToOutputMap;
        std::map<DataSignal *, Variable *> outputToRegisterMap;
        std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;

        std::map<Port *, std::list<Expr *>> arrayPorts;

        void findOutputs();
        void findInputs();
        void findVariables();
        void findInternalRegisterIn();
        void findInternalRegisterOut();

        void replaceDataSignals(const std::map<DataSignal *, DataSignal *> &dataSignalMap);
        void replaceVariables();
        void removeRedundantConditions();
        void mapOutputRegistersToOutput();
        void arraySlicing();

        std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);
        DataSignal* getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);

        template <typename Key, typename Value>
        std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);

        template <typename T>
        static std::set<T *> getParents(const std::set<T *> &subVars);
    };

    template <typename T>
    std::set<T *> OptimizerHLS::getParents(const std::set<T *> &subVars) {
        std::set<T *> parents;
        for (const auto& var : subVars) {
            if (var->isSubVar()) {
                if (parents.find(var->getParent()) == parents.end()) {
                    parents.insert(var->getParent());
                }
            } else {
                if (parents.find(var) == parents.end()) {
                    parents.insert(var);
                }
            }
        }
        return parents;
    }

    std::map<Port *, std::list<Expr *>> OptimizerHLS::getArrayPorts() const {
        return arrayPorts;
    }

    std::vector<DataSignal *> OptimizerHLS::getCorrespondingTopSignals(DataSignal *dataSignal) const {
        return moduleToTopSignalMap.at(dataSignal);
    }

    std::set<DataSignal *> OptimizerHLS::getOutputs() const {
        return outputs;
    }

    std::set<DataSignal *> OptimizerHLS::getInputs() const {
        return inputs;
    }

    std::set<Variable *> OptimizerHLS::getVariables() const {
        return variables;
    }

    std::set<Variable *> OptimizerHLS::getInternalRegisterIn() const {
        return internalRegisterIn;
    }

    std::set<Variable *> OptimizerHLS::getInternalRegisterOut() const {
        return internalRegisterOut;
    }

    std::set<Variable *> OptimizerHLS::getConstantVariables() const {
        return constantVariables;
    }

}}

#endif //SCAM_UTILITIES_HLS_H
