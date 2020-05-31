//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TIMEPOINT_H
#define DESCAM_TIMEPOINT_H

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
    class Timepoint : public VariableTemplate<Timepoint> {
    public:
        Timepoint() = delete;
        Timepoint(Timepoint&) = delete;
        explicit Timepoint(std::string name, DataType *type = DataTypes::getDataType("unsigned"), ConstValue *initialValue = nullptr, Timepoint *parent = nullptr);

        //Visitor
        virtual void accept(AbstractVisitor &visitor);

        // Serialization
        friend class Serializer;
    };

}

#endif //DESCAM_TIMEPOINT_H
