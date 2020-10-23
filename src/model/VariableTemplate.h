//
// Created by tobias on 15.11.18.
//

#ifndef PROJECT_VARIABLEINTERFACE_H
#define PROJECT_VARIABLEINTERFACE_H

#include "TypeInterface.h"
#include "ConstValue.h"

namespace DESCAM {
template<class T>
class VariableTemplate : public TypeInterface, public AbstractNode {
 public:
  explicit VariableTemplate(const std::string &name,
                            const DataType *data_type,
                            ConstValue *initial_value = nullptr,
                            VariableTemplate *parent = nullptr,
                            LocationInfo location_info = LocationInfo());

  virtual T *getParent() const final;

  virtual ConstValue *getInitialValue() const final;

  virtual bool isSubVar() const final;

  virtual bool hasSubVar(const std::string &n) const final;

  virtual T *getSubVar(const std::string &n) const final;

  virtual std::vector<T *> getSubVarList() const final;

  std::string getFullName(const std::string &delimiter = ".") const;

  bool isConstant() const;
  void setConstant(bool isConstant);
  bool isArrayElement() const;

 private:

  std::vector<VariableTemplate *> subVarList;
  bool subVar; //! True, if this is a subVar
  VariableTemplate *parent; //! If this is a subVar; parent points to the variable contining this
  DESCAM::ConstValue *initial_value_;
  bool constant = false;

};

template
class VariableTemplate<Variable>;

template
class VariableTemplate<DataSignal>;

template
class VariableTemplate<Parameter>;

template
class VariableTemplate<Timepoint>;
};

#endif //PROJECT_VARIABLEINTERFACE_H
