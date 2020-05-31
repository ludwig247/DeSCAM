//

#include <assert.h>
#include "DataSignal.h"


SCAM::DataSignal::DataSignal(std::string name, SCAM::DataType *type, SCAM::ConstValue *initialValue, SCAM::DataSignal *parent, SCAM::Port *port) :
        port(port),
        VariableTemplate(name, type, initialValue, parent) {
    //! Commenting this below because it breaks the serialization (for cases when 'parent' is of type VariableTemplate
    //! and thus, invalid 'port' object may exist)
//    if (parent != nullptr) {
//        this->port = parent->getPort();
//    }
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
