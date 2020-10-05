#ifndef DESCAM_CHECKERRORS_H
#define DESCAM_CHECKERRORS_H


//Clang
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/AST.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Parse/Parser.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"


// PArse SystemC
#include "FindPorts.h"
#include "FindSCMain.h"
#include "FindModules.h"
#include "FindNetlist.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "Model.h"
#include <iostream>

using namespace clang::driver;
using namespace clang::tooling;
using namespace clang;


namespace DESCAM {

    bool containsSubstring(std::string, std::string);

    class CheckErrors : public ASTConsumer, public RecursiveASTVisitor<CheckErrors> {
    public:
        explicit CheckErrors(CompilerInstance &ci);

        ~CheckErrors() override = default;

        virtual bool preFire();

        virtual bool fire();

        virtual bool postFire();

    private:
        Model *model;
        CompilerInstance &_ci;
        ASTContext &_context;
        SourceManager &_sm;
        llvm::raw_ostream &_os;
        std::vector<std::string> unimportantModules; //! List containing unimportant modules

        //Methods
        void HandleTranslationUnit(ASTContext &context) override;

        void addModules(clang::TranslationUnitDecl *decl);

        void addGlobalConstants(TranslationUnitDecl *pDecl);

        void addPorts(Module *module, clang::CXXRecordDecl *decl);

        void addFunctions(Module *module, CXXRecordDecl *decl);

        void addBehavior(Module *module, clang::CXXRecordDecl *decl);

        void addVariables(Module *module, clang::CXXRecordDecl *decl);
    };


}
#endif //DESCAM_CHECKERRORS_H
