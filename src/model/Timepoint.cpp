//
// Created by lucas on 16.01.20.
//

#include "Timepoint.h"

DESCAM::Timepoint::Timepoint(std::string name, DataType *type, ConstValue *initialValue, Timepoint *parent, LocationInfo locationInfo) :
        VariableTemplate(name,
                DataTypes::getDataType("unsigned"),
                         nullptr,
                         nullptr,locationInfo) {

}

void DESCAM::Timepoint::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
