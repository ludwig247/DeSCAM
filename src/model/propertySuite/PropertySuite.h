//
// Created by deutschmann on 10.09.18.
//

#ifndef PROJECT_PROPERTYSUITE_H
#define PROJECT_PROPERTYSUITE_H

#include <set>
#include <memory>

#include "FunctionMacro.h"
#include "Property.h"
#include "PropertyConstraint.h"
#include "PropertyMacro.h"
#include "UnsignedValue.h"
#include "Variable.h"
#include "VariableOperand.h"


namespace SCAM {

    class PropertySuite {

    public:

        // Constructor
        explicit PropertySuite(std::string name);

        PropertySuite(PropertySuite const &) = default;

        // Name
        const std::string &getName() const;

        void setName(const std::string &name);

        // Macros
        void addSyncSignal(std::shared_ptr<PropertyMacro> ss);

        void addNotifySignal(std::shared_ptr<PropertyMacro> ss);

        void addDpSignal(std::shared_ptr<PropertyMacro> dp);

        void addVisibleRegister(std::shared_ptr<PropertyMacro> reg);

        void addState(std::shared_ptr<PropertyMacro> state);

        const std::vector<std::shared_ptr<PropertyMacro>> &getSyncSignals() const;

        const std::vector<std::shared_ptr<PropertyMacro>> &getNotifySignals() const;

        const std::vector<std::shared_ptr<PropertyMacro>> &getDpSignals() const;

        const std::vector<std::shared_ptr<PropertyMacro>> &getVisibleRegisters() const;

        const std::vector<std::shared_ptr<PropertyMacro>> &getStates() const;

        std::shared_ptr<PropertyMacro> findSignal(const std::string &signalName) const;

        std::shared_ptr<PropertyMacro> findSignal(const std::string &parentlName, const std::string &subVarName) const;

        std::shared_ptr<PropertyMacro> findSignal(Variable *var) const;

        // Functions
        void addFunction(Function *function);

        const std::vector<Function *> &getFunctions() const;

        // Constraints
        std::shared_ptr<PropertyConstraint> createConstraint(const std::string &name);

        std::shared_ptr<PropertyConstraint> createConstraint(const std::string &name, Stmt *expr);

        std::shared_ptr<PropertyConstraint> getConstraint(const std::string &constraintName) const;

        const std::vector<std::shared_ptr<PropertyConstraint>> &getConstraints() const;

        // ResetProperty
        std::shared_ptr<Property> getResetProperty() const;

        void setResetProperty(std::shared_ptr<Property> resetProperty);

        // OperationProperties
        void addProperty(std::shared_ptr<Property> property);

        const std::vector<std::shared_ptr<Property>> &getProperties() const;

        // StateMap
        //std::set<PropertyMacro*> getPredecessorStates(PropertyMacro* state);
        //std::set<PropertyMacro*> getSuccessorStates(PropertyMacro* state);
        //std::set<AbstractProperty*> getPredecessorProperties(PropertyMacro* state);
        //std::set<AbstractProperty*> getSuccessorProperties(PropertyMacro* state);

    private:

        std::string name;

        Variable *resetSignal;

        std::vector<std::shared_ptr<PropertyMacro>> syncSignals;
        std::vector<std::shared_ptr<PropertyMacro>> notifySignals;
        std::vector<std::shared_ptr<PropertyMacro>> dpSignals;
        std::vector<std::shared_ptr<PropertyMacro>> visibleRegisters;
        std::vector<std::shared_ptr<PropertyMacro>> states;

        std::vector<Function *> functions;

        std::vector<std::shared_ptr<PropertyConstraint>> constraints;

        std::shared_ptr<Property> resetProperty;
        std::vector<std::shared_ptr<Property>> propertyList;

        //std::map<PropertyMacro*, std::set<PropertyMacro*>> predecessorStates;
        //std::map<PropertyMacro*, std::set<PropertyMacro*>> successorStates;
        //std::map<PropertyMacro*, std::set<AbstractProperty*>> predecessorProperties;
        //std::map<PropertyMacro*, std::set<AbstractProperty*>> successorProperties;

    };

}

#endif //PROJECT_PROPERTYSUITE_H
