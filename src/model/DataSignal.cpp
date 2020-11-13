//

#include "DataSignal.h"


DESCAM::DataSignal::DataSignal(std::string name, const DESCAM::DataType *type, DESCAM::ConstValue *initialValue, DESCAM::DataSignal *parent, DESCAM::Port *port, LocationInfo locationInfo) :
        port(port),
        VariableTemplate(name, type, initialValue, parent,locationInfo) {
    if (parent != nullptr) {
        this->port = parent->getPort();
    }
}

DESCAM::Port *DESCAM::DataSignal::getPort() const {
    if (this->isSubVar()) {
        return this->getParent()->getPort();
    }
    return port;
}

void DESCAM::DataSignal::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
