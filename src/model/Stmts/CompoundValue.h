//
// Created by tobias on 09.08.17.
//

#ifndef PROJECT_COMPOUNDVALUE_H
#define PROJECT_COMPOUNDVALUE_H

#include "ConstValue.h"

namespace DESCAM {

class CompoundValue : public ConstValue {
 public:
  CompoundValue(const std::vector<ConstValue *> &values,
                const DataType *dataType,
                LocationInfo stmtLocationInfo = LocationInfo());

  //GETTER
  const std::map<std::string, ConstValue *> &getValues() const;

  virtual std::string getValueAsString() const override;

  //VISITOR
  void accept(StmtAbstractVisitor &visitor) override;

  bool operator==(const Stmt &other) const override;

 private:
  std::map<std::string, ConstValue *> values;
};
};
#endif //PROJECT_COMPOUNDVALUE_H
