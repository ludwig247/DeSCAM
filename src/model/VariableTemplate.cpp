//
// Created by tobias on 15.11.18.
//
#include "VariableTemplate.h"
#include "Variable.h"
#include "DataSignal.h"
#include "Timepoint.h"
#include "Parameter.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "DescamException.h"

namespace DESCAM {
template<class T>
VariableTemplate<T>::VariableTemplate(const std::string &name,
                                      const DataType *data_type,
                                      ConstValue *initial_value,
                                      VariableTemplate *parent,
                                      LocationInfo location_info) :
    subVar(parent != nullptr),
    parent(parent),
    initial_value_(initial_value),
    AbstractNode(name, location_info),
    TypeInterface(data_type) {

  //Build sub variables for complex types
  if (this->isCompoundType()) {
    if (this->isSubVar())
      throw DescamException("in variable '" + getName() + "', a compound sub-variable is not allowed", location_info);
    //if (parent == nullptr) TERMINATE("Parent is not supposed to be null");
    //create the subVariables (with default init values)
    for (auto &&sub_var : data_type->getSubVarMap()) {
      subVarList.push_back(new T(sub_var.first, sub_var.second, sub_var.second->getDefaultVal(), (T *) (this)));
    }
  } else if (this->isArrayType()) {
    if (this->isSubVar())
      throw DescamException("in variable '" + getName() + "', a array sub-variable is not allowed",
                            location_info);
    //if (parent == nullptr) TERMINATE("Parent is not supposed to be null");
    for (int i = 0; i < data_type->getArraySize(); ++i) {
      subVarList.push_back(new T(std::to_string(i),
                                 this->getDataType()->getArrayType(),
                                 this->getDataType()->getArrayType()->getDefaultVal(),
                                 (T *) (this)));
    }
  } else if (!this->isBuiltInType() && !this->isEnumType())
    throw DescamException("variable '" + getName() + ", with unknown datatype", location_info);

  if (this->initial_value_ == nullptr) {
    this->initial_value_ = data_type->getDefaultVal();
  } else
    assert(data_type == initial_value->getDataType());
}

template<class T>
bool VariableTemplate<T>::hasSubVar(const std::string &n) const {
  if (!this->isCompoundType() && !this->isArrayType()) TERMINATE(
      "Variable hasSubVar, called for a non-compound/array variable");
  for (auto &&sub_var : subVarList) {
    if (sub_var->getName() == n) {
      return true;
    }
  }
  return false;
}

template<class T>
bool VariableTemplate<T>::isSubVar() const {
  return subVar;
}

template<class T>
ConstValue *VariableTemplate<T>::getInitialValue() const {
  return initial_value_;
}

template<class T>
std::string VariableTemplate<T>::getFullName(const std::string &delimiter) const {
  if (this->isSubVar() && this->parent->isCompoundType()) {
    return this->parent->getName() + delimiter + this->getName();
  } else if (this->isSubVar() && this->parent->isArrayType()) {
    return this->parent->getName() + "[" + this->getName() + "]";
  } else return this->getName();
}

template<class T>
T *VariableTemplate<T>::getSubVar(const std::string &n) const {
  if (!this->isCompoundType() && !this->isArrayType()) TERMINATE(
      "Variable getSubVar, called for a non-compound variable");

  for (auto &&sub_var : subVarList) {
    if (sub_var->getName() == n) {
      return (T *) sub_var;
    }
  }
  TERMINATE("Variable getSubVar called with \"" + n + "\", not a sub-variable name");
}

template<class T>
T *VariableTemplate<T>::getParent() const {
  return (T *) parent;
}

template<class T>
std::vector<T *> VariableTemplate<T>::getSubVarList() const {
  std::vector<T *> test;
  for (VariableTemplate *sub_var: this->subVarList) {
    test.push_back((T *) sub_var);
  }
  return test;
}

template<class T>
bool VariableTemplate<T>::isConstant() const {
  return constant;
}

template<class T>
void VariableTemplate<T>::setConstant(bool isConstant) {
  VariableTemplate::constant = isConstant;
}

template<class T>
bool VariableTemplate<T>::isArrayElement() const {
  return this->isSubVar() && this->parent->isArrayType();
}
}