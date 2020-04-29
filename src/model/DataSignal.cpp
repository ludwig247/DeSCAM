//

#include <assert.h>
#include "DataSignal.h"


SCAM::DataSignal::DataSignal(std::string name, const SCAM::DataType *type, SCAM::ConstValue *initialValue, SCAM::DataSignal *parent, SCAM::Port *port, LocationInfo locationInfo) :
        port(port),
        VariableTemplate(name, type, initialValue, parent,locationInfo) {
    if (parent != nullptr) {
        this->port = parent->getPort();
    }
}

SCAM::Port *SCAM::DataSignal::getPort() const {
    if (this->isSubVar()) {
        return this->getParent()->getPort();
    }
    return port;
}

void SCAM::DataSignal::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
