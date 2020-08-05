//
// Created by ludwig on 18.07.18.
//

#ifndef PROJECT_COMPOUNDEXPR_H
#define PROJECT_COMPOUNDEXPR_H

#include <string>
#include "Expr.h"

namespace DESCAM {
    class CompoundExpr : public Expr {
    public:
        CompoundExpr(std::map<std::string, DESCAM::Expr *> valueMap, const DataType *dataType, LocationInfo stmtLocationInfo = LocationInfo());

        virtual ~CompoundExpr();

        const std::map<std::string, Expr *> &getValueMap() const;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        std::map<std::string, DESCAM::Expr *> valueMap;
    };


}


#endif //PROJECT_COMPOUNDEXPR_H
