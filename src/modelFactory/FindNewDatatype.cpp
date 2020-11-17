//
// Created by tobias on 29.04.16.
//


#include <iostream>
#include "FindNewDatatype.h"
#include "FindVariables.h"
#include "IFindVariables.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {

DESCAM::DataType *FindNewDatatype::getEnumeralType(const clang::QualType &type) {

//  auto *new_type = new DESCAM::DataType(getTypeName(type));
//  const auto *enum_type = type->getAs<clang::EnumType>()->getDecl();
//  for (auto it = enum_type->enumerator_begin(); it != enum_type->enumerator_end(); ++it) {
//    new_type->addEnumValue(it->getNameAsString());
//  }

  auto *new_type = new DESCAM::DataType(getTypeName(type));
  const auto enum_range = type->getAs<clang::EnumType>()->getDecl()->enumerators();
  for (auto it : enum_range) {
    new_type->addEnumValue(it->getNameAsString());
  }
  return new_type;
}

DESCAM::DataType *FindNewDatatype::getStructureType(const clang::QualType &type) {
  auto record_decl = type->getAsCXXRecordDecl();

  if (record_decl->getNameAsString() == "array") {

    auto specialization_decl = clang::cast<clang::ClassTemplateSpecializationDecl>(record_decl);
    auto &args = specialization_decl->getTemplateArgs();
    auto array_type = getTypeName(args.get(0).getAsType());
    auto array_size = args.get(1).getAsIntegral().getSExtValue();

    auto *new_type = new DESCAM::DataType(getTypeName(type));
    new_type->addArray(DataTypes::getDataType(array_type), array_size);

    return new_type;

  } else {

    bool success = true;
    GetClangVariables clang_variables(success, record_decl);

    //Create new dataType
    auto *new_type = new DataType(record_decl->getNameAsString());
    //Add sub-variables
    for (const auto &var: clang_variables.getVariableTypeMap()) {
      auto data_type = FindNewDatatype::getDataType(var.second);
      if (!(data_type->isBuiltInType() || data_type->isEnumType())) {
        TERMINATE("Only built-in and enum type allowed for compound")
      }

      if (data_type->isEnumType()) {
        if (FindNewDatatype::isGlobal(var.second)) {
          DataTypes::addDataType(data_type);
        } else TERMINATE("Local enum types in compound not supported")
      }
      new_type->addSubVar(var.first, data_type);
    }
    return new_type;
  }
}

DESCAM::DataType *FindNewDatatype::getConstantArrayType(const clang::QualType &type) {
//  DESCAM::LocationInfo info;
//  DESCAM::LoggerMsg loggerMsg("C-style arrays are not supported for simulation. Use std::array<TYPE> instead",
//                              info,
//                              LoggerMsg::SeverityLevel::Warning,
//                              LoggerMsg::ViolationType::SystemC_PPA_compliance,
//                              Logger::getCurrentProcessedLocation());
//  DESCAM::Logger::addMsg(loggerMsg);

  auto *new_type = new DESCAM::DataType(getTypeName(type));
  auto const_array_type = clang::cast<clang::ConstantArrayType>(type);
  auto size = const_array_type->getSize().getSExtValue();
  auto type_name = FindNewDatatype::getTypeName(const_array_type->getElementType());
  new_type->addArray(DataTypes::getDataType(type_name), size);

  return new_type;
}

DESCAM::DataType *FindNewDatatype::getDataType(const clang::QualType &type) {
  const auto typeName = FindNewDatatype::getTypeName(type);
  //DataType already exists?
  if (DataTypes::isDataType(typeName)) return DataTypes::getDataType(typeName);
  //Create a new one
  if (type->isEnumeralType()) return getEnumeralType(type);

  if (type->isStructureType()) return getStructureType(type);

  if (type->isConstantArrayType()) return getConstantArrayType(type);

  TERMINATE("Can't analyze datatypes")
}

std::string FindNewDatatype::getTypeName(const clang::QualType &type) {
  if (type->isBuiltinType()) {
    std::string type_name = type.getAsString();
    if (type_name == "_Bool") return "bool";
    else if (type_name == "int") return "int";
    else if (type_name == "unsigned int") return "unsigned";
    else TERMINATE("Built-in type: " + type_name + " is not allowed!")
  } else if (type->isEnumeralType()) {
    const clang::EnumType *enumType = type->getAs<clang::EnumType>();
    return enumType->getDecl()->getNameAsString();
  } else if (type->isStructureType()) {
    // std::array is a structure type. Maybe there is some better way to identify it than the name?
    if (type->getAsCXXRecordDecl()->getNameAsString() == "array") {
      auto std_array_type = clang::cast<clang::ClassTemplateSpecializationDecl>(type->getAsCXXRecordDecl());
      auto &args = std_array_type->getTemplateArgs();
      if (args.size() == 2) {
        // first template argument specifies array type
        std::string name = FindNewDatatype::getTypeName(args.get(0).getAsType());
        // second one specifies array size.
        // todo check if it really is an integral?
        std::string size = std::to_string(args.get(1).getAsIntegral().getSExtValue());
        return name + "_" + size;
      } else
      TERMINATE("std::array<> requires exactly two template parameters. " + std::to_string(args.size()) + " were given.")
    }
    return type->getAsCXXRecordDecl()->getNameAsString();
  } else if (type->isConstantArrayType()) {
    auto const_array_type = clang::cast<clang::ConstantArrayType>(type);
    std::string name = FindNewDatatype::getTypeName(const_array_type->getElementType());
    std::string size = std::to_string(const_array_type->getSize().getSExtValue());
    return name + "_" + size;
  } else {
    type->dump();
    TERMINATE("Can't analyze datatype")
  }
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
  } else TERMINATE("Can't analyze datatypes")
}

}