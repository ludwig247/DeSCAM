//
// Created by tobias on 05.12.18.
//

#include "Notify.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::Notify::Notify(DESCAM::Port *port, LocationInfo stmtLocationInfo) :
        port(port),
        Expr(DataTypes::getDataType("bool")) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

DESCAM::Port *DESCAM::Notify::getPort() const {
    return port;
}

void DESCAM::Notify::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::Notify::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekNotify(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Notify *) this;
    auto otherPtr = (const Notify *) &other;
    return (thisPtr->getPort() == otherPtr->getPort());
}

