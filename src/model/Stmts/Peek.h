//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/11/19.
//

#ifndef SCAM_PEEK_H
#define SCAM_PEEK_H

//#include "Expr.h"
//#include "PortOperand.h"
#include "Communication.h"
#include "PortOperand.h"

namespace SCAM {

    class Peek : public Expr, public Communication {
    public:
        explicit Peek(SCAM::Port *port, LocationInfo stmtLocationInfo = LocationInfo());

        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    };

}
#endif //SCAM_PEEK_H
