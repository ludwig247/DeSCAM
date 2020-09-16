//
// Created by tobias on 15.11.18.
//

#ifndef PROJECT_VARIABLEINTERFACE_H
#define PROJECT_VARIABLEINTERFACE_H

#include "TypeInterface.h"
#include "ConstValue.h"


namespace DESCAM {
    template<class T>
    class VariableTemplate : public TypeInterface, public AbstractNode {
    public:
        explicit VariableTemplate(std::string name, const DataType *dataType, ConstValue *initialValue = nullptr, VariableTemplate *parent = nullptr, LocationInfo locationInfo = LocationInfo());

        virtual T *getParent() const final;

        virtual ConstValue *getInitialValue() const final;

        virtual bool isSubVar() const final;

        virtual bool hasSubVar(const std::string &n) const final;

        virtual T *getSubVar(const std::string &n) const final;

        virtual std::vector<T *> getSubVarList() const final;

        std::string getFullName() const;

        bool isConstant() const;
        void setConstant(bool isConstant);
        bool isArrayElement() const;

    private:

        std::vector<VariableTemplate *> subVarList;
        bool subVar; //! True, if this is a subVar
        VariableTemplate *parent; //! If this is a subVar; parent points to the variable contining this
        DESCAM::ConstValue *initialValue;
        bool constant = false;

    };

    template
    class VariableTemplate<Variable>;

    template
    class VariableTemplate<DataSignal>;

    template
    class VariableTemplate<Parameter>;

    template
    class VariableTemplate<Timepoint>;
};


#endif //PROJECT_VARIABLEINTERFACE_H
