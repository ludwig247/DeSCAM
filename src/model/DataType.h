//
// Created by tobias on 29.04.16.
//

#ifndef SCAM_DATATYPE_H
#define SCAM_DATATYPE_H


#include <cassert>
#include <utility>
#include "AbstractNode.h"

namespace DESCAM {


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
 *  2) Add all sub-variables
 *  Complex->addSubVar(x,DataTypeMap[int])
 *
 *  enum-type:
 *  Enum foo<A,B,C>
 *  Its constructed in two steps
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
        explicit DataType(std::string name, LocationInfo locationInfo = LocationInfo()) :
                AbstractNode(std::move(name), std::move(locationInfo)) {};

        //Adder
        void addSubVar(const std::string& subVarName, DataType *subVarType);

        void addEnumValue(const std::string& enumValue);

        void addArray(DataType *arrayType, int arraySize);

        //Getter
        //TODO: make protected ... every object should implement typeInterface
        bool isCompoundType() const;

        bool isEnumType() const;

        bool isUnsigned() const;

        bool isInteger() const;

        bool isBoolean() const;

        bool isBuiltInType() const;

        bool isVoid() const;

        bool isArrayType() const;

        ConstValue *getDefaultVal() const;

        int getArraySize() const;

        DataType *getArrayType() const;

        const std::map<std::string, DataType *> &getSubVarMap() const;

        const std::map<std::string, int> &getEnumValueMap() const;

        //Visitor
        void accept(AbstractVisitor &visitor) override;

    private:
        int array_size_ = 0;
        DataType *array_type_ = nullptr;
        std::map<std::string, DESCAM::DataType *> sub_var_map_; //! Contains an entry <subVarName,subVarType>
        std::map<std::string, int> enum_value_map_; //! Contains an entry <elementName,int> for every possible value
    };


}
#endif //SCAM_DATATYPE_H
