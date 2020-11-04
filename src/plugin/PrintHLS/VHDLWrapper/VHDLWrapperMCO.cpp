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
        ss << "\t\t\t\tactive_operation <= op_" << op.getState()->getName() << "_" << std::to_string(op.getId()) << ";\n";
        ss << "\t\t\t\tnext_state <= st_" << op.getNextState()->getName() << ";\n";
        ss << "\t\t\t\twait_state <= '0';\n";
    } else {
        ss << "\t\t\t\tactive_operation <= op_state_wait;\n";
        ss << "\t\t\t\tnext_state <= st_" << op.getState()->getName() << ";\n";
        ss << "\t\t\t\twait_state <= '1';\n";
    }
    return ss.str();
}

void VHDLWrapperMCO::moduleOutputHandling(std::stringstream &ss) {
    auto printOutputProcess = [&](DataSignal *dataSignal) {
        bool hasOutputReg = optimizer->hasOutputReg(dataSignal);
        ss << "\tprocess (rst, " << dataSignal->getFullName("_") << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t"
           << (hasOutputReg ? optimizer->getCorrespondingRegister(dataSignal)->getFullName() : dataSignal->getFullName(
                   "."))
           << " <= " << getResetValue(dataSignal) << ";\n"
           << "\t\telsif (" << dataSignal->getFullName("_") << "_vld = \'1\') then\n"
           << "\t\t\t"
           << (hasOutputReg ? optimizer->getCorrespondingRegister(dataSignal)->getFullName() : dataSignal->getFullName(
                   "."))
           << " <= " << dataSignal->getFullName("_") << "_out;\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    ss << "\t-- Output_Vld Processes\n";
    for (const auto &out : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        printOutputProcess(out);
    }

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
        bool isEnum = reg->isEnumType();
        std::string signalIn;
        std::string signalOut;
        if (isEnum) {
            signalIn = SignalFactory::vectorToEnum(reg, "", "in_");
            signalOut = SignalFactory::vectorToEnum(reg, "", "out_");
        } else {
            signalIn = "in_" + reg->getFullName("_");
            signalOut = "out_" + reg->getFullName("_");
        }
        ss << "\twith out_" << reg->getFullName("_") << "_vld select\n"
           << "\t\t" << reg->getFullName(".") << " <= " << signalIn << " when '0',\n"
           << "\t\t\t" << signalOut << " when others;\n\n";
    }

    for (const auto &reg : inOutReg) {
        bool isEnum = reg->isEnumType();
        std::string SignalRegister;
        std::string SignalReset;
        if (isEnum) {
            SignalRegister = SignalFactory::enumToVector(reg);
            SignalReset = SignalRegister;
            std::string replaceWith = getResetValue(reg);
            std::string toReplace = reg->getFullName(".");
            SignalReset.replace(SignalReset.find(toReplace), toReplace.length(), replaceWith);
        } else {
            SignalRegister = reg->getFullName(".");
            SignalReset = getResetValue(reg);
        }
        ss << "\tprocess(clk, rst)\n"
           << "\tbegin\n"
           << "\t\tif (rst = '1') then\n"
           << "\t\t\tin_" << reg->getFullName("_") << " <= " << SignalReset << ";\n"
           << "\t\telsif (clk = '1' and clk'event) then\n"
           << "\t\t\tin_" << reg->getFullName("_") << " <= " << SignalRegister << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }

    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tprocess(" << notifySignal->getName() << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (" << notifySignal->getName() << "_vld = '1') then\n"
           << "\t\t\t" << notifySignal->getName() << "_reg <= " << notifySignal->getName() << "_out;\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }

    ss << "\t-- Output Processes\n"
       << "\tprocess(rst, done_sig)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto &registerOutputMap : optimizer->getOutputRegisterMap()) {
        if (optimizer->hasMultipleOutputs(registerOutputMap.second)) {
            for (const auto &output : optimizer->getCorrespondingTopSignals(registerOutputMap.second)) {
                if (output->isCompoundType()) {
                    for (const auto &subVar : output->getSubVarList()) {
                        ss << "\t\t\t" << subVar->getFullName(".") << " <= " << getResetValue(subVar) << ";\n";
                    }
                } else {
                    ss << "\t\t\t" << registerOutputMap.second->getFullName(".") << " <= "
                       << getResetValue(registerOutputMap.second) << ";\n";
                }
            }
        } else {
            if (registerOutputMap.second->isCompoundType()) {
                for (const auto &subVar : registerOutputMap.second->getSubVarList()) {
                    ss << "\t\t\t" << subVar->getFullName(".") << " <= " << getResetValue(subVar) << ";\n";
                }
            } else {
                ss << "\t\t\t" << registerOutputMap.second->getFullName(".") << " <= "
                   << getResetValue(registerOutputMap.second) << ";\n";
            }
        }
    }
    ss << "\t\telsif (done_sig = '1') then\n";
    for (const auto &registerOutputMap : optimizer->getOutputRegisterMap()) {
        if (optimizer->hasMultipleOutputs(registerOutputMap.second)) {
            for (const auto &output : optimizer->getCorrespondingTopSignals(registerOutputMap.second)) {
                ss << "\t\t\t" << output->getFullName() << " <= " << registerOutputMap.first->getFullName() << ";\n";
            }
        } else {
            ss << "\t\t\t" << registerOutputMap.second->getFullName() << " <= "
               << registerOutputMap.first->getFullName() << ";\n";
        }
    }
    ss << "\t\tend if;\n"
       << "\tend process;\n\n";

    ss << "\tprocess(rst, done_sig, idle_sig)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto &commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        // Find and print notifies from reset property commitments
        const auto &assignment = NodePeekVisitor::nodePeekAssignment((*commitment).getStatement());
        if ((assignment != nullptr) && (NodePeekVisitor::nodePeekNotify(assignment->getLhs()) != nullptr)) {
            ss << "\t\t\t" << PrintStmtVHDL::toString((*commitment).getStatement()) << ";\n";
        }
    }
    ss << "\t\telse\n"
       << "\t\t\tif (done_sig = '1') then\n";
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_reg;\n";
    }
    ss << "\t\t\telsif (idle_sig = '1') then\n";
    for (const auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            ss << "\t\t\t\t" << port.second->getName() << "_notify <= '0';\n";
        }
    }
    ss << "\t\t\telse\n";
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= '0';\n";
    }
    ss << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}

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
