//
// Created by M.I.Alkoudsi on 10.09.19.
//

#ifndef SCAM_SUBSTITUTEFUNCTIONSWITHRETURNVALUES_H
#define SCAM_SUBSTITUTEFUNCTIONSWITHRETURNVALUES_H


#include "PrintStmt.h"
#include "Behavior/CfgNode.h"
#include "Optimizer/Utilities/FindVariablesAndFunctionsInStatement.h"
#include "Optimizer/Utilities/ExpressionSubstitution.h"
#include <stack>
#include <set>


namespace SCAM {
    /***
        * \brief: Replaces the use of a function inside an expression with its all possible return values and stores the result in a map
        * \author:mi-alkoudsi
        * \inputs:
        *       - std::map<std::string, std::set<SCAM::Expr *>> variablesValuesMap;
        * \outputs:
        *       - std::map<std::string, std::set<SCAM::Expr *>> newVariablesValuesMap;
        * \details: Replaces every function inside values in the variablesValuesMap with their returned values.
        * If any of a function' x return values rx uses a function y, y is also substituted with its return values in rx.
        * This creates a number of return values that replace rx in function x inside the newVariableValuesMap.
        */

    class SubstituteFunctionsWithReturnValues : public StmtAbstractVisitor {
    public:
        SubstituteFunctionsWithReturnValues() = delete;
        explicit SubstituteFunctionsWithReturnValues(const std::map<std::string, std::set<SCAM::Expr*>>& variablesValuesMap);
        ~SubstituteFunctionsWithReturnValues() = default;
        const std::map<std::string, std::set<SCAM::Expr*>> &getNewVariableValuesMap() const;
        const std::set<std::string>&  getVariablesWithRecrusiveFunctions() const;
    private:
        bool functionHasRecursion;
        std::map<SCAM::Expr*,std::vector<SCAM::Expr*>> functionReturnsSubstitutionMap;
        std::map<std::string, std::set<SCAM::Expr*>> variableValuesOfReturnsMap;
        std::map<std::string, std::set<SCAM::Expr*>> newVariablesValuesMap;
        std::set<std::string> variablesWithRecrusiveFunctions;
        static std::set<SCAM::Expr *> substituteFunctionsWithTheirReturns(SCAM::Expr* toBeSubstitutedExpr, const std::map<SCAM::Expr*,std::vector<SCAM::Expr*>>& functionReturnsSubstitutionMap);
        std::set<SCAM::Expr *>  substituteReturnValuesOfNestedFunctions(SCAM::Expr* returnValWithFunctions,const std::map<std::string, FunctionOperand *>& functionsInStmtMap);
        static void addValToFunctionReturnsSubstitutionMap(SCAM::Expr* functionOp, SCAM::Expr* returnVal,  std::map<SCAM::Expr*,std::vector<SCAM::Expr*>>& functionReturnsSubstitutionMap);
        void addValToVarValMap(const std::string& varName, SCAM::Expr * expr);


        //visitors
        void visit(struct VariableOperand &node) override{};

        void visit(struct TimePointOperand &node) override{};

        void visit(struct IntegerValue &node) override{};

        void visit(struct UnsignedValue &node) override{};

        void visit(struct BoolValue &node) override{};

        void visit(struct EnumValue &node) override{};

        void visit(struct CompoundValue &node) override{};

        void visit(class PortOperand &node) override{};

        void visit(class Assignment &node) override{};

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override{};

        void visit(struct If &node) override{};

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

        void visit(struct SCAM::FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override{};

        void visit(class ArrayExpr &node) override{};

        void visit(class ParamOperand &node) override{};

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};
    };
}

#endif //SCAM_SUBSTITUTEFUNCTIONSWITHRETURNVALUES_H
