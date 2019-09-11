
#include <Stmts/EnumValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <llvm/Support/raw_ostream.h>
#include <Stmts/UnsignedValue.h>
#include "Variable.h"

SCAM::Variable::Variable(std::string name, SCAM::DataType *type, SCAM::ConstValue *initialValue, SCAM::Variable *parent) :
        VariableTemplate(name,type,initialValue,parent) {

}

void SCAM::Variable::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

