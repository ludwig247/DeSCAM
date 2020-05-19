//
// Created by johannes on 13.03.20.
//

#ifndef DESCAM_PRINTFUNCTION_H
#define DESCAM_PRINTFUNCTION_H

#include "PrintStmt.h"

namespace DESCAM { namespace HLSPlugin { namespace HLS {

class PrintFunction : public PrintStmt {

public:
    PrintFunction(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset);

    static std::string toString(
            Stmt *stmt,
            unsigned int indentSize = 2,
            unsigned int indentOffset = 0
    );

    std::string getString();

protected:
    void visit(ArrayOperand &node) override;
    void visit(Assignment &node) override ;
    void visit(Bitwise &node) override ;
    void visit(Cast &node) override ;
    void visit(CompoundExpr &node) override ;
    void visit(FunctionOperand &node) override ;
    void visit(Logical &node) override ;
    void visit(Notify &node) override ;
    void visit(ParamOperand &node) override ;
    void visit(Return &node) override ;
    void visit(UnaryExpr &node) override ;
    void visit(VariableOperand &node) override ;

private:

    void printIndent();
};

}}}

#endif //DESCAM_PRINTFUNCTION_H
