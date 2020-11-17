//===-- src/PluginAction.h - systemc-clang class definition -------*- C++ -*-===//
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

/**
 * This class protects externally created ASTConsumers from being deleted by the clang::tooling framework.
 * Without this protection, a second run of a PluginAction in the ModelGlobal will work on a nullptr,
 * even though the Consumer and the PluginAction were created once more ? Why? Nobody knows...
 */
class Relay : public clang::ASTConsumer {
 private:
  clang::ASTConsumer* consumer_;
 public:
  explicit Relay(clang::ASTConsumer *consumer) : consumer_(consumer) {}

  void HandleTranslationUnit(clang::ASTContext &context) override{
    consumer_->HandleTranslationUnit(context);
  };
};

/**
 * Wrapper class required to interface with the clang::Tool class.
 * Acts as Factory for Relay
 */
class DeScamAction : public clang::ASTFrontendAction {
 public:
  explicit DeScamAction(IModelFactory *model_factory) :
      model_factory_(model_factory) {}

 private:
  IModelFactory *model_factory_;

 protected:
  std::unique_ptr<clang::ASTConsumer> CreateASTConsumer(clang::CompilerInstance &ci, clang::StringRef) override {
    model_factory_->setup(&ci);
    return std::make_unique<Relay>(model_factory_);
  };
};

/**
 * Wrapper class required to interface with the clang::Tool class.
 * Acts as Factory for DeScamAction
 */
class DESCAMFrontEndFactory : public FrontendActionFactory {
 private:
  IModelFactory *model_factory_;

 public:
  explicit DESCAMFrontEndFactory(IModelFactory *model_factory) : model_factory_(model_factory){};

  std::unique_ptr<clang::FrontendAction> create() override {
    return std::make_unique<DeScamAction>(model_factory_);
  }
};

/**
 * Wrapper class required to interface with the clang::Tool class.
 */
class PluginAction {
 private:
  //TODO: delete this static member
  /** length of last run source-file list because clang stores source file lists and we have to delete them */
  static int previous_length_;

 public:
  PluginAction(int argc, const char **argv, IModelFactory *model_factory);
};
}
#endif /* _PLUGIN_ACTION_H_ */
