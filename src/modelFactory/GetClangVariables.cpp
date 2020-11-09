//
// Created by burr on 15.10.20.
//

#include "GetClangVariables.h"

DESCAM::GetClangVariables::GetClangVariables(bool &success, clang::CXXRecordDecl *record_decl) :
    record_decl_(record_decl) {
  success = TraverseDecl(record_decl);
}

bool DESCAM::GetClangVariables::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
  if (fieldDecl->getParent()->getName().str() != record_decl_->getName().str()) return true;
  //If field is builtin-> add else make sure its tracked such that we don't miss any values
  if (fieldDecl->getType()->isBuiltinType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getNameAsString(), fieldDecl));
    std::string typeName = fieldDecl->getType().getAsString();
    if (typeName == "_Bool") typeName = "bool";
    else if (fieldDecl->getType()->isUnsignedIntegerType()) {
      typeName = "unsigned";
    } else if (fieldDecl->getType()->isIntegerType()) {
      typeName = "int";
    } else TERMINATE("unsupported type")
    this->member_map_.insert(std::make_pair(fieldDecl->getNameAsString(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getNameAsString(), typeName));

  } else if (fieldDecl->getType()->isStructureType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getNameAsString(), fieldDecl));
    std::string typeName = fieldDecl->getType()->getAsCXXRecordDecl()->getName().str();
    this->member_type_map_.insert(std::make_pair(fieldDecl->getNameAsString(), typeName));

  } else if (fieldDecl->getType()->isEnumeralType()) {
    //if (fieldDecl->getName() == "section" || fieldDecl->getName() == "next_section") return true;

    const clang::EnumType *enumType = fieldDecl->getType()->getAs<clang::EnumType>();
    std::string typeName = enumType->getDecl()->getName().str();
    //Add all enumValues
    this->member_map_.insert(std::make_pair(fieldDecl->getNameAsString(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getNameAsString(), typeName));

  } else if (fieldDecl->getType()->isConstantArrayType()) {
    this->member_map_.insert(std::make_pair(fieldDecl->getNameAsString(), fieldDecl));
    this->member_type_map_.insert(std::make_pair(fieldDecl->getNameAsString(), "array"));
  } else {

    //TODO: is every fieldDecl caught? -> maybe first store all in a list in work off that list afterwards
  }
  return true;

}
std::map<std::string, clang::QualType> DESCAM::GetClangVariables::getVariableTypeMap() const {
  std::map<std::string, clang::QualType> typeMap;
  for (const auto &var:  this->getVariableMap()) {
    typeMap.insert(std::make_pair(var.first, var.second->getType()));
  }
  return typeMap;
}
const std::map<std::string, clang::FieldDecl *> &DESCAM::GetClangVariables::getVariableMap() const {
  return this->member_map_;
}
