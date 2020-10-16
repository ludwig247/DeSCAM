//
// Created by burr on 09.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDNEWDATATYPE_H_
#define SCAM_SRC_MODELFACTORY_IFINDNEWDATATYPE_H_

#include "DataType.h"
#include "clang/AST/Type.h"
#include "Module.h"
#include "clang/Frontend/CompilerInstance.h"

namespace DESCAM {
class IFindNewDatatype {
 public:
  virtual ~IFindNewDatatype() = default;

  virtual DESCAM::DataType *getDataType(const clang::QualType &type) = 0;
  virtual std::string getTypeName(const clang::QualType &type) = 0;
  virtual bool isGlobal(const clang::QualType &type) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDNEWDATATYPE_H_
