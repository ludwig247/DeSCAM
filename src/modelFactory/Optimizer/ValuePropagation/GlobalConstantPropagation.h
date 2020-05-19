//
// Created by M.I.Alkoudsi on 16.05.19.
//

#ifndef SCAM_GLOBALCONSTANTPROPAGATION_H
#define SCAM_GLOBALCONSTANTPROPAGATION_H

#include <map>
#include <set>
#include <utility>
#include <PrintStmt.h>
#include "Behavior/CfgNode.h"
#include "Optimizer/Utilities/FindCfgPaths.h"
#include "Optimizer/Utilities/PropagateConstantValue.h"


namespace DESCAM {

    /***
     * \brief: Propagates the value of globally constant variables
     * \author:mi-alkoudsi
     * \inputs:
     *       - std::map<int, CfgNode *> CFG;
     *       - FindCfgPaths findCfgPaths;
     *       - std::set<std::string> variablesThatHaveReadSet;
     * \outputs:
     *      - std::map<int, CfgNode *> optimizedCFG;
     * \details: Checks the use of variables in each statement in the CFG
     * and propagates the value to it if and only if the variable turns out to be globally constant
     * Uses PropagateValue to safely propagate a value
     */


    class GlobalConstantPropagation : public StmtAbstractVisitor, FindCfgPaths {

    public:
        GlobalConstantPropagation() = delete;

        GlobalConstantPropagation(const std::map<int, CfgNode *> &CFG, const FindCfgPaths &findCfgPaths,
                                  std::set<std::string> variablesThatHaveReadSet);

        ~GlobalConstantPropagation() = default;

        const std::map<int, CfgNode *> &getCFG() const;

    private:
        bool propagationValid;                                                  //indicates that there is a valid propagated value when it's true
        int currentNodeID;                                                      //refers to the node currently being processed
        Expr *newExpr;
        std::map<int, CfgNode *> CFG;
        std::set<std::string> variablesThatHaveReadSet;
        std::set<std::string> varAlreadyCheckedSet;                              // keeps the name for each variable so PropagateValue won't be called if variable already checked
        std::map<std::string, Expr *> varValMap;                           // keeps the value of a variable operand if already checked

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

        void visit(struct While &node) override {};

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

        void visit(struct FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

        void visit(class TimePointOperand &node) override {};

        void visit(class Ternary &node) override;
    };
}
#endif //SCAM_GLOBALCONSTANTPROPAGATION_H