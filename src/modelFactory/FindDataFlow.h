//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_FINDDATAFLOW_H
#define SCAM_FINDDATAFLOW_H

#include <map>
#include <iostream>

#include "clang/AST/RecursiveASTVisitor.h"


#include <ErrorMsg.h>
#include <Model.h>
#include "PrintStmt.h"

namespace SCAM{
        class Module;
        class Process;
        /**
         * \brief processes a clang::stmt and extract all necessary information from it
         *
         * Different stages:
         * pass=0: Looking for operation(assignment,binary operator,membercall, functioncall)
         * pass=1: Find LHS operator
         * pass=2: Find RHS operator
         */
        class FindDataFlow: public clang::RecursiveASTVisitor<FindDataFlow> {
        public:
            FindDataFlow(clang::Stmt *stmt, Module *module, bool unsigned_flag = false);
            //Operator
            bool VisitBinaryOperator(clang::BinaryOperator* binaryOperator);
            bool VisitUnaryOperator(clang::UnaryOperator* unaryOperator);
            bool VisitCXXMemberCallExpr(clang::CXXMemberCallExpr* memberCallExpr);
            bool VisitWhileStmt(clang::WhileStmt* whileStmt);
            bool VisitIfStmt(clang::IfStmt* ifStmt);
            bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr * operatorCallExpr);

            bool VisitMemberExpr(clang::MemberExpr* memberExpr);
            bool VisitIntegerLiteral(clang::IntegerLiteral* integerLiteral);
            bool VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr* boolLiteralExpr);
            bool VisitDeclRefExpr(clang::DeclRefExpr* varDecl);
            bool VisitCXXStaticCastExpr(clang::CXXStaticCastExpr * staticCastExpr);
            bool VisitCompoundStmt(clang::CompoundStmt * compoundStmt);

            bool VisitCallExpr(clang::CallExpr * callExpr);
            bool VisitImplicitCastExpr(clang::ImplicitCastExpr * implicitCastExpr);
            bool VisitReturnStmt(clang::ReturnStmt * returnStmt);


            Expr *getExpr() const;
            SCAM::Stmt* getStmt();

            static std::string functionName;
            static bool isFunction;

        private:
            Module * module; //! Module the dataflow is generated for
            SCAM::Stmt* stmt; //! Represents the stmt in case of operator, values are stored in lhs and rhs

            Expr * expr;
            Expr* lhsExpr; //! Assign Operation lValue = rValue
            Expr* rhsExpr;//! Assign Operation lValue = rValue
            int pass;

            std::stringstream logStream; //! Contains every message that is generated during

            void switchPassExpr(Expr * stmt); //! Depending on the current value of pass assigns value to stmt(pass==0), lhs(1) or rhs(2)
            bool exitVisitor(std::string msg, ErrorMsg::ErrorType errorType = ErrorMsg::ErrorType::error);

            bool unsigned_flag;
        };

}


#endif //SCAM_FINDDATAFLOW_H
