//
// Created by burr on 15.10.20.
//

#include "GetClangVariables.h"

DESCAM::GetClangVariables::GetClangVariables(bool &success, clang::CXXRecordDecl *record_decl) :
    record_decl_(record_decl) {
  success = TraverseDecl(record_decl);
}

bool DESCAM::GetClangVariables::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
  if (fieldDecl->getParent()->getName().str() == record_decl_->getName().str()) {
    const clang::QualType &kType = fieldDecl->getType();
    if (kType->isBuiltinType() || kType->isStructureType() || kType->isConstantArrayType() || kType->isEnumeralType()) {
      this->member_map_.emplace(fieldDecl->getNameAsString(), fieldDecl);
    }
  }
  return true;
}

std::map<std::string, clang::QualType> DESCAM::GetClangVariables::getVariableTypeMap() const {
  std::map<std::string, clang::QualType> typeMap;
  for (const auto &var:  this->getVariableMap()) {
    typeMap.emplace(var.first, var.second->getType());
  }
  return typeMap;
}

const std::map<std::string, clang::FieldDecl *> &DESCAM::GetClangVariables::getVariableMap() const {
  return this->member_map_;
}
