//
// Created by johannes on 02.11.19.
//

#include "PrintStmtVHDL.h"
#include "Utilities.h"
#include "VHDLWrapperSCO.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

VHDLWrapperSCO::VHDLWrapperSCO(
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
void VHDLWrapperSCO::signals(std::stringstream &ss) {

    ss << "\n\t-- Internal Registers\n";
    for (const auto &signal : Utilities::getParents(signalFactory->getInternalRegisterOut())) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "", "", false);
    }

    ss << "\n\t-- Operation Module Inputs\n";
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "", "_in", true);
    }
    ss << SignalFactory::printSignalDefinition(signalFactory->getActiveOperation(), ".", "", "_in", true);

    ss << "\n\t-- Module Outputs\n";
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printSignalDefinition(signal, "_", "", "_out", true);
    }
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
    }

    ss << "\n\t-- Monitor Signals\n";
    for (const auto &signal : signalFactory->getMonitorSignals()) {
        ss << SignalFactory::printSignalDefinition(signal, ".", "", "", false);
    }

}

/*
 * Print Component Declaration
 */
void VHDLWrapperSCO::component(std::stringstream &ss) {

    if (emptyModule()) {
        return;
    }

    ss << "\n\tcomponent " << moduleName << "_operations is\n";
    ss << "\tport(\n";

    for (const auto &signal : signalFactory->getControlSignals()) {
        ss << SignalFactory::printComponentSignal(signal, "ap_", signal->getPort()->getInterface()->getDirection());
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printComponentSignal(signal, "", signal->getPort()->getInterface()->getDirection());
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printComponentSignal(signal, "", signal->getPort()->getInterface()->getDirection());
    }
    for (const auto &signal : signalFactory->getInternalRegisterOut()) {
        ss << SignalFactory::printComponentSignal(signal, "", "out");
    }

    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
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
void VHDLWrapperSCO::componentInst(std::stringstream &ss) {
    if (emptyModule()) {
        return;
    }

    ss << "\toperations_inst: " << moduleName << "_operations\n"
       << "\tport map(\n";

    for (const auto &signal : signalFactory->getControlSignals()) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "ap_", "");
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "", "_in");
    }
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        ss << SignalFactory::printPortMapSignal(signal, "_", "", "_out");
    }
    for (const auto &signal : signalFactory->getInternalRegisterOut()) {
        ss << SignalFactory::printPortMapSignal(signal, ".", "", "");
    }
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
    }

    ss << "\t\t" << signalFactory->getActiveOperation()->getFullName()
       << " => " << signalFactory->getActiveOperation()->getFullName("_") << "_in\n\t);\n\n";
}

/*
 * Print out a single Operation for the monitor
 */
std::string VHDLWrapperSCO::printMonitorOperation(const Operation &op) {
    std::stringstream ss;
    if (!op.IsWait()) {
        ss << "\t\t\t\tactive_operation <= op_" << op.getState()->getName() << "_" << std::to_string(op.getId())
           << ";\n";
        ss << "\t\t\t\tnext_state <= st_" << op.getNextState()->getName() << ";\n";
    } else {
        ss << "\t\t\t\tactive_operation <= op_state_wait;\n";
        ss << "\t\t\t\tnext_state <= active_state;\n";
    }
    return ss.str();
}

/*
 * Print signal assignments outside processes
 */
void VHDLWrapperSCO::moduleOutputHandling(std::stringstream &ss) {

    if (!Utilities::getSubVars(signalFactory->getOperationModuleOutputs()).empty()) {
        ss << "\n\t-- Operation Module Outputs\n";
    }
    for (const auto &output : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        const auto &outputName = (optimizer->hasOutputReg(output) ?
                                  optimizer->getCorrespondingRegister(output)->getFullName() :
                                  output->getFullName());
        ss << "\t" << outputName << " <= " << output->getFullName("_") << "_out;\n";
    }

    if (!optimizer->getOutputRegisterMap().empty()) {
        ss << "\n\t-- Output Register to Output Mapping\n";
    }
    for (const auto &registerOutputMap : optimizer->getOutputRegisterMap()) {
        ss << "\t" << registerOutputMap.second->getFullName() << " <= " << registerOutputMap.first->getFullName()
           << ";\n";
    }

    if (!propertySuite->getNotifySignals().empty()) {
        ss << "\n\t-- Notify Signals\n";
    }
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_out;\n";
    }

    ss << "\n\t-- Operation Module Inputs\n";
    ss << "\t" << signalFactory->getActiveOperation()->getFullName() << "_in <= "
       << signalFactory->getActiveOperation()->getFullName() << ";\n";
    for (const auto &signal : Utilities::getSubVars(signalFactory->getOperationModuleInputs())) {
        ss << "\t" << signal->getFullName("_") << "_in <= " << signal->getFullName() << ";\n";
    }

}

/*
 * Print main sequential process
 */
void VHDLWrapperSCO::controlProcess(std::stringstream &ss) {
    ss << "\n\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getOperation()->getNextState()->getName()
       << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tactive_state <= next_state;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}

/*
 * Check, if module is empty
 */
bool VHDLWrapperSCO::emptyModule() {
    return optimizer->getInternalRegisterOut().empty() && optimizer->getOutputs().empty() &&
           propertySuite->getNotifySignals().empty();
}
