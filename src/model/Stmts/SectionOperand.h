//
// Created by ludwig on 20.11.15.
//

#ifndef SCAM_STATEVARIABLE_H
#define SCAM_STATEVARIABLE_H

#include <Variable.h>
#include "FSM.h"
#include "Stmt.h"


namespace DESCAM {
    /*!
     * \brief Operand for a state variable
     *
     */
    class SectionOperand : public DESCAM::Expr {
    public:
        SectionOperand(DESCAM::Variable *sectionVariable, LocationInfo stmtLocationInfo = LocationInfo());

        std::string getName();

        Variable *getSectionVariable() const;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Variable *sectionVariable;

    };

}


#endif //SCAM_STATEVARIABLE_H
