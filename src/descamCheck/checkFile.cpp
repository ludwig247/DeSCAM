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
    DESCAM::CommandLineProcess cml = DESCAM::CommandLineProcess(argc, argv);
    /* Initialize logger */
    //setting sinks
    std::shared_ptr<DESCAM::LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
    consoleSink->setFormatOption(DESCAM::LoggerFormatter::FormatOption::JSON);
    DESCAM::Logger::addSink(consoleSink);
    //setting filtering options
    DESCAM::Logger::setFilteringOptions(
            std::set<DESCAM::LoggerFilter::FilterOptions>{DESCAM::LoggerFilter::FilterOptions::showSyntaxMsgs,
                                                        DESCAM::LoggerFilter::FilterOptions::showBehaviorMsgs,
                                                        DESCAM::LoggerFilter::FilterOptions::showPortsMsgs,
                                                        DESCAM::LoggerFilter::FilterOptions::showFunctionMsgs}
    );
    //Create model
    ASSERT_MODEL_CREATION(DESCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile(), true))
    // write log messages to all sinks
    DESCAM::Logger::log();
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