//
// Created by tobias on 29.04.16.
//

#ifndef SCAM_DATATYPE_H
#define SCAM_DATATYPE_H


#include <cassert>
#include "AbstractNode.h"

namespace SCAM {


/** \brief Represents DataTypes built-in-type(int,bool,...), compound-type or Enum-type
 *
 *  Each variable and port has a dedicated type.
 *  built-in type:
 *  Represents a build-in type, classic builtin-in type of C are bool,int,char,double,float
 *  new DataType("build-in type name"); e.g. "bool"
 *
 *  compound-type:
 *  Represents a datatype that is compound of multiple built-in types
 *  E.g:
 *  Complex<int x,int y,bool z>
 *  Compound Type named Complex with SubVariables x,y,z
 *  It is constructed in two steps:
 *  1) Create a type for the compound
 *  DataType * Complex = new DataType("compound-type name"); e.g. "Complex"
 *  2) Add all subvariables
 *  Complex->addSubVar(x,DataTypeMap[int])
 *
 *  enum-type:
 *  Enum foo<A,B,C>
 *  Its constructed in two stesps
 *  1) Create a type for the enum
 *  DataType *  foo = new DataType("enum-type name"); e.g. "foo"
 *  2) Add all possible enum values
 *  foo->addEnumValue("A");
 *
 *
 */
    class ConstValue;

    class DataType : public AbstractNode {
    public:
        DataType(std::string name) :
                AbstractNode(name) {};

        //Adder
        void addSubVar(std::string subVarName, DataType *subVarType);

        void addEnumValue(std::string enumValue);

        //Getter
        const bool isCompoundType() const;

        const bool isEnumType() const;

        const bool isUnsigned() const;

        const bool isInteger() const;

        const bool isBuiltInType() const;

        const bool isVoid() const;

        ConstValue *getDefaultVal();

        const std::map<std::string, DataType *> &getSubVarMap() const;

        const std::map<std::string, int> &getEnumValueMap() const;

        //Visitor
        virtual void accept(AbstractVisitor &visitor);

    private:
        std::map<std::string, SCAM::DataType *> subVarMap; //! Contains an entry <subVarName,subVarType>
        std::map<std::string, int> enumValueMap; //! Contains an entry <elementName,int> for every possible value
    };


}
#endif //SCAM_DATATYPE_H
