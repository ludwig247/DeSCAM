//
// Created by lucas on 16.01.20.
//

#include "Timepoint.h"

SCAM::Timepoint::Timepoint(std::string name, DataType *type, ConstValue *initialValue, Timepoint *parent) :
        VariableTemplate(name,
                DataTypes::getDataType("unsigned"),
                         nullptr,
                         nullptr) {

}

void SCAM::Timepoint::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
