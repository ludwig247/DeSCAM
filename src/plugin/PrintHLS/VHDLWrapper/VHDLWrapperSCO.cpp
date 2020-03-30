//
// Created by johannes on 02.11.19.
//

#include "PrintStatement.h"
#include "Utilities.h"
#include "VHDLWrapperSCO.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

VHDLWrapperSCO::VHDLWrapperSCO(
        Module* module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuiteHelper>& propertySuiteHelper,
        std::shared_ptr<OptimizerHLS>& optimizer
)
{
    this->propertySuiteHelper = propertySuiteHelper;
    this->currentModule = module;
    this->moduleName = moduleName;
    this->optimizer = optimizer;
    this->signalFactory = nullptr;
}

std::map<std::string, std::string> VHDLWrapperSCO::printModule() {
    std::map<std::string, std::string> pluginOutput;
    signalFactory = std::make_unique<SignalFactory>(propertySuiteHelper, currentModule, optimizer, true);

    pluginOutput.insert(std::make_pair(moduleName + "_types.vhd", printTypes()));
    pluginOutput.insert(std::make_pair(moduleName + ".vhd", printArchitecture()));

    return pluginOutput;
}

void VHDLWrapperSCO::entity(std::stringstream &ss) {
    // Print Entity
    ss << "entity " + propertySuiteHelper->getName() + "_module is\n";
    ss << "port(\n";

    auto printPortSignals = [&ss](std::set<DataSignal* > const& dataSignals, bool lastSet) {
        for (auto dataSignal = dataSignals.begin(); dataSignal != dataSignals.end(); ++dataSignal) {
            ss << "\t" << (*dataSignal)->getFullName() << ": " << (*dataSignal)->getPort()->getInterface()->getDirection()
               << " " << SignalFactory::getDataTypeName(*dataSignal, false);
            if (std::next(dataSignal) != dataSignals.end() || !lastSet) {
                ss << ";\n";
            }
        }
    };
    printPortSignals(signalFactory->getInputs(), false);
    printPortSignals(signalFactory->getOutputs(), false);
    for (const auto& notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << ": out std_logic;\n";
    }
    for (const auto syncSignal : propertySuiteHelper->getSyncSignals()) {
        ss << "\t" << syncSignal->getName() << ": in std_logic;\n";
    }
    printPortSignals(signalFactory->getControlSignals(), true);

    ss << "\n);\n";
    ss << "end " + propertySuiteHelper->getName() << "_module;\n\n";
}

// Print Signals
void VHDLWrapperSCO::signals(std::stringstream &ss) {
    auto printVars = [&ss](
            std::set<Variable *> const& vars,
            Style const& style,
            std::string const& prefix,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& var : vars) {
            ss << "\tsignal " << prefix << SignalFactory::getName(var, style, suffix) << ": " << SignalFactory::getDataTypeName(var, asVector) << ";\n";
        }
    };

    auto printSignal = [&ss](
            std::set<DataSignal *> const& signals,
            Style const& style,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << SignalFactory::getName(signal, style, suffix) << ": " << SignalFactory::getDataTypeName(signal, asVector) << ";\n";
        }
    };

    ss << "\n\t-- Internal Registers\n";
    printVars(Utilities::getParents(signalFactory->getInternalRegisterOut()),Style::UL, "", "", false);
    printVars(signalFactory->getInternalRegisterOut(),Style::UL, "out_", "", true);

//    ss << "\n\t-- Output Registers\n";
//    printVars(Utilities::getParents(signalFactory->getOutputRegister()), Style::DOT, "", "", false);

    ss << "\n\t-- Operation Module Inputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()),
            Style::UL, "_in", true);
    printVars({signalFactory->getActiveOperation()}, Style::DOT, "", "_in", true);

    ss << "\n\t-- Module Outputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()),
            Style::UL, "_out", true);
    for (const auto& notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
    }

    ss << "\n\t-- Monitor Signals\n";
    printVars(signalFactory->getMonitorSignals(), Style::DOT, "", "", false);

}

