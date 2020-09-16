//
// Created by tobias on 30.10.19.
//

#include "ArrayExpr.h"
#include "DescamException.h"
#include <NodePeekVisitor.h>
#include "FatalError.h"
#include "Logger/Logger.h"
#include <utility>

DESCAM::ArrayExpr::ArrayExpr(std::map<std::string, DESCAM::Expr *> valueMap, const DESCAM::DataType *dataType,
                           LocationInfo stmtLocationInfo) :
        valueMap(valueMap),
        Expr(dataType) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (!dataType->isArrayType()) TERMINATE(dataType->getName() + " is not a array type");
    for (auto subsig: dataType->getSubVarMap()) {
        if (valueMap.find(subsig.first) == valueMap.end())
            TERMINATE(subsig.first + "is not in the value map");
        if (valueMap.find(subsig.first) != valueMap.end()) {
            if (valueMap.find(subsig.first)->second->getDataType() != subsig.second) {
                throw DescamException(
                        subsig.first + "has not the same datatype as " + valueMap.find(subsig.first)->first,
                        this->stmtLocationInfo);
            }
        }
    }
}

void DESCAM::ArrayExpr::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::ArrayExpr::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekArrayExpr(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ArrayExpr *) this;
    auto otherPtr = (const ArrayExpr *) &other;
    if (thisPtr->getDataType() != otherPtr->getDataType()) return false;
    return (thisPtr->valueMap == otherPtr->valueMap);
}

const std::map<std::string, DESCAM::Expr *> &DESCAM::ArrayExpr::getValueMap() const {
    return valueMap;
}

