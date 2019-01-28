//
// Created by ludwig on 06.06.18.
//

#ifndef PROJECT_STMTTOXMLVISITOR_H
#define PROJECT_STMTTOXMLVISITOR_H

#include <Stmts/StmtAbstractVisitor.h>
#include <tinyxml/tinyxml.h>
#include "Stmts_all.h"

namespace SCAM{
    class StmtToXMLVisitor: public StmtAbstractVisitor {
    public:
        static TiXmlElement * toTiXmlElement(SCAM::Stmt * stmt);

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
        virtual void visit(SCAM::FunctionOperand &node);
        virtual void visit(SCAM::SubSelect &node);
        virtual void visit(SCAM::CompoundExpr &node);

        virtual void visit(ParamOperand &node);
        virtual void visit(Return &node);

    protected:
        TiXmlElement * translate(SCAM::Stmt * stmt);
        TiXmlElement * current;
        TiXmlElement * root;
    };


}



#endif //PROJECT_STMTTOXMLVISITOR_H
