//
// Created by deutschmann on 10.09.18.
//

#include <Stmts/Assignment.h>

#include <utility>
#include "PropertySuite.h"


namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    PropertySuite::PropertySuite(std::string name) :
            name(std::move(name)){
        this->resetSignal = new Variable("rst", DataTypes::getDataType("unsigned"));
        this->createConstraint(("no_reset"), new Assignment(new VariableOperand(resetSignal), new UnsignedValue(0)));
        //this->resetProperty = new Property("reset", nullptr);
    }

    // ------------------------------------------------------------------------------
    //                              Name-Functions
    // ------------------------------------------------------------------------------

    const std::string &PropertySuite::getName() const {
        return name;
    }

    void PropertySuite::setName(const std::string &name) {
        PropertySuite::name = name;
    }

    // ------------------------------------------------------------------------------
    //                             Macro-Functions
    // ------------------------------------------------------------------------------


    void PropertySuite::addSyncSignal(PropertyMacro *ss) {
        this->syncSignals.push_back(ss);
    }

    void PropertySuite::addNotifySignal(PropertyMacro *ss) {
        this->notifySignals.push_back(ss);
    }

    void PropertySuite::addDpSignal(PropertyMacro *dp) {
        this->dpSignals.push_back(dp);
    }

    void PropertySuite::addVisibleRegister(PropertyMacro *reg) {
        this->visibleRegisters.push_back(reg);
    }

    void PropertySuite::addState(PropertyMacro *state) {
        this->states.push_back(state);
    }

    const std::vector<PropertyMacro *> &PropertySuite::getSyncSignals() const {
        return syncSignals;
    }

    const std::vector<PropertyMacro *> &PropertySuite::getNotifySignals() const {
        return notifySignals;
    }

    const std::vector<PropertyMacro *> &PropertySuite::getDpSignals() const {
        return dpSignals;
    }

    const std::vector<PropertyMacro *> &PropertySuite::getVisibleRegisters() const {
        return visibleRegisters;
    }

    const std::vector<PropertyMacro *> &PropertySuite::getStates() const {
        return states;
    }

    PropertyMacro * PropertySuite::findSignal(const std::string &signalName) const {

        for (auto syncSignal : syncSignals) {
            if (syncSignal->getName() == signalName) {
                return syncSignal;
            }
        }

        for (auto notifySignal : notifySignals) {
            if (notifySignal->getName() == signalName) {
                return notifySignal;
            }
        }

        for (auto dpSignal : dpSignals) {
            if (dpSignal->getName() == signalName) {
                return dpSignal;
            }
        }

        for (auto visibleRegister : visibleRegisters) {

            if(visibleRegister->getSubVarName() != ""){
                std::string name = visibleRegister->getName() + "." + visibleRegister->getSubVarName();
                if(name == signalName) return visibleRegister;
            }
            else if (visibleRegister->getName() == signalName) {
                return visibleRegister;
            }
        }

        for (auto state : states) {
            if (state->getName() == signalName) {
                return state;
            }
        }

        throw std::runtime_error("PropertySuite::findSignal has not found the given signal: " + signalName);
    }

    PropertyMacro * PropertySuite::findSignal(const std::string &parentName, const std::string &subVarName) const {
        for (auto dpSignal : dpSignals) {
            if (dpSignal->isCompoundType()) {
                auto name = parentName + "." + subVarName;
                std::string test = dpSignal->getFullName();
                if (dpSignal->getFullName() == name) {
                    return dpSignal;
                }
            }

        }

        for (auto visibleRegister : visibleRegisters) {
            if (visibleRegister->isCompoundType()) {
                if ((visibleRegister->getName() == parentName) && (visibleRegister->getSubVarName() == subVarName)) {
                    return visibleRegister;
                }
            }
        }

        throw std::runtime_error("PropertySuite::findSignal has not found the given signal: " + parentName + "." + subVarName);
    }

    PropertyMacro * PropertySuite::findSignal(Variable * var) const {

        for (auto visibleRegister : visibleRegisters) {
            if (var == visibleRegister->getVariable()) {
                return visibleRegister;
            }
        }

        throw std::runtime_error("PropertySuite::findSignal has not found the given variable: " + var->getName());

    }

    // ------------------------------------------------------------------------------
    //                             Function-Functions
    // ------------------------------------------------------------------------------

    void PropertySuite::addFunction(SCAM::Function *function) {
        this->functions.push_back(function);
    }

    const std::vector<Function *> &PropertySuite::getFunctions() const {
        return functions;
    }

    // ------------------------------------------------------------------------------
    //                            Constraint-Functions
    // ------------------------------------------------------------------------------

    PropertyConstraint * PropertySuite::createConstraint(const std::string &name) {
        return (*constraints.insert(constraints.end(), new PropertyConstraint(name)));
    }

    PropertyConstraint * PropertySuite::createConstraint(const std::string &name, Stmt *expr) {
        return (*constraints.insert(constraints.end(), new PropertyConstraint(name, expr)));
    }

    PropertyConstraint * PropertySuite::getConstraint(const std::string &constraintName) const {
        for (auto constraint : constraints) {
            if (constraint->getName() == constraintName) {
                return constraint;
            }
        }

        throw std::runtime_error("PropertySuite::getConstraint has not found the given constraint: " + constraintName);

    }

    const std::vector<PropertyConstraint *> &PropertySuite::getConstraints() const {
        return constraints;
    }

    // ------------------------------------------------------------------------------
    //                               ResetProperty
    // ------------------------------------------------------------------------------

    Property *PropertySuite::getResetProperty() const {
        return resetProperty;
    }

    void PropertySuite::setResetProperty(Property *newResetProperty) {
        this->resetProperty = newResetProperty;
    }

    // ------------------------------------------------------------------------------
    //                              Properties
    // ------------------------------------------------------------------------------

    void PropertySuite::addProperty(Property *property) {
        this->Properties.push_back(property);
    }

    const std::vector<Property*> &PropertySuite::getProperties() const {
        return Properties;
    }

    // ------------------------------------------------------------------------------
    //                                StateMap
    // ------------------------------------------------------------------------------
/*
    std::set<PropertyMacro*> PropertySuite::getPredecessorStates(PropertyMacro* state) {

        if ( predecessorStates.find(state) == predecessorStates.end() ) {
            throw std::runtime_error("No predecessor states found!");
        } else {
            return predecessorStates[state];
        }

    }
    std::set<PropertyMacro*> PropertySuite::getSuccessorStates(PropertyMacro *state) {

        if ( successorStates.find(state) == successorStates.end() ) {
            throw std::runtime_error("No successor states found!");
        } else {
            return successorStates[state];
        }

    }

    std::set<AbstractProperty*> PropertySuite::getPredecessorProperties(PropertyMacro* state) {

        if ( predecessorProperties.find(state) == predecessorProperties.end() ) {
            throw std::runtime_error("No predecessor states found!");
        } else {
            return predecessorProperties[state];
        }

    }
    std::set<AbstractProperty*> PropertySuite::getSuccessorProperties(PropertyMacro *state) {

        if ( successorProperties.find(state) == successorProperties.end() ) {
            throw std::runtime_error("No successor states found!");
        } else {
            return successorProperties[state];
        }

    }*/
}
























