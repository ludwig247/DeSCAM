//
// Created by deutschmann on 06.09.18.
//

#include "PropertyMacro.h"

namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    PropertyMacro::PropertyMacro(const std::string &name, Port * port, const DataType * type) :
        port(port),
        parentName(name),
        portOperand(new PortOperand(port)),
        macroType(MacroType::portType),
        AbstractMacro(name, type){
    }

    PropertyMacro::PropertyMacro(const std::string &parentName, Port * port, const DataType * type, const std::string subVarName) :
        port(port),
        portOperand(new PortOperand(port)),
        macroType(MacroType::portType),
        subVarName(subVarName),
        parentName(parentName),
        AbstractMacro(subVarName, type){
    }

    PropertyMacro::PropertyMacro(const std::string &name, Port * port, Notify * notifySignal, const DataType * type) :
        parentName(name),
        subVarName(""),
        AbstractMacro(name, type){

        this->port = port;
        this->notifySignal = notifySignal;
        this->macroType = MacroType::notifyType;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Port * port, SyncSignal * syncSignal, const DataType * type) :
        parentName(name),
        AbstractMacro(name, type){

        this->port = port;
        this->syncSignal = syncSignal;
        this->macroType = MacroType::syncType;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Variable * variable, const DataType * type) :
            parentName(name),
            AbstractMacro(name, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = MacroType::varType;

    }

    PropertyMacro::PropertyMacro(const std::string &parentName, Variable * variable, const DataType * type, std::string subVarName) :
            parentName(parentName),
            AbstractMacro(subVarName, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = MacroType::varType;
        this->subVarName = subVarName;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Variable * variable, PropertyMacro * parent, const DataType * type) :
            parentName(name),
            AbstractMacro(name, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = MacroType::arrayType;
        this->parent = parent;

    }


    // ------------------------------------------------------------------------------
    //                                 Getter
    // ------------------------------------------------------------------------------

    Port *PropertyMacro::getPort() const {
        if (macroType != MacroType::portType and macroType != MacroType::notifyType and macroType != MacroType::syncType){
            throw std::runtime_error("Called Macro is not of type port, notifySignal or syncSignal!");
        }
        return port;
    }

    PortOperand *PropertyMacro::getPortOperand() const {
        if (macroType != MacroType::portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        return portOperand;
    }

    Notify *PropertyMacro::getNotifySignal() const {
        if (macroType != MacroType::notifyType){
            throw std::runtime_error("Called Macro is not of type notifySignal!");
        }
        return notifySignal;
    }

    SyncSignal *PropertyMacro::getSyncSignal() const {
        if (macroType != MacroType::syncType){
            throw std::runtime_error("Called Macro is not of type syncSignal!");
        }
        return syncSignal;
    }

    Variable *PropertyMacro::getVariable() const {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variable;
    }

    VariableOperand *PropertyMacro::getVariableOperand() const {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variableOperand;
    }

    PropertyMacro *PropertyMacro::getParent() const {
        if (macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type array!");
        }
        return parent;
    }

    const std::string &PropertyMacro::getSubVarName() const {
        return subVarName;
    }

    Expr *PropertyMacro::getOperand() const {

        if (macroType == MacroType::portType) {
            return portOperand;
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

    void PropertyMacro::setPort(Port *port) {
        if (macroType != MacroType::portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        PropertyMacro::port = port;
    }

    void PropertyMacro::setPortOperand(PortOperand *portOperand) {
        if (macroType != MacroType::portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        PropertyMacro::portOperand = portOperand;
    }

    void PropertyMacro::setNotifySignal(Notify *notifySignal) {
        if (macroType != MacroType::notifyType){
            throw std::runtime_error("Called Macro is not of type notifySignal!");
        }
        PropertyMacro::notifySignal = notifySignal;
    }

    void PropertyMacro::setSyncSignal(SyncSignal *syncSignal) {
        if (macroType != MacroType::portType){
            throw std::runtime_error("Called Macro is not of type syncSignal!");
        }
        PropertyMacro::syncSignal = syncSignal;
    }

    void PropertyMacro::setVariable(Variable *variable) {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        PropertyMacro::variable = variable;
    }

    void PropertyMacro::setVariableOperand(VariableOperand *variableOperand) {
        if (macroType != MacroType::varType and macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        PropertyMacro::variableOperand = variableOperand;
    }

    void PropertyMacro::setParent(SCAM::PropertyMacro *parent) {
        if (macroType != MacroType::arrayType){
            throw std::runtime_error("Called Macro is not of type array!");
        }
        PropertyMacro::parent = parent;
    }

    // ------------------------------------------------------------------------------
    //                      CompoundType/ArrayType-Functions
    // ------------------------------------------------------------------------------

    bool PropertyMacro::isCompoundType() const {
        return !subVarName.empty();
    }

    bool PropertyMacro::isArrayType() const {
        return macroType == MacroType::arrayType;
    }

    const std::string &PropertyMacro::getParentName() const {
        return parentName;
    }

    std::string PropertyMacro::getFullName() const {
        if(this->isCompoundType()){
            return this->parentName+"."+this->subVarName;
        }else return this->parentName;
    }

    std::string PropertyMacro::getFullName(const std::string& delimiter) const {
        if(this->macroType == MacroType::arrayType){
            if(this->variable->isSubVar() && this->variable->getParent()->isArrayType()){
                return this->variable->getParent()->getName()+"("+this->variable->getName()+")";
            }
        }

        if(this->isCompoundType()){
            return this->parentName+delimiter+this->subVarName;
        }else return this->parentName;
    }

    bool operator<(const PropertyMacro &c1, const PropertyMacro &c2) {
        return c1.getFullName() < c2.getFullName();
    }
}





















