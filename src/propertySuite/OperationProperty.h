//
// Created by deutschmann on 20.11.18.
//

#ifndef PROJECT_OPERATIONPROPERTY_H
#define PROJECT_OPERATIONPROPERTY_H

#include "AbstractProperty.h"

namespace SCAM {

    enum NotifyTiming{TT_1, FF_1, FF_e, FT_e};

    class OperationProperty : public AbstractProperty {

    public:

        explicit OperationProperty(const std::string &name);

        void addTiming(Port* port, NotifyTiming t);

        NotifyTiming getTiming(Port* port);


    private:

        std::map<Port*,NotifyTiming> notifyTimingMap;

    };

}

#endif //PROJECT_OPERATIONPROPERTY_H
