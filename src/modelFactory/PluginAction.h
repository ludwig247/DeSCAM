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
#include "IModelFactory.h"

using namespace clang::driver;
using namespace clang::tooling;

namespace DESCAM {

class LightsCameraAction : public clang::ASTFrontendAction {
 public:
  explicit LightsCameraAction(IModelFactory *model_factory) :
      model_factory_(model_factory) {}
 private:
  IModelFactory *model_factory_;
 protected:
  clang::ASTConsumer *CreateASTConsumer(clang::CompilerInstance &ci, clang::StringRef) override {
    model_factory_->setup(&ci);
    return model_factory_;
  };
};

class DESCAMFrontEndFactory: public FrontendActionFactory{
 private:
  LightsCameraAction *lights_camera_action_;
 public:
  explicit DESCAMFrontEndFactory(LightsCameraAction *lights_camera_action):
  lights_camera_action_(lights_camera_action){};
  clang::FrontendAction * create() override{
    return lights_camera_action_;
  }
};

class PluginAction {
 public:
  PluginAction(int argc, const char **argv, IModelFactory *model_factory) {

    CommonOptionsParser OptionsParser(argc, argv);

    ClangTool Tool(OptionsParser.getCompilations(), OptionsParser.getSourcePathList());

    std::string output;
    llvm::raw_string_ostream ss(output);
    auto diagnosticOptions = new clang::DiagnosticOptions();
    diagnosticOptions->ShowSourceRanges = 1;
    auto diagnosticPrinter = new clang::ClangDiagnosticPrinter(ss, diagnosticOptions);
    Tool.setDiagnosticConsumer(diagnosticPrinter);
    auto *lights_camera_action = new LightsCameraAction(model_factory);
    FrontendActionFactory *fe = new DESCAMFrontEndFactory(lights_camera_action);
    Tool.run(fe);
    diagnosticPrinter->addDiagnosticsToLogger(std::move(ss.str()));
  }
};
}

#endif /* _PLUGIN_ACTION_H_ */
