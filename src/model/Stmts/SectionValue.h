//
// Created by ludwig on 23.11.15.
//

#ifndef SCAM_STATEVALUE_H
#define SCAM_STATEVALUE_H

#include "ConstValue.h"

namespace SCAM{
/*!
 * \brief Class representing a state of FSM
 */
class SectionValue: public ConstValue {
public:
    SectionValue(std::string value, const DataType *type);
    SectionValue(const ConstValue * value);
    virtual void accept(StmtAbstractVisitor &visitor);

    std::string getValue();

    virtual std::string getValueAsString() const;

    virtual bool operator==(const Stmt &other) const;

private:
    std::string value;
};

}

#endif //SCAM_STATEVALUE_H
