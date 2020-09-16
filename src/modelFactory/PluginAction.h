//===-- src/PluginAction.h - systec-clang class definition -------*- C++ -*-===//
//
//                     modelFactory: SystemC Parser
//
// This file is distributed under the TBD
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file contains the class for defining basic plugin actions.
///
//===----------------------------------------------------------------------===//
#ifndef _PLUGIN_ACTION_H_
#define _PLUGIN_ACTION_H_


#include <iostream>
#include <GlobalUtilities.h>
#include <Logger/Logger.h>
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/AST.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Parse/Parser.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "ClangDiagnosticPrinter.h"


using namespace clang::driver;
using namespace clang::tooling;


namespace scpar {
    template<typename A>
    class LightsCameraAction : public clang::ASTFrontendAction {
    protected:

        virtual clang::ASTConsumer *CreateASTConsumer(clang::CompilerInstance &ci, clang::StringRef) {
            return new A(ci);
        };

    };

}

using namespace scpar;

template<typename A>
class PluginAction {
public:
    PluginAction(int argc, const char **argv) {

        std::vector<std::string> arg;

     //Ensures that only the specified file paths given as arguments in command line are passed to CLang at a time
        for(int i=1; i < argc ; i++) {
            if(!(std::string(argv[i]) == "--")){
                arg.push_back(argv[i]);
//                std::cout << "ARG: " << arg[i-1] << std::endl;
            }
            else break;
        };

        CommonOptionsParser OptionsParser (argc, argv);

        //Print to screen file paths given to compiler through CommonOptionsParser
//        for(auto src: OptionsParser.getSourcePathList()){
//            std::cout << "OP:" << src << std::endl;
//        }


		ClangTool Tool (OptionsParser.getCompilations (), arg);

        std::string output;
        llvm::raw_string_ostream ss(output);
        auto diagnosticOptions = new clang::DiagnosticOptions();
        diagnosticOptions->ShowSourceRanges = 1;
        auto diagnosticPrinter = new clang::ClangDiagnosticPrinter(ss, diagnosticOptions);
        Tool.setDiagnosticConsumer(diagnosticPrinter);
        FrontendActionFactory *fe = newFrontendActionFactory<LightsCameraAction<A> >();
        Tool.run(fe);
        diagnosticPrinter->addDiagnosticsToLogger(std::move(ss.str()));
    }

};

#endif /* _PLUGIN_ACTION_H_ */
