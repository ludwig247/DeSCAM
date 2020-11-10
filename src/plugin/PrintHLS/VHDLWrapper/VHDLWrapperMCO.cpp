//
// Created by johannes on 02.11.19.
//

#include "PrintStmtVHDL.h"
#include "Utilities.h"
#include "VHDLWrapperMCO.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

VHDLWrapperMCO::VHDLWrapperMCO(
        Module *module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuite> propertySuite,
        std::shared_ptr<OptimizerHLS> &optimizer
) {
    this->propertySuite = std::move(propertySuite);
    this->currentModule = module;
    this->moduleName = moduleName;
    this->optimizer = optimizer;
    this->signalFactory = std::make_unique<SignalFactory>(this->propertySuite, currentModule, this->optimizer, false);
}

/*
 * Print Signal Definitions
 */
void VHDLWrapperMCO::signals(std::stringstream &ss) {

    ss << "\n\t-- Internal Registers\n";
    for (const auto &signal : Utilities::getParents(signalFactory->getInternalRegister())) {
        ss << SignalFactory::printSignalDefinition(signal, ".", "", "", false, false);
    }
    for (const auto &signal : signalFactory->getInternalRegisterIn()) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "in_", "", true, false);
    }
    for (const auto &signal : signalFactory->getInternalRegisterOut()) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "out_", "", true, true);
    }

    ss << "\n\t-- Module Inputs\n";
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "", "_in", true, false);
    }
    ss << SignalFactory::printSignalDefinition(signalFactory->getActiveOperation(), ".", "", "_in", true, false);

    ss << "\n\t-- Module Outputs\n";
    for (const auto &output : signalFactory->getOutputs()) {
        ss << "\tsignal " << output->getName() << "_reg : " << SignalFactory::convertDataTypeName(output->getDataType()) << ";\n";
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "", "_out", true, true);
    }
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
        ss << "\tsignal " << notifySignal->getName() << "_vld: std_logic;\n";
        ss << "\tsignal " << notifySignal->getName() << "_reg: std_logic;\n";
    }

    ss << "\n\t-- Handshaking Protocol Signals (Communication between top and operations_inst)\n";
    for (const auto &signal : signalFactory->getHandshakingProtocolSignals()) {
        ss << SignalFactory::printSignalDefinition(signal, ".", "", "_sig", false, false);
    }
    ss << "\n\t-- Monitor Signals\n";
    for (const auto &signal : signalFactory->getMonitorSignals()) {
        ss << SignalFactory::printSignalDefinition(signal, ".", "", "", false, false);
    }
}

/*
 * Print Component Declaration
 */
void VHDLWrapperMCO::component(std::stringstream &ss) {

    ss << "\n\tcomponent " << moduleName << "_operations is\n";
    ss << "\tport(\n";

    for (const auto &signal : signalFactory->getControlSignals()) {
        ss << SignalFactory::printComponentSignal(signal, "ap_", signal->getPort()->getInterface()->getDirection(),
                                                  false);
    }
    for (const auto &signal : signalFactory->getHandshakingProtocolSignals()) {
        ss << SignalFactory::printComponentSignal(signal, "ap_", signal->getPort()->getInterface()->getDirection(),
                                                  false);
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printComponentSignal(signal, "", signal->getPort()->getInterface()->getDirection(), false);
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printComponentSignal(signal, "", signal->getPort()->getInterface()->getDirection(), true);
    }
    for (const auto &signal : signalFactory->getInternalRegisterIn()) {
        ss << SignalFactory::printComponentSignal(signal, "in_", "in", false);
    }
    for (const auto &signal : signalFactory->getInternalRegisterOut()) {
        ss << SignalFactory::printComponentSignal(signal, "out_", "out", true);
    }

    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
        ss << "\t\t" << notifySignal->getName() << "_ap_vld: out std_logic;\n";
    }

    const auto &activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << ": in "
       << SignalFactory::convertDataTypeName(activeOp->getDataType(), true) << "\n";

    ss << "\t);\n"
       << "\tend component;\n";
}

/*
 * Print port map of operation component
 */
