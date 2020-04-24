//
// Created by ludwig on 18.07.18.
//

#include <NodePeekVisitor.h>

#include <utility>
#include "CompoundExpr.h"
#include "StmtException.h"


namespace SCAM {
    CompoundExpr::CompoundExpr(std::map<std::string, SCAM::Expr *> valueMap, const DataType *dataType, StmtLocationInfo stmtLocationInfo) :
            valueMap(valueMap),
            Expr(dataType) {
        this->stmtLocationInfo = std::move(stmtLocationInfo);
        if (!dataType->isCompoundType()) throw SCAM::StmtException(dataType->getName() + " is not a compound type",this->stmtLocationInfo);
        for (auto subsig: dataType->getSubVarMap()) {
            if (valueMap.find(subsig.first) == valueMap.end()) throw SCAM::StmtException(subsig.first + "is not in the value map",this->stmtLocationInfo);
            if (valueMap.find(subsig.first) != valueMap.end()) {
                if (valueMap.find(subsig.first)->second->getDataType() != subsig.second) {
                    throw SCAM::StmtException(subsig.first + "has not the same datatype as " + valueMap.find(subsig.first)->first,this->stmtLocationInfo);
                }
            }
        }
    }

    CompoundExpr::~CompoundExpr() {

    }

    void CompoundExpr::accept(StmtAbstractVisitor &visitor) {
        visitor.visit(*this);

    }

    const std::map<std::string, Expr *> &CompoundExpr::getValueMap() const {
        return valueMap;
    }

    bool CompoundExpr::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekCompoundExpr(const_cast<Stmt *>(&other)) == nullptr) return false;
        auto thisPtr = (CompoundExpr *) this;
        auto otherPtr = (const CompoundExpr *) &other;
        if (thisPtr->getDataType() != otherPtr->getDataType()) return false;
        return (thisPtr->valueMap == otherPtr->valueMap);
    }


}



