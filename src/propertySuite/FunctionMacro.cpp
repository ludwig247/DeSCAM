//
// Created by deutschmann on 23.11.18.
//

#include "FunctionMacro.h"

SCAM::FunctionMacro::FunctionMacro(const std::string &name, const DataType * type) : AbstractMacro(name, type) {

}

const std::vector<SCAM::Parameter *> &SCAM::FunctionMacro::getParameters() const {
    return parameters;
}

void SCAM::FunctionMacro::setParameters(const std::vector<SCAM::Parameter *> &parameters) {
    FunctionMacro::parameters = parameters;
}

void SCAM::FunctionMacro::addParameter(SCAM::Parameter *parameter) {
    FunctionMacro::parameters.push_back(parameter);
}