void VHDLWrapperMCO::componentInst(std::stringstream &ss) {

    ss << "\toperations_inst: " << moduleName << "_operations\n"
       << "\tport map(\n";

    for (const auto &signal : signalFactory->getControlSignals()) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "ap_", "", false);
    }
    for (const auto &signal : signalFactory->getHandshakingProtocolSignals()) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "ap_", "_sig", false);
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "", "_in", false);
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "", "_out", true);
    }
    for (const auto &signal : signalFactory->getInternalRegisterIn()) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "in_", "", false);
    }
    for (const auto &signal : signalFactory->getInternalRegisterOut()) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "out_", "", true);
    }

    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
        ss << "\t\t" << notifySignal->getName() << "_ap_vld  => " << notifySignal->getName() << "_vld,\n";
    }

    const auto &activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << " => " << activeOp->getFullName("_") << "_in\n"
       << "\t);\n\n";
}

/*
 * Print out a single Operation for the monitor
 */
std::string VHDLWrapperMCO::printMonitorOperation(const Operation &op) {
    std::stringstream ss;
    if (!op.IsWait()) {
        ss << "\t\t\t\tactive_operation <= op_" << op.getState()->getName() << "_" << std::to_string(op.getId())
           << ";\n";
        ss << "\t\t\t\tnext_state <= st_" << op.getNextState()->getName() << ";\n";
        ss << "\t\t\t\twait_state <= '0';\n";
    } else {
        ss << "\t\t\t\tactive_operation <= op_state_wait;\n";
        ss << "\t\t\t\tnext_state <= st_" << op.getState()->getName() << ";\n";
        ss << "\t\t\t\twait_state <= '1';\n";
    }
    return ss.str();
}

/*
 * Print a sequential process
 *
 * Used for Output Registers
 */
std::string VHDLWrapperMCO::printRegisterProcess(const std::string &regName,
                                                 const std::string &resetValue,
                                                 const std::string &vldName,
                                                 const std::string &inputName) {
    std::stringstream ss;
    ss << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = \'1\') then\n"
       << "\t\t\t" << regName << " <= " << resetValue << ";\n"
       << "\t\telsif (clk = \'1\' and clk\'event) then\n"
       << "\t\t\tif (" << vldName << " = \'1\') then\n"
       << "\t\t\t\t" << regName << " <= " << inputName << ";\n"
       << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
    return ss.str();
}

/*
 * Print Processes for the given notify signal
 *
 * The first process is sequential, describing the register to save the signals value
 * The second process is combinatorial, specifying the output of the module
 */
std::string VHDLWrapperMCO::printNotifyProcesses(const std::shared_ptr<PropertyMacro> &notify) {

    std::stringstream ss;
    std::string resetValue = SignalFactory::findAssignedValue(propertySuite->getResetProperty(), notify);

    // Print sequential process
    ss << printRegisterProcess(notify->getName() + "_reg",
                               resetValue,
                               notify->getName() + "_vld",
                               notify->getName() + "_out");

    // Find wait states for which the notify signal is active
    std::vector<std::string> activeStates;
    for (const auto &waitProperty : propertySuite->getWaitProperties()) {
        std::string assignedValue = SignalFactory::findAssignedValue(waitProperty, notify);
        if (assignedValue == "\'1\'") {
            activeStates.push_back(waitProperty->getOperation()->getState()->getName());
        }
    }

    // Print combinatorial process
    ss << "\tprocess (rst, done_sig, "
       << (activeStates.empty() ? "" : "idle_sig, ")
       << notify->getName() << "_vld)\n"
       << "\tbegin\n"
       << "\t\tif (rst = \'1\') then\n"
       << "\t\t\t" << notify->getName() << " <= " << resetValue << ";\n"
       << "\t\telsif (done_sig = \'1\') then\n"
       << "\t\t\tif (" << notify->getName() << "_vld = \'1\') then\n"
       << "\t\t\t\t" << notify->getName() << " <= " << notify->getName() << "_out;\n"
       << "\t\t\telse\n"
       << "\t\t\t\t" << notify->getName() << " <= " << notify->getName() << "_reg;\n"
       << "\t\t\tend if;\n";

    if (!(activeStates.empty())) {
        ss << "\t\telsif (idle_sig = \'1\') then\n";
        ss << "\t\t\tif ";
        if (activeStates.size() > 1) {
            ss << "(";
        }
        for (auto state = activeStates.begin(); state != activeStates.end(); state++) {
            ss << "(active_state = st_" << (*state) << ")";
            if (state != (activeStates.end() - 1)) {
                ss << " or ";
            }
        }
        if (activeStates.size() > 1) {
            ss << ")";
        }
        ss << " then\n"
           << "\t\t\t\t" << notify->getName() << " <= \'1\';\n"
           << "\t\t\telse\n"
           << "\t\t\t\t" << notify->getName() << " <= \'0\';\n"
           << "\t\t\tend if;\n";
    }

    ss << "\t\telse\n"
       << "\t\t\t" << notify->getName() << " <= \'0\';\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
    return ss.str();
}

