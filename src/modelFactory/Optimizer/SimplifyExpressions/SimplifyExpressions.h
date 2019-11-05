//
// Created by M.I.Alkoudsi on 05.08.19.
//


#ifndef SCAM_SIMPLIFYEXPRESSIONS_H
#define SCAM_SIMPLIFYEXPRESSIONS_H


#include "z3++.h"
#include "StmtAbstractVisitor.h"
#include "Behavior/CfgNode.h"
#include "ExprTranslator.h"
#include <utility>
#include <Optimizer/Utilities/OptUtilities.h>

namespace SCAM {

    /***
    * @brief: simplifies DeSCAM expressions in the CFG or Functions using Z3++ Solver.
    * e.g.: 3+2 becomes 5
    *
    */

    class SimplifyExpressions : public StmtAbstractVisitor {
    public:
        SimplifyExpressions() = delete;

        SimplifyExpressions(std::map<int, CfgNode *> CFG, SCAM::Module *module);

        SimplifyExpressions(std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList,
                            SCAM::Module *module);

        ~SimplifyExpressions() = default;

        const std::map<int, CfgNode *> &getCFG() const;

        const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &getReturnValueConditionList() const;

    private:
        std::map<int, CfgNode *> CFG;
        SCAM::Module *module;
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList;
        SCAM::Expr *newExpr;
        SCAM::Stmt *newStmt;

        void translateExpression(SCAM::Expr *);


        //visitors
        void visit(struct VariableOperand &node) override {};

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override {};

        void visit(struct While &node) override {};

        void visit(struct If &node) override;

        void visit(struct Read &node) override {};

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override {};

        void visit(struct Arithmetic &node) override {};

        void visit(struct Logical &node) override {};

        void visit(struct Relational &node) override {};

        void visit(struct Bitwise &node) override {};

        void visit(struct SyncSignal &node) override {};

        void visit(struct DataSignalOperand &node) override {};

        void visit(struct Cast &node) override {};

        void visit(struct SCAM::FunctionOperand &node) override {};

        void visit(struct ArrayOperand &node) override {};

        void visit(class CompoundExpr &node) override {};

        void visit(class ArrayExpr &node) override {};

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

    };

}

#endif //SCAM_SIMPLIFYEXPRESSIONS_H