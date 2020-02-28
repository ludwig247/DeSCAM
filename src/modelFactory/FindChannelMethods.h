//
// Created by wezel on 2/25/20.
//

#ifndef DESCAM_FINDCHANNELMETHODS_H
#define DESCAM_FINDCHANNELMETHODS_H

#endif //DESCAM_FINDCHANNELMETHODS_H
#include <map>
#include <string>
#include "clang/AST/RecursiveASTVisitor.h"
#include "FindFunctions.h"

namespace SCAM {

    class FindChannelMethods : public FindFunctions {
    public:

        FindChannelMethods(clang::CXXRecordDecl *recordDecl);

        virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *);



    private:
        clang::CXXMethodDecl * constructor;
        std::map<std::string, std::vector<std::string>> ConstructorParamNameMap;
        std::map<std::string, std::vector<std::string>> ConstructorParamTypeMap;

    };
}

