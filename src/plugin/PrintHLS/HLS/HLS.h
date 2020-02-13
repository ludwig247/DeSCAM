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

namespace SCAM { namespace HLSPlugin { namespace  HLS {

        class HLS : public PluginFactory, public AbstractVisitor {
        public:
            HLS();
            ~HLS() override = default;

            std::map<std::string, std::string> printModel(Model* model) override;

            inline std::shared_ptr<Optimizer> getOptimizer();

        private:
            std::stringstream ss;

            PropertySuite* propertySuite;
            SCAM::Module* currentModule;

            std::shared_ptr<Optimizer> opt;

            void dataTypes(Model* model);
            void functions();
            void operations();
            void interface();
            void registerVariables();
            void writeToOutput();

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

        std::shared_ptr<Optimizer> HLS::getOptimizer() {
            return opt;
        }

}}}

#endif //SCAM_MAIN_HLS_H
