//
// Created by ludwig on 09.11.16.
//

#include <iostream>
#include "DataTypes.h"


SCAM::DataTypes &SCAM::DataTypes::getInstance() {
    static DataTypes instance;

    return instance;
}

const std::map<std::string, SCAM::DataType *> &SCAM::DataTypes::getDataTypeMap() {
    return DataTypes::getInstance().dataTypeMap;
}

SCAM::DataType *SCAM::DataTypes::getDataType(std::string name) {
    if (DataTypes::getInstance().dataTypeMap.find(name) == DataTypes::getInstance().dataTypeMap.end()) {
        throw std::runtime_error("DataTypes.cpp: getDataType \"" + name + "\" is not a datatype");
    }
    return DataTypes::getInstance().dataTypeMap.at(name);
}

void SCAM::DataTypes::addDataType(DataType *dataType) {
    if (DataTypes::getDataTypeMap().find(dataType->getName()) == DataTypes::getDataTypeMap().end()) {
        DataTypes::getInstance().dataTypeMap.insert(std::make_pair(dataType->getName(), dataType));
    }
}

bool SCAM::DataTypes::isDataType(const std::string &name) {
    return DataTypes::getDataTypeMap().find(name) != DataTypes::getDataTypeMap().end();
}


bool SCAM::DataTypes::isLocalDataType(const std::string &name, const std::string &moduleName) {
    auto localTypeMap = DataTypes::getLocalDataTypeMap();
    if (localTypeMap.find(moduleName) != localTypeMap.end()) {
        auto localTypes = (*localTypeMap.find(moduleName)).second;
        return (localTypes.find(name) != localTypes.end());
    }
    return false;

}


void SCAM::DataTypes::reset() {
    DataTypes::getInstance().dataTypeMap.clear();
    DataTypes::getInstance().localDataTypeMap.clear();
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("bool", new DataType("bool")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("int", new DataType("int")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("unsigned", new DataType("unsigned")));
}

void SCAM::DataTypes::addLocalDataType(std::string moduleName, SCAM::DataType *type) {
    if (!isLocalDataType(type->getName(), moduleName)) {
        auto typeEntry = std::make_pair(type->getName(), type);
        DataTypes::getInstance().localDataTypeMap[moduleName].insert(typeEntry);
    }
}

const std::map<std::string, std::map<std::string, SCAM::DataType *>> &SCAM::DataTypes::getLocalDataTypeMap() {
    return DataTypes::getInstance().localDataTypeMap;
}

SCAM::DataType *SCAM::DataTypes::getLocalDataType(std::string moduleName, std::string typeName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    if (DataTypes::getInstance().localDataTypeMap.find(moduleName) != DataTypes::getInstance().localDataTypeMap.end()) {
        auto it = DataTypes::getInstance().localDataTypeMap.find(moduleName)->second.find(typeName);
        if (it != DataTypes::getInstance().localDataTypeMap.find(moduleName)->second.end()) {
            return it->second;
        } else throw std::runtime_error("Unkown local type " + typeName + "for module " + moduleName);
    } else throw std::runtime_error("Unknown module " + moduleName);
}

std::map<std::string, SCAM::DataType *> SCAM::DataTypes::getLocalDataTypes(std::string moduleName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    if (DataTypes::getInstance().localDataTypeMap.find(moduleName) != DataTypes::getInstance().localDataTypeMap.end()) {
        return DataTypes::getInstance().localDataTypeMap.find(moduleName)->second;
    } else{//} throw std::runtime_error("Unknown module " + moduleName);
         std::map<std::string, SCAM::DataType *> dummy = {};
         return dummy;
    }
}


bool SCAM::DataTypes::hasLocalDataTypes(const std::string &moduleName) {
    auto ldt = DataTypes::getInstance().localDataTypeMap;
    return ldt.find(moduleName) != ldt.end();
}



