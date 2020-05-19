//
// Created by mi-alkoudsi
//


#include <iostream>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "CommandLineProcess.h"
#include "CommandLineParameter.h"
#include "ModelGlobal.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "Logger/ConsoleSink.h"

namespace py = pybind11;

int checkFile(int argc, const char *argv[]) {
    //Process commandline data
    SCAM::CommandLineProcess cml = SCAM::CommandLineProcess(argc, argv);
    /* Initialize logger */
    //setting sinks
    std::shared_ptr<SCAM::LoggerSink> consoleSink = std::make_shared<SCAM::ConsoleSink>();
    consoleSink->setFormatOption(SCAM::LoggerFormatter::FormatOption::JSON);
    SCAM::Logger::addSink(consoleSink);
    //setting filtering options
    SCAM::Logger::setFilteringOptions(
            std::set<SCAM::LoggerFilter::FilterOptions>{SCAM::LoggerFilter::FilterOptions::showSyntaxMsgs,
                                                        SCAM::LoggerFilter::FilterOptions::showBehaviorMsgs,
                                                        SCAM::LoggerFilter::FilterOptions::showPortsMsgs,
                                                        SCAM::LoggerFilter::FilterOptions::showFunctionMsgs}
    );
    //Create model
    ASSERT_MODEL_CREATION(SCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile(), true))
    // write log messages to all sinks
    SCAM::Logger::log();
    return 0;
}

PYBIND11_MODULE(descamCheck, pyModule) {
    pyModule.def("descamCheck", [](const std::vector<std::string> &args) {
        std::vector<const char *> cstrs;
        auto binary = "DESCAM";
        cstrs.push_back(binary);
        cstrs.reserve(args.size() + 1);
        for (auto &s : args) cstrs.push_back(s.c_str());
        return checkFile(cstrs.size(), cstrs.data());
    });
}

/*
const std::string getFileName(std::string fileDir) {
    std::string filename = "";
    int i = fileDir.length() - 1;
    while (fileDir[i] != '/' && i >= 0) {
        i--;
    }
    filename = fileDir.substr(i + 1, fileDir.length() - i);
    return filename;
}
*/