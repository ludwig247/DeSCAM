//
// Created by M.I.Alkoudsi on 14.07.19.
//

#ifndef SCAM_FUNCTIONSOPTIMIZER_H
#define SCAM_FUNCTIONSOPTIMIZER_H


#include <map>
#include <set>
#include <ModelGlobal.h>
#include <StmtAbstractVisitor.h>
#include "Behavior/CfgNode.h"
#include "Optimizer/ValuePropagation/ParamValuePropagation.h"
#include "Optimizer/ReachabilityAnalysis/ReachabilityAnalysis.h"
#include "Optimizer/SimplifyExpressions/SimplifyExpressions.h"
#include "Optimizer/OperatorStrengthReduction/OperatorStrengthReduction.h"
#include "Optimizer/Utilities/FindVariablesValues.h"

namespace SCAM {

    /***
     * \brief: Performs optimizations on functions inside the control flow graph(CFG)
     *
     * \author: mi-alkoudsi
     *
     * \input:
     *      - std::map<int, SCAM::CfgNode *> cfg;
     *      - SCAM::Module * module;
     *      - std::set<std::string> variablesThatHaveReadSet;
     * \output:
     *      - std::map<int, CfgNode *> optimizedCFG;
     *
     * \details: Performs the following optimizations on every function used inside a statement or another function:
     * Parameters value propagation
     * Operator strength reduction
     * Simplify expressions
     * Reachability analysis
     */

    class FunctionsOptimizer : public StmtAbstractVisitor {
    public:
        //Constructors and Destructor
        FunctionsOptimizer() = delete;

        FunctionsOptimizer(std::map<int, CfgNode *> CFG, SCAM::Module *module, const std::map<std::string, Variable *> &globalVariableMap ,
                           std::set<std::string> variablesThatHaveReadSet);

        ~FunctionsOptimizer() = default;

        //Setters and Getters
        const std::map<int, SCAM::CfgNode *> &getCFG() const;

    private:
        SCAM::Module *module;
        std::map<int, SCAM::CfgNode *> CFG;
        std::map<std::string, Variable *> globalVariableMap;
        bool hasFunction;
        SCAM::Stmt *newStmt;                                                     //used to propagate statements and the modified functionOperands
        SCAM::Expr *newExpr;
        std::map<std::string, std::set<SCAM::Expr *>> allVarValuesMap;          //Contains all possible values that all variable can take
        std::set<std::string> variablesThatHaveReadSet;                         //All variables that can't be optimized due to interprocedural behaviour
        std::map<std::string, int> functionUseMap;                              //keeps the number of times a function is used in the blockCFG, for naming purposes
        std::map<SCAM::FunctionOperand *, SCAM::Expr *> oldFuncOpOptimizedFuncPairsMap;   //Keeps a pointer to the optimized function to reuse an optimized function instead of creating a new one if paramter list is the same
        std::string createFuncName(std::string funcOpName);
        SCAM::Expr *
        isAlreadyOptimizedFunction(std::string operandName, const std::map<std::string, SCAM::Expr *> &paramValueMap);
        static bool noOptimizationAchieved(const std::vector<std::pair<Return *, std::vector<Expr *>>> &returnValConditionListPairVector1, std::vector<std::pair<Return *, std::vector<Expr *>>> &returnValConditionListPairVector2);
        //visitors
        void visit(class VariableOperand &node) override {};

        void visit(class IntegerValue &node) override {};

        void visit(class UnsignedValue &node) override {};

        void visit(class BoolValue &node) override {};

        void visit(class EnumValue &node) override {};

        void visit(class CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(class UnaryExpr &node) override;

        void visit(class While &node) override {};

        void visit(class If &node) override;

        void visit(class Read &node) override {};

        void visit(class Write &node) override;

        void visit(class SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(class ITE &node) override {};

        void visit(class Arithmetic &node) override;

        void visit(class Logical &node) override;

        void visit(class Relational &node) override;

        void visit(class Bitwise &node) override;

        void visit(class SyncSignal &node) override {};

        void visit(class DataSignalOperand &node) override {};

        void visit(class Cast &node) override;

        void visit(SCAM::FunctionOperand &node) override;

        void visit(class ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override {};

        void visit(class Return &node) override {};

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

    };
}

#endif //SCAM_FUNCTIONSOPTIMIZER_H