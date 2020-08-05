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

namespace DESCAM {
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

    class ReconstructOperations : public DESCAM::StmtAbstractVisitor {
    public:
        ReconstructOperations() = default;
        ReconstructOperations(std::map<std::string, DESCAM::State *> statesMap, DESCAM::Module *module);
        ReconstructOperations(std::vector<DESCAM::Stmt*> statementsList, DESCAM::Module * module);
        void sortOperation(DESCAM::Operation *operation);

        void simplifyTernary(DESCAM::Operation * operation);

        static std::vector<DESCAM::Expr *> extractConditions(std::vector<DESCAM::Stmt*> statementsList, DESCAM::Module * module);
        static Return * getReturnValue(std::vector<DESCAM::Stmt*> statementsList, DESCAM::Module * module);
        ~ReconstructOperations() = default;

        void visit(DESCAM::VariableOperand &node) override;

        void visit(DESCAM::IntegerValue &node) override;

        void visit(DESCAM::UnsignedValue &node) override;

        void visit(DESCAM::BoolValue &node) override;

        void visit(DESCAM::EnumValue &node) override;

        void visit(DESCAM::CompoundValue &node) override;

        void visit(DESCAM::PortOperand &node) override;

        void visit(DESCAM::Assignment &node) override;

        void visit(DESCAM::UnaryExpr &node) override;

        void visit(DESCAM::While &node) override;

        void visit(DESCAM::If &node) override;

        void visit(DESCAM::Read &node) override;

        void visit(DESCAM::Write &node) override;

        void visit(DESCAM::SectionOperand &node) override;

        void visit(DESCAM::SectionValue &node) override;

        void visit(DESCAM::ITE &node) override;

        void visit(DESCAM::Arithmetic &node) override;

        void visit(DESCAM::Logical &node) override;

        void visit(DESCAM::Relational &node) override;

        void visit(DESCAM::Bitwise &node) override;

        void visit(DESCAM::SyncSignal &node) override;

        void visit(DESCAM::DataSignalOperand &node) override;

        void visit(DESCAM::Cast &node) override;

        void visit(DESCAM::FunctionOperand &node) override;

        void visit(DESCAM::ArrayOperand &node) override;

        void visit(DESCAM::CompoundExpr &node) override;

        void visit(DESCAM::ParamOperand &node) override;

        void visit(DESCAM::Return &node) override;

        void visit(DESCAM::Notify &node) override;

        void visit(DESCAM::Wait &node) override;

        void visit(DESCAM::Peek &node) override;

        void visit(ArrayExpr &node) override;

        void visit(DESCAM::TimePointOperand &node) override;

        void visit(DESCAM::Ternary &node) override;


    private:
        std::map<std::string, DESCAM::Expr *> variableAssignmentMap; //! Contains the current pointer to the value of a variable
        std::map<std::string, DESCAM::Expr *> variableMap; //! Contains an entry for each variable_name,Variable*
        DESCAM::Expr *find_or_add_variable(const std::string& varName, DESCAM::Expr *expr);

        void reset();
        bool isStateVar ;
        DESCAM::Expr *newExpr;

        std::vector<Expr *> assumptionsList;
        std::vector<Assignment *> commitmentsList;

        std::map<std::string, DESCAM::State *> statesMap;
        std::vector<std::string> dpSignalsList;
        DESCAM::Module *module = nullptr;
        Return *returnValue = nullptr;

        DataSignal *reconstructArrayVar(Operand *operand);

        bool isWaitOperation =false;
    };

}
#endif //SCAM_RECONSTRUCTOPERATIONS_H
