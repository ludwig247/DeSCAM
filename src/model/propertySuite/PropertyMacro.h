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

    class PropertyMacro : public AbstractMacro {

    public:
        // Constructor
        explicit PropertyMacro(SyncSignal *syncSignal);
        explicit PropertyMacro(Notify *notifySignal);
        explicit PropertyMacro(DataSignal *dataSignal);
        explicit PropertyMacro(Variable *variable);

        // Getter
        Port *getPort() const;
        Notify *getNotifySignal() const;
        SyncSignal *getSyncSignal() const;
        Variable *getVariable() const;
        VariableOperand *getVariableOperand() const;

        Expr *getOperand() const;

        std::string getFullName(const std::string &delimiter = ".") const;  //! Return the full name if compound ... return parent + subvar name
        std::string getParentName() const; //! Returns the parent name, only call if subvar
        std::string getSubVarName() const; //! Returns the subvar name, only call if subvar
        bool isSubVar() const; //! Returns true if object is part of a compound or array
        const DataType *getParentDataType() const;

    private:
        Port *port = nullptr;
        //Ports
        Notify *notifySignal = nullptr;
        SyncSignal *syncSignal = nullptr;
        DataSignal *dataSignal = nullptr;

        //Variable
        Variable *variable = nullptr;
        VariableOperand *variableOperand = nullptr;

        PropertyMacro *parent = nullptr;

        enum class MacroType {
            portType, notifyType, syncType, varType, arrayType
        };
        MacroType macroType;

    };

    bool operator<(const PropertyMacro &c1, const PropertyMacro &c2);

}

#endif //PROJECT_PROPERTYMACRO_H
