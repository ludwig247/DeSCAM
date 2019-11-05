//
// Created by deutschmann on 06.09.18.
//

#ifndef PROJECT_PROPERTYMACRO_H
#define PROJECT_PROPERTYMACRO_H

#include "AbstractMacro.h"
#include "Operand.h"
#include "PortOperand.h"
#include "VariableOperand.h"

namespace SCAM {

    //TODO: Use Template (Port, Variable...) ?
    //TODO: Rename? SignalMacro?
    class PropertyMacro : public AbstractMacro {

    public:

        // Constructor
        PropertyMacro(const std::string &name, Port* port, const DataType * type);
        PropertyMacro(const std::string &name, Port* port, const DataType * type, std::string subVarName);
        PropertyMacro(const std::string &name, Port* port, SyncSignal* syncSignal, const DataType * type);
        PropertyMacro(const std::string &name, Port* port, Notify* notifySignal, const DataType * type);
        PropertyMacro(const std::string &name, Variable* variable, const DataType * type);
        PropertyMacro(const std::string &name, Variable* state);
        PropertyMacro(const std::string &name, Variable* variable, const DataType * type, std::string subVarName);
        PropertyMacro(const std::string &name, Variable* variable, PropertyMacro* parent, const DataType * type);

        // Getter
        Port *getPort() const;
        PortOperand *getPortOperand() const;
        Notify *getNotifySignal() const;
        SyncSignal *getSyncSignal() const;
        Variable *getVariable() const;
        VariableOperand *getVariableOperand() const;
        PropertyMacro *getParent() const;
        const std::string &getSubVarName() const;

        // Setter
        void setPort(Port *port);
        void setPortOperand(PortOperand *portOperand);
        void setNotifySignal(Notify *notifySignal);
        void setSyncSignal(SyncSignal *syncSignal);
        void setVariable(Variable *variable);
        void setVariableOperand(VariableOperand *variableOperand);
        void setParent(PropertyMacro *parent);

        // Array-Type
        bool isCompoundType();
        bool isArrayType();


    private:
        Port * port = nullptr;
        PortOperand * portOperand = nullptr;
        Notify * notifySignal = nullptr;
        SyncSignal * syncSignal = nullptr;
        Variable * variable = nullptr;
        VariableOperand * variableOperand = nullptr;

        std::string subVarName;

    private:

        PropertyMacro * parent = nullptr;

        enum MacroType {portType, notifyType, syncType, varType, stateType, arrayType};
        MacroType macroType;

    };

}

#endif //PROJECT_PROPERTYMACRO_H
