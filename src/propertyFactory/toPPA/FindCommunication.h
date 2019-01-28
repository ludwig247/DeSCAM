//
// Created by tobias on 13.07.16.
//

#ifndef SCAM_FCV_H
#define SCAM_FCV_H

#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include <Operand.h>
#include <Port.h>
#include <PortOperand.h>
#include <Stmts/Communication.h>
#include "Stmts_all.h"


namespace SCAM {
    class FindCommunication : public StmtAbstractVisitor {


    public:
        FindCommunication();
        virtual ~FindCommunication();


        Communication * getCommStmt() const;
        Stmt * getStmt() const; //! Returns the stmt that contains the communication
        Port * getPort() const;
        bool isCommunication() const;
        bool isBlockingInterface() const; //! Returns true if port has blocking interface
        bool isNonBlockingAccess() const; //! Returns true if non-block read/write of a blocking port is used

        bool isRead() const;
        bool isWrite() const;
        bool isShared() const;

        bool isMaster() const;
        Expr *getWriteValue() const;
        //! Value only valid in case of a write  port->write(value)


    private:
        virtual void visit(struct VariableOperand &node) override;
        virtual void visit(struct IntegerValue &node) override;
        virtual void visit(struct UnsignedValue &node) override;
        virtual void visit(struct BoolValue &node) override;
        virtual void visit(struct EnumValue &node) override;
        virtual void visit(struct CompoundValue &node) override;
        virtual void visit(class PortOperand &node) override;
        virtual void visit(class Assignment &node) override;
        virtual void visit(struct UnaryExpr &node) override;
        virtual void visit(struct While &node) override;
        virtual void visit(struct If &node) override;
        virtual void visit(struct SectionOperand &node) override;
        virtual void visit(class SectionValue &node) override;
        virtual void visit(struct ITE &node) override;
        virtual void visit(struct Arithmetic &node) override;
        virtual void visit(struct Logical &node) override;
        virtual void visit(struct Relational &node) override;
        virtual void visit(struct Bitwise &node) override;
        virtual void visit(struct Read &node) override;
        virtual void visit(struct Write &node) override;
        virtual void visit(struct NBRead &node) override;
        virtual void visit(struct NBWrite &node) override;
        virtual void visit(struct SyncSignal &node) override;
        virtual void visit(struct DataSignalOperand &node) override;
        virtual void visit(struct Cast &node) override;
        virtual void visit(struct FunctionOperand &node);
        virtual void visit(struct CompoundExpr &node);
        virtual void visit(struct SubSelect &node);
        void visit(ParamOperand &node);
        void visit(Return &node);
    private:

        bool communication;
        bool non_blocking_access;
        SCAM::Communication * commStmt;
        SCAM::Stmt * stmt;
        SCAM::Expr * writeValue; //! Value that is written on the port

    };
}


#endif //SCAM_FCV_H
