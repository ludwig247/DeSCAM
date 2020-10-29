//
// Created by schwarz on 06.10.20.
//

#ifndef SCAM_IFINDGLOBAL_H
#define SCAM_IFINDGLOBAL_H

#include <Variable.h>
#include <Function.h>
#include <clang/Frontend/CompilerInstance.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include <map>
#include <string>
#include "IFindDataFlow.h"
#include "IFindDataFlowFactory.h"

namespace DESCAM {

/**
 * TODO Comment for DoD
 */
class IFindGlobal {
 public:

  virtual ~IFindGlobal() = default;

  virtual bool setup(clang::TranslationUnitDecl *decl,
                     clang::CompilerInstance *ci,
                     IFindDataFlowFactory *find_data_flow_factory) = 0;

  virtual const std::map<std::string, Variable *> &getVariableMap() const = 0;

  virtual const std::map<std::string, Function *> &getFunctionMap() const = 0;

  virtual std::vector<DESCAM::Stmt *> getFunctionBody(std::string function_name,
                                                      DESCAM::Function *function) const = 0;
};
}

#endif //SCAM_IFINDGLOBAL_H
