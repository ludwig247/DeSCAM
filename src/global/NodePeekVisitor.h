//
// Created by pmorku on 7/15/18.
//

#ifndef PROJECT_NODEPEEKVISITOR_H
#define PROJECT_NODEPEEKVISITOR_H

#include <Stmts/StmtAbstractVisitor.h>
#include <Stmts/Stmts_all.h>

namespace SCAM {
    class NodePeekVisitor : public StmtAbstractVisitor {

    public:
        NodePeekVisitor(Stmt *node);

        bool isConstTypeNode() const;

        static bool isConstTypeNode(Stmt *node);

        VariableOperand *nodePeekVariableOperand() const;

        IntegerValue *nodePeekIntegerValue() const;

        UnsignedValue *nodePeekUnsignedValue() const;

        BoolValue *nodePeekBoolValue() const;

        EnumValue *nodePeekEnumValue() const;

        CompoundValue *nodePeekCompoundValue() const;

        PortOperand *nodePeekPortOperand() const;

        Assignment *nodePeekAssignment() const;

        UnaryExpr *nodePeekUnaryExpr() const;

        While *nodePeekWhile() const;

        If *nodePeekIf() const;

        SectionOperand *nodePeekSectionOperand() const;

        SectionValue *nodePeekSectionValue() const;

        ITE *nodePeekITE() const;

        Arithmetic *nodePeekArithmetic() const;

        Logical *nodePeekLogical() const;

        Relational *nodePeekRelational() const;

        Bitwise *nodePeekBitwise() const;

        Read *nodePeekRead() const;

        Write *nodePeekWrite() const;

        NBRead *nodePeekNBRead() const;

        NBWrite *nodePeekNBWrite() const;

        SyncSignal *nodePeekSyncSignal() const;

        DataSignalOperand *nodePeekDataSignalOperand() const;

        Cast *nodePeekCast() const;

        FunctionOperand *nodePeekFunctionOperand() const;

        SubSelect *nodePeekSubSelect() const;

        CompoundExpr *nodePeekCompoundExpr() const;

        ParamOperand *nodePeekParamOperand() const;

        Return *nodePeekReturn() const;

        static VariableOperand *nodePeekVariableOperand(Stmt *node);

        static IntegerValue *nodePeekIntegerValue(Stmt *node);

        static UnsignedValue *nodePeekUnsignedValue(Stmt *node);

        static BoolValue *nodePeekBoolValue(Stmt *node);

        static EnumValue *nodePeekEnumValue(Stmt *node);

        static CompoundValue *nodePeekCompoundValue(Stmt *node);

        static PortOperand *nodePeekPortOperand(Stmt *node);

        static Assignment *nodePeekAssignment(Stmt *node);

        static UnaryExpr *nodePeekUnaryExpr(Stmt *node);

        static While *nodePeekWhile(Stmt *node);

        static If *nodePeekIf(Stmt *node);

        static SectionOperand *nodePeekSectionOperand(Stmt *node);

        static SectionValue *nodePeekSectionValue(Stmt *node);

        static ITE *nodePeekITE(Stmt *node);

        static Arithmetic *nodePeekArithmetic(Stmt *node);

        static Logical *nodePeekLogical(Stmt *node);

        static Relational *nodePeekRelational(Stmt *node);

        static Bitwise *nodePeekBitwise(Stmt *node);

        static Read *nodePeekRead(Stmt *node);

        static Write *nodePeekWrite(Stmt *node);

        static NBRead *nodePeekNBRead(Stmt *node);

        static NBWrite *nodePeekNBWrite(Stmt *node);

        static SyncSignal *nodePeekSyncSignal(Stmt *node);

        static DataSignalOperand *nodePeekDataSignalOperand(Stmt *node);

        static Cast *nodePeekCast(Stmt *node);

        static FunctionOperand *nodePeekFunctionOperand(Stmt *node);

        static SubSelect *nodePeekSubSelect(Stmt *node);

        static CompoundExpr *nodePeekCompoundExpr(Stmt *node);

        static ParamOperand *nodePeekParamOperand(Stmt *node);

        static Return *nodePeekReturn(Stmt *node);


    private:
        bool isConstTypeNodeFlag = false;
        VariableOperand *nodePtrVariableOperand = nullptr;
        IntegerValue *nodePtrIntegerValue = nullptr;
        UnsignedValue *nodePtrUnsignedValue = nullptr;
        BoolValue *nodePtrBoolValue = nullptr;
        EnumValue *nodePtrEnumValue = nullptr;
        CompoundValue *nodePtrCompoundValue = nullptr;
        PortOperand *nodePtrPortOperand = nullptr;
        Assignment *nodePtrAssignment = nullptr;
        UnaryExpr *nodePtrUnaryExpr = nullptr;
        While *nodePtrWhile = nullptr;
        If *nodePtrIf = nullptr;
        SectionOperand *nodePtrSectionOperand = nullptr;
        SectionValue *nodePtrSectionValue = nullptr;
        ITE *nodePtrITE = nullptr;
        Arithmetic *nodePtrArithmetic = nullptr;
        Logical *nodePtrLogical = nullptr;
        Relational *nodePtrRelational = nullptr;
        Bitwise *nodePtrBitwise = nullptr;
        Read *nodePtrRead = nullptr;
        Write *nodePtrWrite = nullptr;
        NBRead *nodePtrNBRead = nullptr;
        NBWrite *nodePtrNBWrite = nullptr;
        SyncSignal *nodePtrSyncSignal = nullptr;
        DataSignalOperand *nodePtrDataSignalOperand = nullptr;
        Cast *nodePtrCast = nullptr;
        FunctionOperand *nodePtrFunctionOperand = nullptr;
        SubSelect *nodePtrSubSelect = nullptr;
        CompoundExpr *nodePtrCompoundExpr = nullptr;
        ParamOperand *nodePtrParamOperand = nullptr;
        Return *nodePtrReturn = nullptr;


    public:
        virtual void visit(class VariableOperand &node);

        virtual void visit(class IntegerValue &node);

        virtual void visit(class UnsignedValue &node);

        virtual void visit(class BoolValue &node);

        virtual void visit(class EnumValue &node);

        virtual void visit(class CompoundValue &node);

        virtual void visit(class PortOperand &node);

        virtual void visit(class Assignment &node);

        virtual void visit(class UnaryExpr &node);

        virtual void visit(class While &node);

        virtual void visit(class If &node);

        virtual void visit(class SectionOperand &node);

        virtual void visit(class SectionValue &node);

        virtual void visit(class ITE &node);

        virtual void visit(class Arithmetic &node);

        virtual void visit(class Logical &node);

        virtual void visit(class Relational &node);

        virtual void visit(class Bitwise &node);

        virtual void visit(class Read &node);

        virtual void visit(class Write &node);

        virtual void visit(class NBRead &node);

        virtual void visit(class NBWrite &node);

        virtual void visit(class SyncSignal &node);

        virtual void visit(class DataSignalOperand &node);

        virtual void visit(class Cast &node);

        virtual void visit(class FunctionOperand &node);

        virtual void visit(class SubSelect &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(class ParamOperand &node);

        virtual void visit(class Return &node);
    };
}


#endif //PROJECT_NODEPEEKVISITOR_H
