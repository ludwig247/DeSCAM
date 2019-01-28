#include <iostream>
#include "FindCall.h"

namespace SCAM {
    FindCall::FindCall(clang::Stmt* stmt):
            pass(0),
            methodName(""),
            objectName("") {
        TraverseStmt(stmt);
    }


    FindCall::~FindCall() {
    }


    bool FindCall::VisitMemberExpr(clang::MemberExpr *memberExpr) {
        //obj->method()
        //Pass == 1: Check obj
        if (pass == 1) {
            this->objectName = memberExpr->getMemberDecl()->getNameAsString();
            this->pass = 2;
            return false;
        }

        return true;

    }

    bool FindCall::VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) {
        //Find Method name and Traverse Argument Tree
        //obj->method
        //Pass == 0: Check method
        if (pass == 0) {
            this->methodName = memberCallExpr->getDirectCallee()->getName().str();
            pass = 1;
            TraverseStmt(memberCallExpr->getImplicitObjectArgument());

            return false;
        }
        return true;
    }

    std::string FindCall::getMethodName() {
        return this->methodName;
    }

    std::string FindCall::getObjectName() {
        return this->objectName;
    }

    bool FindCall::isCall() {
        if(methodName != ""){
            return true;
        }
        return false;
    }
}