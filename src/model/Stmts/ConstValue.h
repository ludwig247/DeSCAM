//
// Created by ludwig on 04.11.15.
//

#ifndef SCAM_CONSTVALUE_H
#define SCAM_CONSTVALUE_H

#include "Expr.h"

namespace DESCAM {

class ConstValue : public Expr {
 public:
  ConstValue(const DataType *dataType);

  virtual ~ConstValue() = default;

  virtual std::string getValueAsString() const = 0;

};
}

#endif //SCAM_CONSTVALUE_H
