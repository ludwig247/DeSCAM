//
// Created by tobias on 22.10.15.
//

#include <iostream>
#include "FindVariables.h"
#include "FindNewDatatype.h"
#include "FatalError.h"
#include "Logger/Logger.h"



SCAM::FindVariables::FindVariables(clang::CXXRecordDecl* recordDecl):
        recordDecl(recordDecl) {
    //Find Members
    TraverseDecl(recordDecl);
}


bool SCAM::FindVariables::VisitFieldDecl(clang::FieldDecl *fieldDecl) {
    if(fieldDecl->getParent()->getName().str() != recordDecl->getName().str()) return true;
    //If field is builtin-> add else make sure its tracked such that we don't miss any values
    if (fieldDecl->getType()->isBuiltinType()) {
        this->memberMap.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
        std::string typeName = fieldDecl->getType().getAsString();
        if (typeName == "_Bool") typeName = "bool";
        else if(fieldDecl->getType()->isUnsignedIntegerType()) {
            typeName = "unsigned";
        }else if(fieldDecl->getType()->isIntegerType()){
            typeName = "int";
        }else TERMINATE("unsupported type");
        this->memberMap.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
        this->memberTypeMap.insert(std::make_pair(fieldDecl->getName(), typeName));

    } else if (fieldDecl->getType()->isStructureType()) {
        this->memberMap.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
        std::string typeName = fieldDecl->getType()->getAsCXXRecordDecl()->getName();
        this->memberTypeMap.insert(std::make_pair(fieldDecl->getName(), typeName));

    } else if (fieldDecl->getType()->isEnumeralType()) {
        //if (fieldDecl->getName() == "section" || fieldDecl->getName() == "nextsection") return true;

        const clang::EnumType *enumType = fieldDecl->getType()->getAs<clang::EnumType>();
        std::string typeName = enumType->getDecl()->getName().str();
        //Add all enumValues
        this->memberMap.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
        this->memberTypeMap.insert(std::make_pair(fieldDecl->getName(), typeName));

    } else if(fieldDecl->getType()->isConstantArrayType()){
        this->memberMap.insert(std::make_pair(fieldDecl->getName(), fieldDecl));
        this->memberTypeMap.insert(std::make_pair(fieldDecl->getName(), "array"));
    }
    else{

        //TODO: is every fieldDecl catched? -> maybe first store all in a list in work off that list afterwards
    }
    return true;

}

const std::map<std::string, clang::FieldDecl *> & SCAM::FindVariables::getVariableMap() const {
    return this->memberMap;
}

std::map<std::string, clang::QualType> SCAM::FindVariables::getVariableTypeMap() const {
    std::map<std::string, clang::QualType> typeMap;
    for(auto var:  this->getVariableMap()){
        typeMap.insert(std::make_pair(var.first,var.second->getType()));
    }
    return typeMap;
}

