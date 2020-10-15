//
// Created by tobias on 29.04.16.
//

#ifndef SCAM_FINDSTRUCT_H
#define SCAM_FINDSTRUCT_H

#include <map>
#include <clang/AST/RecursiveASTVisitor.h>
#include <DataType.h>
#include <DataTypes.h>
#include "IFindNewDatatype.h"

/*!
 * \brief Maps clang:Qualtypes to DESCAM:Datatypes
 */

namespace DESCAM {

class FindNewDatatype : public IFindNewDatatype, public clang::RecursiveASTVisitor<FindNewDatatype> {
 public:

  ~FindNewDatatype() override = default;

  DESCAM::DataType *getDataType(const clang::QualType &type,
                                clang::CompilerInstance *ci,
                                DESCAM::Module *module) override;
  std::string getTypeName(const clang::QualType &type) override;
  bool isGlobal(const clang::QualType &type) override; //! Returns true, if datatype is not defined within a module class

};

}

#endif //SCAM_FINDSTRUCT_H
