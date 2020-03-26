//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/10/19.
//

#ifndef SCAM_RECONSTRUCTOPERATIONS_H
#define SCAM_RECONSTRUCTOPERATIONS_H

#include <Model.h>
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include "Behavior/Operation.h"
#include "Behavior/State.h"

namespace SCAM {
/**
 * \brief Propagates assignments through the stmtlist
 *
 * Look through all stmts of an operation in case of an assigment
 * Propagate to all further usages of this variable
 * E.g.:
 * AML
 * [...]
 * cnt = cnt + 3
 * if(cnt < 10)
 * [...]
 *
 * In path change condition from
 * cnt < 10
 * to
 * (cnt+3) < 10
 * Because the operation always assumes the value of cnt at the beginning
 * -------------------------------------------------------
 * STEP 1: Create a variableMap
 * -------------------------------------------------------
 * For each variable that is assigned a new value
 *  -------------------------------------------------------
 * STEP 2: Redirect pointer
 * -------------------------------------------------------
 * Every time a variable is used it is checked whether this variable has a previous
 * assignment. If there is a new assignment for a variable it is stored in the variableValue map.
 */

    class ReconstructOperations : public SCAM::StmtAbstractVisitor {
    public:
        ReconstructOperations() = default;
        ReconstructOperations(std::map<std::string, SCAM::State *> statesMap, SCAM::Module *module);
        ReconstructOperations(std::vector<SCAM::Stmt*> statementsList, SCAM::Module * module);
        void sortOperation(SCAM::Operation *operation);

        static std::vector<SCAM::Expr *> extractConditions(std::vector<SCAM::Stmt*> statementsList, SCAM::Module * module);
        static Return * getReturnValue(std::vector<SCAM::Stmt*> statementsList, SCAM::Module * module);
        ~ReconstructOperations() = default;

        void visit(SCAM::VariableOperand &node) override;

        void visit(SCAM::IntegerValue &node) override;

        void visit(SCAM::UnsignedValue &node) override;

        void visit(SCAM::BoolValue &node) override;

        void visit(SCAM::EnumValue &node) override;

        void visit(SCAM::CompoundValue &node) override;

        void visit(SCAM::PortOperand &node) override;

        void visit(SCAM::Assignment &node) override;

        void visit(SCAM::UnaryExpr &node) override;

        void visit(SCAM::While &node) override;

        void visit(SCAM::If &node) override;

        void visit(SCAM::Read &node) override;

        void visit(SCAM::Write &node) override;

        void visit(SCAM::SectionOperand &node) override;

        void visit(SCAM::SectionValue &node) override;

        void visit(SCAM::ITE &node) override;

        void visit(SCAM::Arithmetic &node) override;

        void visit(SCAM::Logical &node) override;

        void visit(SCAM::Relational &node) override;

        void visit(SCAM::Bitwise &node) override;

        void visit(SCAM::SyncSignal &node) override;

        void visit(SCAM::DataSignalOperand &node) override;

        void visit(SCAM::Cast &node) override;

        void visit(SCAM::FunctionOperand &node) override;

        void visit(SCAM::ArrayOperand &node) override;

        void visit(SCAM::CompoundExpr &node) override;

        void visit(SCAM::ParamOperand &node) override;

        void visit(SCAM::Return &node) override;

        void visit(SCAM::Notify &node) override;

        void visit(SCAM::Wait &node) override;

        void visit(SCAM::Peek &node) override;

        void visit(ArrayExpr &node) override;

        void visit(SCAM::TimePointOperand &node) override;

        void visit(SCAM::Ternary &node) override;


    private:
        std::map<std::string, SCAM::Expr *> variableAssignmentMap; //! Contains the current pointer to the value of a variable
        std::map<std::string, SCAM::Expr *> variableMap; //! Contains an entry for each variable_name,Variable*
        SCAM::Expr *find_or_add_variable(const std::string& varName, SCAM::Expr *expr);

        void reset();
        bool isStateVar;
        SCAM::Expr *newExpr;

        std::vector<Expr *> assumptionsList;
        std::vector<Assignment *> commitmentsList;

        std::map<std::string, SCAM::State *> statesMap;
        std::vector<std::string> dpSignalsList;
        SCAM::Module *module;
        Return *returnValue = nullptr;

        DataSignal *reconstructArrayVar(Operand *operand);

        bool isWaitOperation =false;
    };

}
#endif //SCAM_RECONSTRUCTOPERATIONS_H
