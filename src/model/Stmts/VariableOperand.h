//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_MEMBEROPERATOR_H
#define SCAM_MEMBEROPERATOR_H

#include "Operand.h"
#include "Variable.h"

namespace SCAM {
    /**
     * \brief Points to a MemberVariable of the class, that is NOT a signal or port
     *
     */
    class VariableOperand : public Operand {
    public:
        VariableOperand(Variable* variable);

        Variable* getVariable();

        virtual void accept(StmtAbstractVisitor &visitor);

        std::string getOperandName() const;

        virtual bool operator==(const Stmt &other) const;

    private:
        Variable* variable;
    };


}


#endif //SCAM_MEMBEROPERATOR_H
