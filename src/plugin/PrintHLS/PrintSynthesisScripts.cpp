//
// Created by johannes on 13.08.19.
//

#include "PrintSynthesisScripts.h"


PrintSynthesisScripts::PrintSynthesisScripts() :
    propertySuite(nullptr),
    currentModule(nullptr)
{
}

std::map<std::string, std::string> PrintSynthesisScripts::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->currentModule = module.second;
        this->propertySuite = module.second->getPropertySuite();

        pluginOutput.insert(std::make_pair("run_hls.tcl", synthesisScript()));
        pluginOutput.insert(std::make_pair("directives.tcl", directivesScript()));

    }
    return pluginOutput;
}


std::string PrintSynthesisScripts::synthesisScript() {
    std::stringstream ss;

    //ss << "cd " << functionName << "\n\n";
    ss << "# Create project\n";
    ss << "open_project -reset synthesis\n\n";
    ss << "# Add design files\n";
    ss << "add_files " << currentModule->getName() << ".cpp\n\n";
    ss << "# Set the top-level function\n";
    ss << "set_top operations\n\n";
    ss << "########## Solution " << 1 << " ##########\n\n";
    ss << "# Create solution" << 1 << "\n";
    ss << "open_solution -reset solution" << 1 << "\n\n";
    ss << "# Define technology and clock rate\n";
    ss << "set_part  {xcvu9p-flga2104-2-i}\n";
    ss << "create_clock -period 20\n\n";
    ss << "# Insert directives\n";
    ss << "source directives/directives.tcl" << "\n\n";
    ss << "# Synthesis\n";
    ss << "csynth_design\n\n";
    ss << "exit";

    return ss.str();
}

std::string PrintSynthesisScripts::directivesScript() {
    std::stringstream ss;

    ss << "config_rtl -reset all -reset_async -reset_level high\n";
    ss << "config_schedule -effort medium -relax_ii_for_timing=0 -verbose=0\n";
    ss << "config_bind -effort high\n";
    ss << "set_directive_latency -max=4 -min=4 operations\n";
    ss << setDirectivesReset();
    ss << setDirectiveInterface();
    ss << setDirectiveAllocation();
    // ss << setDirectivePipeline();

    return ss.str();
}

std::string PrintSynthesisScripts::setDirectivesReset() {
    std::stringstream ss;
    ss << "set_directive_interface -mode ap_ctrl_hs operations\n";
    for (auto visibleRegisters : propertySuite->getVisibleRegisters()) {
        ss << "set_directive_reset operations ";
        if (visibleRegisters->isCompoundType()) {
            ss << visibleRegisters->getVariable()->getParent()->getName() << "_"
                << visibleRegisters->getVariable()->getName();
        } else {
            ss << visibleRegisters->getName();
        }
        ss << "\n";
    }
    return ss.str();
}

std::string PrintSynthesisScripts::setDirectiveInterface() {
    std::stringstream ss;
    for (auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            ss << "set_directive_interface -mode ap_none -register operations " << port.second->getName() << "_sig\n";
        }
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "set_directive_interface -mode ap_none -register operations " << notifySignal->getName() << "\n";
    }
    return ss.str();
}

std::string PrintSynthesisScripts::setDirectiveAllocation() {
    std::stringstream ss;
    for (auto &function : currentModule->getFunctionMap()) {
        ss << "set_directive_allocation -limit 1 -type function operations " << function.second->getName() << "\n";
    }
    return ss.str();
}

std::string PrintSynthesisScripts::setDirectivePipeline() {
    std::stringstream ss;
    for (auto &function : currentModule->getFunctionMap()) {
        ss << "set_directive_pipeline " << function.second->getName() << "\n";
    }
    return ss.str();
}

