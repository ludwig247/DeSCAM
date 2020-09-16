//
// Created by ludwig on 09.11.16.
//

#include <iostream>
#include "DataTypes.h"
#include "FatalError.h"
#include <Logger/Logger.h>


DESCAM::DataTypes &DESCAM::DataTypes::getInstance() {
    static DataTypes instance;

    return instance;
}

const std::map<std::string, DESCAM::DataType *> &DESCAM::DataTypes::getDataTypeMap() {
    return DataTypes::getInstance().dataTypeMap;
}

DESCAM::DataType *DESCAM::DataTypes::getDataType(std::string name) {
    if (DataTypes::getInstance().dataTypeMap.find(name) == DataTypes::getInstance().dataTypeMap.end()) {
        TERMINATE("DataTypes.cpp: getDataType \"" + name + "\" is not a datatype");
    }
    return DataTypes::getInstance().dataTypeMap.at(name);
}

void DESCAM::DataTypes::addDataType(DataType *dataType) {
    if (DataTypes::getDataTypeMap().find(dataType->getName()) == DataTypes::getDataTypeMap().end()) {
        DataTypes::getInstance().dataTypeMap.insert(std::make_pair(dataType->getName(), dataType));
    }
}

bool DESCAM::DataTypes::isDataType(const std::string &name) {
    return DataTypes::getDataTypeMap().find(name) != DataTypes::getDataTypeMap().end();
}


bool DESCAM::DataTypes::isLocalDataType(const std::string &name, const std::string &moduleName) {
    auto localTypeMap = DataTypes::getLocalDataTypeMap();
    if (localTypeMap.find(moduleName) != localTypeMap.end()) {
        auto localTypes = (*localTypeMap.find(moduleName)).second;
        return (localTypes.find(name) != localTypes.end());
    }
    return false;

}


void DESCAM::DataTypes::reset() {
    DataTypes::getInstance().dataTypeMap.clear();
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("bool", new DataType("bool")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("int", new DataType("int")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("unsigned", new DataType("unsigned")));
}

void DESCAM::DataTypes::addLocalDataType(std::string moduleName, DESCAM::DataType *type) {
    if (!isLocalDataType(type->getName(), moduleName)) {
        auto typeEntry = std::make_pair(type->getName(), type);
        DataTypes::getInstance().localDataTypeMap[moduleName].insert(typeEntry);
    }
}

const std::map<std::string, std::map<std::string, DESCAM::DataType *>> &DESCAM::DataTypes::getLocalDataTypeMap() {
    return DataTypes::getInstance().localDataTypeMap;
}

DESCAM::DataType *DESCAM::DataTypes::getLocalDataType(std::string moduleName, std::string typeName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    if (DataTypes::getInstance().localDataTypeMap.find(moduleName) != DataTypes::getInstance().localDataTypeMap.end()) {
        auto it = DataTypes::getInstance().localDataTypeMap.find(moduleName)->second.find(typeName);
        if (it != DataTypes::getInstance().localDataTypeMap.find(moduleName)->second.end()) {
            return it->second;
        } else TERMINATE("Unkown local type " + typeName + "for module " + moduleName);
    } else TERMINATE("Unknown module " + moduleName);
}

std::map<std::string, DESCAM::DataType *> DESCAM::DataTypes::getLocalDataTypes(std::string moduleName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    if (DataTypes::getInstance().localDataTypeMap.find(moduleName) != DataTypes::getInstance().localDataTypeMap.end()) {
        return DataTypes::getInstance().localDataTypeMap.find(moduleName)->second;
    } else{//} TERMINATE("Unknown module " + moduleName);
         std::map<std::string, DESCAM::DataType *> dummy = {};
         return dummy;
    }
}


bool DESCAM::DataTypes::hasLocalDataTypes(const std::string &moduleName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    return ldt.find(moduleName) != ldt.end();
}



