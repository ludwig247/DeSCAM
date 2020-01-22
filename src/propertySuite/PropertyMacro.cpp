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
        macroType(portType),
        AbstractMacro(name, type){
    }

    PropertyMacro::PropertyMacro(const std::string &parentName, Port * port, const DataType * type, const std::string subVarName) :
        port(port),
        portOperand(new PortOperand(port)),
        macroType(portType),
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
        this->macroType = notifyType;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Port * port, SyncSignal * syncSignal, const DataType * type) :
        parentName(name),
        AbstractMacro(name, type){

        this->port = port;
        this->syncSignal = syncSignal;
        this->macroType = syncType;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Variable * variable, const DataType * type) :
            parentName(name),
            AbstractMacro(name, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = varType;

    }

    PropertyMacro::PropertyMacro(const std::string &parentName, Variable * variable, const DataType * type, std::string subVarName) :
            parentName(parentName),
            AbstractMacro(subVarName, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = varType;
        this->subVarName = subVarName;

    }

    PropertyMacro::PropertyMacro(const std::string &name, Variable * variable, PropertyMacro * parent, const DataType * type) :
            parentName(name),
            AbstractMacro(name, type){

        this->variable = variable;
        this->variableOperand = new VariableOperand(variable);
        this->macroType = arrayType;
        this->parent = parent;

    }


    // ------------------------------------------------------------------------------
    //                                 Getter
    // ------------------------------------------------------------------------------

    Port *PropertyMacro::getPort() const {
        if (macroType != portType and macroType != notifyType and macroType != syncType){
            throw std::runtime_error("Called Macro is not of type port, notifySignal or syncSignal!");
        }
        return port;
    }

    PortOperand *PropertyMacro::getPortOperand() const {
        if (macroType != portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        return portOperand;
    }

    Notify *PropertyMacro::getNotifySignal() const {
        if (macroType != notifyType){
            throw std::runtime_error("Called Macro is not of type notifySignal!");
        }
        return notifySignal;
    }

    SyncSignal *PropertyMacro::getSyncSignal() const {
        if (macroType != syncType){
            throw std::runtime_error("Called Macro is not of type syncSignal!");
        }
        return syncSignal;
    }

    Variable *PropertyMacro::getVariable() const {
        if (macroType != varType and macroType != arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variable;
    }

    VariableOperand *PropertyMacro::getVariableOperand() const {
        if (macroType != varType and macroType != arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        return variableOperand;
    }

    PropertyMacro *PropertyMacro::getParent() const {
        if (macroType != arrayType){
            throw std::runtime_error("Called Macro is not of type array!");
        }
        return parent;
    }

    const std::string &PropertyMacro::getSubVarName() const {
        return subVarName;
    }

    Expr *PropertyMacro::getOperand() const {

        if (macroType == portType) {
            return portOperand;
        } else if (macroType == notifyType) {
            return reinterpret_cast<Expr *>(notifySignal);
        } else if (macroType == syncType) {
            return reinterpret_cast<Expr *>(syncSignal);
        } else if (macroType == varType) {
            return variableOperand;
        } else if (macroType == arrayType) {
            return variableOperand;
        } else {
            throw std::runtime_error("Unknown macroType when calling PropertyMacro::getOperand.");
        }

    }


    // ------------------------------------------------------------------------------
    //                                 Setter
    // ------------------------------------------------------------------------------

    void PropertyMacro::setPort(Port *port) {
        if (macroType != portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        PropertyMacro::port = port;
    }

    void PropertyMacro::setPortOperand(PortOperand *portOperand) {
        if (macroType != portType){
            throw std::runtime_error("Called Macro is not of type port!");
        }
        PropertyMacro::portOperand = portOperand;
    }

    void PropertyMacro::setNotifySignal(Notify *notifySignal) {
        if (macroType != notifyType){
            throw std::runtime_error("Called Macro is not of type notifySignal!");
        }
        PropertyMacro::notifySignal = notifySignal;
    }

    void PropertyMacro::setSyncSignal(SyncSignal *syncSignal) {
        if (macroType != portType){
            throw std::runtime_error("Called Macro is not of type syncSignal!");
        }
        PropertyMacro::syncSignal = syncSignal;
    }

    void PropertyMacro::setVariable(Variable *variable) {
        if (macroType != varType and macroType != arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        PropertyMacro::variable = variable;
    }

    void PropertyMacro::setVariableOperand(VariableOperand *variableOperand) {
        if (macroType != varType and macroType != arrayType){
            throw std::runtime_error("Called Macro is not of type variable!");
        }
        PropertyMacro::variableOperand = variableOperand;
    }

    void PropertyMacro::setParent(SCAM::PropertyMacro *parent) {
        if (macroType != arrayType){
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

    bool PropertyMacro::isArrayType() {
        return macroType == arrayType;
    }

    const std::string &PropertyMacro::getParentName() const {
        return parentName;
    }

    std::string PropertyMacro::getFullName() const {
        if(this->isCompoundType()){
            return this->parentName+"."+this->subVarName;
        }else return this->parentName;
    }

    std::string PropertyMacro::getFullName(std::string delimiter) const {
        if(this->isCompoundType()){
            return this->parentName+delimiter+this->subVarName;
        }else return this->parentName;
    }
}





















