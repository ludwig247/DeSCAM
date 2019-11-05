//
#include "Path.h"

// Created by ludwig on 05.07.16.
SCAM::Path::Path(const SCAM::Path &path) :
        stmtList(path.getStmtList()){
}

SCAM::Path::Path(const SCAM::Path &path, const std::vector<SCAM::Stmt *> &stmtList) :
        stmtList(stmtList){
}

SCAM::Path::~Path() {
}

void SCAM::Path::addStmt(SCAM::Stmt *stmt) {
    this->stmtList.push_back(stmt);
}


const std::vector<SCAM::Stmt *> &SCAM::Path::getStmtList() const {
    return this->stmtList;
}


SCAM::Path &SCAM::Path::operator+=(const SCAM::Path &newPath) {
        for (auto stmt: newPath.getStmtList()) {
            this->stmtList.push_back(stmt);
        }
        return *this;
}


