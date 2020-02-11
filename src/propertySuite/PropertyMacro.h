//
// Created by deutschmann on 06.09.18.
//

#ifndef PROJECT_PROPERTYMACRO_H
#define PROJECT_PROPERTYMACRO_H

#include "AbstractMacro.h"

#include "PortOperand.h"
#include "VariableOperand.h"

#include "Variable.h"
#include "DataSignal.h"
#include "SyncSignal.h"
#include "Notify.h"

namespace SCAM {

    //TODO: Use Template (Port, Variable...) ?
    //TODO: Rename? SignalMacro?
    class PropertyMacro : public AbstractMacro{

    public:
        // Constructor
        explicit PropertyMacro(SyncSignal *syncSignal);
        explicit PropertyMacro(Notify *notifySignal);
        explicit PropertyMacro(DataSignal * dataSignal);
        explicit PropertyMacro(Variable *variable);

        PropertyMacro(Variable *variable, PropertyMacro *parent);

        // Getter
        Port *getPort() const;
        Notify *getNotifySignal() const;
        SyncSignal *getSyncSignal() const;
        Variable *getVariable() const;

        VariableOperand *getVariableOperand() const;
        PropertyMacro *getParent() const;
        Expr *getOperand() const;

        std::string getFullName(const std::string& delimiter = ".") const;
        const std::string &getParentName() const;
        const std::string &getSubVarName() const;

    private:
        Port * port = nullptr;
        //Ports
        Notify * notifySignal = nullptr;
        SyncSignal * syncSignal = nullptr;
        DataSignal * dataSignal = nullptr;

        //Variable
        Variable * variable = nullptr;
        VariableOperand * variableOperand = nullptr;

        PropertyMacro * parent = nullptr;

        enum class MacroType {portType, notifyType, syncType, varType, arrayType};
        MacroType macroType;

    };
    bool operator<(const PropertyMacro &c1, const PropertyMacro &c2);

}

#endif //PROJECT_PROPERTYMACRO_H
