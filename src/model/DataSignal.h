//
// Created by ludwig on 10.11.16.
//

#ifndef SCAM_DATASIGNAL_H
#define SCAM_DATASIGNAL_H

#include <Port.h>
#include "ConstValue.h"
namespace SCAM{


class DataSignal: public AbstractNode {
public:
    DataSignal(SCAM::Port *port, const ConstValue * constValue);

    DataType * getDataType();

    DataSignal * getParent() const;

    const std::vector<DataSignal *> &getSubSigList() const;
    bool isCompoundType();
    bool isSubSig() const;

    DataSignal* getSubSig(const std::string& n);

    const ConstValue *getInitialValue() const;
    std::string getFullName() const;

    Port *getPort() const;


    virtual void accept(AbstractVisitor &visitor);

private:
    DataSignal(std::string name, SCAM::DataType *type, DataSignal *parent, Port *port);

    bool subSig;
    Port * port;
    DataSignal * parent;
    DataType * dataType;
    const ConstValue * initialValue;
    std::vector<DataSignal*> subSigList;

};
}

#endif //SCAM_DATASIGNAL_H
