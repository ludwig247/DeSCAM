//
// Created by johannes on 12.08.19.
//

#ifndef SCAM_PRINTOPERATIONS_H
#define SCAM_PRINTOPERATIONS_H

#include <memory>

#include "PrintStmt.h"
#include "Utilities.h"

namespace SCAM { namespace HLSPlugin { namespace HLS {

        struct Node {
            StmtType type = StmtType::UNKNOWN;
            SubTypeBitwise subType = SubTypeBitwise::UNKNOWN;
            uint32_t value;
            uint32_t firstBit;
            uint32_t lastBit;
            std::string name;
            std::vector<std::shared_ptr<Node>> child;
        };

        class PrintBitOperations : public StmtAbstractVisitor {

        public:
            PrintBitOperations(Stmt *stmt, HLS::HLSOption hlsOption);

            bool isSlicingOp();
            std::string getOpAsString();
            uint32_t getRangeAsValue();

        private:
            std::shared_ptr<Node> actualNode;
            uint32_t rangeValue;
            HLS::HLSOption hlsOption;

            bool slicing(Node *node);
            bool sliceWithShift(Node *node);
            bool sliceWithoutShift(Node *node);
            bool shiftWithConstant(Node *node);

            std::string getString(Node *node);
            bool getRange(uint32_t number, uint32_t &firstBit, uint32_t &lastBit);

            void visit(Arithmetic &node) override;
            void visit(VariableOperand &node) override;
            void visit(DataSignalOperand &node) override;
            void visit(SyncSignal &node) override {};
            void visit(EnumValue &node) override {};
            void visit(Relational &node) override;
            void visit(UnaryExpr &node) override;
            void visit(IntegerValue &node) override;
            void visit(UnsignedValue &node) override;
            void visit(Logical &node) override;
            void visit(FunctionOperand &node) override {};
            void visit(CompoundExpr &node) override {};
            void visit(BoolValue &node) override {};
            void visit(CompoundValue &node) override {};
            void visit(PortOperand &node) override {};
            void visit(Assignment &node) override;
            void visit(While &node) override {};
            void visit(If &node) override {};
            void visit(SectionOperand &node) override {};
            void visit(SectionValue &node) override {};
            void visit(ITE &node) override {};
            void visit(Bitwise &node) override;
            void visit(Read &node) override {};
            void visit(Write &node) override {};
            void visit(Cast &node) override {};
            void visit(ArrayOperand &node) override;
            void visit(ParamOperand &node) override;
            void visit(Return &node) override {};
            void visit(Notify &node) override {};
            void visit(Wait &node) override {};
            void visit(Peek &node) override {};
            void visit(ArrayExpr &node) override {};
            void visit(TimePointOperand &node) override {};
        };

        class BitConcatenation {

        public:
            explicit BitConcatenation(Bitwise *node, HLS::HLSOption hlsOption);

            bool isBitConcatenationOp();
            std::string getOpAsString();

        private:
            using slicing_ops = std::vector<std::unique_ptr<PrintBitOperations>>;

            Bitwise *bitwiseNode;
            slicing_ops bitSlicingOps;
            uint32_t constValue;
            std::string opAsString;
            HLS::HLSOption hlsOption;

            uint32_t getConstValue(Expr *node);
            bool evaluateOps(Bitwise *node);
            bool isConstValue(Expr *node);
            void getBitConcatenationOp(Bitwise *node);
            void setOpAsString();
        };

}}}

#endif //SCAM_PRINTOPERATIONS_H
