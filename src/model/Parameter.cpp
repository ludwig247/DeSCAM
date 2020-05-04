//
// Created by tobias on 19.07.18.
//

#include "Parameter.h"

//SCAM::DataType *SCAM::Parameter::getDataType() const {
//    return dataType;
//}

void SCAM::Parameter::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::Parameter::Parameter(std::string name, SCAM::DataType *dataType, SCAM::ConstValue *initialValue,
                           SCAM::VariableTemplate<SCAM::Parameter> *parent, LocationInfo locationInfo) : VariableTemplate(name, dataType, initialValue, parent, locationInfo) {

}


