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
 * \brief Maps clang:Qualtypes to SCAM:Datatypes
 */

namespace SCAM{

class FindNewDatatype : public clang::RecursiveASTVisitor<FindNewDatatype> {
public:

    static SCAM::DataType*  getDataType(const clang::QualType& type, std::map<std::string, clang::CXXRecordDecl *> _moduleMap);
    static std::string getTypeName(const clang::QualType& type);
    static bool isGlobal(const clang::QualType& type); //! Returns true, if datatype is not defined within a module class

};

}

#endif //SCAM_FINDSTRUCT_H