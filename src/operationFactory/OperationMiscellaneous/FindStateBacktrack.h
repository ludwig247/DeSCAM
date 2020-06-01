//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#ifndef SCAM_FINDSTATEBACKTRACK_H
#define SCAM_FINDSTATEBACKTRACK_H

#include <StmtAbstractVisitor.h>
#include "Behavior/CfgNode.h"
//#include "OperationDataStructure/State2.h"
#include "Stmts_all.h"

namespace SCAM {

    /**
     * \brief: extract all possible backward paths from important state to the "while(true)" statement
     *
     * \input:
     *      - SCAM::CfgNode * state;
     *      - SCAM::CfgNode * whileNode
     * \output:
     *      - std::vector<std::vector<SCAM::Stmt *>> stateBacktracks;
     *
     * \details: Traverse CFG (iterative depth first search through node's predecessors) and extract all possible paths starting from the important state.
     *
     */
    class FindStateBacktrack : public SCAM::StmtAbstractVisitor {
    public:
        FindStateBacktrack(SCAM::CfgNode * state, SCAM::CfgNode * whileNode);
        ~FindStateBacktrack() = default;
        const std::vector<std::vector<SCAM::Stmt *>> &getStateBacktracks();



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

        void visit(SCAM::ArrayExpr &node) override;

        void visit(SCAM::CompoundExpr &node) override;

        void visit(SCAM::ParamOperand &node) override;

        void visit(SCAM::Return &node) override;

        void visit(SCAM::Notify &node) override;

        void visit(SCAM::Wait &node) override;

        void visit(SCAM::Peek &node) override;

        void visit(SCAM::TimePointOperand &node) override;

        void visit(SCAM::Ternary &node) override;

    private:
        std::vector<std::vector<SCAM::CfgNode *>> stateAssumptions;//Temporary
        std::vector<std::vector<SCAM::Stmt *>> stateBacktracks;//Temporary

        SCAM::Expr *newExpr;
        std::vector<SCAM::Stmt *> statementsList;
        bool condition;
    };

}

#endif //SCAM_FINDSTATEBACKTRACK_H
