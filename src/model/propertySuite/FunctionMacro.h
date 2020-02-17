//
// Created by deutschmann on 23.11.18.
//

#ifndef PROJECT_FUNCTIONMACRO_H
#define PROJECT_FUNCTIONMACRO_H

#include "AbstractMacro.h"

namespace SCAM {

    class FunctionMacro : public AbstractMacro {

        //TODO: REMOVE?

    public:

        explicit FunctionMacro(const std::string &name, const DataType * type);

        const std::vector<Parameter *> &getParameters() const;

        void setParameters(const std::vector<Parameter *> &parameters);

        void addParameter(Parameter* parameter);

    private:

        std::vector<Parameter*> parameters;


    };

}

#endif //PROJECT_FUNCTIONMACRO_H
