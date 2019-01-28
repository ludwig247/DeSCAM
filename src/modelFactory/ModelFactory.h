//
// Created by ludwig on 15.09.15.
//

#ifndef SCAM_CREATEMODEL_H
#define SCAM_CREATEMODEL_H


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
#include "FindCall.h"
#include "FindModules.h"
#include "FindNetlist.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "Model.h"
#include <iostream>

using namespace clang::driver;
using namespace clang::tooling;
using namespace clang;



namespace SCAM {

    bool containsSubstring(std::string,std::string);

    /*!
     * \brief Factory for creating a SCAM::Model
     *
     * HandleTranslationUnit is called after instantiation of the model and calls three methods preFire, fire and postFire
     * The preFire face is unimportant for us and is automatically followed by the fire face.
     * During the fire face the clang ast is instantiated and can be accessed using visitors.
     * The clang::TranslationUnitDecl contains the hole AST and is passed to FindModules in order to extract the modules of the
     * systemc description. For each module the ports are extraced using FindPorts and so on.
     * Aferwards a netlist of all modules is extracted, starting with the sc_main().
     * Right now only two modules can be connceted and  a nested modules are not supported
     *
     * The model is then accessed using the SCAM::GraphVistor. This visitors only prints the structural information of the system.
     * In order to access the behavioral information  for each module we refer SCAM::SuspensionAutomata.
     *
     */
    class ModelFactory : public ASTConsumer, public RecursiveASTVisitor<ModelFactory> {

    public:
        ModelFactory(CompilerInstance &ci);

        virtual ~ModelFactory();

        virtual bool preFire();
        virtual bool fire();
        virtual bool postFire();


    private:
        Model* model;
        CompilerInstance &_ci;
        virtual void HandleTranslationUnit(ASTContext & context);
        ASTContext & _context;
        SourceManager & _sm;
        llvm::raw_ostream & _os;

        std::vector<std::string> unimportantModules; //! List containing unimportant modules


        //Methods
        void addModules(clang::TranslationUnitDecl* decl);
        void addPorts(Module* module,clang::CXXRecordDecl* decl);
        void addFunctions(Module *module, CXXRecordDecl *pDecl);
        void addBehavior(Module *module, clang::CXXRecordDecl *decl);
        void addSections(Module *module, clang::CXXRecordDecl *decl);
        void addVariables(Module *module, clang::CXXRecordDecl *decl); //!Adds variable to module
        void addInstances(TranslationUnitDecl * tu );

        bool moduleHasSections; //! True if the module that is currently processed has explicte state rep. need for section dection

        void addCommunicationFSM(SCAM::Module *pModule);
    };


}
#endif //SCAM_CREATEMODEL_H
