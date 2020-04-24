//
// Created by ludwig on 02.11.16.
//

#ifndef SCAM_READ_H
#define SCAM_READ_H

#include "PortOperand.h"
#include "VariableOperand.h"
#include "Communication.h"

namespace SCAM {


    class Read : public Stmt, public Communication {
    public:
        Read(Port *port, VariableOperand *variable, bool is_non_blocking_access = false, VariableOperand *status = nullptr, StmtLocationInfo stmtLocationInfo = StmtLocationInfo());

        VariableOperand *getVariableOperand() const;

        VariableOperand *getStatusOperand() const;

        bool hasStatusOperand() const;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual std::ostream &print(std::ostream &ostream) const;

        virtual bool operator==(const Stmt &other) const;



    private:
        VariableOperand *variable;
        VariableOperand *status;

    };

}

#endif //SCAM_READ_H
