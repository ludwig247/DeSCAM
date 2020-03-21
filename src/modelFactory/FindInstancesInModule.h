//
// Created by schmitz on 05.03.20.
//

#ifndef DESCAM_FINDINSTANCESINMODULE_H
#define DESCAM_FINDINSTANCESINMODULE_H




#include <map>
#include <string>
#include "clang/AST/RecursiveASTVisitor.h"

namespace SCAM {
    /*
     * \brief Finds all instances inside modules
     *
     */
    class FindInstancesInModules : public clang::RecursiveASTVisitor<FindInstancesInModules> {
    public:

        FindInstancesInModules(clang::CXXRecordDecl * RecDecl, std::map<std::string, clang::CXXRecordDecl *>);

        virtual bool VisitFieldDecl(clang::FieldDecl *);

        std::map<std::pair<std::string, std::string>, std::string> getInstanceMap();
        void printInstanceMap();

    private:

        std::map<std::pair<std::string, std::string>, std::string> _instanceMap; //! <<instance_name, sc_module>, parent>
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;
        clang::CXXRecordDecl * _recDecl;

    };
}
#endif //DESCAM_FINDINSTANCESINMODULE_H
