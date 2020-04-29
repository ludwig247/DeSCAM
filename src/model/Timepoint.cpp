//
// Created by lucas on 16.01.20.
//

#include "Timepoint.h"

SCAM::Timepoint::Timepoint(std::string name, DataType *type, ConstValue *initialValue, Timepoint *parent, LocationInfo locationInfo) :
        VariableTemplate(name,
                DataTypes::getDataType("unsigned"),
                         nullptr,
                         nullptr,locationInfo) {

}

void SCAM::Timepoint::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
