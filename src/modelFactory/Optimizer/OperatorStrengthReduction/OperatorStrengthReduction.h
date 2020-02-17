//
// Created by M.I.Alkoudsi on 04.09.19.
//


#ifndef SCAM_OPERATORSTRENGTHREDUCTION_H
#define SCAM_OPERATORSTRENGTHREDUCTION_H

#include <map>
#include <Expr.h>
#include <cmath>
#include <utility>
#include "Behavior/CfgNode.h"
#include "StmtAbstractVisitor.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"


namespace SCAM {

    /***
      * \brief: Transforms heavy operations such as multiplications,divisions into simpler operations such as shifts and additions, if possible.
      *
      * \author: mi-alkoudsi
      *
      * \details:
      *      example: the following statements are converted using OperatorStrengthReduction as follows:
      *        x = y * 4 => x = y << 2
      *        x = y * 3 => x = (y << 2) - y
      *        x = y / 8 => x = (Y >> 3)
      *        x = y % 16 => x = y & 15
      */

    class OperatorStrengthReduction : public StmtAbstractVisitor {

    public:
        //Constructors and Destructor
        OperatorStrengthReduction() = delete;

        explicit OperatorStrengthReduction(std::map<int, CfgNode *> CFG);

        explicit OperatorStrengthReduction(
                std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList);

        ~OperatorStrengthReduction() = default;

        const std::map<int, CfgNode *> &getCFG() const;

        const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &getReturnValueConditionList() const;


    private:
        template<class T>
        static bool isPowerOfTwo(T num);

        bool isCFGOptimizer;                                    //true when the constructor has blockCFG as an argument
        std::map<int, CfgNode *> CFG;
        bool hasReduction;
        std::map<std::string, SCAM::Expr *> paramValMap;
        std::pair<std::string, SCAM::Expr *> param;
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList;
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> tempList;
        SCAM::Expr *newExpr;
        SCAM::Stmt *newStmt{};

        //visitors
        void visit(struct VariableOperand &node) override {};

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

        void visit(class TimePointOperand &node) override {};

    };
}

#endif //SCAM_OPERATORSTRENGTHREDUCTION_H
