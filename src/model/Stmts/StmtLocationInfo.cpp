//
// Created by ibrahim on 19.03.20.
//

#include "StmtLocationInfo.h"

const std::string &SCAM::StmtLocationInfo::getFile() {
    return this->fileDir;
}

int SCAM::StmtLocationInfo::getRowStartNumber() {
    return this->rowStartNumber;
}

int SCAM::StmtLocationInfo::getRowEndNumber() {
    return this->rowEndNumber;
}

int SCAM::StmtLocationInfo::getColumnStartNumber() {
    return this->columnStartNumber;
}

int SCAM::StmtLocationInfo::getColumnEndNumber() {
    return this->columnEndNumber;
}

void SCAM::StmtLocationInfo::setFile(const std::string &fileDir) {
    this->fileDir = fileDir;
}

void SCAM::StmtLocationInfo::setRowStartNumber(int rowStartNumber) {
    this->rowStartNumber = rowStartNumber;
}

void SCAM::StmtLocationInfo::setRowEndNumber(int rowEndNumber) {
    this->rowEndNumber = rowEndNumber;
}

void SCAM::StmtLocationInfo::setColumnStartNumber(int columnStartNumber) {
    this->columnStartNumber = columnStartNumber;
}

void SCAM::StmtLocationInfo::setColumnEndNumber(int columnEndNumber) {
    this->columnEndNumber = columnEndNumber;
}

void SCAM::StmtLocationInfo::setInfo(const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                     int columnEndNumber) {
setFile(fileDir);
setRowStartNumber(rowStartNumber);
setRowEndNumber(rowEndNumber);
setColumnStartNumber(columnStartNumber);
setColumnEndNumber(columnEndNumber);
}

SCAM::StmtLocationInfo::StmtLocationInfo(const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                         int columnEndNumber) {
    setInfo(fileDir,rowStartNumber,rowEndNumber,columnStartNumber,columnEndNumber);
}
