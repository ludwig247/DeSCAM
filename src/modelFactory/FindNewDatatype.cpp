//
// Created by tobias on 29.04.16.
//


#include <iostream>
#include "FindNewDatatype.h"
#include "FindVariables.h"

namespace SCAM {


    SCAM::DataType *FindNewDatatype::getDataType(const clang::QualType &type, std::map<std::string, clang::CXXRecordDecl *> _moduleMap) {

        std::string typeName = FindNewDatatype::getTypeName(type);
        //DataType already exists?
        if (DataTypes::isDataType(typeName)) return DataTypes::getDataType(typeName);
        //Create a new one
        SCAM::DataType *newType = nullptr;
        if (type->isEnumeralType()) {
            //Sections enum is a reserved key-word and is handlet by FindSections
            //if (typeName != "Sections") {
                //create new DataType for enum
                newType = new SCAM::DataType(typeName);
                //Add each enum_value
                const clang::EnumType *enumType = type->getAs<clang::EnumType>();
                for (auto it = enumType->getDecl()->enumerator_begin(); it != enumType->getDecl()->enumerator_end(); it++) {
                    newType->addEnumValue(it->getName().str());
                }
            //}
        } else if (type->isStructureType()) {
            auto recordDecl = type->getAsCXXRecordDecl();
            FindVariables findVariables(recordDecl, _moduleMap);
            //Create new dataType
            newType = new DataType(recordDecl->getName().str());
            //Add sub-variables
            for (auto var: findVariables.getVariableTypeMap()) {
                auto subVarDataType = FindNewDatatype::getDataType(var.second, _moduleMap);
                if (subVarDataType->isBuiltInType()) {
                    newType->addSubVar(var.first, subVarDataType);
                } else if (subVarDataType->isEnumType()) {
                    if (FindNewDatatype::isGlobal(var.second)) {
                        DataTypes::addDataType(subVarDataType);
                    } else throw std::runtime_error("Local enum types in compound not supported");
                    newType->addSubVar(var.first, subVarDataType);
                } else throw std::runtime_error("Only built-in and enum type allowed for compound");
            }
        } else if (type->isConstantArrayType()) {
            newType = new SCAM::DataType(typeName);
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            int size = constantArrayType->getSize().getSExtValue();
            std::string type = FindNewDatatype::getTypeName(constantArrayType->getElementType());
            newType->addArray(DataTypes::getDataType(type), size);

        } else throw std::runtime_error("Can't analyze datatypes");
        //DataTypes::addDataType(newType);
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
            return enumType->getDecl()->getName();
        } else if (type->isStructureType()) {
            return type->getAsCXXRecordDecl()->getName().str();
        } else if (type->isConstantArrayType()) {
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            std::string name = FindNewDatatype::getTypeName(constantArrayType->getElementType());
            std::string size = std::to_string(constantArrayType->getSize().getSExtValue());
            return name + "_" + size;
        } else throw std::runtime_error("Can't analyze datatype");
    }

    bool FindNewDatatype::isGlobal(const clang::QualType &type) {
        if (type->isEnumeralType()) {
            const clang::EnumType *enumType = type->getAs<clang::EnumType>();
            return !enumType->getDecl()->isCXXClassMember();
            //Sections enum is a reserved key-word and is handlet by FindSections
        } else if (type->isStructureType()) {
            auto recordDecl = type->getAsCXXRecordDecl();
            return !recordDecl->isCXXClassMember();
        } else if (type->isConstantArrayType()) {
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            return isGlobal(constantArrayType->getElementType());
        } else if (type->isBuiltinType()) {
            return true;
        } else throw std::runtime_error("Can't analyze datatypes");
    }
}
/*
//
// Created by tobias on 29.04.16.
//


#include <iostream>
#include "FindNewDatatype.h"
#include "FindVariables.h"

namespace SCAM {


    SCAM::DataType *FindNewDatatype::getDataType(const clang::QualType &type) {

        std::string typeName = FindNewDatatype::getTypeName(type);
        //DataType already exists?
        if (DataTypes::isDataType(typeName)) return DataTypes::getDataType(typeName);
        //Create a new one
        SCAM::DataType *newType = nullptr;
        if (type->isEnumeralType()) {
            //Sections enum is a reserved key-word and is handlet by FindSections
            //if (typeName != "Sections") {
            //create new DataType for enum
            newType = new SCAM::DataType(typeName);
            //Add each enum_value
            const clang::EnumType *enumType = type->getAs<clang::EnumType>();
            for (auto it = enumType->getDecl()->enumerator_begin(); it != enumType->getDecl()->enumerator_end(); it++) {
                newType->addEnumValue(it->getName().str());
            }
            //}
        } else if (type->isStructureType()) {
            auto recordDecl = type->getAsCXXRecordDecl();
            FindVariables findVariables(recordDecl);
            //Create new dataType
            newType = new DataType(recordDecl->getName().str());
            //Add sub-variables
            for (auto var: findVariables.getVariableTypeMap()) {
                auto subVarDataType = FindNewDatatype::getDataType(var.second);
                if (subVarDataType->isBuiltInType()) {
                    newType->addSubVar(var.first, subVarDataType);
                } else if (subVarDataType->isEnumType()) {
                    if (FindNewDatatype::isGlobal(var.second)) {
                        DataTypes::addDataType(subVarDataType);
                    } else throw std::runtime_error("Local enum types in compound not supported");
                    newType->addSubVar(var.first, subVarDataType);
                } else throw std::runtime_error("Only built-in and enum type allowed for compound");
            }
        } else if (type->isConstantArrayType()) {
            newType = new SCAM::DataType(typeName);
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            int size = constantArrayType->getSize().getSExtValue();
            std::string type = FindNewDatatype::getTypeName(constantArrayType->getElementType());
            newType->addArray(DataTypes::getDataType(type), size);

        } else throw std::runtime_error("Can't analyze datatypes");
        //DataTypes::addDataType(newType);
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
            return enumType->getDecl()->getName();
        } else if (type->isStructureType()) {
            return type->getAsCXXRecordDecl()->getName().str();
        } else if (type->isConstantArrayType()) {
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            std::string name = FindNewDatatype::getTypeName(constantArrayType->getElementType());
            std::string size = std::to_string(constantArrayType->getSize().getSExtValue());
            return name + "_" + size;
        } else throw std::runtime_error("Can't analyze datatype");
    }

    bool FindNewDatatype::isGlobal(const clang::QualType &type) {
        if (type->isEnumeralType()) {
            const clang::EnumType *enumType = type->getAs<clang::EnumType>();
            return !enumType->getDecl()->isCXXClassMember();
            //Sections enum is a reserved key-word and is handlet by FindSections
        } else if (type->isStructureType()) {
            auto recordDecl = type->getAsCXXRecordDecl();
            return !recordDecl->isCXXClassMember();
        } else if (type->isConstantArrayType()) {
            auto constantArrayType = clang::cast<clang::ConstantArrayType>(type);
            return isGlobal(constantArrayType->getElementType());
        } else if (type->isBuiltinType()) {
            return true;
        } else throw std::runtime_error("Can't analyze datatypes");
    }
}
 */