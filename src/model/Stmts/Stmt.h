//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_STMT_H
#define SCAM_STMT_H

#include "StmtAbstractVisitor.h"
#include <iostream>



namespace SCAM{

    /**
     * \brief Base class for every other suspensionAST node
     *
     * Represents a statement in CFGBlock
     * Stmnts:
     *  -Assignment: lhs = rhs
     *  -FunctionCall: method(parameter), only methods that are defined within the sc_module
     *                 AND that are const evaluable are allowed. E.g. a computation square(x)
     *  -Call:  member.method() Calling a method of a member. Methods can either be read() or write()
     *                Here we distinguish between a call on a port(external) or a call on a signal(internal).
     *  -Binary operator: lhs [operator] rhs: Operators can be +,-, <, >, == ... assignment is a binary operation, too
     *
     *  -Operand: -> member(port,variable,signal)
     *            -> constant value(int, boolean, float, ...)
     *              Actions are performed on/with operands
     *  -Return ( Expr)
     */

    class NodePeekVisitor;

    class Stmt {
    public:
        virtual void accept(StmtAbstractVisitor& visitor) = 0;

        virtual bool operator==(const Stmt &other) const = 0;
        virtual std::ostream& print(std::ostream&) const = 0;
    };
}
inline std::ostream& operator<<(std::ostream& os, SCAM::Stmt const& stmt){
    return stmt.print(os);
}


#endif //SCAM_STMT_H
