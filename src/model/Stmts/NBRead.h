//
// Created by ludwig on 03.11.16.
//

#ifndef SCAM_NBREAD_H
#define SCAM_NBREAD_H

#include <Variable.h>
#include "Expr.h"
#include "PortOperand.h"
#include "VariableOperand.h"
#include "Communication.h"

namespace SCAM{

class NBRead: public Communication, public Expr {
public:
    NBRead(Port *port, VariableOperand *variable);

    VariableOperand *getVariableOperand() const;

    virtual void accept(StmtAbstractVisitor &visitor) override;


        virtual bool operator==(const Stmt &other) const;


private:
    VariableOperand * variable;
};

}

#endif //SCAM_NBREAD_H
