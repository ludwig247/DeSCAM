//
// Created by tobias on 04.11.16.
//

#include <DataTypes.h>
#include "SyncSignal.h"
#include "NodePeekVisitor.h"

SCAM::SyncSignal::SyncSignal(SCAM::Port *port) :
        port(port),
        Expr(DataTypes::getDataType("bool")) {
}

void SCAM::SyncSignal::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

SCAM::Port *SCAM::SyncSignal::getPort() const {
    return port;
}

bool SCAM::SyncSignal::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSyncSignal(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SyncSignal *) this;
    auto otherPtr = (const SyncSignal *) &other;
    return (thisPtr->getPort() == otherPtr->getPort());
}
