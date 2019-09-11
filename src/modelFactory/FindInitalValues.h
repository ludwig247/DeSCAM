//
// Created by ludwig on 09.11.15.
//

#ifndef SCAM_FINDCONSTRUCTOR_H
#define SCAM_FINDCONSTRUCTOR_H

#include <Variable.h>
#include <Model.h>
#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM{
    /**
     * \brief Visits the constructors of a sc_module in order to find inital values for members
     *
     * FindInitalValues has to be called after FindMember, otherwise no intitalvalues can be found.
     *
     */
    class FindInitalValues : public clang::RecursiveASTVisitor<FindInitalValues> {
    public:
        FindInitalValues(clang::CXXRecordDecl *recordDecl, const std::map<std::string, clang::FieldDecl *> &variableMap,
                                 SCAM::Module *module);

        //Visitor
        virtual bool VisitCXXConstructorDecl(clang::CXXConstructorDecl* constructorDecl);
        //Getter
        const std::map<std::string, ConstValue *> &getVariableInitialMap() const;


    private:
        std::map<std::string, clang::FieldDecl *> variableMap; //! <memberName, pointerInAst> contains an entry for each member of this module
        std::map<std::string, ConstValue *> variableInitialMap; //! <memberName, pointerInAst> contains an entry for each member of this module
        int pass;
        SCAM::Module * module;
    };

}


#endif //SCAM_FINDCONSTRUCTOR_H
