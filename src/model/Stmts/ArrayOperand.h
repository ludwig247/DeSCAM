//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_SELECT_H
#define PROJECT_SELECT_H

#include <string>
#include "StmtAbstractVisitor.h"
#include "Operand.h"

namespace DESCAM {
class ArrayOperand : public Expr {
 public:
  ArrayOperand() = delete;

  ArrayOperand(Variable *arrayVar, Expr *idx, LocationInfo stmtLocationInfo = LocationInfo());
  ArrayOperand(Operand *operand, Expr *idx, LocationInfo stmtLocationInfo = LocationInfo());

  ~ArrayOperand() override = default;

  Operand *getArrayOperand() const;

  Expr *getIdx() const;

  bool operator==(const Stmt &other) const override;

  void accept(StmtAbstractVisitor &visitor) override;

 private:
  DESCAM::Variable *array_var_{};
  Operand *operand_;

  DESCAM::Expr *idx_;
};
}

#endif //PROJECT_SELECT_H
