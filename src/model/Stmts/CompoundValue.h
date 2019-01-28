//
// Created by tobias on 09.08.17.
//

#ifndef PROJECT_COMPOUNDVALUE_H
#define PROJECT_COMPOUNDVALUE_H

#include "ConstValue.h"

namespace SCAM {

    class CompoundValue : public ConstValue {
    public:
        CompoundValue(const std::vector<ConstValue *> &values, const DataType *dataType);

        //GETTER
        const std::map<std::string, ConstValue *> &getValues() const;

        virtual std::string getValueAsString() const override;

        //VISITOR
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        std::map<std::string, ConstValue *> values;
    };
};
#endif //PROJECT_COMPOUNDVALUE_H
