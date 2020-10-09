//
// Created by tobias on 22.10.15.
//

#include <iostream>
#include "FindVariables.h"
#include "FatalError.h"
#include "Logger/Logger.h"

bool DESCAM::FindVariables::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
  if (fieldDecl->getParent()->getName().str() != record_decl_->getName().str()) return true;
  //If field is builtin-> add else make sure its tracked such that we don't miss any values
  if (fieldDecl->getType()->isBuiltinType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
    std::string typeName = fieldDecl->getType().getAsString();
    if (typeName == "_Bool") typeName = "bool";
    else if (fieldDecl->getType()->isUnsignedIntegerType()) {
      typeName = "unsigned";
    } else if (fieldDecl->getType()->isIntegerType()) {
      typeName = "int";
    } else TERMINATE("unsupported type");
    this->member_map_.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getName(), typeName));

  } else if (fieldDecl->getType()->isStructureType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
    std::string typeName = fieldDecl->getType()->getAsCXXRecordDecl()->getName();
    this->member_type_map_.insert(std::make_pair(fieldDecl->getName(), typeName));

  } else if (fieldDecl->getType()->isEnumeralType()) {
    //if (fieldDecl->getName() == "section" || fieldDecl->getName() == "nextsection") return true;

    const clang::EnumType *enumType = fieldDecl->getType()->getAs<clang::EnumType>();
    std::string typeName = enumType->getDecl()->getName().str();
    //Add all enumValues
    this->member_map_.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getName(), typeName));

  } else if (fieldDecl->getType()->isConstantArrayType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getName(), "array"));
  } else {

    //TODO: is every fieldDecl catched? -> maybe first store all in a list in work off that list afterwards
  }
  return true;

}

const std::map<std::string, clang::FieldDecl *> &DESCAM::FindVariables::getVariableMap() const {
  return this->member_map_;
}

std::map<std::string, clang::QualType> DESCAM::FindVariables::getVariableTypeMap() const {
  std::map<std::string, clang::QualType> typeMap;
  for (const auto &var:  this->getVariableMap()) {
    typeMap.insert(std::make_pair(var.first, var.second->getType()));
  }
  return typeMap;
}
bool DESCAM::FindVariables::setup(clang::CXXRecordDecl *record_decl) {
  assert(record_decl);
  if (record_decl_ == record_decl) {
    return true;
  } else {
    // TODO setup fields
    record_decl_ = record_decl;
    member_map_.clear(); //! <NameOfField,Declaration>
    member_type_map_.clear(); //! <NameOfField,Declaration>
    //Find Members
    return TraverseDecl(record_decl);
  }
}

