//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_MODULES_H
#define SCAM_MODULES_H

#include <vector>
#include <PropertySuite.h>
#include <Behavior/CfgNode.h>
#include <memory>

#include "Port.h"
#include "Variable.h"
#include "FSM.h"
#include "Function.h"


namespace DESCAM {
    class Module : public AbstractNode {
    public:
        Module() = delete;
        explicit  Module(std::string name, LocationInfo locationInfo = LocationInfo());
        ~Module() = default;

        //Ports
        void addPort(Port *port);

        const std::map<std::string, Port *> &getPorts() const;
        Port * getPort(const std::string &n) const;
        bool isPort(const std::string &n) const;
        bool isSlave() const;

        //FSM
        FSM *getFSM() const;

        //Variables
        void addVariables(std::map<std::string, Variable *> variables);
        const std::map<std::string, Variable *> &getVariableMap() const;
        Variable *getVariable(const std::string &n) const;
        bool isVariable(const std::string &n) const;
        void removeVariable(Variable *variable);
        void removeFunction(std::string functionName);
        void setVariableMap(const std::map<std::string, Variable *> &variableMap);

        //Functions
        const std::map<std::string, Function *> &getFunctionMap() const;
        void addFunction(Function *function);
        /**
         * Sets functions into the module
         * @param functions functions that should be added to module
         */
        void addFunctions(std::map<std::string, Function *> functions);
        bool isFunction(std::string name) const;
        Function *getFunction(std::string name);

        //Accept
        void accept(AbstractVisitor &visitor);

        // PropertySuite
        std::shared_ptr<PropertySuite> getPropertySuite() const;

        void setPropertySuite(std::shared_ptr<PropertySuite> propertySuite);

        std::map<int, DESCAM::CfgNode *> getCFG() const;

        std::multimap<std::string, std::vector<DESCAM::CfgNode *>> getcommGroups() const; //TODO: delete
        void setCFG(std::map<int, DESCAM::CfgNode *> cfg);
        void setCFG(std::map<int, DESCAM::CfgNode *> cfg, std::multimap<std::string, std::vector<DESCAM::CfgNode *>> commGroups);


    private:

        std::map<std::string, Port *> ports; //! sc_in, sc_port<Interface>, ...
        std::map<std::string, Variable *> variableMap; //! <memberName,ptrToMember>
        std::map<std::string, Function *> function_map_;

        FSM *fsm;

        std::map<int, DESCAM::CfgNode *> cfg;
        std::multimap<std::string, std::vector<DESCAM::CfgNode *>> commGroups;

        std::shared_ptr<PropertySuite> propertySuite;
    };
}


#endif //SCAM_MODULES_H
