
#include <Stmts/EnumValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <Stmts/UnsignedValue.h>
#include "Variable.h"

DESCAM::Variable::Variable(const std::string &name,
                           const DataType *type,
                           DESCAM::ConstValue *initial_value,
                           DESCAM::Variable *parent,
                           LocationInfo location_info) :
    VariableTemplate(name, type, initial_value, parent, std::move(location_info)) {
}

void DESCAM::Variable::accept(DESCAM::AbstractVisitor &visitor) {
  visitor.visit(*this);
}

