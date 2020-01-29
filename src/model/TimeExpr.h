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
        TimeExpr() = delete;
        TimeExpr(TimeExpr&) = delete;

        explicit TimeExpr(std::string name, DataType *type = DataTypes::getDataType("unsigned"), ConstValue *initialValue = nullptr, TimeExpr *parent = nullptr);

        //Visitor
        virtual void accept(AbstractVisitor &visitor);

    };

}

#endif //DESCAM_TIMEEXPR_H
