//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TIMEPOINTOPERAND_H
#define DESCAM_TIMEPOINTOPERAND_H

#include "NodePeekVisitor.h"
#include "Operand.h"
#include "Timepoint.h"

namespace DESCAM {
/**
 * \brief Points to a TimeExpr
 *
 */
class TimePointOperand : public Operand {
 public:
  explicit TimePointOperand(Timepoint *timepoint, LocationInfo stmtLocationInfo = LocationInfo());

  Timepoint *getTimepoint() const;

  void accept(StmtAbstractVisitor &visitor) override;

  std::string getOperandName() const override;

  bool operator==(const Stmt &other) const override;

 private:
  Timepoint *timepoint;
};

}
#endif //DESCAM_TIMEPOINTOPERAND_H
