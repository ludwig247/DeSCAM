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


const std::string &SCAM::LocationInfo::getStmt() {
    return this->stmt;
}

void SCAM::LocationInfo::setStmt(const std::string &stmt) {
    this->stmt = stmt;
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

void SCAM::LocationInfo::setInfo(const std::string &stmt, const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                 int columnEndNumber) {
setStmt(stmt);
setFile(fileDir);
setRowStartNumber(rowStartNumber);
setRowEndNumber(rowEndNumber);
setColumnStartNumber(columnStartNumber);
setColumnEndNumber(columnEndNumber);
}

SCAM::LocationInfo::LocationInfo(const std::string &stmt, const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                 int columnEndNumber) {
    setInfo(stmt, fileDir,rowStartNumber,rowEndNumber,columnStartNumber,columnEndNumber);
}


