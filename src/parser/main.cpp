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

    /* Initialize logger */
    //setting sinks
    std::shared_ptr<LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
    consoleSink->setFormatOption(LoggerFormatter::FormatOption::TEXT);
    DESCAM::Logger::addSink(consoleSink);
    std::shared_ptr<LoggerSink> fileSink = std::make_shared<DESCAM::FileSink>(std::string(SCAM_HOME"/bin/LOGS"),true);
    fileSink->setFormatOption(LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(fileSink);
    //setting filtering options
    DESCAM::Logger::setFilteringOptions(
            std::set<LoggerFilter::FilterOptions>{LoggerFilter::FilterOptions::showAllMsgs});
    DESCAM::Logger::setPrintDecorativeFrames();

    //Create model
    ASSERT_MODEL_CREATION(DESCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile()))
    // write log messages to all sinks
    if (DESCAM::Logger::hasFeedback()) {
        DESCAM::Logger::log();
    }
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
                        pluginOutput = style->printModel(DESCAM::ModelGlobal::getModel());
                        createFiles(*it, pluginOutput, cml.getOutputDirectory());
                    } else {
                        std::cout << "Couldn't create directory: " << cml.getOutputDirectory() << "/" << *it << "\n";
                    }
                } else {
                    std::map<std::string, std::string> pluginOutput;
                    pluginOutput = style->printModel(DESCAM::ModelGlobal::getModel());
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
