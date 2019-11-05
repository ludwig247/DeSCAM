//
// Created by M.I.Alkoudsi on 12.09.19.
//

#ifndef SCAM_ANALYZECOUNTERVARIABLES_H
#define SCAM_ANALYZECOUNTERVARIABLES_H


#include <set>
#include "Behavior/CfgNode.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h"
#include "Optimizer/Utilities/DetectCounterVariable.h"
#include <utility>

namespace SCAM {
    /***
        * @brief: analyzes counter variables values margins
        *
        * @author:M.I.Alkoudsi
        */
    class AnalyzeCounterVariables : public StmtAbstractVisitor {
    public:
        AnalyzeCounterVariables() = delete;

        AnalyzeCounterVariables(std::set<std::string> counterVariablesSet,
                                std::map<int, SCAM::CfgNode *> CFG);

        ~AnalyzeCounterVariables() = default;

        const std::map<std::string, std::string> &getMarginalValuesMap();

    private:
        std::map<int, SCAM::CfgNode *> CFG;
        std::set<std::string> counterVariablesSet;
        std::string currentCounterVariable;
        std::set<std::string> counterVariablesInIfStmt;
        bool counterVariableIncrements;
        bool hardToAnalyzeCounterVariable;
        enum class MarginValue {
            limited, intRange, unsignedRange
        };
        MarginValue marginValue;
        std::map<std::string, std::string> marginalValuesMap;

        void addToMarginalValuesMap(std::string varName);

        //visitors
        void visit(struct VariableOperand &node) override {};

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override {};

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override {};

        void visit(struct If &node) override;

        void visit(struct Read &node) override {};

        void visit(struct Write &node) override {};

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override {};

        void visit(struct Arithmetic &node) override {};

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override;

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


#endif //SCAM_ANALYZECOUNTERVARIABLES_H
