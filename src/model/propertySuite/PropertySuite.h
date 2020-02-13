//
// Created by deutschmann on 10.09.18.
//

#ifndef PROJECT_PROPERTYSUITE_H
#define PROJECT_PROPERTYSUITE_H

#include <set>

#include "FunctionMacro.h"
#include "Property.h"
#include "PropertyConstraint.h"
#include "PropertyMacro.h"
#include "UnsignedValue.h"
#include "Variable.h"
#include "VariableOperand.h"


namespace SCAM {

    class PropertySuite  {

    public:

        // Constructor
        explicit PropertySuite(std::string name);

        // Name
        const std::string &getName() const;
        void setName(const std::string &name);

        // Macros
        void addSyncSignal(PropertyMacro* ss);
        void addNotifySignal(PropertyMacro* ss);
        void addDpSignal(PropertyMacro* dp);
        void addVisibleRegister(PropertyMacro* reg);
        void addState(PropertyMacro* state);
        const std::vector<PropertyMacro *> &getSyncSignals() const;
        const std::vector<PropertyMacro *> &getNotifySignals() const;
        const std::vector<PropertyMacro *> &getDpSignals() const;
        const std::vector<PropertyMacro *> &getVisibleRegisters() const;
        const std::vector<PropertyMacro *> &getStates() const;
        PropertyMacro * findSignal(const std::string &signalName) const;
        PropertyMacro * findSignal(const std::string &parentlName, const std::string &subVarName) const;
        PropertyMacro * findSignal(Variable * var) const;

        // Functions
        void addFunction(Function* function);
        const std::vector<Function*> &getFunctions() const;


        // Constraints
        PropertyConstraint * createConstraint(const std::string &name);
        PropertyConstraint * createConstraint(const std::string &name, Stmt *expr);
        PropertyConstraint * getConstraint(const std::string &constraintName) const;
        const std::vector<PropertyConstraint *> &getConstraints() const;

        // ResetProperty
        Property* getResetProperty() const;
        void setResetProperty(Property* resetProperty);

        // OperationProperties
        void addProperty(Property* property);
        const std::vector<Property*> &getProperties() const;

        // StateMap
        //std::set<PropertyMacro*> getPredecessorStates(PropertyMacro* state);
        //std::set<PropertyMacro*> getSuccessorStates(PropertyMacro* state);
        //std::set<AbstractProperty*> getPredecessorProperties(PropertyMacro* state);
        //std::set<AbstractProperty*> getSuccessorProperties(PropertyMacro* state);

    private:

        std::string name;

        Variable * resetSignal;

        std::vector<PropertyMacro*> syncSignals;
        std::vector<PropertyMacro*> notifySignals;
        std::vector<PropertyMacro*> dpSignals;
        std::vector<PropertyMacro*> visibleRegisters;
        std::vector<PropertyMacro*> states;

        std::vector<Function*> functions;

        std::vector<PropertyConstraint*> constraints;

        Property* resetProperty;
        std::vector<Property*> propertyList;

        //std::map<PropertyMacro*, std::set<PropertyMacro*>> predecessorStates;
        //std::map<PropertyMacro*, std::set<PropertyMacro*>> successorStates;
        //std::map<PropertyMacro*, std::set<AbstractProperty*>> predecessorProperties;
        //std::map<PropertyMacro*, std::set<AbstractProperty*>> successorProperties;

    };

}

#endif //PROJECT_PROPERTYSUITE_H
