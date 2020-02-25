//
// Created by wezel on 2/25/20.
//

#ifndef DESCAM_FINDCHANNELMETHODS_H
#define DESCAM_FINDCHANNELMETHODS_H

#endif //DESCAM_FINDCHANNELMETHODS_H
#include <map>
#include <string>
#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM {

    class FindChannelMethods : public clang::RecursiveASTVisitor<FindChannelMethods> {
    public:

        FindChannelMethods(clang::CXXRecordDecl*);

        virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *);

        const std::map<std::string, clang::CXXMethodDecl *> & getChannelMethodMap();

    private:
        clang::CXXMethodDecl * constructor;
        std::map<std::string, clang::CXXMethodDecl *> _ChannelMethodMap;

    };
}

