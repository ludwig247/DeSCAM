//
// Created by tobias on 12.06.17.
//

#ifndef PROJECT_PRIMTSTMTFORDOTSPURIOUS_H
#define PROJECT_PRIMTSTMTFORDOTSPURIOUS_H


#include <PrintStmt.h>

namespace DESCAM{

    class PrintStmtForDotSpurious: public PrintStmt{
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0) {
            PrintStmtForDotSpurious printer;
            return printer.createString(stmt, indentSize, indentOffset);
        }

    protected:
        virtual void visit(Relational &node) {
            this->ss << "(";
            node.getLhs()->accept(*this);
            if(node.getOperation() == "<="){
                this->ss << " \\<=" << " ";
            }else if(node.getOperation() == ">="){
                this->ss << " \\>=" << " ";
            }else{
                this->ss << " " + node.getOperation() << " ";
            }

            node.getRhs()->accept(*this);
            this->ss << ")";
        }

    };
}

#endif //PROJECT_PRIMTSTMTFORDOTSPURIOUS_H
