//
// Created by tobias on 22.10.15.
//

#ifndef SCAM_MEMBER_H
#define SCAM_MEMBER_H

#include <Stmts/ConstValue.h>
#include "AbstractNode.h"
#include "enums.h"
#include "DataType.h"
#include "VariableTemplate.h"

namespace DESCAM {

/** \brief Represnts a variable within the module structure
 *
 *  - Variable(std::string name,DataType * type)
 *  Every variable needs to have an initialValue, if not passed the following initialvalues are assuemd
 *  bool: false
 *  int: 0
 *  enum: the first symbolic value in the enum value list
 *
 *  - Variable with built-in type: Variable(std::string name,DataType * type, ConstValue * initialValue);
 *  - Compound Variable: Create all sub-variables with their initalValue, create a new variable and pass them as a list
 *
 */
class Variable : public VariableTemplate<Variable> {
 public:
  Variable(const std::string &name,
           const DataType *type,
           ConstValue *initial_value = nullptr,
           Variable *parent = nullptr,
           LocationInfo location_info = LocationInfo());

  //Visitor
  virtual void accept(AbstractVisitor &visitor);

};

}

#endif //SCAM_MEMBER_H
