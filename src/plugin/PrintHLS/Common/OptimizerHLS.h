//
// Created by johannes on 27.10.19.
//

#ifndef SCAM_UTILITIES_HLS_H
#define SCAM_UTILITIES_HLS_H

#include <list>
#include <memory>
#include <set>

#include "PluginFactory.h"
#include "PropertySuite.h"

namespace DESCAM { namespace HLSPlugin {

    struct optional {
        bool valid = false;
        Assignment* value = nullptr;
    };

    class OptimizerHLS {

    public:
        //OptimizerHLS(std::shared_ptr<PropertySuiteHelper> propertyHelper, Module* module);
        OptimizerHLS(std::shared_ptr<PropertySuite> propertyHelper, Module* module);
        ~OptimizerHLS() = default;

        bool hasOutputReg(DataSignal* dataSignal);
        bool isConstant(Variable* variable) const;
        bool hasMultipleOutputs(DataSignal *dataSignal) const;

        Variable* getCorrespondingRegister(DataSignal* dataSignal) ;
        std::set<Variable *> getOutputRegister();
        std::vector<DataSignal *> getConstantOutputs();

        inline std::set<DataSignal *> getOutputs() const;
        inline std::set<DataSignal *> getInputs() const;
        inline std::set<Variable *> getInternalRegisterIn() const;
        inline std::set<Variable *> getInternalRegisterOut() const;
        inline std::set<Variable *> getConstantVariables() const;

        inline std::map<Port *, std::list<Expr *>> getArrayPorts() const;
        inline std::map<Variable *, DataSignal *> getOutputRegisterMap() const;
        inline std::vector<DataSignal *> getCorrespondingTopSignals(DataSignal *dataSignal) const;

        std::vector<Assignment *> getNotifyStatements(std::shared_ptr<Property> property) const;

        std::vector<Assignment *> getResetStatements();

    private:
        //std::shared_ptr<PropertySuiteHelper> propertySuiteHelper;
        std::shared_ptr<PropertySuite> propertySuite;
        Module* module;

        std::set<DataSignal *> outputs;
        std::set<DataSignal *> inputs;
        std::set<Variable *> variables;
        std::set<Variable *> internalRegisterIn;
        std::set<Variable *> internalRegisterOut;
        std::set<Variable *> constantVariables;

        std::map<Variable *, DataSignal *> registerToOutputMap;
        std::map<DataSignal *, Variable *> outputToRegisterMap;
        std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;
        std::map<DataSignal*, DataSignal*> oldToNewDataSignalMap;

        std::map<std::shared_ptr<Property>, std::vector<Assignment*>> simplifiedCommitments;
    public:
        const std::map<std::shared_ptr<Property>, std::vector<Assignment *>> &getSimplifiedCommitments() const;

    private:

        std::map<Port *, std::list<Expr *>> arrayPorts;

        void findVariables();
        void findOperationModuleSignals();

        void simplifyCommitments();
        bool isSelfAssignments(Assignment *assignment);
        bool isDuplicate(Assignment *newAssignment, std::vector<Assignment *> const& assignmentList);

        optional replaceDataSignals(Assignment *assignment);
        optional replaceByOutputRegister(Assignment *assignment);

        void removeRedundantConditions();
        void mapOutputRegistersToOutput();
        void arraySlicing();

        std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);
        DataSignal* getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);

        template <typename Key, typename Value>
        std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);
    };

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

    std::set<Variable *> OptimizerHLS::getInternalRegisterIn() const {
        return internalRegisterIn;
    }

    std::set<Variable *> OptimizerHLS::getInternalRegisterOut() const {
        return internalRegisterOut;
    }

    std::set<Variable *> OptimizerHLS::getConstantVariables() const {
        return constantVariables;
    }

    std::map<Variable *, DataSignal *> OptimizerHLS::getOutputRegisterMap() const {
        return registerToOutputMap;
    }

}}

#endif //SCAM_UTILITIES_HLS_H
