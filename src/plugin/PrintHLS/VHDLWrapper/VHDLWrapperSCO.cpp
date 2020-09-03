//
// Created by johannes on 02.11.19.
//

#include "PrintCondition.h"
#include "PrintFunction.h"
#include "Utilities.h"
#include "VHDLWrapperSCO.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

VHDLWrapperSCO::VHDLWrapperSCO(
        Module* module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuite> propertySuite,
        std::shared_ptr<OptimizerHLS>& optimizer
)
{
    this->propertySuite = std::move(propertySuite);
    this->currentModule = module;
    this->moduleName = moduleName;
    this->optimizer = optimizer;
    this->signalFactory = std::make_unique<SignalFactory>(this->propertySuite, currentModule, this->optimizer, true);
}

std::map<std::string, std::string> VHDLWrapperSCO::printModule() {
    std::map<std::string, std::string> pluginOutput;

    pluginOutput.insert(std::make_pair(moduleName + "_types.vhd", printTypes()));
    pluginOutput.insert(std::make_pair(moduleName + ".vhd", printArchitecture()));

    return pluginOutput;
}

// Print Signals
void VHDLWrapperSCO::signals(std::stringstream &ss) {

    auto printVars = [&ss](
            std::set<Variable *> const& vars,
            std::string const& delimiter,
            std::string const& prefix,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& var : vars) {
            ss << "\tsignal " << prefix << var->getFullName(delimiter) << suffix << ": " << SignalFactory::getDataTypeName(var, asVector) << ";\n";
        }
    };

    auto printSignal = [&ss](
            std::set<DataSignal *> const& signals,
            std::string const& delimiter,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << signal->getFullName(delimiter) << suffix << ": " << SignalFactory::getDataTypeName(signal, asVector) << ";\n";
        }
    };

    ss << "\n\t-- Internal Registers\n";
    printVars(Utilities::getParents(signalFactory->getInternalRegisterOut()),"_", "", "", false);
    printVars(signalFactory->getInternalRegisterOut(),"_", "out_", "", true);

    ss << "\n\t-- Operation Module Inputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "_", "_in", true);
    printVars({signalFactory->getActiveOperation()}, ".", "", "_in", true);

    ss << "\n\t-- Module Outputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "_", "_out", true);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
    }

    ss << "\n\t-- Monitor Signals\n";
    printVars(signalFactory->getMonitorSignals(), ".", "", "", false);

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
            ss << "\t\t" << prefix << signal->getFullName("_") << suffix << ": "
               << signal->getPort()->getInterface()->getDirection() << " " << SignalFactory::getDataTypeName(signal, true)
               << ";\n";
        }
    };

    auto printComponentVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type=="int" || type=="unsigned" ? "_V" : "");
            ss << "\t\t" << prefix + "_" << var->getFullName("_") << suffix << ": "
               << prefix << " " << SignalFactory::getDataTypeName(var, true)
               << ";\n";
        }
    };

    printComponentSignal(signalFactory->getControlSignals(), "ap_");
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "");
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "");
    printComponentVars(signalFactory->getInternalRegisterOut(), "out");

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
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
            ss << "\t\t" << prefix << signal->getFullName("_") << moduleSuffix << " => "
               << signal->getFullName("_") << suffix << ",\n";
        }
    };

    auto printComponentInstVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << var->getFullName("_") << suffix << " => "
               << prefix << var->getFullName("_") << ",\n";
        }
    };

    printComponentInstSignal(signalFactory->getControlSignals(), "ap_", "");
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "", "_in");
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "", "_out");
    printComponentInstVars(signalFactory->getInternalRegisterOut(), "out_");

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << " => " << activeOp->getFullName("_") << "_in\n"
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
            ss << PrintCondition::toString(*expr);
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
            name = optimizer->getCorrespondingRegister(dataSignal)->getFullName(".");
        } else {
            name = dataSignal->getFullName(".");
        }
        ss << "\t" << name << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(dataSignal, "_out") :
                   dataSignal->getFullName("_") + "_out")
           << ";\n";
    };

    auto printOutputProcessRegs = [&](Variable* var) {
        bool isEnum = var->isEnumType();
        ss << "\t" << var->getFullName(".") << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(var, "", "out_") :
                   "out_" + var->getFullName("_"))
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
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_out;\n";
    }

    auto printModuleInputSignals = [&ss](std::set<DataSignal*> const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            if (!dataSignal->getPort()->isArrayType()) {
                ss << "\t" << dataSignal->getFullName("_") << "_in <= "
                   << (
                           dataSignal->isEnumType() ?
                           SignalFactory::enumToVector(dataSignal) :
                           dataSignal->getFullName("."))
                   << ";\n";
            }
        }
    };

    auto printModuleInputVars = [&ss](std::set<Variable*> const& vars, std::string const& prefix, std::string const& suffix) {
        for (const auto& var : vars) {
            ss << "\t" << prefix << var->getFullName(".") << suffix << " <= "
               << var->getFullName(".") << ";\n";
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
               << PrintFunction::toString(expr) << ")));\n";
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
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getOperation()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tactive_state <= next_state;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}


bool VHDLWrapperSCO::emptyModule()
{
    return optimizer->getInternalRegisterOut().empty() && optimizer->getOutputs().empty() && propertySuite->getNotifySignals().empty();
}
