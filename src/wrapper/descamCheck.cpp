//
// Created by mi-alkoudsi
//


#include <iostream>
#include "CommandLineProcess.h"
#include "PluginFactory.h"
#include "ModelGlobal.h"
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "Logger/Logger.h"
#include "Logger/ConsoleSink.h"


namespace py = pybind11;
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

int descamCheck(int argc, const char *argv[]) {
    //Process commandline data
    CommandLineProcess cml = CommandLineProcess(argc, argv);
    //initialize logger
    SCAM::Logger::addSink(std::make_shared<SCAM::ConsoleSink>());
    SCAM::Logger::setTextFormatOptions(SCAM::TextFormatter::FormatOptions::JSON);
    //Create model
    SCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile(), true);
    // write log messages to all sinks
    SCAM::Logger::log();
    return 0;
}

PYBIND11_MODULE(wrapper, pyModule) {
    pyModule.def("descamCheck", [](const std::vector<std::string> &args) {
        std::vector<const char *> cstrs;
        auto binary = "DESCAM";
        cstrs.push_back(binary);
        cstrs.reserve(args.size() + 1);
        for (auto &s : args) cstrs.push_back(s.c_str());
        return descamCheck(cstrs.size(), cstrs.data());
    });
}
