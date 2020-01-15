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
        explicit FindGlobal(clang::TranslationUnitDecl* decl, clang::CompilerInstance &ci,  SCAM::Module * module);
        FindGlobal() = delete;
        ~FindGlobal() = default;
        virtual bool VisitVarDecl(const clang::VarDecl * varDecl);
        virtual bool VisitFunctionDecl(const clang::FunctionDecl * funDecl);

        const std::map<std::string, Variable *> &getVariableMap() const;
        const std::map<std::string, Function *> &getFunctionMap() const;

        const std::map<std::string, const clang::FunctionDecl *> &getFunctionDeclMap() const;

    private:
        clang::CompilerInstance & ci;
        SCAM::DataType * getDataType(const clang::QualType& type) const;
        clang::TranslationUnitDecl* decl;
        SCAM::Module * module;
        std::map<std::string,Variable*> variableMap;
        std::map<std::string,Function*> functionMap;
        std::map<std::string,const clang::FunctionDecl*> functionDeclMap;
    };
}




#endif //DESCAM_FINDGLOBAL_H
