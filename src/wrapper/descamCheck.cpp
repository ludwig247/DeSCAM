//
// Created by mi-alkoudsi
//


#include <iostream>
#include "CommandLineProcess.h"
#include "PluginFactory.h"
#include "ModelGlobal.h"
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "ErrorMsg.h"


namespace py = pybind11;

void printErrorsJSON() {
    std::stringstream json;
    if (ErrorMsg::hasError()) {
        auto errorList = SCAM::ErrorMsg::getInstance().getErrorList();
        json << "[\n";
        for (const auto &err: errorList) {
            // if (err.file != "" && err.loc != "") {
            if (err.errorLog.size() > 0) {
            json << "\t{\n";
            json << "\t\t" << "file: '" << err.file << "'\n";
            json << "\t\t" << "line: '" << err.loc << "'\n";
            json << "\t\t" << "message: '" << err.msg << "'\n";
            json << "\t\t" << "fix: '";
                for (auto i = 0; i < err.errorLog.size(); i++) {
                    if (i == err.errorLog.size() - 1) {
                        json << err.errorLog[i] << "'\n";
                    } else {
                        json << err.errorLog[i] << ", ";
                    }
                }
                json << "\t}\n";
            }
            //  }
        }
        json << "]\n";
        std::cout << json.str();
    }
}

int descamCheck(int argc, const char *argv[]) {
    //Process commandline data
    CommandLineProcess cml = CommandLineProcess(argc, argv);
    //Create model
    SCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile(), true);
    /* auto errorList = SCAM::ErrorMsg::getInstance().getErrorList();
     if (ErrorMsg::hasError()) {
         std::cout << "" << std::endl;
         std::cout << "Errors: Translation of Stmts" << std::endl;
         std::cout << "----------------------" << std::endl;
         for (const auto &item: errorList) {
             std::cout << "- msg: " << item.msg << std::endl;
             std::cout << "- astMsg: " << item.astMsg << std::endl;
             std::cout << "- file: " << item.file << std::endl;
             std::cout << "- loc: " << item.loc << std::endl;
             for (const auto &log: item.errorLog) {
                 std::cout << "\t" << log << std::endl;
             }
             std::cout << std::endl;
         }
         ErrorMsg::clear();
     }*/
    printErrorsJSON();
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
