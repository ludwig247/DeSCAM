//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TIMEEXPR_H
#define DESCAM_TIMEEXPR_H

#include <string>

#include "AbstractVisitor.h"
#include "ConstValue.h"
#include "VariableTemplate.h"

namespace SCAM {

    /** \brief Represents a time expression within a property
     *
     *  - TimeExpr(std::string name)
     *
     */
    class TimeExpr : public VariableTemplate<TimeExpr> {
    public:
        TimeExpr(std::string name);

        //Visitor
        virtual void accept(AbstractVisitor &visitor);

    };

}

#endif //DESCAM_TIMEEXPR_H
