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

const std::string getFileName(std::string fileDir) {
    std::string filename = "";
    int i = fileDir.length() - 1;
    while (fileDir[i] != '/' && i >= 0) {
        i--;
    }
    filename = fileDir.substr(i + 1, fileDir.length() - i);
    return filename;
}

void printErrorsJSON(std::string filedir) {
    std::stringstream json;
    if (ErrorMsg::hasError()) {
        auto errorList = SCAM::ErrorMsg::getInstance().getErrorList();
        json << "[\n";
        for (auto errorListItr = errorList.begin(); errorListItr != errorList.end(); errorListItr++) {
            if (!getFileName(errorListItr->file).compare(filedir) && errorListItr->lineNumber != "") {
                if (errorListItr->errorMsgs.size() > 0) {
                    json << "\t{\n";
                    auto errMsgs = errorListItr->errorMsgs;
                    for (auto msgItr = errMsgs.begin(); msgItr != errMsgs.end(); msgItr++) {
                        json << "\t\t" << "file: '" << errorListItr->file << "'\n";
                        json << "\t\t" << "statement: '" << errorListItr->statement << "'\n";
                        json << "\t\t" << "line: '" << errorListItr->lineNumber << "'\n";
                        json << "\t\t" << "severity: '" << msgItr->second << "'\n";
                        json << "\t\t" << "message: '";
                        if (std::next(msgItr, 1) == errMsgs.end()) {
                            json << msgItr->first << "'\n";
                        } else {
                            json << msgItr->first << ", ";
                        }
                    }
                    if (std::next(errorListItr, 1) == errorList.end()) {
                        json << "\t}\n";
                    } else {
                        json << "\t},\n";
                    }
                }
            }
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
    printErrorsJSON(cml.getSourceFile());
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
