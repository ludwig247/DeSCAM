//
// Created by M.I.Alkoudsi on 14.08.19.
//

#ifndef SCAM_LOCALVALUEPROPAGATION_H
#define SCAM_LOCALVALUEPROPAGATION_H

#include <map>
#include <set>
#include "Behavior/CfgNode.h"
#include "Optimizer/Utilities/FindCfgPaths.h"
#include "PrintStmt.h"
#include "Optimizer/Utilities/PropagateConstantValue.h"
#include "Optimizer/Utilities/OptUtilities.h"

namespace SCAM {

    /***
     * @brief: checks the use of variables in each statement in the control flow graph and propagates the value to it
     * can exploit chances more than that of inside single block value propagation
     * relies on PropagateValue to safely propagate a value
     * @author:M.I.Alkoudsi
     */


    class LocalValuePropagation : public SCAM::StmtAbstractVisitor, FindCfgPaths {

    public:

        //Constructors and Destructor
        LocalValuePropagation() = delete;

        explicit LocalValuePropagation(const std::map<int, SCAM::CfgNode *> &CFG);

        ~LocalValuePropagation() = default;

        //Setters and Getters
        const std::map<int, SCAM::CfgNode *> &getCFG() const;

    private:
        bool propagationValid;
        int currentNodeID;
        int whileNodeID;
        Expr *newExpr;
        std::map<int, SCAM::CfgNode *> CFG;
        std::map<int, std::vector<SCAM::CfgNode *>> pathsToStmtMap;              //Stores the paths from while to the current statement
        std::map<std::string, SCAM::Expr *> varValMap;                           // keeps the value of a variable operand if already checked in the same statement
        std::set<std::string> varAlreadyCheckedSet;                              // keeps the name for each variable so PropagateValue won't be called if variable already checked

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


#endif //SCAM_LOCALVALUEPROPAGATION_H
