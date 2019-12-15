//
// Created by tobias on 25.11.19.
//

#ifndef DESCAM_FINDSTATENAME_H
#define DESCAM_FINDSTATENAME_H


#include <clang/AST/RecursiveASTVisitor.h>

class FindStateName: public clang::RecursiveASTVisitor<FindStateName> {
public:
    explicit FindStateName(clang::Stmt *stmt);
    bool VisitStringLiteral(clang::StringLiteral * stringLiteral);
    bool hasStateName() const;
    const std::string &getStateName() const;

private:
    std::string stateName = "";
    bool isSet = false;
};


#endif //DESCAM_FINDSTATENAME_H
