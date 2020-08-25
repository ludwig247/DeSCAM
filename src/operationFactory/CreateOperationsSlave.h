//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/8/19.
//

#ifndef SCAM_CREATEOPERATIONSSLAVE_H
#define SCAM_CREATEOPERATIONSSLAVE_H

#include <Model.h>
#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include "Behavior/CfgNode.h"
#include "Behavior/Operation.h"
#include "Behavior/State.h"

namespace DESCAM {

    class CreateOperationsSlave : public DESCAM::StmtAbstractVisitor {
    public:

        CreateOperationsSlave(const std::vector<std::vector<DESCAM::CfgNode *> > &rawOperations, std::map<std::string, DESCAM::State *> statesMap, DESCAM::Module *module);

        virtual ~CreateOperationsSlave() = default;

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

        void visit(struct ArrayExpr &node) override;

        void visit(DESCAM::ParamOperand &node) override;

        void visit(DESCAM::Return &node) override;

        void visit(DESCAM::Notify &node) override;

        void visit(DESCAM::Wait &node) override;

        void visit(DESCAM::Peek &node) override;

        void visit(DESCAM::TimePointOperand &node) override;
        void visit(DESCAM::Ternary &node) override;
    private:
        void extendRawOperation(const std::vector<DESCAM::CfgNode *> &rawOperation);
        void addStates(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation);
        void addStatementsList(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation);
        std::vector<std::vector<DESCAM::CfgNode *>> rawOperationsExtended;
        std::vector<DESCAM::Stmt *> statementsList;
        DESCAM::Expr *newExpr;
        bool firstStatement;
        bool lastStatement;
        bool condition;

        std::vector<DESCAM::Operation *> operationsList;
        std::map<std::string, DESCAM::State *> statesMap;
        DESCAM::Module *module;
    };
}

#endif //SCAM_CREATEOPERATIONSSLAVE_H
