//
// Created by burr on 14.10.20.
//

#include "PluginAction.h"

using namespace DESCAM;

int PluginAction::previous_length_ = 0;

PluginAction::PluginAction(int argc, const char **argv, IModelFactory *model_factory) {

  CommonOptionsParser OptionsParser(argc, argv);

  // Delete files of previous runs
  auto sources = OptionsParser.getSourcePathList();
  int now_length = sources.size();
  if (previous_length_ > 0) {
    sources.erase(sources.begin(), sources.begin() + previous_length_);
  }
  previous_length_ = now_length;

  ClangTool Tool(OptionsParser.getCompilations(), sources);

  std::string output;
  llvm::raw_string_ostream ss(output);
  auto diagnosticOptions = new clang::DiagnosticOptions();
  diagnosticOptions->ShowSourceRanges = 1;
  auto diagnosticPrinter = new clang::ClangDiagnosticPrinter(ss, diagnosticOptions);
  Tool.setDiagnosticConsumer(diagnosticPrinter);
  Tool.run(new DESCAMFrontEndFactory(model_factory));
  diagnosticPrinter->addDiagnosticsToLogger(std::move(ss.str()));
}
