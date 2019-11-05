//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_PRINTSTMTFORTEMPLATE_H
#define PROJECT_PRINTSTMTFORTEMPLATE_H


#include "PrintStmt.h"

class PrintStmtForTemplate : public PrintStmt {

public:

    static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0) {
        PrintStmtForTemplate printer;
        return printer.createString(stmt, indentSize, indentOffset);
    }

protected:

    /// overriding one of PrintStmt functions to give a different format style
    void visit(BoolValue &node) {
        if (node.getValue()) {
            this->ss << "1";
        } else {
            this->ss << "0";
        }
    }
};

#endif //PROJECT_PRINTSTMTFORTEMPLATE_H