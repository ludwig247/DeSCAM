//
// Created by M.I.Alkoudsi on 17.08.19.
//

#ifndef SCAM_DETECTCOUNTERVARIABLE_H
#define SCAM_DETECTCOUNTERVARIABLE_H

#include <Expr.h>
#include <StmtAbstractVisitor.h>
#include "NodePeekVisitor.h"
#include "ExprVisitor.h"
#include <utility>

namespace SCAM {

    /***
     * @brief: checks if a variable is in a counter assignment form and whether its value increments or decrements
     *  for e.g. x = x + 1 => x is a counter variable in an assignment that increments its value
     * @author:M.I.Alkoudsi
     *
     */
    class DetectCounterVariable : public StmtAbstractVisitor {

    public:

        //Constructors and Destructor
        DetectCounterVariable() = delete;

        DetectCounterVariable(std::string variableName, SCAM::Expr *expr);

        ~DetectCounterVariable() = default;

        bool isCounterVariable() const;

        bool isIncrementKnown() const;

        bool isVariableIncrements() const;

    private:
        bool variableIncrementsChanged;
        bool variableIncrements;
        bool incrementKnown;
        bool isCounter;
        std::string variableName;
        SCAM::Expr *expr;

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override {};

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override {};

        void visit(struct If &node) override {};

        void visit(struct Read &node) override {};

        void visit(struct Write &node) override {};

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

        void visit(class ParamOperand &node) override;

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

    };
}

#endif //SCAM_DETECTCOUNTERVARIABLE_H
