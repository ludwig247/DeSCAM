//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_VHDLWrapperMCO_H
#define SCAM_VHDLWrapperMCO_H

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

                static std::string printRegisterProcess(const std::string &regName,
                                                        const std::string &resetValue,
                                                        const std::string &vldName,
                                                        const std::string &inputName);

                template<typename T>
                std::string printOutputProcesses(const T &signal);

                std::string printNotifyProcesses(const std::shared_ptr<PropertyMacro> &notify);

                void moduleOutputHandling(std::stringstream &ss) override;

                void controlProcess(std::stringstream &ss) override;
            };


            /*
             * Print Processes for the given notify signal
             *
             * The first process is sequential, describing the register to save the signals value
             * The second process is combinatorial, specifying the output of the module
             */
            template<typename T>
            std::string VHDLWrapperMCO::printOutputProcesses(const T &signal) {
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

                ss << printRegisterProcess(registerName, getResetValue(signal), opOutputValidSignal, opOutputSignal);

                ss << "\tprocess (clk, done_sig, " << opOutputValidSignal << ")\n"
                   << "\tbegin\n"
                   << "\t\tif (rst = \'1\') then\n"
                   << "\t\t\t" << signal->getFullName() << " <= " << getResetValue(signal) << ";\n"
                   << "\t\telsif ((done_sig = \'1\') and (" << opOutputValidSignal << " = \'1\')) then\n"
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

#endif //SCAM_VHDLWrapperMCO_H
