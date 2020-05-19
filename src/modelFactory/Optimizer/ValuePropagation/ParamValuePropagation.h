//
// Created by M.I.Alkoudsi on 15.07.19.
//



#ifndef SCAM_PARAMVALUEPROPAGATION_H
#define SCAM_PARAMVALUEPROPAGATION_H


#include <map>
#include <set>
#include <utility>
#include <ModelGlobal.h>
#include <Expr.h>
#include <StmtAbstractVisitor.h>
#include "PrintStmt.h"


namespace SCAM {

   /***
   * \brief: Propagates parameters values from the parameter list to their use inside the body of the function
   * \author:mi-alkoudsi
   * \inputs:
   *       - std::map<std::string, SCAM::Expr *> paramValMap;
   *       - std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList;
   * \outputs:
   *       - std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> optimizedReturnValueConditionList;
   */

    class ParamValuePropagation : public StmtAbstractVisitor {

    public:

        //Constructors and Destructor
        ParamValuePropagation() = delete;

        ParamValuePropagation(
                              std::map<std::string, Expr *> paramValMap,
                              const std::map<std::string, Variable *> &globalVariableMap,
                              std::vector<std::pair<Return *, std::vector<Expr *>>> returnValueConditionList);

        ~ParamValuePropagation() = default;

        std::vector<std::pair<Return *, std::vector<Expr *>>> getReturnValueConditionList() const;

    private:
        std::map<std::string, Expr *> paramValMap;
        std::vector<std::pair<Return *, std::vector<Expr *>>> returnValueConditionList;
        std::map<std::string, Variable *> globalVariableMap;
        Expr *newExpr;

        //visitors
        void visit(struct VariableOperand &node) override;

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

        void visit(struct FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override;

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

        void visit(class TimePointOperand &node) override{};

        void visit(class Ternary &node) override;

    };
}


#endif //SCAM_PARAMVALUEPROPAGATION_H
