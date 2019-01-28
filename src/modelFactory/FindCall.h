#ifndef _FIND_WAIT_H_
#define _FIND_WAIT_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace SCAM {

    /**
     * \brief Class checks, wheter a stmt is a member call.
     *
     * E.g. obj->member()
     *
     * This archived in two steps
     *
     * Pass 0: Find methodname
     *
     * Pass 1: Find objectname
     */
    class FindCall : public clang::RecursiveASTVisitor<FindCall> {
    public:
        FindCall(clang::Stmt* stmt);
        ~FindCall();

        virtual bool VisitCXXMemberCallExpr(clang::CXXMemberCallExpr* memberCallExpr);
        virtual bool VisitMemberExpr(clang::MemberExpr* memberExpr);

        std::string getMethodName();
        std::string getObjectName();
        bool isCall(); //! Returns true, if Stmt is a call

    private:
        int pass;
        std::string methodName; //! object->method(): method of the object, that is called
        std::string objectName; //! object->method(): object the method is called on

        std::string argument;
        std::string argument_t;


    };
}
#endif
