//
// Created by tobias on 29.04.16.
//

#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <Stmts/EnumValue.h>
#include <Stmts/CompoundValue.h>
#include <assert.h>
#include <Stmts/UnsignedValue.h>
#include "DataType.h"

void SCAM::DataType::addSubVar(std::string subVarName, SCAM::DataType *subVarType) {
    //if(this->isEnumType()) throw std::runtime_error("DataType can either be enum or compound");
    this->subVarMap.insert(std::make_pair(subVarName,subVarType));
}

const bool SCAM::DataType::isCompoundType() const {
    return !this->subVarMap.empty();
}

void SCAM::DataType::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

const std::map<std::string, SCAM::DataType *> &SCAM::DataType::getSubVarMap() const {
    return subVarMap;
}

const std::map<std::string, int> &SCAM::DataType::getEnumValueMap() const {
    return enumValueMap;
}

void SCAM::DataType::addEnumValue(std::string enumValue) {
    if(this->isCompoundType()) throw std::runtime_error("DataType can either be enum or compound");
    this->enumValueMap.insert(std::make_pair(enumValue,this->enumValueMap.size()));

}

const bool SCAM::DataType::isEnumType() const {
    return !this->enumValueMap.empty();
}

const bool SCAM::DataType::isBuiltInType() const {
    return !(this->isEnumType() || this->isCompoundType());
}

const bool SCAM::DataType::isVoid() const {
    return this->getName()=="void";
}

SCAM::ConstValue *SCAM::DataType::getDefaultVal()  {
    ConstValue * initVal;
    if (this->getName() == "int") initVal = new IntegerValue(0);
    else if (this->getName() == "bool") initVal = new BoolValue(false);
    else if (this->getName() == "unsigned") initVal = new UnsignedValue(0);
    else if (this->isEnumType()) {
        auto firstEnumVal = *(this->getEnumValueMap().begin());
        initVal = new EnumValue(firstEnumVal.first, this);
    } else if (this->isCompoundType()) {
        std::vector<ConstValue*> compoundValueList;
        for(auto subVar: this->getSubVarMap()){

            auto subVarType = subVar.second;
            if(subVarType->getName() == "int") compoundValueList.push_back( new IntegerValue(0));
            else if(subVarType->getName() == "bool") compoundValueList.push_back(new BoolValue(false));
            else if(subVarType->getName() == "unsigned") compoundValueList.push_back(new UnsignedValue(0));
            else if(subVarType->isEnumType()){
                auto firstEnumVal = *(subVarType->getEnumValueMap().begin());
                compoundValueList.push_back(new EnumValue(firstEnumVal.first,subVarType));
            }else throw std::runtime_error("Unsupported type for compound: " + subVarType->getName());
        }
       initVal = new CompoundValue(compoundValueList,this);


    } else throw std::runtime_error("Unsupported datatype: " + this->getName());
    assert(initVal != nullptr);
    return initVal;
}

const bool SCAM::DataType::isUnsigned() const {
    return this->getName() == "unsigned" ;
}

const bool SCAM::DataType::isInteger() const {
    return this->getName() == "int";
}

