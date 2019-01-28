//
// Created by ludwig on 31.08.16.
//

#ifndef SCAM_CONDITIONVISITOR_H
#define SCAM_CONDITIONVISITOR_H

#include <PrintStmt.h>

namespace SCAM{

class ConditionVisitor: public PrintStmt {
public:
    static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0);
protected:
    virtual void visit(class Relational &node);
    virtual void visit(class SyncSignal &node);
    virtual void visit(class Arithmetic &node);
    virtual void visit(class Bitwise &node);
    virtual void visit(class DataSignalOperand &node);
    virtual void visit(class VariableOperand &node);
    virtual void visit(class IntegerValue &node);
    virtual void visit(class UnsignedValue &node);
    virtual void visit(class Cast &node);
    virtual void visit(class Return &node);
    virtual void visit(class ITE &node);
    virtual void visit(class Assignment &node);
    virtual void visit(class SubSelect &node);
    virtual void visit(class CompoundExpr &node);

    bool resize_flag=false;
};

}

#endif //SCAM_CONDITIONVISITOR_H
