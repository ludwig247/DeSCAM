//
// Created by johannes on 28.07.19.
//

#ifndef SCAM_MAIN_HLS_H
#define SCAM_MAIN_HLS_H

#include <memory>

#include "Model.h"
#include "OptimizerHLS.h"
#include "PluginFactory.h"
#include "PrintStatement.h"
#include "PrintReset.h"
#include "Utilities.h"

namespace SCAM { namespace HLSPlugin { namespace  HLS {

    struct optional {
        bool valid = false;
        std::string value = "";
    };

    class HLS : public AbstractVisitor {
    public:
        HLS(
                HLSOption hlsOption,
                Module* module,
                const std::string &moduleName,
                std::shared_ptr<PropertySuiteHelper>& propertySuiteHelper,
                std::shared_ptr<OptimizerHLS>& optimizer
        );
        ~HLS() override = default;

        std::map<std::string, std::string> printModule();

    private:
        std::stringstream ss;

        HLSOption hlsOption;
        std::string moduleName;
        Module* currentModule;
        std::shared_ptr<OptimizerHLS> optimizer;
        std::shared_ptr<PropertySuiteHelper> propertySuiteHelper;

        void dataTypes();
        void functions();
        void operations();
        void interface();
        void registerVariables();
        void writeToOutput();
        void waitOperation();
        void printDataType(const DataType *node);

        std::string getVariableReset(Variable* variable);
        std::string getDataSignalReset(DataSignal* dataSignal);
        std::string getValue(Variable* variable);

        template<typename T>
        optional getResetValue(T* signal);

        void visit(Model& node) override {};
        void visit(Module& node) override {};
        void visit(ModuleInstance& node) override {};
        void visit(Port& node) override {};
        void visit(DataSignal& node) override {};
        void visit(Channel& node) override {};
        void visit(Interface& node) override {}
        void visit(Variable& node) override {};
        void visit(FSM& node) override {};
        void visit(DataType& node) override {};
        void visit(Function& node) override;
        void visit(Parameter& node) override {};
        void visit(Timepoint& node) override {};
    };
}}}

#endif //SCAM_MAIN_HLS_H
