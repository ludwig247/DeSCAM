//
// Created by tobias on 13.11.19.
//

#ifndef DESCAM_FINDGLOBAL_H
#define DESCAM_FINDGLOBAL_H

#include <map>
#include <string>
#include <Module.h>
#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM{
    class FindGlobal: public clang::RecursiveASTVisitor<FindGlobal> {
    public:
        explicit FindGlobal(clang::TranslationUnitDecl* decl, SCAM::Module * module);
        FindGlobal() = delete;
        ~FindGlobal() = default;
        virtual bool VisitVarDecl(const clang::VarDecl * varDecl);

        const std::map<std::string, Variable *> &getVariableMap() const;

    private:
        clang::TranslationUnitDecl* decl;
        SCAM::Module * module;


        std::map<std::string,Variable*> variableMap;
    };
}




#endif //DESCAM_FINDGLOBAL_H
