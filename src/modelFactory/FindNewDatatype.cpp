//
// Created by tobias on 29.04.16.
//


#include <iostream>
#include "FindNewDatatype.h"
#include "FindVariables.h"
#include "FindInitialValues.h"
#include "FindDataFlowFactory.h"
#include "IFindVariables.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {

DESCAM::DataType *FindNewDatatype::getDataType(const clang::QualType &type) {

  std::string typeName = FindNewDatatype::getTypeName(type);
  //DataType already exists?
  if (DataTypes::isDataType(typeName)) return DataTypes::getDataType(typeName);
  //Create a new one
  DESCAM::DataType *new_type;
  if (type->isEnumeralType()) {
    //Sections enum is a reserved key-word and is handled by FindSections
    //if (typeName != "Sections") {
    //create new DataType for enum
    new_type = new DESCAM::DataType(typeName);
    //Add each enum_value
    const clang::EnumType *enum_type = type->getAs<clang::EnumType>();
    for (auto it = enum_type->getDecl()->enumerator_begin(); it != enum_type->getDecl()->enumerator_end(); it++) {
      new_type->addEnumValue(it->getName().str());
    }
    //}
  } else if (type->isStructureType()) {
    auto record_decl = type->getAsCXXRecordDecl();

    GetClangVariables clang_variables(record_decl);

    //Create new dataType
    new_type = new DataType(record_decl->getName().str());
    //Add sub-variables
    for (const auto &var: clang_variables.getVariableTypeMap()) {
      auto sub_var_data_type = FindNewDatatype::getDataType(var.second);
      if (sub_var_data_type->isBuiltInType()) {
        new_type->addSubVar(var.first, sub_var_data_type);
      } else if (sub_var_data_type->isEnumType()) {
        if (FindNewDatatype::isGlobal(var.second)) {
          DataTypes::addDataType(sub_var_data_type);
        } else TERMINATE("Local enum types in compound not supported");
        new_type->addSubVar(var.first, sub_var_data_type);
      } else TERMINATE("Only built-in and enum type allowed for compound");
    }
  } else if (type->isConstantArrayType()) {
    new_type = new DESCAM::DataType(typeName);
    auto const_array_type = clang::cast<clang::ConstantArrayType>(type);
    int size = const_array_type->getSize().getSExtValue();
    std::string type = FindNewDatatype::getTypeName(const_array_type->getElementType());
    new_type->addArray(DataTypes::getDataType(type), size);

  } else TERMINATE("Can't analyze datatypes");
  //DataTypes::addDataType(newType);
  return new_type;
}

std::string FindNewDatatype::getTypeName(const clang::QualType &type) {
  if (type->isBuiltinType()) {
    std::string type_name = type.getAsString();
    if (type_name == "_Bool") return "bool";
    else if (type_name == "int") return "int";
    else if (type_name == "unsigned int") return "unsigned";
    else TERMINATE("Built-in type: " + type_name + " is not allowed!");
  } else if (type->isEnumeralType()) {
    const clang::EnumType *enumType = type->getAs<clang::EnumType>();
    return enumType->getDecl()->getName();
  } else if (type->isStructureType()) {
    return type->getAsCXXRecordDecl()->getName().str();
  } else if (type->isConstantArrayType()) {
    auto const_array_type = clang::cast<clang::ConstantArrayType>(type);
    std::string name = FindNewDatatype::getTypeName(const_array_type->getElementType());
    std::string size = std::to_string(const_array_type->getSize().getSExtValue());
    return name + "_" + size;
  } else TERMINATE("Can't analyze datatype");
}

bool FindNewDatatype::isGlobal(const clang::QualType &type) {
  if (type->isEnumeralType()) {
    const clang::EnumType *enum_type = type->getAs<clang::EnumType>();
    return !enum_type->getDecl()->isCXXClassMember();
    //Sections enum is a reserved key-word and is handled by FindSections
  } else if (type->isStructureType()) {
    auto record_decl = type->getAsCXXRecordDecl();
    return !record_decl->isCXXClassMember();
  } else if (type->isConstantArrayType()) {
    auto const_array_type = clang::cast<clang::ConstantArrayType>(type);
    return isGlobal(const_array_type->getElementType());
  } else if (type->isBuiltinType()) {
    return true;
  } else TERMINATE("Can't analyze datatypes");
}
}