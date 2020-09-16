//
// Created by deutschmann on 23.11.18.
//

#include "FunctionMacro.h"

DESCAM::FunctionMacro::FunctionMacro(const std::string &name, const DataType * type) : AbstractMacro(name, type) {

}

const std::vector<DESCAM::Parameter *> &DESCAM::FunctionMacro::getParameters() const {
    return parameters;
}

void DESCAM::FunctionMacro::setParameters(const std::vector<DESCAM::Parameter *> &parameters) {
    FunctionMacro::parameters = parameters;
}

void DESCAM::FunctionMacro::addParameter(DESCAM::Parameter *parameter) {
    FunctionMacro::parameters.push_back(parameter);
}
