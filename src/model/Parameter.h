//
// Created by tobias on 19.07.18.
//

#ifndef PROJECT_PARAMETER_H
#define PROJECT_PARAMETER_H


#include <DataType.h>
#include "VariableTemplate.h"

namespace SCAM {

    class Parameter : public VariableTemplate<Parameter> {
    public:
        Parameter() = delete;

        Parameter(std::string name, DataType *dataType, ConstValue *initialValue = nullptr, VariableTemplate *parent = nullptr, LocationInfo locationInfo = LocationInfo());

        virtual ~Parameter() = default;

        //DataType *getDataType() const;

        virtual void accept(AbstractVisitor &visitor);

    private:

    };

}

#endif //PROJECT_PARAMETER_H
