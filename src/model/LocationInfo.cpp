//
// Created by ibrahim on 19.03.20.
//

#include "LocationInfo.h"

const std::string &DESCAM::LocationInfo::getFile() {
    return this->fileDir;
}

int DESCAM::LocationInfo::getRowStartNumber() {
    return this->rowStartNumber;
}

int DESCAM::LocationInfo::getRowEndNumber() {
    return this->rowEndNumber;
}

int DESCAM::LocationInfo::getColumnStartNumber() {
    return this->columnStartNumber;
}

int DESCAM::LocationInfo::getColumnEndNumber() {
    return this->columnEndNumber;
}


const std::string &DESCAM::LocationInfo::getObject() {
    return this->object;
}

void DESCAM::LocationInfo::setObject(const std::string &object) {
    this->object = object;
}

void DESCAM::LocationInfo::setFile(const std::string &fileDir) {
    this->fileDir = fileDir;
}

void DESCAM::LocationInfo::setRowStartNumber(int rowStartNumber) {
    this->rowStartNumber = rowStartNumber;
}

void DESCAM::LocationInfo::setRowEndNumber(int rowEndNumber) {
    this->rowEndNumber = rowEndNumber;
}

void DESCAM::LocationInfo::setColumnStartNumber(int columnStartNumber) {
    this->columnStartNumber = columnStartNumber;
}

void DESCAM::LocationInfo::setColumnEndNumber(int columnEndNumber) {
    this->columnEndNumber = columnEndNumber;
}

void
DESCAM::LocationInfo::setInfo(const std::string &object, const std::string &fileDir, int rowStartNumber, int rowEndNumber,
                            int columnStartNumber,
                            int columnEndNumber) {
    setObject(object);
    setFile(fileDir);
    setRowStartNumber(rowStartNumber);
    setRowEndNumber(rowEndNumber);
    setColumnStartNumber(columnStartNumber);
    setColumnEndNumber(columnEndNumber);
}

DESCAM::LocationInfo::LocationInfo(const std::string &object, const std::string &fileDir, int rowStartNumber,
                                 int rowEndNumber, int columnStartNumber,
                                 int columnEndNumber) {
    setInfo(object, fileDir, rowStartNumber, rowEndNumber, columnStartNumber, columnEndNumber);
}

bool DESCAM::LocationInfo::operator==(const DESCAM::LocationInfo &other) const {
    if (this == &other) return true;
    return this->fileDir == other.fileDir &&
            this->object == other.object &&
           this->rowStartNumber == other.rowStartNumber &&
           this->rowEndNumber == other.rowEndNumber &&
           this->columnStartNumber == other.columnStartNumber &&
           this->columnEndNumber == other.columnEndNumber;
}


