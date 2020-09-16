//
// Created by tobias on 04.11.16.
//

#include <DataTypes.h>

#include <utility>
#include "SyncSignal.h"
#include "NodePeekVisitor.h"

DESCAM::SyncSignal::SyncSignal(DESCAM::Port *port, LocationInfo stmtLocationInfo) :
        port(port),
        Expr(DataTypes::getDataType("bool")) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

void DESCAM::SyncSignal::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

DESCAM::Port *DESCAM::SyncSignal::getPort() const {
    return port;
}

bool DESCAM::SyncSignal::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSyncSignal(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SyncSignal *) this;
    auto otherPtr = (const SyncSignal *) &other;
    return (thisPtr->getPort() == otherPtr->getPort());
}
