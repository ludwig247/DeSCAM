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
     * @brief: propagates parameters values inside functions in the control flow graph
     *
     *
     */


    class ParamValuePropagation : public StmtAbstractVisitor {

    public:

        //Constructors and Destructor
        ParamValuePropagation() = delete;

        ParamValuePropagation(std::map<std::string, SCAM::Expr *> paramValMap,
                              std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList);

        ~ParamValuePropagation() = default;

        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> getReturnValueConditionList() const;

    private:
        std::map<std::string, SCAM::Expr *> paramValMap;
        std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> returnValueConditionList;
        SCAM::Expr *newExpr;

        //visitors
        void visit(struct VariableOperand &node) override{};

        void visit(struct IntegerValue &node) override{};

        void visit(struct UnsignedValue &node) override{};

        void visit(struct BoolValue &node) override{};

        void visit(struct EnumValue &node) override{};

        void visit(struct CompoundValue &node) override{};

        void visit(class PortOperand &node) override{};

        void visit(class Assignment &node) override{};

        void visit(struct UnaryExpr &node);

        void visit(struct While &node) override{};

        void visit(struct If &node) override{};

        void visit(struct Read &node) override{};

        void visit(struct Write &node) override{};

        void visit(struct SectionOperand &node){};

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

        void visit(class ParamOperand &node) override;

        void visit(class Return &node) override{};

        void visit(class Notify &node) override{};

        void visit(class Wait &node) override{};

        void visit(class Peek &node) override{};

    };
}


#endif //SCAM_PARAMVALUEPROPAGATION_H
