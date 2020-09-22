//
// Created by tobias on 19.07.18.
//

#ifndef PROJECT_RETURN_H
#define PROJECT_RETURN_H

#include "Expr.h"

namespace DESCAM {
    class Return : public Stmt {
    public:
        Return() = delete;

        explicit Return(Expr *returnValue, LocationInfo stmtLocationInfo = LocationInfo());

        virtual ~Return() = default;

        Expr *getReturnValue() const;

        void setReturnValue(Expr *returnValue);

        void accept(StmtAbstractVisitor &visitor) override;

        std::ostream &print(std::ostream &ostream) const override;

        bool operator==(const Stmt &other) const override;

    private:


        Expr *returnValue;
    };
}


#endif //PROJECT_RETURN_H
