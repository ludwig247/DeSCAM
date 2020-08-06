//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/4/19.
//

#ifndef SCAM_CREATEOPERATIONS_H
#define SCAM_CREATEOPERATIONS_H

#include <Model.h>
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include "Behavior/Operation.h"
#include "Behavior/State.h"

namespace DESCAM {

    /**
     * \brief: This class create operations given all combinations of communications synchs.
     *          This class is used in case the module is not slave.
     *
     * \input:
     *          - std::vector<std::vector<DESCAM::CfgNode *> > &rawOperations;
     *          - std::map<std::string, DESCAM::State2 *> statesMap;
     *          - DESCAM::Module * module;
     * \output:
     *          - std::vector<DESCAM::Operation2 *> operationsList;
     *          - std::map<std::string, DESCAM::State2 *> statesMap;
     *
     * \details:
     *          For operations with blocking communication, sync signal assumption should be added.
     *          In case of blocking communication, an implicit operation should be created (i.e. implicit operation) with sync signal deasserted
     *          For every raw operation:
     *              - assign starting state and next state.
     *              - extract the statement list.
     *
     *          - Create Explicit Operations
     *          - Create implicit Operations
     */
    class CreateOperations : public DESCAM::StmtAbstractVisitor {
    public:

        CreateOperations(const std::vector<std::vector<DESCAM::CfgNode *> > &rawOperations, std::map<std::string, DESCAM::State *> statesMap, DESCAM::Module *module);

        virtual ~CreateOperations() = default;

        const std::vector<DESCAM::Operation *> &getOperationsList() const;

        const std::map<std::string, DESCAM::State *> &getStatesMap() const;

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

        void visit(struct ArrayExpr &node) override;

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

        void visit(DESCAM::TimePointOperand &node) override;

        void visit(DESCAM::Ternary &node) override;
    private:
        void addStates(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation);
        void addStatementsList(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation);
        std::vector<DESCAM::Stmt *> statementsList;
        DESCAM::Expr *newExpr;
        bool firstStatement;
        bool lastStatement;
        bool condition;
        bool waitOp;
        bool notSyncOp;

        std::vector<DESCAM::Operation *> operationsList;
        std::vector<DESCAM::CfgNode *> nodeWaitList;
        std::map<std::string, DESCAM::State *> statesMap;
        DESCAM::Module *module;
    };
}

#endif //SCAM_CLEANOPERATIONS_H
