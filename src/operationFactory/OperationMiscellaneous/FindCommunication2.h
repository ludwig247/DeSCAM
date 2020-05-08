//
// Created by tobias on 13.07.16.
//

#ifndef SCAM_FINDCOMMUNICATION_H
#define SCAM_FINDCOMMUNICATION_H

#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include <Operand.h>
#include <Port.h>
#include <PortOperand.h>
#include <Stmts/Communication.h>
#include "Stmts_all.h"


namespace SCAM {
    class FindCommunication2 : public StmtAbstractVisitor {


    public:
        FindCommunication2();
        virtual ~FindCommunication2();

        bool isWaitComm() const;
        bool isCommunication() const;
        bool isBlockingInterface() const; //! Returns true if port has blocking interface
        bool isMaster() const;
        bool isSlave() const;
        bool isShared() const;
        bool isRead() const;
        bool isWrite() const;
        bool isNonBlockingAccess() const; //! Returns true if non-block read/write of a blocking port is used

        Communication * getCommStmt() const;
        Port * getPort() const;
        Stmt * getStmt() const; //! Returns the stmt that contains the communication
        SCAM::Expr * getWriteValue() const;
        SCAM::VariableOperand * getReadVariable() const;

    private:
        void visit(struct VariableOperand &node) override;
        void visit(struct IntegerValue &node) override;
        void visit(struct UnsignedValue &node) override;
        void visit(struct BoolValue &node) override;
        void visit(struct EnumValue &node) override;
        void visit(struct CompoundValue &node) override;
        void visit(class PortOperand &node) override;
        void visit(class Assignment &node) override;
        void visit(struct UnaryExpr &node) override;
        void visit(struct While &node) override;
        void visit(struct If &node) override;
        void visit(struct SectionOperand &node) override;
        void visit(class SectionValue &node) override;
        void visit(struct ITE &node) override;
        void visit(struct Arithmetic &node) override;
        void visit(struct Logical &node) override;
        void visit(struct Relational &node) override;
        void visit(struct Bitwise &node) override;
        void visit(struct Read &node) override;
        void visit(struct Write &node) override;
        void visit(struct SyncSignal &node) override;
        void visit(struct DataSignalOperand &node) override;
        void visit(struct Cast &node) override;
        void visit(struct FunctionOperand &node) override;
        void visit(struct CompoundExpr &node) override;
        void visit(struct ArrayOperand &node) override;
        void visit(ParamOperand &node) override;
        void visit(Return &node) override;
        virtual void visit(Wait &node) override;
        virtual void visit(Peek &node) override;
        virtual void visit(class Notify &node) override;
        virtual void visit(class ArrayExpr &node);
        void visit(struct TimePointOperand &node) override;

    public:
        const std::string &getStateName() const;
        bool hasStateName() const;

        void visit(class Ternary &node) override;

    private:
        bool waitComm;
        bool communication;
        bool non_blocking_access;
        SCAM::Communication * commStmt;
        SCAM::Stmt * stmt;
        SCAM::Expr * writeValue; //! Value that is written on the port
        SCAM::VariableOperand * readVariable;
        std::string stateName = "";
    };
}


#endif //SCAM_FINDCOMMUNICATION_H
