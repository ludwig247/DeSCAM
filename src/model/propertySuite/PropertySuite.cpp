//
// Created by deutschmann on 10.09.18.
//

#include <Stmts/Assignment.h>
#include "FatalError.h"
#include "Logger/Logger.h"
#include <utility>
#include <algorithm>
#include "PropertySuite.h"


namespace DESCAM {

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


    void PropertySuite::addSyncSignal(std::shared_ptr<PropertyMacro>ss) {
        this->syncSignals.push_back(ss);
    }

    void PropertySuite::addNotifySignal(std::shared_ptr<PropertyMacro>ss) {
        this->notifySignals.push_back(ss);
    }

    void PropertySuite::addDpSignal(std::shared_ptr<PropertyMacro>dp) {
        this->dpSignals.push_back(dp);
    }

    void PropertySuite::addVisibleRegister(std::shared_ptr<PropertyMacro>reg) {
        this->visibleRegisters.push_back(reg);
    }

    void PropertySuite::addState(std::shared_ptr<PropertyMacro>state) {
        this->states.push_back(state);
    }

    const std::vector<std::shared_ptr<PropertyMacro>> &PropertySuite::getSyncSignals() const {
        return syncSignals;
    }

    const std::vector<std::shared_ptr<PropertyMacro>> &PropertySuite::getNotifySignals() const {
        return notifySignals;
    }

    const std::vector<std::shared_ptr<PropertyMacro>> &PropertySuite::getDpSignals() const {
        return dpSignals;
    }

    const std::vector<std::shared_ptr<PropertyMacro>> &PropertySuite::getVisibleRegisters() const {
        return visibleRegisters;
    }

    const std::vector<std::shared_ptr<PropertyMacro>> &PropertySuite::getStates() const {
        return states;
    }

    std::shared_ptr<PropertyMacro> PropertySuite::findSignal(const std::string &signalName) const {

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

            if(visibleRegister->isSubVar()){
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

        TERMINATE("PropertySuite::findSignal has not found the given signal: " + signalName);
    }

    std::shared_ptr<PropertyMacro> PropertySuite::findSignal(const std::string &parentName, const std::string &subVarName) const {
        for (auto dpSignal : dpSignals) {
            if (dpSignal->isSubVar()) {
                if ((dpSignal->getParentName() == parentName) && (dpSignal->getSubVarName() == subVarName)) {
                    return dpSignal;
                }
            }
        }
        for (auto visibleRegister : visibleRegisters) {
            if (visibleRegister->isSubVar()) {
                if ((visibleRegister->getParentName() == parentName) && (visibleRegister->getSubVarName() == subVarName)) {
                    return visibleRegister;
                }
            }
        }

        TERMINATE("PropertySuite::findSignal has not found the given signal: " + parentName + "." + subVarName);
    }

    std::shared_ptr<PropertyMacro> PropertySuite::findSignal(Variable * var) const {

        for (auto visibleRegister : visibleRegisters) {
            if (var == visibleRegister->getVariable()) {
                return visibleRegister;
            }
        }

        TERMINATE("PropertySuite::findSignal has not found the given variable: " + var->getName());

    }

    // ------------------------------------------------------------------------------
    //                             Function-Functions
    // ------------------------------------------------------------------------------

    void PropertySuite::addFunction(DESCAM::Function *function) {
        this->functions.push_back(function);
    }

    const std::vector<Function *> &PropertySuite::getFunctions() const {
        return functions;
    }

    // ------------------------------------------------------------------------------
    //                            Constraint-Functions
    // ------------------------------------------------------------------------------

    std::shared_ptr<PropertyConstraint> PropertySuite::createConstraint(const std::string &name) {
        return (*constraints.insert(constraints.end(), std::make_shared<PropertyConstraint>(name)));
    }

    std::shared_ptr<PropertyConstraint> PropertySuite::createConstraint(const std::string &name, Stmt *expr) {
        return (*constraints.insert(constraints.end(), std::make_shared<PropertyConstraint>(name, expr)));
    }

    std::shared_ptr<PropertyConstraint> PropertySuite::getConstraint(const std::string &constraintName) const {
        for (auto constraint : constraints) {
            if (constraint->getName() == constraintName) {
                return constraint;
            }
        }

        TERMINATE("PropertySuite::getConstraint has not found the given constraint: " + constraintName);

    }

    const std::vector<std::shared_ptr<PropertyConstraint>> &PropertySuite::getConstraints() const {
        return constraints;
    }

    // ------------------------------------------------------------------------------
    //                               ResetProperty
    // ------------------------------------------------------------------------------

    std::shared_ptr<Property> PropertySuite::getResetProperty() const {
        return resetProperty;
    }

    void PropertySuite::setResetProperty(std::shared_ptr<Property> newResetProperty) {
        this->resetProperty = newResetProperty;
    }

    // ------------------------------------------------------------------------------
    //                              Properties
    // ------------------------------------------------------------------------------

    void PropertySuite::addProperty(std::shared_ptr<Property> property) {
        this->propertyList.push_back(property);

        if (property->getOperation()->IsWait()) {
            this->waitPropertyList.push_back(property);
        } else {
            this->operationPropertyList.push_back(property);
        }

        std::sort(propertyList.begin(), propertyList.end(), [](std::shared_ptr<Property> a, std::shared_ptr<Property> b){return a->getName() < b->getName();});
        std::sort(operationPropertyList.begin(), operationPropertyList.end(), [](std::shared_ptr<Property> a, std::shared_ptr<Property> b){return a->getName() < b->getName();});
        std::sort(waitPropertyList.begin(), waitPropertyList.end(), [](std::shared_ptr<Property> a, std::shared_ptr<Property> b){return a->getName() < b->getName();});
    }

    const std::vector<std::shared_ptr<Property>> &PropertySuite::getProperties() const {
        return propertyList;
    }

    const std::vector<std::shared_ptr<Property>> &PropertySuite::getOperationProperties() const {
        return operationPropertyList;
    }

    const std::vector<std::shared_ptr<Property>> &PropertySuite::getWaitProperties() const {
        return waitPropertyList;
    }

    // ------------------------------------------------------------------------------
    //                                StateMap
    // ------------------------------------------------------------------------------
/*
    std::set<PropertyMacro*> PropertySuite::getPredecessorStates(PropertyMacro* state) {

        if ( predecessorStates.find(state) == predecessorStates.end() ) {
            TERMINATE("No predecessor states found!");
        } else {
            return predecessorStates[state];
        }

    }
    std::set<PropertyMacro*> PropertySuite::getSuccessorStates(PropertyMacro *state) {

        if ( successorStates.find(state) == successorStates.end() ) {
            TERMINATE("No successor states found!");
        } else {
            return successorStates[state];
        }

    }

    std::set<AbstractProperty*> PropertySuite::getPredecessorProperties(PropertyMacro* state) {

        if ( predecessorProperties.find(state) == predecessorProperties.end() ) {
            TERMINATE("No predecessor states found!");
        } else {
            return predecessorProperties[state];
        }

    }
    std::set<AbstractProperty*> PropertySuite::getSuccessorProperties(PropertyMacro *state) {

        if ( successorProperties.find(state) == successorProperties.end() ) {
            TERMINATE("No successor states found!");
        } else {
            return successorProperties[state];
        }

    }*/
}
























