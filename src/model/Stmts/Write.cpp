//
// Created by ludwig on 02.11.16.
//

#include <PrintStmt.h>
#include "Write.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

namespace SCAM {

    Write::Write(Port *portOperand, Expr *value, bool is_non_blocking_access, VariableOperand *status, LocationInfo stmtLocationInfo) :
            value(value),
            status(status),
            Communication(portOperand, is_non_blocking_access) {
        this->stmtLocationInfo = std::move(stmtLocationInfo);
        if (portOperand->getDataType() != value->getDataType()) {
            throw SCAM::DescamException("Port " + portOperand->getName() + " and Value '" + PrintStmt::toString(value) + "' are not of the same datatype",this->stmtLocationInfo);
        }
    }

    Expr *Write::getValue() const {
        assert(value != nullptr);
        return value;
    }

    VariableOperand *Write::getStatusOperand() const {
        return status;
    }

    void Write::accept(StmtAbstractVisitor &visitor) {
        visitor.visit(*this);

    }

    bool Write::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekWrite(const_cast<Stmt *>(&other)) == nullptr) return false;
        auto thisPtr = (Write *) this;
        auto otherPtr = (const Write *) &other;
        if (thisPtr->getPort() != otherPtr->getPort()) return false;
        if ((thisPtr->value == otherPtr->value) && (!thisPtr->isNonBlockingAccess() && !otherPtr->isNonBlockingAccess())) return true;
        if ((*thisPtr->value == *otherPtr->value) && (!thisPtr->isNonBlockingAccess() && !otherPtr->isNonBlockingAccess())) return true; //FIXME: is this correct?
        if ((thisPtr->value == otherPtr->value) && (thisPtr->isNonBlockingAccess() && otherPtr->isNonBlockingAccess()) && (thisPtr->status == otherPtr->status)) return true;
        if ((*thisPtr->value == *otherPtr->value) && (thisPtr->isNonBlockingAccess() && otherPtr->isNonBlockingAccess()) && (*thisPtr->status == *otherPtr->status)) return true;
        return false;
    }

    std::ostream &Write::print(std::ostream &ostream) const {
        ostream << PrintStmt::toString(this);
        return ostream;
    }

    bool Write::hasStatusOperand() const {
        return this->status != nullptr;
    }

}
