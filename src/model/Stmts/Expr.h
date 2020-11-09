//
// Created by ludwig on 02.11.16.
//

#ifndef SCAM_EXPR_H
#define SCAM_EXPR_H

#include <DataType.h>
#include "StmtAbstractVisitor.h"
#include "Stmt.h"
#include <DataTypes.h>

namespace DESCAM {

class Expr : public Stmt {
 public:
  Expr() = delete;
  explicit Expr(const DataType *dataType, LocationInfo stmtLocationInfo = LocationInfo());
  ~Expr() = default;

  const DataType *getDataType() const;

  std::ostream &print(std::ostream &ostream) const override;

  bool isDataType(std::string n) const;
  void accept(StmtAbstractVisitor &visitor) override = 0;

 private:
  const DataType *dataType;
};

}

#endif //SCAM_EXPR_H
