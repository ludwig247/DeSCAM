//
// Created by tobias on 19.07.18.
//

#ifndef PROJECT_PARAMETER_H
#define PROJECT_PARAMETER_H

#include <AbstractNode.h>
#include <DataType.h>

namespace SCAM{

class Parameter: public AbstractNode {
public:
    Parameter(std::string name, DataType * dataType);
    virtual ~Parameter() = default;

    DataType *getDataType() const;

    virtual void accept(AbstractVisitor &visitor);

private:
    Parameter() = default;
    DataType * dataType;
};

}

#endif //PROJECT_PARAMETER_H
