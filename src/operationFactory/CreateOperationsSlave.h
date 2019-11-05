//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/8/19.
//

#ifndef SCAM_CREATEOPERATIONSSLAVE_H
#define SCAM_CREATEOPERATIONSSLAVE_H

#include <Model.h>
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include "Behavior/Operation2.h"
#include "Behavior/State2.h"

namespace SCAM {

    class CreateOperationsSlave : public SCAM::StmtAbstractVisitor {
    public:

        CreateOperationsSlave(const std::vector<std::vector<SCAM::CfgNode *> > &rawOperations, std::map<std::string, SCAM::State2 *> statesMap, SCAM::Module *module);

        virtual ~CreateOperationsSlave() = default;

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

        void visit(struct ArrayExpr &node) override;

        void visit(SCAM::ParamOperand &node) override;

        void visit(SCAM::Return &node) override;

        void visit(SCAM::Notify &node) override;

        void visit(SCAM::Wait &node) override;

        void visit(SCAM::Peek &node) override;
    private:
        void extendRawOperation(const std::vector<SCAM::CfgNode *> &rawOperation);
        void addStates(const std::vector<SCAM::CfgNode *> &rawOperation, Operation2 *operation);
        void addStatementsList(const std::vector<SCAM::CfgNode *> &rawOperation, Operation2 *operation);
        std::vector<std::vector<SCAM::CfgNode *>> rawOperationsExtended;
        std::vector<SCAM::Stmt *> statementsList;
        SCAM::Expr *newExpr;
        bool firstStatement;
        bool lastStatement;
        bool condition;

        std::vector<SCAM::Operation2 *> operationsList;
        std::map<std::string, SCAM::State2 *> statesMap;
        SCAM::Module *module;
    };
}

#endif //SCAM_CREATEOPERATIONSSLAVE_H
