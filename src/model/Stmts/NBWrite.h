//
// Created by ludwig on 03.11.16.
//

#ifndef SCAM_NBWRITE_H
#define SCAM_NBWRITE_H

#include "Expr.h"
#include "PortOperand.h"
#include "Communication.h"

namespace SCAM{
    class NBWrite: public Communication, public Expr {
    public:
        NBWrite(Port *port, Expr *value);

        Expr *getValue() const;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual bool operator==(const Stmt &other) const;

    private:
        Expr * value;
    };
}




#endif //SCAM_NBWRITE_H
