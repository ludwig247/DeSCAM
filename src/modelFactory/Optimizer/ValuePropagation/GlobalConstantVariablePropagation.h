//
// Created by mi-alkoudsi on 09.12.19.
//

#ifndef DESCAM_GLOBALCONSTANTVARIABLEPROPAGATION_H
#define DESCAM_GLOBALCONSTANTVARIABLEPROPAGATION_H

#include <map>
#include <set>
#include <utility>
#include <PrintStmt.h>
#include "Behavior/CfgNode.h"
#include "Optimizer/Utilities/FindCfgPaths.h"
#include "Optimizer/Utilities/PropagateConstantValue.h"


namespace SCAM {

    /***
     * \brief: Propagates the initial value of constant global variables
     * \author:mi-alkoudsi
     * \inputs:
     *       - std::map<int, CfgNode *> CFG;
     *       - std::map<std::string, Variable*> globalVariableMap;
     * \outputs:
     *      - std::map<int, CfgNode *> optimizedCFG;
     * \details: Checks the use of global variables in each statement in the CFG,
     * substitutes each use with the initial value of the global variable
     *
     */


    class GlobalConstantVariablePropagation : public SCAM::StmtAbstractVisitor {

    public:
        GlobalConstantVariablePropagation() = delete;

        GlobalConstantVariablePropagation(const std::map<int, SCAM::CfgNode *> &CFG, const std::map<std::string, Variable*>& globalVariableMap);

        ~GlobalConstantVariablePropagation() = default;

        const std::map<int, SCAM::CfgNode *> &getCFG() const;

    private:
        int currentNodeId;
        Expr *newExpr;
        std::map<int, SCAM::CfgNode *> CFG;
        std::map<std::string, Variable*> globalVariableMap;

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override;

        void visit(struct If &node) override;

        void visit(struct Read &node) override {};

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override {};

        void visit(struct Arithmetic &node) override;

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override;

        void visit(struct Bitwise &node) override;

        void visit(struct SyncSignal &node) override {};

        void visit(struct DataSignalOperand &node) override {};

        void visit(struct Cast &node) override;

        void visit(struct SCAM::FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};
    };
}

#endif //DESCAM_GLOBALCONSTANTVARIABLEPROPAGATION_H
