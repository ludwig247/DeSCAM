//
// Created by tobias on 19.07.18.
//

#include "Parameter.h"

//DESCAM::DataType *DESCAM::Parameter::getDataType() const {
//    return dataType;
//}

void DESCAM::Parameter::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

DESCAM::Parameter::Parameter(std::string name, DESCAM::DataType *dataType, DESCAM::ConstValue *initialValue,
                           DESCAM::VariableTemplate<DESCAM::Parameter> *parent, LocationInfo locationInfo) : VariableTemplate(name, dataType, initialValue, parent, locationInfo) {

}

bool DESCAM::Parameter::isInput() const {
    return is_input;
}

void DESCAM::Parameter::setIsInput(bool isInput) {
    is_input = isInput;
}


