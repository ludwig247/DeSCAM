//
// Created by tobias on 22.10.15.
//

#ifndef SCAM_MEMBER_H
#define SCAM_MEMBER_H

#include <Stmts/ConstValue.h>
#include "AbstractNode.h"
#include "enums.h"
#include "DataType.h"

namespace SCAM{

    /** \brief Represnts a variable within the module structure
     *
     *  - Variable(std::string name,DataType * type)
     *  Every variable needs to have an initialValue, if not passed the following initialvalues are assuemd
     *  bool: false
     *  int: 0
     *  enum: the first symbolic value in the enum value list
     *
     *  - Variable with built-in type: Variable(std::string name,DataType * type, ConstValue * initialValue);
     *  - Compound Variable: Create all sub-variables with their initalValue, create a new variable and pass them as a list
     *
     */
    class Variable: public AbstractNode {
    public:
        //TODO: Creater interface for DataSignal + Variable, remove first constructor
        Variable(std::string name,DataType * type, Variable * parent = nullptr); //! Single variable with default initalValue
        Variable(std::string name,DataType * type, ConstValue * nitialValue); //! Single Variable

         //Datatype
        DataType * getDataType();

        //Compound, Enum
        Variable *getParent() const; //! Compound containing this var

        const std::vector<Variable *>&getSubVarList() const;
        bool isCompoundType();
        bool isSubVar() const;
        bool hasSubVar(const std::string& n);
        Variable* getSubVar(const std::string& n);

        //Intital Value
        ConstValue * getInitialValue() const;
        void setInitialValue(ConstValue *initialValue);
        virtual std::string getFullName() const;

        //Visitor
        virtual void accept(AbstractVisitor &visitor);

    private:
        DataType * dataType; //!DataType of the variable
        bool mIsSubVar; //! True, if this is a subVar
        Variable * parent; //! If this is a subVar; parent points to the variable contining this
        SCAM::ConstValue * initialValue;
        std::vector<Variable*> subVarList;//needed (mydata var1.a should be a different object than mydata var2.a)
    };

}



#endif //SCAM_MEMBER_H
