//
// Created by tobias on 15.11.18.
//

#ifndef PROJECT_TYPEINTERFACE_H
#define PROJECT_TYPEINTERFACE_H

#include "DataType.h"
#include "DescamException.h"

namespace DESCAM {

    class TypeInterface {
    protected:

        explicit TypeInterface(const DataType *dataType) :
                dataType(dataType) {
            if(!dataType) throw DescamException("Datatype is null",LocationInfo());
        };
    public:

        virtual const DataType *getDataType() const final {
            return dataType;
        }

        virtual bool isCompoundType() const final {
            return dataType->isCompoundType();
        }

        virtual bool isArrayType() const final {
            return dataType->isArrayType();
        }

        virtual bool isEnumType() const final {
            return dataType->isEnumType();
        }

        virtual bool isUnsigned() const final {
            return dataType->isUnsigned();
        }

        virtual bool isInteger() const final {
            return dataType->isInteger();
        }

        virtual bool isBuiltInType() const final {
            return dataType->isBuiltInType();
        }

        virtual bool isVoid() const final {
            return dataType->isVoid();
        }

        virtual bool hasSubVar() const final {
            return this->isCompoundType() || this->isArrayType();
        }

    private:
        TypeInterface() = default;

        const DataType *dataType;

    };
}


#endif //PROJECT_TYPEINTERFACE_H
