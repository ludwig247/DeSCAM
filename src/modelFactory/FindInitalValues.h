//
// Created by ludwig on 09.11.15.
//

#ifndef SCAM_FINDCONSTRUCTOR_H
#define SCAM_FINDCONSTRUCTOR_H

#include <Variable.h>
#include <Model.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include <clang/AST/Stmt.h>
#include <clang/Analysis/CFG.h>
#include <clang/Basic/SourceManager.h>
#include <clang/Frontend/CompilerInstance.h>

namespace SCAM{
    /**
     * \brief Visits the constructors of a sc_module in order to find inital values for members
     *
     * FindInitalValues has to be called after FindMember, otherwise no intitalvalues can be found.
     *
     */
    class FindInitalValues : public clang::RecursiveASTVisitor<FindInitalValues> {
    public:
        virtual ~ FindInitalValues() = default;
        static ConstValue * getInitValue(clang::CXXRecordDecl *recordDecl, clang::FieldDecl * fieldDecl, SCAM::Module *module, clang::CompilerInstance& ci);

        //Visitor
        virtual bool VisitCXXConstructorDecl(clang::CXXConstructorDecl* constructorDecl);
    private:
        FindInitalValues() = default;
        FindInitalValues(clang::CXXRecordDecl *recordDecl, clang::FieldDecl * fieldDecl, SCAM::Module *module, clang::CompilerInstance& ci);

        clang::FieldDecl * fieldDecl;
        ConstValue * initValue;
        int pass;
        SCAM::Module * module;
        clang::CompilerInstance& ci;
    };

}


#endif //SCAM_FINDCONSTRUCTOR_H
