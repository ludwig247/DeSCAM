//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FUNCTIONOPERAND_H
#define PROJECT_FUNCTIONOPERAND_H

#include "Function.h"
#include "Operand.h"

namespace DESCAM {
    class FunctionOperand : public Operand {
    public:
        explicit FunctionOperand(Function *function, const std::map<std::string, DESCAM::Expr *> &paramValueMap, LocationInfo stmtLocationInfo = LocationInfo());
        FunctionOperand(FunctionOperand&) = delete;
        FunctionOperand() = delete;
        virtual ~FunctionOperand() = default;

        virtual std::string getOperandName() const;

        Function *getFunction() const;

        const std::map<std::string, Expr *> &getParamValueMap() const;

        void setParamValueMap(const std::map<std::string, DESCAM::Expr *> &paramValueMap);

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        std::map<std::string, DESCAM::Expr *> paramValueMap;
        Function *function;
    };
}


#endif //PROJECT_FUNCTIONOPERAND_H
