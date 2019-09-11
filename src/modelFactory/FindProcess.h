//
// Created by ludwig on 28.09.15.
//

#ifndef SCAM_FINDPROCESS_H
#define SCAM_FINDPROCESS_H

#include <vector>
#include <string>
#include <map>
#include "clang/AST/RecursiveASTVisitor.h"

#include "enums.h"


namespace SCAM{
    /*!
     * \brief Class searches for process declartions within a sc_module
     *
     * For now, only modules with one thread are allowed. This should be changed in future!
     * BUT: a merge between the suspension automats of the differnt methods has to be done
     *
     * //TODO: rethink finding of proccesses? Too complicated
     * //TODO: only allow threads
     */
    class FindProcess: public clang::RecursiveASTVisitor<FindProcess>  {
    public:

        FindProcess(clang::CXXRecordDecl* recordDecl);
        virtual ~FindProcess();

        /// Virtual methods from RecursiveASTVisitor
        virtual bool VisitStringLiteral(clang::StringLiteral *s);
        virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *md);
        virtual bool VisitMemberExpr(clang::MemberExpr *e);

        //Getter
        const std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE>>& getProcessMap();
        std::vector<clang::CXXMethodDecl*> getOtherFunctions();

    private:
        clang::CXXRecordDecl* recordDecl;
        PROCESS_TYPE processType; //! Method, Thread, Process
        clang::Stmt *_constructorStmt;

        std::map<std::string, std::pair<clang::CXXMethodDecl*, PROCESS_TYPE> > processMap; //! <processName, <MethodDecl, processType> >
        std::vector<clang::CXXMethodDecl*> otherFunctions;

        int _pass;


    };
}




#endif //SCAM_FINDPROCESS_H
