//
// Created by ibrahim on 19.03.20.
//

#include "LocationInfo.h"

const std::string &SCAM::LocationInfo::getFile() {
    return this->fileDir;
}

int SCAM::LocationInfo::getRowStartNumber() {
    return this->rowStartNumber;
}

int SCAM::LocationInfo::getRowEndNumber() {
    return this->rowEndNumber;
}

int SCAM::LocationInfo::getColumnStartNumber() {
    return this->columnStartNumber;
}

int SCAM::LocationInfo::getColumnEndNumber() {
    return this->columnEndNumber;
}


const std::string &SCAM::LocationInfo::getObject() {
    return this->object;
}

void SCAM::LocationInfo::setObject(const std::string &object) {
    this->object = object;
}

void SCAM::LocationInfo::setFile(const std::string &fileDir) {
    this->fileDir = fileDir;
}

void SCAM::LocationInfo::setRowStartNumber(int rowStartNumber) {
    this->rowStartNumber = rowStartNumber;
}

void SCAM::LocationInfo::setRowEndNumber(int rowEndNumber) {
    this->rowEndNumber = rowEndNumber;
}

void SCAM::LocationInfo::setColumnStartNumber(int columnStartNumber) {
    this->columnStartNumber = columnStartNumber;
}

void SCAM::LocationInfo::setColumnEndNumber(int columnEndNumber) {
    this->columnEndNumber = columnEndNumber;
}

void
SCAM::LocationInfo::setInfo(const std::string &object, const std::string &fileDir, int rowStartNumber, int rowEndNumber,
                            int columnStartNumber,
                            int columnEndNumber) {
    setObject(object);
    setFile(fileDir);
    setRowStartNumber(rowStartNumber);
    setRowEndNumber(rowEndNumber);
    setColumnStartNumber(columnStartNumber);
    setColumnEndNumber(columnEndNumber);
}

SCAM::LocationInfo::LocationInfo(const std::string &object, const std::string &fileDir, int rowStartNumber,
                                 int rowEndNumber, int columnStartNumber,
                                 int columnEndNumber) {
    setInfo(object, fileDir, rowStartNumber, rowEndNumber, columnStartNumber, columnEndNumber);
}

bool SCAM::LocationInfo::operator==(const SCAM::LocationInfo &other) const {
    if (this == &other) return true;
    return this->fileDir == other.fileDir &&
            this->object == other.object &&
           this->rowStartNumber == other.rowStartNumber &&
           this->rowEndNumber == other.rowEndNumber &&
           this->columnStartNumber == other.columnStartNumber &&
           this->columnEndNumber == other.columnEndNumber;
}


