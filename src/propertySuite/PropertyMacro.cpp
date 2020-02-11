//
// Created by deutschmann on 06.09.18.
//

#include "PropertyMacro.h"

namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------


    PropertyMacro::PropertyMacro(DataSignal *dataSignal) :
            port(dataSignal->getPort()),
            dataSignal(dataSignal),
            macroType(MacroType::portType),
            AbstractMacro(dataSignal->getName(), dataSignal->getDataType()) {
    }


    PropertyMacro::PropertyMacro(Notify *notifySignal) :
            notifySignal(notifySignal),
            port(notifySignal->getPort()),
            macroType(MacroType::notifyType),
            AbstractMacro(notifySignal->getPort()->getName() + "_notify", notifySignal->getDataType()) {
    }

    PropertyMacro::PropertyMacro(SyncSignal *syncSignal) :
            port(syncSignal->getPort()),
            syncSignal(syncSignal),
            macroType(MacroType::syncType),
            AbstractMacro(syncSignal->getPort()->getName() + "sync", syncSignal->getDataType()) {
    }

    PropertyMacro::PropertyMacro(Variable *variable) :
            variable(variable),
            variableOperand(new VariableOperand(variable)),
            macroType(MacroType::varType),
            AbstractMacro(variable->getName(), variable->getDataType()) {
    }

    PropertyMacro::PropertyMacro(Variable *variable, PropertyMacro *parent) :
            variable(variable),
            variableOperand(new VariableOperand(variable)),
            macroType(MacroType::varType),
            parent(parent),
            AbstractMacro(variable->getName(), variable->getDataType()) {
    }


    // ------------------------------------------------------------------------------
    //                                 Getter
    // ------------------------------------------------------------------------------

    Port *PropertyMacro::getPort() const {
        if (macroType != MacroType::portType and macroType != MacroType::notifyType and macroType != MacroType::syncType) {
            throw std::runtime_error("Called Macro is not of type port, notifySignal or syncSignal!");
        }
        return port;
    }

    Notify *PropertyMacro::getNotifySignal() const {
        if (macroType != MacroType::notifyType) {
            throw std::runtime_error("Called Macro is not of type notifySignal!");
        }
        return notifySignal;
    }

    SyncSignal *PropertyMacro::getSyncSignal() const {
        if (macroType != MacroType::syncType) {
            throw std::runtime_error("Called Macro is not of type syncSignal!");
        }
        return syncSignal;
    }

    Variable *PropertyMacro::getVariable() const {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType) {
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variable;
    }

    VariableOperand *PropertyMacro::getVariableOperand() const {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType) {
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variableOperand;
    }

    PropertyMacro *PropertyMacro::getParent() const {
        if (macroType != MacroType::arrayType) {
            throw std::runtime_error("Called Macro is not of type array!");
        }
        return parent;
    }

    const std::string &PropertyMacro::getSubVarName() const {
        if (this->variable != nullptr) {
            if (this->variable->isSubVar()) {
                return this->variable->getName();
            }
        } else if (this->dataSignal->isSubVar()) {
            return this->variable->getName();
        } else {
            throw std::runtime_error(" Macro does not contain a subvarible. Check first with ->isSubVar() ");
        }
    }

    Expr *PropertyMacro::getOperand() const {

        if (macroType == MacroType::portType) {
            return new PortOperand(port);
        } else if (macroType == MacroType::notifyType) {
            return reinterpret_cast<Expr *>(notifySignal);
        } else if (macroType == MacroType::syncType) {
            return reinterpret_cast<Expr *>(syncSignal);
        } else if (macroType == MacroType::varType) {
            return variableOperand;
        } else if (macroType == MacroType::arrayType) {
            return variableOperand;
        } else {
            throw std::runtime_error("Unknown macroType when calling PropertyMacro::getOperand.");
        }

    }


    // ------------------------------------------------------------------------------
    //                                 Setter
    // ------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------
    //                      CompoundType/ArrayType-Functions
    // ------------------------------------------------------------------------------

    const std::string &PropertyMacro::getParentName() const {
        if (this->variable != nullptr) {
            if (this->variable->isSubVar()) {
                return this->variable->getParent()->getName();
            }
        } else if (this->dataSignal->isSubVar()) {
            return this->dataSignal->getName();
        } else {
            throw std::runtime_error(" Macro is not a subvarible. Check first with ->isSubVar() ");
        }
    }

    std::string PropertyMacro::getFullName(const std::string &delimiter) const {
        if (this->macroType == MacroType::arrayType) {
            if (this->variable->isSubVar() && this->variable->getParent()->isArrayType()) {
                return this->variable->getParent()->getName() + "(" + this->variable->getName() + ")";
            }
        }

        if (this->isCompoundType()) {
            return this->getParentName() + delimiter + this->getSubVarName();
        } else return this->getName();
    }

//    std::string PropertyMacro::getName() const {
//        if(this->variable != nullptr){
//            return this->variable->getName();
//        }else if(this->dataSignal != nullptr){
//            return this->dataSignal->getName();
//        }else if(this->notifySignal != nullptr){
//            return notifySignal->getPort()->getName()+"_notify";
//        }else if(this->syncSignal != nullptr){
//            return this->syncSignal->getPort()->getName()+"_sync";
//        }
//    }

    bool operator<(const PropertyMacro &c1, const PropertyMacro &c2) {
        return c1.getFullName() < c2.getFullName();
    }
}





















