//
// Created by M.I.Alkoudsi on 10.09.19.
//


#ifndef SCAM_FINDVARIABLESVALUESINRELATIONALEXPRESSIONS_H
#define SCAM_FINDVARIABLESVALUESINRELATIONALEXPRESSIONS_H

#include "Behavior/CfgNode.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h"
#include <set>


namespace SCAM {
    /***
        * \brief: collects the values compared to variables values in relational expressions of If statements
        * \author:mi-alkoudsi
        * \inputs:
        *       - std::map<int, SCAM::CfgNode *> CFG;
        * \outputs:
        *       - std::map<std::string, std::set<SCAM::Expr *>> variableValuesFromRelationalExpressionsMap;
        *       - std::set<std::string> difficultToAnalyseVariablesSet;
        */
    class FindVariablesValuesInRelationalExpressions : public StmtAbstractVisitor {
    public:
        FindVariablesValuesInRelationalExpressions() = delete;

        explicit FindVariablesValuesInRelationalExpressions(const std::map<int, CfgNode *> &CFG);

        ~FindVariablesValuesInRelationalExpressions() = default;

        const std::map<std::string, std::set<Expr *>> &getVariableValuesFromRelationalExpressionsMap() const;

        const std::set<std::string> &getDifficultToAnalyseVariablesSet() const;

    private:
        void addValToVarValMap(std::string varName, Expr *expr);

        std::map<int, CfgNode *> CFG;
        std::map<std::string, std::set<Expr *>> variableValuesFromRelationalExpressionsMap;
        std::set<std::string> difficultToAnalyseVariablesSet;

        //visitors
        void visit(struct VariableOperand &node) override{};

        void visit(struct TimePointOperand &node) override{};

        void visit(struct IntegerValue &node) override{};

        void visit(struct UnsignedValue &node) override{};

        void visit(struct BoolValue &node) override{};

        void visit(struct EnumValue &node) override{};

        void visit(struct CompoundValue &node) override{};

        void visit(class PortOperand &node) override{};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override{};

        void visit(struct If &node) override;

        void visit(struct Read &node) override{};

        void visit(struct Write &node) override{};

        void visit(struct SectionOperand &node) override{};

        void visit(class SectionValue &node) override{};

        void visit(struct ITE &node) override{};

        void visit(struct Arithmetic &node) override;

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override;

        void visit(struct Bitwise &node) override;

        void visit(struct SyncSignal &node) override{};

        void visit(struct DataSignalOperand &node) override{};

        void visit(struct Cast &node) override;

        void visit(struct FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override{};

        void visit(class CompoundExpr &node) override{};

        void visit(class ArrayExpr &node) override{};

        void visit(class ParamOperand &node) override{};

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

        void visit(class Ternary &node) override;
    };
}

#endif //SCAM_FINDVARIABLESVALUESINRELATIONALEXPRESSIONS_H
