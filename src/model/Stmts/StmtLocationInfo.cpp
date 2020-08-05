//
// Created by ibrahim on 19.03.20.
//

#include "StmtLocationInfo.h"

const std::string &DESCAM::StmtLocationInfo::getFile() {
    return this->fileDir;
}

int DESCAM::StmtLocationInfo::getRowStartNumber() {
    return this->rowStartNumber;
}

int DESCAM::StmtLocationInfo::getRowEndNumber() {
    return this->rowEndNumber;
}

int DESCAM::StmtLocationInfo::getColumnStartNumber() {
    return this->columnStartNumber;
}

int DESCAM::StmtLocationInfo::getColumnEndNumber() {
    return this->columnEndNumber;
}


const std::string &DESCAM::StmtLocationInfo::getStmt() {
    return this->stmt;
}

void DESCAM::StmtLocationInfo::setStmt(const std::string &stmt) {
    this->stmt = stmt;
}

void DESCAM::StmtLocationInfo::setFile(const std::string &fileDir) {
    this->fileDir = fileDir;
}

void DESCAM::StmtLocationInfo::setRowStartNumber(int rowStartNumber) {
    this->rowStartNumber = rowStartNumber;
}

void DESCAM::StmtLocationInfo::setRowEndNumber(int rowEndNumber) {
    this->rowEndNumber = rowEndNumber;
}

void DESCAM::StmtLocationInfo::setColumnStartNumber(int columnStartNumber) {
    this->columnStartNumber = columnStartNumber;
}

void DESCAM::StmtLocationInfo::setColumnEndNumber(int columnEndNumber) {
    this->columnEndNumber = columnEndNumber;
}

void DESCAM::StmtLocationInfo::setInfo(const std::string &stmt, const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                     int columnEndNumber) {
setStmt(stmt);
setFile(fileDir);
setRowStartNumber(rowStartNumber);
setRowEndNumber(rowEndNumber);
setColumnStartNumber(columnStartNumber);
setColumnEndNumber(columnEndNumber);
}

DESCAM::StmtLocationInfo::StmtLocationInfo(const std::string &stmt, const std::string &fileDir, int rowStartNumber, int rowEndNumber, int columnStartNumber,
                                         int columnEndNumber) {
    setInfo(stmt, fileDir,rowStartNumber,rowEndNumber,columnStartNumber,columnEndNumber);
}


