//
// Created by tobias on 29.04.16.
//

#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <Stmts/EnumValue.h>
#include <Stmts/CompoundValue.h>
#include <cassert>
#include <Stmts/UnsignedValue.h>
#include "DataType.h"
#include "FatalError.h"
#include "Logger/Logger.h"


void DESCAM::DataType::addSubVar(const std::string& subVarName, DESCAM::DataType *subVarType) {
    assert(!this->isArrayType() && "Either Array or Compound");
    this->sub_var_map_.insert(std::make_pair(subVarName, subVarType));
}

bool DESCAM::DataType::isCompoundType() const {
    return !this->sub_var_map_.empty() && !isArrayType();
}

void DESCAM::DataType::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

const std::map<std::string, DESCAM::DataType *> &DESCAM::DataType::getSubVarMap() const {
    return sub_var_map_;
}

const std::map<std::string, int> &DESCAM::DataType::getEnumValueMap() const {
    return enum_value_map_;
}

void DESCAM::DataType::addEnumValue(const std::string& enumValue) {
    if (this->isCompoundType()) TERMINATE("DataType can either be enum or compound")
    this->enum_value_map_.insert(std::make_pair(enumValue, this->enum_value_map_.size()));

}

bool DESCAM::DataType::isEnumType() const {
    return !this->enum_value_map_.empty();
}

bool DESCAM::DataType::isBuiltInType() const {
    return !(this->isEnumType() || this->isCompoundType());
}

bool DESCAM::DataType::isVoid() const {
    return this->getName() == "void";
}

DESCAM::ConstValue *DESCAM::DataType::getDefaultVal() const {
    ConstValue *initVal = nullptr;
    if (this->getName() == "int") initVal = new IntegerValue(0);
    else if (this->getName() == "bool") initVal = new BoolValue(false);
    else if (this->getName() == "unsigned") initVal = new UnsignedValue(0);
    else if (this->isEnumType()) {
        for(const auto& val: this->getEnumValueMap() ){
            if(val.second == 0){
                initVal = new EnumValue(val.first, this);
            }
        }
        assert(initVal != nullptr);

    } else if (this->isCompoundType()) {
        std::vector<ConstValue *> compoundValueList;
        for (const auto& subVar: this->getSubVarMap()) {

            auto subVarType = subVar.second;
            if (subVarType->getName() == "int") compoundValueList.push_back(new IntegerValue(0));
            else if (subVarType->getName() == "bool") compoundValueList.push_back(new BoolValue(false));
            else if (subVarType->getName() == "unsigned") compoundValueList.push_back(new UnsignedValue(0));
            else if (subVarType->isEnumType()) {
                auto firstEnumVal = *(subVarType->getEnumValueMap().begin());
                compoundValueList.push_back(new EnumValue(firstEnumVal.first, subVarType));
            } else TERMINATE("Unsupported type for compound: " + subVarType->getName())
        }
        initVal = new CompoundValue(compoundValueList, this);


    } else if (this->isArrayType()) {
        std::vector<ConstValue *> compoundValueList;
        compoundValueList.reserve(this->array_size_);
for (int i = 0; i < this->array_size_; ++i) {
            compoundValueList.push_back(this->array_type_->getDefaultVal());
        }
        initVal = new CompoundValue(compoundValueList, this);
    } else TERMINATE("Unsupported datatype: " + this->getName())
    assert(initVal != nullptr);
    return initVal;
}

bool DESCAM::DataType::isUnsigned() const {
    return this->getName() == "unsigned";
}

bool DESCAM::DataType::isInteger() const {
    return this->getName() == "int";
}

bool DESCAM::DataType::isBoolean() const {
    return (this->getName() == "bool");
}

void DESCAM::DataType::addArray(DataType *arrayType, int arraySize) {
    assert(arrayType->isBuiltInType() && "Arraytype only allowed for built-in types");
    assert(!this->isCompoundType() && "Either Array or Compound");
    for (int i = 0; i < arraySize; ++i) {
        this->sub_var_map_.insert(std::make_pair(std::to_string(i), arrayType));
    }
    this->array_type_ = arrayType;
    this->array_size_ = arraySize;

}

int DESCAM::DataType::getArraySize() const {
    return array_size_;
}

DESCAM::DataType *DESCAM::DataType::getArrayType() const {
    return array_type_;
}

bool DESCAM::DataType::isArrayType() const {
    return this->array_size_ != 0;
}

