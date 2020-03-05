//
// Created by M.I.Alkoudsi on 10.09.19.
//

#ifndef SCAM_FINDVARIABLESANDFUNCTIONSINSTATEMENT_H
#define SCAM_FINDVARIABLESANDFUNCTIONSINSTATEMENT_H


#include "Behavior/CfgNode.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "FindVariablesAndFunctionsInStatement.h"
#include <set>


namespace SCAM {
    /***
    * \brief: Finds the variables and functions used in a statement or an expression
    * \author:mi-alkoudsi
    */
    class FindVariablesAndFunctionsInStatement : public StmtAbstractVisitor {
    public:
        FindVariablesAndFunctionsInStatement() = delete;

        FindVariablesAndFunctionsInStatement(SCAM::Expr *expr, const std::set<std::string>& readVariablesSet);

        FindVariablesAndFunctionsInStatement(SCAM::Stmt *stmt, const std::set<std::string>& readVariablesSet);

        ~FindVariablesAndFunctionsInStatement() = default;

        const std::set<std::string> &getVariablesInStmtSet() const;

        const std::set<SCAM::VariableOperand *> &getVarOpInStmtSet() const;

        bool hasFunctions();

        const std::map<std::string, SCAM::FunctionOperand *> &getFunctionsInStmtMap() const;

        bool hasReadVariable();

    private:
        bool hasFunction;
        bool hasReadVariables;
        bool isVariableFromFunctionParameters;
        bool isVariableFromFunctionBody;
        std::set<std::string> variablesInStmtSet;
        std::map<std::string, SCAM::FunctionOperand *> functionsInStmtMap;
        std::set<SCAM::VariableOperand *> varOpInStmtSet;
        std::set<std::string> readVariablesSet;

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct TimePointOperand &node) override {};

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

        void visit(struct Read &node) override;

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

#endif //SCAM_FINDVARIABLESANDFUNCTIONSINSTATEMENT_H
