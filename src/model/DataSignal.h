//
// Created by ludwig on 10.11.16.
//

#ifndef SCAM_DATASIGNAL_H
#define SCAM_DATASIGNAL_H

#include <Port.h>
#include "VariableTemplate.h"

namespace SCAM {


    class DataSignal : public VariableTemplate<DataSignal> {
    public:
        DataSignal()= delete;
        DataSignal(DataSignal&) = delete;
        DataSignal(std::string name, const DataType *type, ConstValue *initialValue = nullptr, DataSignal *parent = nullptr, SCAM::Port *port = nullptr, LocationInfo locationInfo = LocationInfo());

        Port *getPort() const;

        virtual void accept(AbstractVisitor &visitor);

    private:
        Port *port;
    };
}

#endif //SCAM_DATASIGNAL_H
