//
// Created by deutschmann on 23.11.18.
//

#include "AbstractMacro.h"

namespace DESCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    AbstractMacro::AbstractMacro(const std::string &name, const DataType *type) :
            name(name),
            TypeInterface(type),
            active(true) {}


    // ------------------------------------------------------------------------------
    //                                 Getter
    // ------------------------------------------------------------------------------

    const std::string &AbstractMacro::getName() const {
        return name;
    }


    Stmt *AbstractMacro::getExpression() {
        return expression;
    }

    // ------------------------------------------------------------------------------
    //                                 Setter
    // ------------------------------------------------------------------------------

    void AbstractMacro::setExpression(Stmt *expr) {
        this->expression = expr;
    }

    // ------------------------------------------------------------------------------
    //                                 Active
    // ------------------------------------------------------------------------------

    const bool &AbstractMacro::isActive() const {
        return active;
    }

    void AbstractMacro::activateMacro() {
        this->active = true;
    }

    void AbstractMacro::deactivateMacro() {
        this->active = false;
    }
}