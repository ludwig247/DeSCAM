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


using namespace clang::driver;
using namespace clang::tooling;





namespace scpar{
	template < typename A > class LightsCameraAction:public clang::ASTFrontendAction	{
	protected:

		virtual clang::ASTConsumer * CreateASTConsumer(clang::CompilerInstance & ci, clang::StringRef)
		{
			return new A(ci);
		};

	};

}

using namespace scpar;

template < typename A > class PluginAction
{
public:
	PluginAction (int argc, const char **argv) {

		CommonOptionsParser OptionsParser (argc, argv);

		ClangTool Tool (OptionsParser.getCompilations (), OptionsParser.getSourcePathList ());

		std::string output;
		llvm::raw_string_ostream ss(output);
		clang::DiagnosticOptions * diagnosticOptions = new clang::DiagnosticOptions();
		clang::TextDiagnosticPrinter * diagnosticPrinter = new clang::TextDiagnosticPrinter(ss,diagnosticOptions);

		Tool.setDiagnosticConsumer(diagnosticPrinter);

		FrontendActionFactory *fe =	newFrontendActionFactory < LightsCameraAction < A > >();
		Tool.run(fe);
		std::cout << ss.str() << std::endl;

	};




private:

};



#endif /* _PLUGIN_ACTION_H_ */
