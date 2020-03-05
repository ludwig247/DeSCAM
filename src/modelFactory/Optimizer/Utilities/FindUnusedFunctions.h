//
// Created by M.I.Alkoudsi on 29.08.19.
//
#ifndef SCAM_FINDUNUSEDFUNCTIONS_H
#define SCAM_FINDUNUSEDFUNCTIONS_H

#include <CfgBlock.h>
#include "ExprVisitor.h"
#include "NodePeekVisitor.h"
#include <algorithm>
#include <Stmts/Expr.h>
#include <set>
#include <Module.h>
#include <utility>

namespace SCAM {

/***
 * \brief: Finds Unused functions in the CFG, prompts a warning for each of them, then delete them from the module
 * \author:mi-lkoudsi
 */

    class FindUnusedFunctions : public SCAM::StmtAbstractVisitor {

    public:
        FindUnusedFunctions() = delete;

        FindUnusedFunctions(const std::map<int, SCAM::CfgBlock *> &CFG, SCAM::Module* module);

        FindUnusedFunctions(const std::map<int, SCAM::CfgNode *> &CFG, SCAM::Module* module);

        ~FindUnusedFunctions() = default;

    private:
        std::map<int, SCAM::CfgBlock *> blockCFG;
        std::map<int, SCAM::CfgNode *> nodeCFG;
        SCAM::Module* module;
        std::set<std::string> usedFunctionsSet;
        std::set<std::string> unusedFunctionSet;


        //visitors
        void visit(struct VariableOperand &node) override{};

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

        void visit(struct Write &node) override;

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

        void visit(struct SCAM::FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override{};

        void visit(class Return &node) override;

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

        void visit(class TimePointOperand &node) override{};
    };
}
#endif //SCAM_FINDUNUSEDFUNCTIONS_H
