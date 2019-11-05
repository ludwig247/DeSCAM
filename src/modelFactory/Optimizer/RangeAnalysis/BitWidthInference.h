//
// Created by M.I.Alkoudsi on 08.08.19.
//

#ifndef SCAM_BITWIDTHINFERENCE_H
#define SCAM_BITWIDTHINFERENCE_H

#include <set>
#include "Behavior/CfgNode.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include <bitset>
#include <utility>
#include "algorithm"

namespace SCAM {
    /***
        * @brief: searches the CFG for bitwise operations in assignments, and performs operations
        *
        * to find a possible deduction of a variable bit width instead of the normal 32bit assignment
        *
        * @author:M.I.Alkoudsi
        */
    class BitWidthInference : public StmtAbstractVisitor {
    public:
        BitWidthInference() = delete;

        BitWidthInference(std::map<int, SCAM::CfgNode *> CFG,
                          std::set<std::string> variablesThatHaveReadSet);

        ~BitWidthInference() = default;

        const std::map<std::string, int> &getVariableBitWidthMap() const;

    private:
        int currentNodeID;
        int newBitWidth;
        std::map<int, SCAM::CfgNode *> CFG;
        std::map<std::string, int> variableBitWidthMap;
        std::set<std::string> variablesThatHaveReadSet;                 // all variables that can't be optimized due to interprocedural behaviour

        //visitors
        void visit(struct VariableOperand &node) override{};

        void visit(struct IntegerValue &node) override;

        void visit(struct UnsignedValue &node) override;

        void visit(struct BoolValue &node) override;

        void visit(struct EnumValue &node) override{};

        void visit(struct CompoundValue &node) override;

        void visit(class PortOperand &node) override{};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override{};

        void visit(struct If &node) override{};

        void visit(struct Read &node) override;

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override{};

        void visit(class SectionValue &node) override{};

        void visit(struct ITE &node) override{};

        void visit(struct Arithmetic &node) override;

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override{};

        void visit(struct Bitwise &node) override;

        void visit(struct SyncSignal &node) override{};

        void visit(struct DataSignalOperand &node) override{};

        void visit(struct Cast &node) override{};

        void visit(struct SCAM::FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override{};

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

    };
}


#endif //SCAM_BITWIDTHINFERENCE_H
