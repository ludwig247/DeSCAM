//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#ifndef SCAM_FINDSTATEBACKTRACK_H
#define SCAM_FINDSTATEBACKTRACK_H

#include <StmtAbstractVisitor.h>
#include "Behavior/CfgNode.h"
//#include "OperationDataStructure/State2.h"
#include "Stmts_all.h"

namespace DESCAM {

    /**
     * \brief: extract all possible backward paths from important state to the "while(true)" statement
     *
     * \input:
     *      - DESCAM::CfgNode * state;
     *      - DESCAM::CfgNode * whileNode
     * \output:
     *      - std::vector<std::vector<DESCAM::Stmt *>> stateBacktracks;
     *
     * \details: Traverse CFG (iterative depth first search through node's predecessors) and extract all possible paths starting from the important state.
     *
     */
    class FindStateBacktrack : public DESCAM::StmtAbstractVisitor {
    public:
        FindStateBacktrack(DESCAM::CfgNode * state, DESCAM::CfgNode * whileNode);
        ~FindStateBacktrack() = default;
        const std::vector<std::vector<DESCAM::Stmt *>> &getStateBacktracks();



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

        void visit(DESCAM::ArrayExpr &node) override;

        void visit(DESCAM::CompoundExpr &node) override;

        void visit(DESCAM::ParamOperand &node) override;

        void visit(DESCAM::Return &node) override;

        void visit(DESCAM::Notify &node) override;

        void visit(DESCAM::Wait &node) override;

        void visit(DESCAM::Peek &node) override;

        void visit(DESCAM::TimePointOperand &node) override;

        void visit(DESCAM::Ternary &node) override;

    private:
        std::vector<std::vector<DESCAM::CfgNode *>> stateAssumptions;//Temporary
        std::vector<std::vector<DESCAM::Stmt *>> stateBacktracks;//Temporary

        DESCAM::Expr *newExpr;
        std::vector<DESCAM::Stmt *> statementsList;
        bool condition;
    };

}

#endif //SCAM_FINDSTATEBACKTRACK_H
