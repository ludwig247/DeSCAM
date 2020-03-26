//
// Created by M.I.Alkoudsi on 17.09.19.
//

#ifndef SCAM_RANGEANDBITWIDTHANALYSIS_H
#define SCAM_RANGEANDBITWIDTHANALYSIS_H


#include "Behavior/CfgNode.h"
#include "NodePeekVisitor.h"
#include "PrintStmt.h"
#include "Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h"
#include "ModelGlobal.h"
#include "VariablesRangeAnalysis.h"
#include "Optimizer/Utilities/FindVariablesValues.h"
#include <GlobalUtilities.h>
#include <ctgmath>
#include <utility>

#include <set>

namespace SCAM {
    /***
        * \brief: Analyzes variables and output ports bitwidth
        * \author: mi-alkoudsi
        * \inputs:
        *       - SCAM::Module *module
        * \outputs:
        *       - std::map<std::string, int> variablesBitwidthMap
        *       - std::map<SCAM::Port, int> outputPortsBitwidthMap
        */
    class RangeAndBitWidthAnalysis : public StmtAbstractVisitor {
    public:
        RangeAndBitWidthAnalysis() = delete;

        explicit RangeAndBitWidthAnalysis(SCAM::Module *module);

        ~RangeAndBitWidthAnalysis() = default;

        const std::map<std::string, int> &getVariableBitWidthMap() const;

        const std::map<SCAM::Port *, int> &getPortsBitWidthMap() const;

    private:
        SCAM::Module *module;
        std::map<int, SCAM::CfgNode *> CFG;
        std::set<std::string> variablesThatHaveReadSet;
        std::map<std::string, std::set<SCAM::Expr *>> variablesValuesMap;
        std::map<std::string, int> variableBitWidthMap;
        std::map<SCAM::Port *, int> writePortBitWidthMap;
        std::map<std::string, std::string> nameFullNameMap;
        int propagatedBitWidth;
        void initializeBitWidthMap();


        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override;

        void visit(struct UnsignedValue &node) override;

        void visit(struct BoolValue &node) override;

        void visit(struct EnumValue &node) override;

        void visit(struct CompoundValue &node) override;

        void visit(class PortOperand &node) override{};

        void visit(class Assignment &node) override{};

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override{};

        void visit(struct If &node) override{};

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

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

        void visit(class TimePointOperand &node) override{};
    };
}


#endif //SCAM_RANGEANDBITWIDTHANALYSIS_H
