//
// Created by tobias on 29.04.16.
//


#include <iostream>
#include "FindNewDatatype.h"
#include "FindVariables.h"

namespace SCAM {

    FindNewDatatype::FindNewDatatype(clang::CXXRecordDecl *recordDecl) :
            recordDecl(recordDecl),
            validDatatype(true) {
        this->typeName = recordDecl->getName();

        //TODO: exclude all-type defintion, that are not supported with recordDecl->has...

        TraverseDecl(recordDecl);
    }

    bool FindNewDatatype::VisitFieldDecl(clang::FieldDecl *fieldDecl) {

        if (fieldDecl->getType()->isBuiltinType()) {
            std::string subVarTypeName = fieldDecl->getType().getAsString();
            if (subVarTypeName == "_Bool") subVarTypeName = "bool";
            if (subVarTypeName == "unsigned int") subVarTypeName = "unsigned";
            this->subVarMap.insert(std::make_pair(fieldDecl->getNameAsString(), subVarTypeName));
        } else if (fieldDecl->getType()->isEnumeralType()) {
            const clang::EnumType *enumType = fieldDecl->getType()->getAs<clang::EnumType>();
            std::string subVarTypeName = enumType->getDecl()->getName();
            //Is dataType already in Map?
            //TODO: This should actually be done by ModuleFactory::addEnum, IDEA use static method
            if (!SCAM::DataTypes::isDataType(subVarTypeName)) {
                //Sections enum is a reserved key-word and is handlet by FindSections
                if (enumType->getDecl()->getName().str() != "Sections") {
                    //create new DataType for enum
                    SCAM::DataType *newType = new SCAM::DataType(subVarTypeName);
                    //Add each enum_value
                    for (auto it = enumType->getDecl()->enumerator_begin(); it != enumType->getDecl()->enumerator_end(); it++) {
                        newType->addEnumValue(it->getName().str());
                    }
                    //Add dataType to dataTypeMap
                    SCAM::DataTypes::addDataType(newType);
                }
            }
            //Add new subvar for compound type
            this->subVarMap.insert(std::make_pair(fieldDecl->getNameAsString(), subVarTypeName));


        } else {
            validDatatype = false;
            llvm::errs() << "-E- FieldDecl " << fieldDecl->getType().getAsString() << " is not allowed, only builtin types! \n";
        }
        return true;

    }

    std::string FindNewDatatype::getTypeName() {
        return this->typeName;
    }

    bool FindNewDatatype::isValidDatatype() {
        return this->validDatatype;
    }

    const std::map<std::string, std::string> &FindNewDatatype::getSubVarMap() const {
        return subVarMap;
    }

    std::vector<DataType *> FindNewDatatype::getDataTypes(const std::map<std::string, clang::QualType> &typeMap) {
        std::vector<DataType *> typesList;
        for (auto type: typeMap) {
            typesList.push_back(FindNewDatatype::getDataType(type.second));
        }

    }

    SCAM::DataType *FindNewDatatype::getDataType(const clang::QualType &type) {
        std::string typeName = FindNewDatatype::getTypeName(type);
        //DataType already exists?
        if(DataTypes::isDataType(typeName)) return DataTypes::getDataType(typeName);
        //Create a new one
        SCAM::DataType *newType = nullptr;
        if (type->isEnumeralType()) {
            //Sections enum is a reserved key-word and is handlet by FindSections
            if (typeName != "Sections") {
                //create new DataType for enum
                newType = new SCAM::DataType(typeName);
                //Add each enum_value
                const clang::EnumType *enumType = type->getAs<clang::EnumType>();
                for (auto it = enumType->getDecl()->enumerator_begin(); it != enumType->getDecl()->enumerator_end(); it++) {
                    newType->addEnumValue(it->getName().str());
                }
            }
        } else if (type->isStructureType()) {
            auto recordDecl = type->getAsCXXRecordDecl();
            FindVariables findVariables(recordDecl);
            //Create new dataType
            newType = new DataType(recordDecl->getName().str());
            //Add sub-variables
            for (auto var: findVariables.getVariableTypeMap()) {
                auto subVarDataType = FindNewDatatype::getDataType(var.second);
                if (subVarDataType->isBuiltInType() || subVarDataType->isEnumType()) {
                    newType->addSubVar(var.first, subVarDataType);
                } else throw std::runtime_error("Only built-in and enum type allowed for compound");
            }
        } else throw std::runtime_error("Can't analyze datatypes");
        DataTypes::addDataType(newType);
        return newType;
    }

    std::string FindNewDatatype::getTypeName(const clang::QualType &type) {
        if (type->isBuiltinType()) {
            std::string typeName = type.getAsString();
            if (typeName == "_Bool") return "bool";
            else if (typeName == "int") return "int";
            else if (typeName == "unsigned int") return "unsigned";
            else throw std::runtime_error("Built-in type: " + typeName + " is not allowed!");
        } else if (type->isEnumeralType()) {
            const clang::EnumType *enumType = type->getAs<clang::EnumType>();
            return  enumType->getDecl()->getName();
        } else if (type->isStructureType()) {
            return type->getAsCXXRecordDecl()->getName().str();
        } else throw std::runtime_error("Can't analyze datatype");
    }
}