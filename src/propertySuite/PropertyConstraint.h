//
// Created by deutschmann on 06.09.18.
//

#ifndef PROJECT_PROPERTYCONSTRAINT_H
#define PROJECT_PROPERTYCONSTRAINT_H

#include <string>
#include <sstream>
#include <Stmts/Assignment.h>
#include "Stmt.h"
#include "Expr.h"


namespace SCAM {

    class PropertyConstraint {

    public:

        // Constructor
        explicit PropertyConstraint(const std::string &name);
        PropertyConstraint(const std::string &name, Stmt *expr);

        // Getter
        const std::string &getName() const;
        Stmt *getExpression();

        // Setter
        void setName(const std::string &name);
        void setExpression(Stmt *expr);

    private:

        std::string name;
        Stmt* expression;

    };

}

#endif //PROJECT_PROPERTYCONSTRAINT_H
