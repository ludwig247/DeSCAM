//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_VHDLWrapperMultiClkCycle_H
#define SCAM_VHDLWrapperMultiClkCycle_H

#include <memory>
#include <string>

#include "PluginFactory.h"
#include "SignalFactory.h"
#include "VHDLWrapper.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class VHDLWrapperMCO : public VHDLWrapper {

            public:
                VHDLWrapperMCO(
                        Module *module,
                        const std::string &moduleName,
                        std::shared_ptr<PropertySuite> propertySuite,
                        std::shared_ptr<OptimizerHLS> &optimizer
                );

                ~VHDLWrapperMCO() = default;

            private:

                void signals(std::stringstream &ss) override;

                void component(std::stringstream &ss) override;

                void componentInst(std::stringstream &ss) override;

                std::string printMonitorOperation(const Operation &op) override;

                template<typename T>
                std::string printOutputRegister(const T &signal);

                template<typename T>
                std::string printOutputProcess(const T &signal);

                std::string printNotifyRegister(const std::shared_ptr<PropertyMacro> &notify);

                std::string printNotifyProcess(const std::shared_ptr<PropertyMacro> &notify);

                void moduleOutputHandling(std::stringstream &ss) override;

                void controlProcess(std::stringstream &ss) override;
            };


            template<typename T>
            std::string VHDLWrapperMCO::printOutputRegister(const T &signal) {
                std::stringstream ss;

                std::string opOutputSignal;
                std::string registerName;
                const auto &output = (signal->isSubVar() ? signal->getParent() : signal);
                opOutputSignal = (optimizer->hasOutputReg(output)
                              ? ("out_" + optimizer->getCorrespondingRegister(output)->getName())
                              : output->getName());
                if (signal->isSubVar()) {
                    registerName = signal->getFullName("_reg.");
                    opOutputSignal += "_" + signal->getName();
                } else {
                    registerName = signal->getFullName() + "_reg";
                }
                std::string opOutputValidSignal = opOutputSignal + "_vld";
                if (!(optimizer->hasOutputReg(output))) {
                    opOutputSignal += "_out";
                }

                ss << "\tprocess (clk, rst)\n"
                   << "\tbegin\n"
                   << "\t\tif (rst = \'1\') then\n"
                   << "\t\t\t" << registerName << " <= " << getResetValue(signal) << ";\n"
                   << "\t\telsif (clk = \'1\' and clk\'event) then\n"
                   << "\t\t\tif (" << opOutputValidSignal << " = \'1\') then\n"
                   << "\t\t\t\t" << registerName << " <= " << opOutputSignal << ";\n"
                   << "\t\t\tend if;\n"
                   << "\t\tend if;\n"
                   << "\tend process;\n\n";
                return ss.str();
            }

            template<typename T>
            std::string VHDLWrapperMCO::printOutputProcess(const T &signal) {
                std::stringstream ss;

                std::string opOutputSignal;
                std::string registerName;
                const auto &output = (signal->isSubVar() ? signal->getParent() : signal);
                opOutputSignal = (optimizer->hasOutputReg(output)
                              ? ("out_" + optimizer->getCorrespondingRegister(output)->getName())
                              : output->getName());
                if (signal->isSubVar()) {
                    registerName = signal->getFullName("_reg.");
                    opOutputSignal += "_" + signal->getName();
                } else {
                    registerName = signal->getFullName() + "_reg";
                }
                std::string opOutputValidSignal = opOutputSignal + "_vld";
                if (!(optimizer->hasOutputReg(output))) {
                    opOutputSignal += "_out";
                }

                ss << "\tprocess (clk, done_sig, "<< opOutputValidSignal << ")\n"
                   << "\tbegin\n"
                   << "\t\tif (rst = \'1\') then\n"
                   << "\t\t\t" << signal->getFullName() << " <= " << getResetValue(signal) << ";\n"
                   << "\t\telsif ((done_sig = \'1\') and ("<< opOutputValidSignal << " = \'1\')) then\n"
                   << "\t\t\t" << signal->getFullName() << " <= " << opOutputSignal << ";\n"
                   << "\t\telse\n"
                   << "\t\t\t" << signal->getFullName() << " <= " << registerName << ";\n"
                   << "\t\tend if;\n"
                   << "\tend process;\n\n";
                return ss.str();
            }

        }
    }
}

#endif //SCAM_VHDLWrapperMultiClkCycle_H
