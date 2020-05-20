//
// Created by wezel on 2/27/20.
//
#include "PrintChannel.h"

std::map<std::string, std::string> PrintChannel::printModel(Model *node) {

    for (auto &module: node->getModules()) {

        this->module = module.second;
        std::stringstream str;

        str << "\n";
        //print Variables
        str << "Variables:\n";
        for (auto var: this->module->getVariableMap()){
            str << var.first << ": " << var.second->getDataType()->getName() << "\n";
        }

        str << "\n";

        //print Functions
        str << "Functions:\n";
        for (auto function: this->module->getFunctionMap()) {
            str << function.first << ":\n";
            auto paramMap = function.second->getParamMap();
            for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
                if (param->second->getDataType()->isCompoundType()) {
                    for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                         iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                        str << param->first << "_" << iterator->first << ": "
                            << convertDataType(iterator->second->getName());
                        if (iterator != --param->second->getDataType()->getSubVarMap().end()) str << ";\n";
                    }
                } else {
                    str << param->first << ": " << convertDataType(param->second->getDataType()->getName());
                }
                if (param != --paramMap.end()) str << ";\n";
            }
            str << "\n";
        }
        pluginOutput.insert(std::make_pair(module.first + "_functions.vhi", str.str()));
    }
    return pluginOutput;
}

std::string PrintChannel::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        return "signed";
    } else {
        return dataTypeName;
    }
}
