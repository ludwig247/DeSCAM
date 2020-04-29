
#include <Stmts/EnumValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <llvm/Support/raw_ostream.h>
#include <Stmts/UnsignedValue.h>
#include "Variable.h"

SCAM::Variable::Variable(std::string name, const DataType *type, SCAM::ConstValue *initialValue, SCAM::Variable *parent, LocationInfo locationInfo) :
        VariableTemplate(name, type, initialValue, parent,locationInfo) {
}

void SCAM::Variable::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

