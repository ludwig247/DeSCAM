//
// Created by tobias on 01.07.16.
//

#ifndef SCAM_STMTABSTRACTVISITOR_H
#define SCAM_STMTABSTRACTVISITOR_H

namespace SCAM{

   class StmtAbstractVisitor {
    public:
        virtual void visit(class VariableOperand &node)=0;
        virtual void visit(class IntegerValue& node)=0;
        virtual void visit(class UnsignedValue& node)=0;
        virtual void visit(class BoolValue& node)=0;
        virtual void visit(class EnumValue& node)=0;
        virtual void visit(class CompoundValue& node)=0;
        virtual void visit(class PortOperand &node)=0;
        virtual void visit(class Assignment &node)=0;
        virtual void visit(class UnaryExpr &node)=0;
        virtual void visit(class While &node)=0;
        virtual void visit(class If &node)=0;
        virtual void visit(class SectionOperand &node) = 0;
        virtual void visit(class SectionValue &node) = 0;
        virtual void visit(class ITE &node) = 0;
        virtual void visit(class Arithmetic &node) = 0;
        virtual void visit(class Logical &node) = 0;
        virtual void visit(class Relational &node) = 0;
        virtual void visit(class Bitwise &node) = 0;
        virtual void visit(class Read &node) = 0;
        virtual void visit(class Write &node) = 0;
        virtual void visit(class NBRead &node) = 0;
        virtual void visit(class NBWrite &node) = 0;
        virtual void visit(class SyncSignal &node) = 0;
        virtual void visit(class DataSignalOperand &node) = 0;
        virtual void visit(class Cast &node) = 0;
        virtual void visit(class FunctionOperand &node) = 0;
        virtual void visit(class SubSelect &node) = 0;
        virtual void visit(class CompoundExpr &node) = 0;
        virtual void visit(class ParamOperand &node) = 0;
        virtual void visit(class Return &node) = 0;
    };
}


#endif //SCAM_STMTABSTRACTVISITOR_H