void VHDLWrapperSCO::component(std::stringstream& ss) {
    if (emptyModule()) {
        return;
    }

    // Print Component
    ss << "\n\tcomponent " << moduleName << "_operations is\n";
    ss << "\tport(\n";

    auto printComponentSignal = [&ss](std::set<DataSignal *> const& signals, std::string const& prefix) {
        for (const auto& signal : signals) {
            bool vectorType = signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned();
            std::string suffix = (vectorType ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, suffix) << ": "
               << signal->getPort()->getInterface()->getDirection() << " " << SignalFactory::getDataTypeName(signal, true)
               << ";\n";
        }
    };

    auto printComponentVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type=="int" || type=="unsigned" ? "_V" : "");
            ss << "\t\t" << prefix + "_" << SignalFactory::getName(var, Style::UL, suffix) << ": "
               << prefix << " " << SignalFactory::getDataTypeName(var, true)
               << ";\n";
        }
    };

    printComponentSignal(signalFactory->getControlSignals(), "ap_");
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "");
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "");
    printComponentVars(signalFactory->getInternalRegisterOut(), "out");

    for (const auto& notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << ": in " << SignalFactory::getDataTypeName(activeOp, true) << "\n";

    ss << "\t);\n"
       << "\tend component;\n";
}

// Print Component Instantiation
void VHDLWrapperSCO::componentInst(std::stringstream& ss) {
    if (emptyModule()) {
        return;
    }

    ss << "\toperations_inst: " << moduleName << "_operations\n"
       << "\tport map(\n";

    auto printComponentInstSignal = [&ss](
            std::set<DataSignal *> const& signals,
            std::string const& prefix,
            std::string const& suffix) {
        for (const auto& signal : signals) {
            std::string type = signal->getDataType()->getName();
            std::string moduleSuffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, moduleSuffix) << " => "
               << SignalFactory::getName(signal, Style::UL, suffix) << ",\n";
        }
    };

    auto printComponentInstVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(var, Style::UL, suffix) << " => "
               << prefix << SignalFactory::getName(var, Style::UL, "") << ",\n";
        }
    };

    printComponentInstSignal(signalFactory->getControlSignals(), "ap_", "");
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "", "_in");
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "", "_out");
    printComponentInstVars(signalFactory->getInternalRegisterOut(), "out_");

    for (const auto& notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << " => " << SignalFactory::getName(activeOp, Style::UL, "_in") << "\n"
       << "\t);\n\n";
}

// Print Monitor
void VHDLWrapperSCO::monitor(std::stringstream &ss) {
    ss << "\t-- Monitor\n"
       << "\tprocess (" << sensitivityList() << ")\n"
       << "\tbegin\n"
       << "\t\tcase active_state is\n";

    auto printAssumptions = [&ss](std::vector<Expr* > exprList) {
        if (exprList.empty()) {
            ss << "true";
        }
        for (auto expr = exprList.begin(); expr != exprList.end(); ++expr) {
            ss << PrintStatement::toString(*expr, true);
            if (std::next(expr) != exprList.end()) {
                ss << " and ";
            }
        }
    };

    for (const auto& state : currentModule->getFSM()->getStateMap()) {
        if (state.second->isInit()) {
            continue;
        }
        bool noEndIf = false;
        bool skipAssumptions = false;
        ss << "\t\twhen st_" << state.second->getName() << " =>\n";
        auto operations = state.second->getOutgoingOperationsList();
        for (auto operation = operations.begin(); operation != operations.end(); ++operation) {
            if (operation == operations.begin()) {
                if (operations.size() == 1) {
                    noEndIf = true;
                    skipAssumptions = true;
                } else {
                    ss << "\t\t\tif (";
                }
            } else if (std::next(operation) == operations.end()) {
                ss << "\t\t\telse\n";
                skipAssumptions = true;
            } else {
                ss << "\t\t\telsif (";
            }
            if (!skipAssumptions) {
                printAssumptions((*operation)->getAssumptionsList());
                ss << ") then \n";
            }
            if (!(*operation)->IsWait()) {
                const std::string& stateName = (*operation)->getState()->getName();
                const std::string& nextStateName = (*operation)->getNextState()->getName();
                const std::string operationName = stateName + "_" + std::to_string((*operation)->getId());

                ss << "\t\t\t\tactive_operation <= op_" << operationName << ";\n"
                   << "\t\t\t\tnext_state <= st_" << (*operation)->getNextState()->getName() << ";\n";
            } else {
                ss << "\t\t\t\tactive_operation <= op_state_wait;\n";
                ss << "\t\t\t\tnext_state <= active_state;\n";
            }
        }
        if (!noEndIf) {
            ss << "\t\t\tend if;\n";
        }
    }
    ss << "\t\tend case;\n"
       << "\tend process;\n\n";
}