/*
 * Print Processes for Module Registers and Outputs
 */
void VHDLWrapperMCO::moduleOutputHandling(std::stringstream &ss) {

    ss << "\t-- Output Processes\n";
    for (const auto &output : signalFactory->getOutputs()) {
        if (output->isCompoundType()) {
            for (const auto &subVar : output->getSubVarList()) {
                ss << printOutputProcesses(subVar);
            }
        } else {
            ss << printOutputProcesses(output);
        }
    }

    ss << "\t-- Notify Processes\n";
    for (const auto &notify : propertySuite->getNotifySignals()) {
        ss << printNotifyProcesses(notify);
    }


    ss << "\t-- Internal Variables\n";
    auto printOutputProcessRegs = [&](Variable *var) {
        ss << "\tprocess (rst, out_" << var->getFullName("_") << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << var->getFullName(".") << " <= " << getResetValue(var) << ";\n"
           << "\t\telsif (out_" << var->getFullName("_") << "_vld = \'1\') then\n"
           << "\t\t\t" << var->getFullName(".") << " <= out_" << var->getFullName("_") << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };

    std::set<Variable *> inOutReg;
    for (const auto &internalRegsOut : signalFactory->getInternalRegisterOut()) {
        auto internalRegsIn = signalFactory->getInternalRegisterIn();
        if (internalRegsIn.find(internalRegsOut) != internalRegsIn.end()) {
            inOutReg.insert(internalRegsOut);
            continue;
        }
        printOutputProcessRegs(internalRegsOut);
    }

    for (const auto &reg : inOutReg) {
        std::string signalIn = "in_" + reg->getFullName("_");
        std::string signalOut = "out_" + reg->getFullName("_");
        ss << "\twith out_" << reg->getFullName("_") << "_vld select\n"
           << "\t\t" << reg->getFullName(".") << " <= " << signalIn << " when '0',\n"
           << "\t\t\t" << signalOut << " when others;\n\n";
    }

    for (const auto &reg : inOutReg) {
        ss << "\tprocess(clk, rst)\n"
           << "\tbegin\n"
           << "\t\tif (rst = '1') then\n"
           << "\t\t\tin_" << reg->getFullName("_") << " <= " << getResetValue(reg) << ";\n"
           << "\t\telsif (clk = '1' and clk'event) then\n"
           << "\t\t\tin_" << reg->getFullName("_") << " <= " << reg->getFullName(".") << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }
}

/*
 * Print sequential control process
 */
void VHDLWrapperMCO::controlProcess(std::stringstream &ss) {

    ss << "\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tstart_sig <= '0';\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getOperation()->getNextState()->getName()
       << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tif ((idle_sig = '1' or ready_sig = '1') and wait_state = '0') then\n"
       << "\t\t\t\tstart_sig <= '1';\n"
       << "\t\t\t\tactive_state <= next_state;\n";

    ss << "\t\t\t\tactive_operation_in <= active_operation;\n";
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << "\t\t\t\t" << signal->getFullName("_") << "_in <= " << signal->getFullName(".") << ";\n";
    }

    for (auto &&internalRegIn : signalFactory->getInternalRegisterIn()) {
        auto internalRegsOut = signalFactory->getInternalRegisterOut();
        if (internalRegsOut.find(internalRegIn) != internalRegsOut.end()) {
            continue;
        }
        ss << "\t\t\t\tin_" << internalRegIn->getFullName("_") << " <= " << internalRegIn->getFullName(".") << ";\n";
    }

    for (const auto &arrayPort : optimizer->getArrayPorts()) {
        uint32_t exprNumber = 0;
        for (const auto &expr : arrayPort.second) {
            ss << "\t\t\t\t" << arrayPort.first->getDataSignal()->getName() << "_" << exprNumber << "_in"
               << " <= " << arrayPort.first->getDataSignal()->getName() << "(to_integer(unsigned("
               << PrintStmtVHDL::toString(expr) << ")));\n";
            exprNumber++;
        }
    }

    ss << "\t\t\telsif ((idle_sig = '1' or  ready_sig = '1') and wait_state = '1') then\n"
       << "\t\t\t\tstart_sig <= '0';\n"
       << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}
