//
// Created by tobias on 15.11.18.
//

#ifndef PROJECT_TYPEINTERFACE_H
#define PROJECT_TYPEINTERFACE_H

#include "DataType.h"

namespace SCAM {

    class TypeInterface {
    protected:

        explicit TypeInterface(DataType *dataType) :
                dataType(dataType) {
            assert(dataType != nullptr && "Datatype is null");
        };
    public:

        virtual DataType *getDataType() const final {
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

        DataType *dataType;

    };
}


#endif //PROJECT_TYPEINTERFACE_H