void VHDLWrapperSCO::moduleOutputHandling(std::stringstream& ss)
{
    auto printOutputProcess = [&](DataSignal* dataSignal) {
        bool isEnum = dataSignal->isEnumType();
        bool hasOutputReg = optimizer->hasOutputReg(dataSignal);
        std::string name;
        if (hasOutputReg) {
            name = SignalFactory::getName(optimizer->getCorrespondingRegister(dataSignal), Style::DOT);
        } else {
            name = SignalFactory::getName(dataSignal, Style::DOT);
        }
        ss << "\t" << name << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(dataSignal, "_out") :
                   SignalFactory::getName(dataSignal, Style::UL, "_out"))
           << ";\n";
    };

    auto printOutputProcessRegs = [&](Variable* var) {
        bool isEnum = var->isEnumType();
        ss << "\t" << SignalFactory::getName(var, Style::DOT) << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(var, "", "out_") :
                   "out_" + SignalFactory::getName(var, Style::UL, ""))
           << ";\n";
    };

    ss << "\n\t-- Operation Module Outputs\n";
    for (const auto& out : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        printOutputProcess(out);
    }
    for (const auto& internalRegs : signalFactory->getInternalRegisterOut()) {
        printOutputProcessRegs(internalRegs);
    }

    ss << "\n\t-- Output Register to Output Mapping\n";
    for (const auto& registerOutputMap : optimizer->getOutputRegisterMap()) {
        if (optimizer->hasMultipleOutputs(registerOutputMap.second)) {
            for (const auto& output : optimizer->getCorrespondingTopSignals(registerOutputMap.second)) {
                ss << "\t" << output->getFullName() << " <= " << registerOutputMap.first->getFullName() << ";\n";
            }
        } else {
            ss << "\t" << registerOutputMap.second->getFullName() << " <= " << registerOutputMap.first->getFullName() << ";\n";
        }
    }

    ss << "\n\t-- Notify Signals\n";
    for (const auto& notifySignal : propertySuiteHelper->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_out;\n";
    }

    auto printModuleInputSignals = [this, &ss](std::set<DataSignal*> const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            if (!dataSignal->getPort()->isArrayType()) {
                ss << "\t" << SignalFactory::getName(dataSignal, Style::UL) << "_in <= "
                   << (
                           dataSignal->isEnumType() ?
                           SignalFactory::enumToVector(dataSignal) :
                           SignalFactory::getName(dataSignal, Style::DOT))
                   << ";\n";
            }
        }
    };

    auto printModuleInputVars = [&ss](std::set<Variable*> const& vars, std::string const& prefix, std::string const& suffix) {
        for (const auto& var : vars) {
            ss << "\t" << prefix << SignalFactory::getName(var, Style::UL) << suffix << " <= "
               << (
                       var->isEnumType() ?
                       SignalFactory::enumToVector(var) :
                       SignalFactory::getName(var, Style::DOT))
               << ";\n";
        }
    };

    ss << "\n\t-- Operation Module Inputs\n";
    printModuleInputVars({signalFactory->getActiveOperation()}, "" , "_in");
    printModuleInputSignals(Utilities::getSubVars(signalFactory->getOperationModuleInputs()));

    for (const auto &arrayPort : optimizer->getArrayPorts()) {
        uint32_t exprNumber = 0;
        for (const auto &expr : arrayPort.second) {
            ss << "\t" << arrayPort.first->getDataSignal()->getName() << "_" << exprNumber << "_in"
               << " <= " << arrayPort.first->getDataSignal()->getName() << "(to_integer(unsigned("
               << PrintStatement::toString(expr, false) << ")));\n";
            exprNumber++;
        }
    }
}

void VHDLWrapperSCO::controlProcess(std::stringstream &ss) {
    // Print Control Process
    ss << "\n\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tactive_state <= st_" << propertySuiteHelper->getResetProperty()->getOperation()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tactive_state <= next_state;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}

std::string VHDLWrapperSCO::operationEnum()
{
    std::stringstream ss;
    ss << "\t-- Operations\n"
       << "\ttype " << propertySuiteHelper->getName() << "_operation_t is (";
    auto operations = propertySuiteHelper->getOperationProperties();
    for (auto op : operations) {
        ss << "op_" << op->getName() << ", ";
    }
    ss << "op_state_wait);\n\n";

    return ss.str();
}

bool VHDLWrapperSCO::emptyModule()
{
    return optimizer->getInternalRegisterOut().empty() && optimizer->getOutputs().empty() && propertySuiteHelper->getNotifySignals().empty();
}
