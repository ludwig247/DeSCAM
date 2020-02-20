//
// Created by johannes on 28.07.19.
//

#ifndef SCAM_MAIN_HLS_H
#define SCAM_MAIN_HLS_H

#include <memory>
#include <boost/optional.hpp>

#include <PluginFactory.h>

#include "Model.h"
#include "Optimizer.h"
#include "PrintStatement.h"
#include "PrintReset.h"
#include "Utilities.h"

namespace SCAM { namespace HLSPlugin { namespace  HLS {

        class HLS : public AbstractVisitor {
        public:
            explicit HLS(HLSOption hlsOption);
            ~HLS() override = default;

            std::map<std::string, std::string> printModule(Module* module, const std::string &moduleName);

            inline std::shared_ptr<Optimizer> getOptimizer();

        private:
            std::stringstream ss;

            std::string moduleName;
            PropertySuite* propertySuite;
            Module* currentModule;

            std::shared_ptr<Optimizer> opt;
            HLSOption hlsOption;

            void dataTypes();
            void functions();
            void operations();
            void interface();
            void registerVariables();
            void writeToOutput();
            void waitOperation();

            std::string getVariableReset(Variable* variable);
            std::string getDataSignalReset(DataSignal* dataSignal);
            std::string getValue(Variable* variable);

            template<typename T>
            boost::optional<std::string> getResetValue(T* signal);

            void visit(Model& node) override { };
            void visit(SCAM::Module& node) override { };
            void visit(ModuleInstance& node) override { };
            void visit(Port& node) override { };
            void visit(DataSignal& node) override { };
            void visit(Channel& node) override { };
            void visit(Interface& node) override { }
            void visit(Variable& node) override { };
            void visit(FSM& node) override { };
            void visit(DataType& node) override;
            void visit(Function& node) override;
            void visit(Parameter& node) override { };
        };

        // Template Function
        template<typename T>
        boost::optional<std::string> HLS::getResetValue(T* signal)
        {
            for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
                auto printResetValue = PrintReset(commitment, signal->getFullName());
                if (printResetValue.toString()) {
                    return printResetValue.getString();
                }
            }
            return boost::none;
        }

        // Inline Function
        std::shared_ptr<Optimizer> HLS::getOptimizer() {
            return opt;
        }

}}}

#endif //SCAM_MAIN_HLS_H
