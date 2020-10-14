//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
#define SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_

//Clang


namespace DESCAM {

/**
 * @brief processes a clang::stmt and extract all necessary information from it
 */
class IFindDataFlow {
 public:
  virtual ~IFindDataFlow() = default;
  virtual Expr *getExpr() const = 0;
  virtual DESCAM::Stmt *getStmt() = 0;
  virtual bool setup(clang::Stmt *stmt, Module *module, clang::CompilerInstance *ci, bool unsigned_flag) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
