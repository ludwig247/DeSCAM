//
// Created by tobias on 30.10.19.
//

#ifndef SCAM_ARRAYEXPR_H
#define SCAM_ARRAYEXPR_H


#include <map>
#include "Expr.h"

namespace DESCAM {

    class ArrayExpr : public Expr {
    public:
        ArrayExpr() = delete;
        ArrayExpr(std::map<std::string, DESCAM::Expr *> valueMap, const DataType *dataType, LocationInfo stmtLocationInfo = LocationInfo());
        virtual ~ArrayExpr() = default;


        const std::map<std::string, DESCAM::Expr *> &getValueMap() const;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:

        std::map<std::string, DESCAM::Expr *> valueMap; //! <index,value>
    };
};


#endif //SCAM_ARRAYEXPR_H
