//
// Created by johannes on 13.08.19.
//

#include <Optimizer/Optimizer.h>
#include "SynthesisScripts.h"
#include "../HLS/Utilities.h"

using namespace SCAM::HLSPlugin::Script;

SynthesisScripts::SynthesisScripts(std::shared_ptr<OptimizerHLS>& optimizer, HLSOption hlsOption) :
    propertySuite(nullptr),
    currentModule(nullptr),
    optimizer(optimizer),
    hlsOption(hlsOption)
{
}

std::map<std::string, std::string> SynthesisScripts::printModule(Module* module, const std::string &moduleName) {
    std::map<std::string, std::string> pluginOutput;

    this->moduleName = moduleName;
    this->currentModule = module;
    this->propertySuite = module->getPropertySuite();

    pluginOutput.insert(std::make_pair(moduleName + "_run_hls.tcl", synthesisScript()));
    pluginOutput.insert(std::make_pair(moduleName + "_directives.tcl", directivesScript()));

    return pluginOutput;
}


std::string SynthesisScripts::synthesisScript() {
    std::stringstream ss;
    ss << "# Create project\n";
    ss << "open_project -reset synthesis\n\n";
    ss << "# Add design files\n";
    ss << "add_files " << currentModule->getName() << ".cpp\n\n";
    ss << "# Set the top-level function\n";
    ss << "set_top " << moduleName << "_operations\n\n";
    ss << "########## Solution " << 1 << " ##########\n\n";
    ss << "# Create solution" << 1 << "\n";
    ss << "open_solution -reset solution" << 1 << "\n\n";
    ss << "# Define technology and clock rate\n";
    ss << "set_part  {xcvu9p-flga2104-2-i}\n";
    ss << "create_clock -period 20\n\n";
    ss << "# Insert directives\n";
    ss << "source directives/" << moduleName << "_directives.tcl" << "\n\n";
    ss << "# Synthesis\n";
    ss << "csynth_design\n\n";
    ss << "exit";

    return ss.str();
}

std::string SynthesisScripts::directivesScript() {
    std::stringstream ss;

    ss << "config_rtl -reset all -reset_async -reset_level high\n";
    ss << "config_schedule -effort high -relax_ii_for_timing=0 -verbose=0\n";
    ss << "config_bind -effort high\n";

    if (hlsOption == HLSOption::OCCO) {
        ss << "set_directive_latency -max=0 " << moduleName << "_operations\n";
        ss << setDirectiveInterfaceNone();
    } else {
        ss << setDirectiveInterfaceHS();
    }

    ss << setDirectiveAllocation();

    return ss.str();
}

std::string SynthesisScripts::setDirectiveInterfaceNone() {
    std::stringstream ss;
    ss << "set_directive_interface -mode ap_ctrl_none " << moduleName << "_operations\n";
    for (auto &out : HLS::Utilities::getParents(optimizer->getOutputs())) {
        ss << "set_directive_interface -mode ap_none " << moduleName << "_operations " << out->getName() << "\n";
    }
    for (auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "set_directive_interface -mode ap_none " << moduleName << "_operations " << notifySignal->getName() << "\n";
    }
    for (auto &internalRegisterOut : HLS::Utilities::getParents(optimizer->getInternalRegisterOut())) {
        ss << "set_directive_interface -mode ap_none " << moduleName << "_operations out_" << internalRegisterOut->getName() << "\n";
    }
    return ss.str();
}

std::string SynthesisScripts::setDirectiveInterfaceHS() {
    std::stringstream ss;
    ss << "set_directive_interface -mode ap_ctrl_hs operations\n";
    for (auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            ss << "set_directive_interface -mode ap_vld " << moduleName << "_operations " << port.second->getName() << "_sig\n";
        }
    }
    for (auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "set_directive_interface -mode ap_vld " << moduleName << "_operations " << notifySignal->getName() << "\n";
    }
    for (auto &internalRegisterOut : HLS::Utilities::getParents(optimizer->getInternalRegisterOut())) {
        ss << "set_directive_interface -mode ap_vld " << moduleName << "_operations out_" << internalRegisterOut->getName() << "\n";
    }
    return ss.str();
}

std::string SynthesisScripts::setDirectiveAllocation() {
    std::stringstream ss;
    for (auto &function : currentModule->getFunctionMap()) {
        ss << "set_directive_allocation -limit 1 -type function " << moduleName << "_operations " << function.second->getName() << "\n";
    }
    return ss.str();
}

