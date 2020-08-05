//
// Created by deutschmann on 06.09.18.
//

#include "PropertyConstraint.h"

namespace DESCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    PropertyConstraint::PropertyConstraint(const std::string &name) :
            name(name) {}

    PropertyConstraint::PropertyConstraint(const std::string &name, Stmt *expr) :
            name(name),
            expression(expr) {}

    // ------------------------------------------------------------------------------
    //                                 Getter
    // ------------------------------------------------------------------------------

    const std::string &PropertyConstraint::getName() const {
        return name;
    }

    Stmt * PropertyConstraint::getExpression() {
        return this->expression;
    }

    // ------------------------------------------------------------------------------
    //                                 Setter
    // ------------------------------------------------------------------------------

    void PropertyConstraint::setName(const std::string &name) {
        this->name = name;
    }

    void PropertyConstraint::setExpression(Stmt *expr) {
        this->expression = expr;
    }

}