#ifndef _SC_MODULES_H_
#define _SC_MODULES_H_

#include <map>
#include <string>
#include "clang/AST/RecursiveASTVisitor.h"
//#include "FindModule.h"

namespace SCAM {

    /*
     * \brief Finds all modules defined by the user
     *
     * Ignores modules that are defined by system_c
     *
     */
    class FindModules : public clang::RecursiveASTVisitor<FindModules> {
    public:

        FindModules(clang::TranslationUnitDecl *);

        virtual bool VisitCXXRecordDecl(clang::CXXRecordDecl *);

        const std::map<std::string, clang::CXXRecordDecl *> & getModuleMap();

    private:
        std::map<std::string, clang::CXXRecordDecl *> _moduleMap;

    };
}
#endif
