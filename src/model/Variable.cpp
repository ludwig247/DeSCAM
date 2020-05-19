
#include <Stmts/EnumValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <llvm/Support/raw_ostream.h>
#include <Stmts/UnsignedValue.h>
#include "Variable.h"

DESCAM::Variable::Variable(std::string name, const DataType *type, DESCAM::ConstValue *initialValue, DESCAM::Variable *parent, LocationInfo locationInfo) :
        VariableTemplate(name, type, initialValue, parent,locationInfo) {
}

void DESCAM::Variable::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

