//
// Created by tobias on 16.08.17.
//

#ifndef PROJECT_DATASIGNALOPERAND_H
#define PROJECT_DATASIGNALOPERAND_H


#include <DataSignal.h>
#include "VariableOperand.h"

namespace SCAM{
    class DataSignalOperand: public Operand {
    public:
        DataSignalOperand(DataSignal * dataSignal);

        DataSignal *getDataSignal() const;

        virtual std::string getOperandName() const;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        DataSignal * dataSignal;
    };
}



#endif //PROJECT_DATASIGNALOPERAND_H
