#ifndef _FIND_SCMAIN_H_
#define _FIND_SCMAIN_H_


#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM {
    /*!
     * \brief Finds the sc_main within a TranslationUnit
     */
    class FindSCMain : public clang::RecursiveASTVisitor<FindSCMain> {
    public:
        FindSCMain(clang::TranslationUnitDecl *);

        virtual bool VisitFunctionDecl(clang::FunctionDecl *functionDecl);

        bool isScMainFound() const;

        clang::FunctionDecl* getSCMainFunctionDecl();

    private:
        clang::FunctionDecl *_scmainFunctionDecl;
        int pass;
        bool scMainFound;

    };
}
#endif
