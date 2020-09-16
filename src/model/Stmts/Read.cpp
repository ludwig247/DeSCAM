//
// Created by ludwig on 02.11.16.
//

#include <assert.h>
#include <PrintStmt.h>

#include <utility>
#include "Read.h"
#include "NodePeekVisitor.h"

namespace DESCAM {

    Read::Read(Port *port, VariableOperand *variable, bool is_non_blocking_access, VariableOperand *status, LocationInfo stmtLocationInfo) :
            variable(variable),
            status(status),
            Communication(port, is_non_blocking_access) {
        this->stmtLocationInfo = std::move(stmtLocationInfo);
        assert(variable != nullptr || port->getDataType()->isVoid());
    }

    VariableOperand *Read::getVariableOperand() const {
        assert(variable != nullptr);
        return variable;
    }

    VariableOperand *Read::getStatusOperand() const {
        return status;
    }

    void Read::accept(StmtAbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    bool Read::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekRead(const_cast<Stmt *>(&other)) == nullptr) return false;
        auto thisPtr = (Read *) this;
        auto otherPtr = (const Read *) &other;
        if (thisPtr->getPort() != otherPtr->getPort()) return false;
        if ((thisPtr->variable == otherPtr->variable) && (!thisPtr->isNonBlockingAccess() && !otherPtr->isNonBlockingAccess())) return true;
        return (thisPtr->variable == otherPtr->variable) &&
               (thisPtr->isNonBlockingAccess() && otherPtr->isNonBlockingAccess()) &&
               (thisPtr->status == otherPtr->status);
    }

    std::ostream &Read::print(std::ostream &ostream) const {
        ostream << PrintStmt::toString(this);
        return ostream;
    }

    bool Read::hasStatusOperand() const {
        return this->status != nullptr;
    }


}
