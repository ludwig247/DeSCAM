//
// Created by lucas on 16.01.20.
//

#include "TimeExpr.h"

SCAM::TimeExpr::TimeExpr(std::string name) :
        VariableTemplate(name, DataTypes::getDataType("unsigned"), nullptr, nullptr) {

}

void SCAM::TimeExpr::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}