//
// Created by ludwig on 02.11.16.
//

#ifndef SCAM_WRITE_H
#define SCAM_WRITE_H

#include "Stmt.h"
#include "PortOperand.h"
#include "Communication.h"

namespace SCAM {
    class Write : public Communication, public Stmt {
    public:
        Write(Port *portOperand, Expr *value, bool is_non_blocking_access = false, VariableOperand *status = nullptr);

        Expr *getValue() const;

        VariableOperand *getStatusOperand() const;

        bool hasStatusOperand() const;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual std::ostream &print(std::ostream &ostream) const;

        virtual bool operator==(const Stmt &other) const;

        // Serialization
        friend class Serializer;

    private:
        Expr *value = nullptr;
        VariableOperand *status = nullptr;

    };

}
#endif //SCAM_WRITE_H



