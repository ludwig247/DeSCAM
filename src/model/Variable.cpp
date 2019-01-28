
#include <Stmts/EnumValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/BoolValue.h>
#include <llvm/Support/raw_ostream.h>
#include <Stmts/UnsignedValue.h>
#include "Variable.h"

SCAM::Variable::Variable(std::string name, SCAM::DataType *type, SCAM::ConstValue *initialValue) :
        dataType(type),
        mIsSubVar(false),
        parent(nullptr),
        initialValue(initialValue),
        AbstractNode(name) {
    //check that the init value has the write DataType
    assert(initialValue != nullptr);
    if (initialValue->getDataType() != type)
        throw std::runtime_error("Variable Constructor, initial_value type does not match the varialbe type");
    if (type->isCompoundType()) {
        //if compound type (all data (and initial values of those) in sub-variables
        //we do not allow sub-variables to be compound (allow only one level nesting)
        if (this->isSubVar()) throw std::runtime_error("Variable Constructor, a compound sub-variable is not allowed");

        //create the subVariables (with default init values)
        for (auto &&subvar : dataType->getSubVarMap()) {
            subVarList.push_back(new Variable(subvar.first, subvar.second, this));
        }
    }
}


SCAM::Variable::Variable(std::string name, SCAM::DataType *type, Variable *parent) :
        dataType(type),
        mIsSubVar(parent != nullptr),
        parent(parent),
        AbstractNode(name) {
    //not explicit init value, use default init values
    if (type->isEnumType()) {
        //FIXME: don't take the first element, search for element with enum_value == 0
        initialValue = new EnumValue(type->getEnumValueMap().begin()->first, type);
    } else if (type->isBuiltInType()) {
        if (type->getName() == "int") {
            initialValue = new IntegerValue(0);
        } else if (type->getName() == "unsigned") {
            initialValue = new UnsignedValue(0);
        } else if (type->getName() == "bool") {
            initialValue = new BoolValue(false);
        } else throw std::runtime_error("Unknown built-in type");
    } else if (type->isCompoundType()) {
        //if compound type (all data (and initial values of those) in sub-variables
        //we do not allow sub-variables to be compound (allow only one level nesting)
        throw std::runtime_error("Variable Constructor, a compound sub-variable is not allowed");
    } else throw std::runtime_error("Unknown datatype" + type->getName());

}

void SCAM::Variable::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::DataType *SCAM::Variable::getDataType() {
    return this->dataType;
}

bool SCAM::Variable::isSubVar() const {
    return mIsSubVar;
}

SCAM::Variable *SCAM::Variable::getParent() const {
    if (this->isSubVar()) return parent;
    throw std::runtime_error("Variable is not SubVariable");
}

void SCAM::Variable::setInitialValue(SCAM::ConstValue *initialValue) {
    Variable::initialValue = initialValue;
}

SCAM::ConstValue * SCAM::Variable::getInitialValue() const {
    if (this->getSubVarList().size() != 0)
        throw std::runtime_error(this->getName() + ": Compound doesn't have a initial value");
    return initialValue;
}

const std::vector<SCAM::Variable *> &SCAM::Variable::getSubVarList() const {
    return subVarList;
}

bool SCAM::Variable::isCompoundType() {
    return this->getDataType()->isCompoundType();
}

bool SCAM::Variable::hasSubVar(const std::string &n) {
    if (!this->isCompoundType()) throw std::runtime_error("Variable hasSubVar, called for a non-compound variable");
    for (auto &&subvar : subVarList) {
        if (subvar->getName() == n) {
            return true;
        }
    }
    return false;
}

SCAM::Variable *SCAM::Variable::getSubVar(const std::string &n) {
    if (!this->isCompoundType()) throw std::runtime_error("Variable getSubVar, called for a non-compound variable");

    for (auto &&subvar : subVarList) {
        if (subvar->getName() == n) {
            return subvar;
        }
    }
    throw std::runtime_error("Variable getSubVar called with \"" + n + "\", not a sub-variable name");

}

std::string SCAM::Variable::getFullName() const {
    if (this->isSubVar()) {
        return this->parent->getName() + "." + this->getName();
    }
    return this->getName();
}

