//
// Created by tobias on 29.04.16.
//

#ifndef SCAM_FINDSTRUCT_H
#define SCAM_FINDSTRUCT_H

#include <map>
#include <clang/AST/RecursiveASTVisitor.h>
#include <DataType.h>
#include <DataTypes.h>

/*!
 * \brief Maps clang:Qualtypes to DESCAM:Datatypes
 */

namespace DESCAM{

class FindNewDatatype : public clang::RecursiveASTVisitor<FindNewDatatype> {
public:

    static DESCAM::DataType*  getDataType(const clang::QualType& type);
    static std::string getTypeName(const clang::QualType& type);
    static bool isGlobal(const clang::QualType& type); //! Returns true, if datatype is not defined within a module class

};

}

#endif //SCAM_FINDSTRUCT_H
