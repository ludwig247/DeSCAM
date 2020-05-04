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
#include "FatalError.h"
#include "Logger/Logger.h"


void SCAM::DataType::addSubVar(std::string subVarName, SCAM::DataType *subVarType) {
    assert(!this->isArrayType() && "Either Array or Compound");
    this->subVarMap.insert(std::make_pair(subVarName, subVarType));
}

const bool SCAM::DataType::isCompoundType() const {
    return !this->subVarMap.empty() && !isArrayType();
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
    if (this->isCompoundType()) TERMINATE("DataType can either be enum or compound");
    this->enumValueMap.insert(std::make_pair(enumValue, this->enumValueMap.size()));

}

const bool SCAM::DataType::isEnumType() const {
    return !this->enumValueMap.empty();
}

const bool SCAM::DataType::isBuiltInType() const {
    return !(this->isEnumType() || this->isCompoundType());
}

const bool SCAM::DataType::isVoid() const {
    return this->getName() == "void";
}

SCAM::ConstValue *SCAM::DataType::getDefaultVal() const {
    ConstValue *initVal = nullptr;
    if (this->getName() == "int") initVal = new IntegerValue(0);
    else if (this->getName() == "bool") initVal = new BoolValue(false);
    else if (this->getName() == "unsigned") initVal = new UnsignedValue(0);
    else if (this->isEnumType()) {
        for(auto val: this->getEnumValueMap() ){
            if(val.second == 0){
                initVal = new EnumValue(val.first, this);
            }
        }
        assert(initVal != nullptr);

    } else if (this->isCompoundType()) {
        std::vector<ConstValue *> compoundValueList;
        for (auto subVar: this->getSubVarMap()) {

            auto subVarType = subVar.second;
            if (subVarType->getName() == "int") compoundValueList.push_back(new IntegerValue(0));
            else if (subVarType->getName() == "bool") compoundValueList.push_back(new BoolValue(false));
            else if (subVarType->getName() == "unsigned") compoundValueList.push_back(new UnsignedValue(0));
            else if (subVarType->isEnumType()) {
                auto firstEnumVal = *(subVarType->getEnumValueMap().begin());
                compoundValueList.push_back(new EnumValue(firstEnumVal.first, subVarType));
            } else TERMINATE("Unsupported type for compound: " + subVarType->getName());
        }
        initVal = new CompoundValue(compoundValueList, this);


    } else if (this->isArrayType()) {
        std::vector<ConstValue *> compoundValueList;
        for (int i = 0; i < this->arraySize; ++i) {
            compoundValueList.push_back(this->arrayType->getDefaultVal());
        }
        initVal = new CompoundValue(compoundValueList, this);
    } else TERMINATE("Unsupported datatype: " + this->getName());
    assert(initVal != nullptr);
    return initVal;
}

const bool SCAM::DataType::isUnsigned() const {
    return this->getName() == "unsigned";
}

const bool SCAM::DataType::isInteger() const {
    return this->getName() == "int";
}

const bool SCAM::DataType::isBoolean() const {
    return (this->getName() == "bool");
}

void SCAM::DataType::addArray(DataType *arrayType, int arraySize) {
    assert(arrayType->isBuiltInType() && "Arraytype only allowed for built-in tpyes");
    assert(!this->isCompoundType() && "Either Array or Compound");
    for (int i = 0; i < arraySize; ++i) {
        this->subVarMap.insert(std::make_pair(std::to_string(i), arrayType));
    }
    this->arrayType = arrayType;
    this->arraySize = arraySize;

}

int SCAM::DataType::getArraySize() const {
    return arraySize;
}

SCAM::DataType *SCAM::DataType::getArrayType() const {
    return arrayType;
}

const bool SCAM::DataType::isArrayType() const {
    return this->arraySize != 0;
}

