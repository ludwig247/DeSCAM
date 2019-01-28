//
// Created by tobias on 22.10.15.
//

#ifndef SCAM_FINDMEMBERS_H
#define SCAM_FINDMEMBERS_H

#include <map>
#include "clang/AST/RecursiveASTVisitor.h"



namespace SCAM{
   /**
     ** \brief Visit fieldDecl of a recordDecl: Memeber Variables
     **
     ** Ports are covered by find Ports. Hence, here we're looking for everything else.
     ** For now, we are considering built-in types only. Here we are also able to track down
     ** Types that are not supported!
    */

    class FindVariables : public clang::RecursiveASTVisitor<FindVariables> {
    public:
        FindVariables(clang::CXXRecordDecl* recordDecl);
        //Visitor
        bool VisitFieldDecl(clang::FieldDecl *fieldDecl);
        //GETTER
        std::map<std::string, clang::QualType>  getVariableTypeMap() const;
        const std::map<std::string, clang::FieldDecl *> & getVariableMap() const;
    private:
        clang::CXXRecordDecl* recordDecl;
        std::map<std::string,clang::FieldDecl*> memberMap; //! <NameOfField,Declaration>
        std::map<std::string, std::string> memberTypeMap; //! <NameOfField,Declaration>

    };


}


#endif //SCAM_FINDMEMBERS_H
