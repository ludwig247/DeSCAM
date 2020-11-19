//
// Created by johannes on 13.02.20.
//

#ifndef DESCAM_VHDLWRAPPER_H
#define DESCAM_VHDLWRAPPER_H

#include "PropertySuite.h"
#include "OptimizerHLS.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class VHDLWrapper {
            public:
                VHDLWrapper() = default;

                ~VHDLWrapper() = default;

                std::map<std::string, std::string> printModule();

            protected:

                std::shared_ptr<PropertySuite> propertySuite;
                Module *currentModule;
                std::string moduleName;
                std::shared_ptr<OptimizerHLS> optimizer;
                std::unique_ptr<SignalFactory> signalFactory;

                // Print functions for VHDL type package
                std::string printTypes();

                void operationEnum(std::stringstream &ss);

                static std::string printDataTypes(const DataType *dataType);

                // Print functions for VHDL wrapper
                std::string printArchitecture();

                void entity(std::stringstream &ss);

                void functions(std::stringstream &ss);

                void monitor(std::stringstream &ss);

                void printConstantOutputs(std::stringstream &ss);

                // Utility print functions
                static std::string printAssumptionList(const std::vector<Expr *> &exprList);

                std::string sensitivityList();

                template<typename T>
                std::string getResetValue(const T &signal);

                // SCO/MCO specific functions
                virtual void signals(std::stringstream &ss) = 0;

                virtual void component(std::stringstream &ss) = 0;

                virtual void componentInst(std::stringstream &ss) = 0;

                virtual std::string printMonitorOperation(const Operation &op) = 0;

                virtual void moduleOutputHandling(std::stringstream &ss) = 0;

                virtual void controlProcess(std::stringstream &ss) = 0;
            };

        }
    }
}

#endif //DESCAM_VHDLWRAPPER_H
