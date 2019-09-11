//
// Created by tobias on 19.07.18.
//

#ifndef PROJECT_PARAMOPERAND_H
#define PROJECT_PARAMOPERAND_H

#include <Parameter.h>
#include "Operand.h"

namespace SCAM{
    class ParamOperand: public Operand{
    public:
        explicit ParamOperand(Parameter * parameter);
        virtual ~ParamOperand()=default;

        virtual std::string getOperandName() const;

        Parameter *getParameter() const;

        virtual bool operator==(const Stmt &other) const;

        virtual void accept(StmtAbstractVisitor &visitor);


    private:

        Parameter * parameter;
    };
}



#endif //PROJECT_PARAMOPERAND_H
