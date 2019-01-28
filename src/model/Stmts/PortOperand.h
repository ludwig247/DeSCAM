//
// Created by ludwig on 03.11.15.
//

#ifndef SCAM_PORTOPERATOR_H
#define SCAM_PORTOPERATOR_H

#include "Operand.h"
#include "Port.h"

namespace SCAM{
    /**
     * \brief Points to a port of the moodule
     */
    class PortOperand : public SCAM::Operand {
    public:
        PortOperand(Port* port);

        Port* getPort();

        virtual std::string getOperandName() const;
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Port* port;

    };
}



#endif //SCAM_PORTOPERATOR_H
