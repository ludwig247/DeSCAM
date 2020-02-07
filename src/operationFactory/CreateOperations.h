//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/4/19.
//

#ifndef SCAM_CREATEOPERATIONS_H
#define SCAM_CREATEOPERATIONS_H

#include <Model.h>
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include "Behavior/Operation2.h"
#include "Behavior/State2.h"

namespace SCAM {

    /**
     * \brief: This class create operations given all combinations of communications synchs.
     *          This class is used in case the module is not slave.
     *
     * \input:
     *          - std::vector<std::vector<SCAM::CfgNode *> > &rawOperations;
     *          - std::map<std::string, SCAM::State2 *> statesMap;
     *          - SCAM::Module * module;
     * \output:
     *          - std::vector<SCAM::Operation2 *> operationsList;
     *          - std::map<std::string, SCAM::State2 *> statesMap;
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
    class CreateOperations : public SCAM::StmtAbstractVisitor {
    public:

        CreateOperations(const std::vector<std::vector<SCAM::CfgNode *> > &rawOperations, std::map<std::string, SCAM::State2 *> statesMap, SCAM::Module *module);

        virtual ~CreateOperations() = default;

        const std::vector<SCAM::Operation2 *> &getOperationsList() const;

        const std::map<std::string, SCAM::State2 *> &getStatesMap() const;

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

        void visit(struct ArrayExpr &node) override;

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

        void visit(SCAM::TimePointOperand &node) override;
    private:
        void addStates(const std::vector<SCAM::CfgNode *> &rawOperation, Operation2 *operation);
        void addStatementsList(const std::vector<SCAM::CfgNode *> &rawOperation, Operation2 *operation);
        std::vector<SCAM::Stmt *> statementsList;
        SCAM::Expr *newExpr;
        bool firstStatement;
        bool lastStatement;
        bool condition;
        bool waitOp;
        bool notSyncOp;

        std::vector<SCAM::Operation2 *> operationsList;
        std::vector<SCAM::CfgNode *> nodeWaitList;
        std::map<std::string, SCAM::State2 *> statesMap;
        SCAM::Module *module;
    };
}

#endif //SCAM_CLEANOPERATIONS_H
