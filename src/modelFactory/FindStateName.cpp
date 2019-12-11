//
// Created by tobias on 25.11.19.
//

#include "FindStateName.h"

FindStateName::FindStateName(clang::Stmt *stmt) {
    TraverseStmt(stmt);
}

bool FindStateName::VisitStringLiteral(clang::StringLiteral *stringLiteral) {
    this->stateName = stringLiteral->getString().str();
    this->isSet = true;
    return false;
}

const std::string &FindStateName::getStateName() const {
    return stateName;
}

bool FindStateName::hasStateName() const {
    return this->isSet;
}

