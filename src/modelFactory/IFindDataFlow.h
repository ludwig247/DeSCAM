//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
#define SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_

//Clang
#include <clang/AST/Stmt.h>
#include <clang/Analysis/CFG.h>
#include <clang/Basic/SourceManager.h>
#include <clang/Frontend/CompilerInstance.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include <map>
#include <iostream>
//DESCAM

#include <Logger/Logger.h>
#include <Model.h>
#include "PrintStmt.h"

namespace DESCAM {

/**
 * @brief processes a clang::stmt and extract all necessary information from it
 */
class IFindDataFlowFactory;
class IFindDataFlow {
 public:
  virtual ~IFindDataFlow() = default;
  virtual Expr *getExpr() const = 0;
  virtual DESCAM::Stmt *getStmt() = 0;
  virtual bool setup(clang::Stmt * _stmt, Module * _module, clang::CompilerInstance * _ci,IFindDataFlowFactory * find_data_flow_factory,bool _unsigned_flag) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
