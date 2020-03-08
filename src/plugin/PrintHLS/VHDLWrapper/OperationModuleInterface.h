//
// Created by johannes on 28.11.19.
//

#ifndef DESCAM_OPERATIONMODULEINTERFACE_H
#define DESCAM_OPERATIONMODULEINTERFACE_H

#include <list>
#include <set>

#include "../Common/PropertySuiteHelper.h"
#include "PluginFactory.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

        class OperationModuleInterface {
        public:
            explicit OperationModuleInterface(PropertySuiteHelper *propertyHelper, Module *module);

            ~OperationModuleInterface() = default;

            std::set<Variable *> getInternalRegisterIn();
            std::set<Variable *> getInternalRegisterOut();
            std::set<Variable *> getOutputRegister();
            std::set<DataSignal *> getOutputs();
            std::set<DataSignal *> getInputs();
            std::set<Variable *> getVariables();

            bool isConstant(Variable *variable);
            bool hasOutputReg(DataSignal *dataSignal) const;
            bool isModuleSignal(DataSignal *dataSignal) const;
            bool isArrayPort(DataSignal *dataSignal) const;

            Variable *getCorrespondingRegister(DataSignal *dataSignal) const;
            std::vector<DataSignal *> getCorrespondingTopSignals(DataSignal *dataSignal) const;

            inline std::map<Port *, std::list<Expr *>> getArrayPorts() const;

        private:
            PropertySuiteHelper *propertyHelper;
            Module *module;

            std::set<DataSignal *> moduleOutputs;
            std::map<Variable *, DataSignal *> registerToOutputMap;
            std::map<DataSignal *, Variable *> outputToRegisterMap;
            std::map<DataSignal *, std::vector<DataSignal *>> moduleToTopSignalMap;
            std::map<Port *, std::list<Expr *>> arrayPorts;

            void removeRedundantConditions();
            void mapOutputRegistersToOutput();
            void mapInputRegistersToInputs();
            void arraySlicing();

            std::set<Port *> setArrayPorts();
            DataSignal *getCombinedDataSignal(const std::vector<DataSignal *> &dataSignals);
            std::multimap<Variable *, DataSignal *> getParentMap(const std::multimap<Variable *, DataSignal *> &multimap);
        };

        std::map<Port *, std::list<Expr *>> OperationModuleInterface::getArrayPorts() const {
            return arrayPorts;
        }

}}}

#endif //DESCAM_OPERATIONMODULEINTERFACE_H
