//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/11/19.
//

#include "Peek.h"

#include <utility>
#include "NodePeekVisitor.h"

SCAM::Peek::Peek(SCAM::Port *port, LocationInfo stmtLocationInfo) :
        Expr(DataTypes::getDataType("bool")),
        Communication(port, true) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

void SCAM::Peek::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool SCAM::Peek::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSyncSignal(const_cast<Stmt *>(&other)) == nullptr) return false; //TODO
    auto thisPtr = (Peek *) this;
    auto otherPtr = (const Peek *) &other;
    return (thisPtr->getPort() == otherPtr->getPort());
}
