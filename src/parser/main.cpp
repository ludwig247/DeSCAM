//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include <iostream>
#include "CommandLineProcess.h"
#include "ManageOutput.h"
#include "PluginFactory.h"
#include <ModelGlobal.h>
#include <Logger/ConsoleSink.h>
#include <Logger/FileSink.h>
#include <FatalError.h>

int main(int argc, const char **argv) {
    //Process commandline data
    CommandLineProcess cml = CommandLineProcess(argc, argv);
    //Create model
    std::cout << "==================================================================" << std::endl;
    std::cout << "......................... Creating model ........................." << std::endl;
    std::cout << "------------------------------------------------------------------" << std::endl << std::endl;
    //initialize logger
    SCAM::Logger::addSink(std::make_shared<SCAM::ConsoleSink>());
    SCAM::Logger::setTextFormatOptions(SCAM::TextFormatter::FormatOptions::JSON);
    SCAM::Logger::setFilteringOptions(
    std::set<LoggingFilter::FilterOptions>{LoggingFilter::FilterOptions::showAllMsgs});
    //Create model
    ASSERT_MODEL_CREATION(SCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile()))
    // write log messages to all sinks
    SCAM::Logger::log();

    //Printing options according to commandline styles chosen
    if (cml.getActivePlugins().size() > 0) {
        std::cout << "==================================================================" << std::endl;
        std::cout << "......................... Printing model ........................." << std::endl;
        std::cout << "------------------------------------------------------------------" << std::endl << std::endl;

        for (auto it = cml.getActivePlugins().begin(); it != cml.getActivePlugins().end(); it++) {
            PluginFactory *style = PluginFactory::create(*it);
            if (style != nullptr) {
                std::cout << "=======================================================================\n";
                std::cout << "========================= " << *it << " =========================\n";
                std::cout << "=======================================================================\n\n";
                if (!cml.getOutputDirectory().empty()) {
                    if (createDirectory(*it, cml.getOutputDirectory())) {
                        std::map<std::string, std::string> pluginOutput;
                        pluginOutput = style->printModel(SCAM::ModelGlobal::getModel());
                        createFiles(*it, pluginOutput, cml.getOutputDirectory());
                    } else {
                        std::cout << "Couldn't create directory: " << cml.getOutputDirectory() << "/" << *it << "\n";
                    }
                } else {
                    std::map<std::string, std::string> pluginOutput;
                    pluginOutput = style->printModel(SCAM::ModelGlobal::getModel());
                    printFiles(*it, pluginOutput);
                }
            } else {
                std::cout << "**************** NO SUCH Print Style AVAILABLE !!!! (" << *it << ")\n";
                std::cout << "make sure to include your implementation in Plugin/PluginFactory.cpp\n";
                std::cout << "********************************************************************\n";
            }
        }
    }
    return 0;
}
