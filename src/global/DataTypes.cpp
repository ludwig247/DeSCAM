//
// Created by ludwig on 09.11.16.
//

#include <iostream>
#include "DataTypes.h"



SCAM::DataTypes &SCAM::DataTypes::getInstance() {
    static DataTypes instance;

    return instance;
}

const std::map<std::string, SCAM::DataType *>&SCAM::DataTypes::getDataTypeMap() {
    return DataTypes::getInstance().dataTypeMap;
}

SCAM::DataType *SCAM::DataTypes::getDataType(std::string name) {
    if (DataTypes::getInstance().dataTypeMap.find(name) == DataTypes::getInstance().dataTypeMap.end()) {
        throw std::runtime_error("DataTypes.cpp: getDataType \"" + name + "\" is not a datatype");
    }
    return DataTypes::getInstance().dataTypeMap.at(name);
}

void SCAM::DataTypes::addDataType(SCAM::DataType * dataType) {

    if(DataTypes::getDataTypeMap().find(dataType->getName()) == DataTypes::getDataTypeMap().end()){
        DataTypes::getInstance().dataTypeMap.insert(std::make_pair(dataType->getName(),dataType));
        //throw std::runtime_error("Type " + dataType->getName() + " already in dataTypeMap");
    }

}

bool SCAM::DataTypes::isDataType(const std::string &name) {
    return DataTypes::getDataTypeMap().find(name) != DataTypes::getDataTypeMap().end();
}

void SCAM::DataTypes::reset() {
    DataTypes::getInstance().dataTypeMap.clear();
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("bool", new DataType("bool")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("int", new DataType("int")));
    DataTypes::getInstance().dataTypeMap.insert(std::make_pair("unsigned",new DataType("unsigned")));

}

