//
// Created by tobias on 15.11.18.
//
#include "VariableTemplate.h"
#include "Variable.h"
#include "DataSignal.h"
#include "Timepoint.h"
#include "Parameter.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {
    template<class T>
    VariableTemplate<T>::VariableTemplate(std::string name, const DataType *dataType, ConstValue *initialValue, VariableTemplate *parent, LocationInfo locationInfo) :
            subVar(parent != nullptr),
            parent(parent),
            initialValue(initialValue),
            AbstractNode(name,locationInfo),
            TypeInterface(dataType) {

        //Build sub varialbes for complex types
        if (this->isCompoundType()) {
            if (this->isSubVar()) TERMINATE("Variable Constructor, a compound sub-variable is not allowed");
            //if (parent == nullptr) TERMINATE("Parent is not supposed to be null");
            //create the subVariables (with default init values)
            for (auto &&subvar : dataType->getSubVarMap()) {
                subVarList.push_back(new T(subvar.first, subvar.second, subvar.second->getDefaultVal(), (T *) (this)));
            }
        } else if (this->isArrayType()) {
            if (this->isSubVar()) TERMINATE("Variable Constructor, a array sub-variable is not allowed");
            //if (parent == nullptr) TERMINATE("Parent is not supposed to be null");
            for (int i = 0; i < dataType->getArraySize(); ++i) {
                subVarList.push_back(new T(std::to_string(i), this->getDataType()->getArrayType(), this->getDataType()->getArrayType()->getDefaultVal(), (T *) (this)));
            }
        } else if (!this->isBuiltInType() && !this->isEnumType()) TERMINATE("Unknown datatype: " + this->getName());

        if (this->initialValue == nullptr) {
            this->initialValue = dataType->getDefaultVal();
        } else
            assert(dataType == initialValue->getDataType());
    }

    template<class T>
    bool VariableTemplate<T>::hasSubVar(const std::string &n) const {
        if (!this->isCompoundType() && !this->isArrayType())
            TERMINATE("Variable hasSubVar, called for a non-compound/array variable");
        for (auto &&subvar : subVarList) {
            if (subvar->getName() == n) {
                return true;
            }
        }
        return false;
    }

    template<class T>
    bool VariableTemplate<T>::isSubVar() const {
        return subVar;
    }

    template<class T>
    ConstValue *VariableTemplate<T>::getInitialValue() const {
        return initialValue;
    }

    template<class T>
    std::string VariableTemplate<T>::getFullName() const {
        if (this->isSubVar() && this->parent->isCompoundType()) {
            return this->parent->getName() + "." + this->getName();
        } else if (this->isSubVar() && this->parent->isArrayType()) {
            return this->parent->getName() + "[" + this->getName() + "]";
        } else return this->getName();
    }

    template<class T>
    T *VariableTemplate<T>::getSubVar(const std::string &n) const {
        if (!this->isCompoundType() && !this->isArrayType()) TERMINATE("Variable getSubVar, called for a non-compound variable");

        for (auto &&subvar : subVarList) {
            if (subvar->getName() == n) {
                return (T *) subvar;
            }
        }
        TERMINATE("Variable getSubVar called with \"" + n + "\", not a sub-variable name");
    }

    template<class T>
    T *VariableTemplate<T>::getParent() const {
        return (T *) parent;
    }

    template<class T>
    std::vector<T *> VariableTemplate<T>::getSubVarList() const {
        std::vector<T *> test;
        for (VariableTemplate *subVar: this->subVarList) {
            test.push_back((T *) subVar);
        }
        return test;
    }

    template<class T>
    bool VariableTemplate<T>::isConstant() const {
        return constant;
    }

    template<class T>
    void VariableTemplate<T>::setConstant(bool isConstant) {
        VariableTemplate::constant = isConstant;
    }

    template<class T>
    bool VariableTemplate<T>::isArrayElement() const {
        return this->isSubVar() && this->parent->isArrayType();
    }
}