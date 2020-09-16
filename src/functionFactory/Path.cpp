//
#include "Path.h"

// Created by ludwig on 05.07.16.
DESCAM::Path::Path(const DESCAM::Path &path) :
        stmtList(path.getStmtList()){
}

DESCAM::Path::Path(const DESCAM::Path &path, const std::vector<DESCAM::Stmt *> &stmtList) :
        stmtList(stmtList){
}

DESCAM::Path::~Path() {
}

void DESCAM::Path::addStmt(DESCAM::Stmt *stmt) {
    this->stmtList.push_back(stmt);
}


const std::vector<DESCAM::Stmt *> &DESCAM::Path::getStmtList() const {
    return this->stmtList;
}


DESCAM::Path &DESCAM::Path::operator+=(const DESCAM::Path &newPath) {
        for (auto stmt: newPath.getStmtList()) {
            this->stmtList.push_back(stmt);
        }
        return *this;
}


