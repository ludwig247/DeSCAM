//
// Created by tobias on 30.10.19.
//

#include "ArrayExpr.h"
#include "StmtException.h"
#include <NodePeekVisitor.h>

#include <utility>

SCAM::ArrayExpr::ArrayExpr(std::map<std::string, SCAM::Expr *> valueMap, const SCAM::DataType *dataType,
                           StmtLocationInfo stmtLocationInfo) :
        valueMap(valueMap),
        Expr(dataType) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (!dataType->isArrayType()) throw std::runtime_error(dataType->getName() + " is not a array type");
    for (auto subsig: dataType->getSubVarMap()) {
        if (valueMap.find(subsig.first) == valueMap.end())
            throw std::runtime_error(subsig.first + "is not in the value map");
        if (valueMap.find(subsig.first) != valueMap.end()) {
            if (valueMap.find(subsig.first)->second->getDataType() != subsig.second) {
                throw StmtException(
                        subsig.first + "has not the same datatype as " + valueMap.find(subsig.first)->first,
                        this->stmtLocationInfo);
            }
        }
    }
}

void SCAM::ArrayExpr::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::ArrayExpr::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekArrayExpr(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ArrayExpr *) this;
    auto otherPtr = (const ArrayExpr *) &other;
    if (thisPtr->getDataType() != otherPtr->getDataType()) return false;
    return (thisPtr->valueMap == otherPtr->valueMap);
}

const std::map<std::string, SCAM::Expr *> &SCAM::ArrayExpr::getValueMap() const {
    return valueMap;
}

