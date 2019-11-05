//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_MODULES_H
#define SCAM_MODULES_H

#include <vector>
#include <PropertySuite.h>
#include <Behavior/CfgNode.h>

#include "Port.h"
#include "Variable.h"
#include "FSM.h"
#include "Function.h"


namespace SCAM {
    class Module : public AbstractNode {
    public:
        Module();

        Module(std::string name);

        virtual ~Module();

        //Ports
        void addPort(Port *port);

        const std::map<std::string, Port *> &getPorts() const;

        Port *getPort(const std::string &n) const;

        bool isPort(const std::string &n) const;

        bool isSlave() const;

        //FSM
        FSM *getFSM() const;

        //Variables
        void addVariable(Variable *variable);

        const std::map<std::string, Variable *> &getVariableMap() const;

        Variable *getVariable(const std::string &n) const;

        bool isVariable(const std::string &n) const;

        void removeVariable(Variable *variable);

        void removeFunction(std::string functionName);

        //Functions
        const std::map<std::string, Function *> &getFunctionMap() const;

        void addFunction(Function *function);

        bool isFunction(std::string name) const;

        Function *getFunction(std::string name);

        //Accept
        void accept(AbstractVisitor &visitor);

        // PropertySuite
        PropertySuite *getPropertySuite() const;

        void setPropertySuite(PropertySuite *propertySuite);

        std::map<int, SCAM::CfgNode *> getCFG() const;

        std::multimap<std::string, std::vector<SCAM::CfgNode *>> getcommGroups() const;

//    std::map<int, SCAM::CfgNode *> getCFG_Original() const;
//    std::map<int, SCAM::CfgNode *> getCFG_Implicit() const;
        void setCFG(std::map<int, SCAM::CfgNode *> cfg);

        void setCFG(std::map<int, SCAM::CfgNode *> cfg, std::multimap<std::string, std::vector<SCAM::CfgNode *>> commGroups);
//    void setCFG_Original(std::map<int, SCAM::CfgNode *> blockCFG);
//    void setCFG_Explicit(std::map<int, SCAM::CfgNode *> blockCFG);

    private:

        bool slave;
        std::map<std::string, Port *> ports; //! sc_in, sc_port<Interface>, ...
        std::map<std::string, Variable *> variableMap; //! <memberName,ptrToMember>
        std::map<std::string, Function *> functionMap;

        FSM *fsm;

        std::map<int, SCAM::CfgNode *> cfg;
        std::multimap<std::string, std::vector<SCAM::CfgNode *>> commGroups;

        //    std::map<int, SCAM::CfgNode *> cfg_Original;
//    std::map<int, SCAM::CfgNode *> cfg_Explicit;
        PropertySuite *propertySuite;
    };
}


#endif //SCAM_MODULES_H
