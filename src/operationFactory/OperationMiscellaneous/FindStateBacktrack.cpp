//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#include "FindStateBacktrack.h"
#include <regex>
#include <PrintStmt.h>
#include "FatalError.h"
#include "Logger/Logger.h"


//#define DEBUG_FINDSTATEASSUMPTIONS

DESCAM::FindStateBacktrack::FindStateBacktrack(DESCAM::CfgNode * state, DESCAM::CfgNode * whileNode) {
    if (state->getId() == 0) {
        this->stateBacktracks.push_back(this->statementsList);
    } else {
        std::vector<DESCAM::CfgNode *> backwardPath;
        std::stack<DESCAM::CfgNode *> stack;
        std::stack<int> visited;
        std::stack<DESCAM::CfgNode *> branchingNodesStack;
        DESCAM::CfgNode *traverseNode = state;
        stack.push(traverseNode);
        /// extract the backtracks as vectors of CFGNodes2
        while (!stack.empty()) {
            traverseNode = stack.top();
            stack.pop();
#ifdef DEBUG_FINDSTATEASSUMPTIONS
            std::cout << traverseNode->printShort();
#endif
            /// Encountering a while node
            if (traverseNode == whileNode) {
                /// reach top, add assumptions list (if statements) as possible backward path
                this->stateAssumptions.push_back(backwardPath);//implicitly insert
                // TODO: (extra) check if the backward path on it's own is valid
                ///retrace
                while (!visited.empty()) {
                    while (backwardPath[backwardPath.size() - 1] != branchingNodesStack.top()) {
                        backwardPath.pop_back();
                    }
                    if (visited.top() == 1) {
                        branchingNodesStack.pop();
                        visited.pop();
                    } else {
                        visited.top()--;
                        break;
                    }
                }
#ifdef DEBUG_FINDSTATEASSUMPTIONS
                std::cout << "Finished Path: Retrace Path: \n";
                for (auto pathNode: backwardPath)
                    std::cout << "ID[" << pathNode->getId() << "] - ";
                std::cout << "\n";
#endif
            }
                /// Normal node
            else {
                backwardPath.push_back(traverseNode);
                /// Push predecessor
                if (traverseNode->getPredecessorList().size() > 1) {
                    branchingNodesStack.push(traverseNode);
                    visited.push(traverseNode->getPredecessorList().size());
                }
                for (int i = traverseNode->getPredecessorList().size() - 1; i >= 0; i--) {
                    stack.push(traverseNode->getPredecessorList()[i]);
                }
            }
        }

        /// extract the statement list of the backtracks
        for (auto backwardBranch : this->stateAssumptions) {
            this->statementsList.clear();
            for (auto it = backwardBranch.rbegin(); it != backwardBranch.rend() - 1; it++) {
                if ((*it)->getStmt() != nullptr) {
                    this->newExpr = nullptr;
                    condition = true;
                    if (((*it)->getId() + 1) != (*(it + 1))->getId()) {
                        condition = false;
                    }
                    (*it)->getStmt()->accept(*this);
                }
            }
            this->stateBacktracks.push_back(this->statementsList);
        }
    }
#ifdef DEBUG_FINDSTATEASSUMPTIONS
    std::cout << "\n--------------- State: ---------------- " << state->printShort();
    for (const auto& stmtsList : this->stateBacktracks) {
        std::cout << "Backtrack: \n";
        for (auto stmt : stmtsList) {
            std::cout << PrintStmt::toString(stmt) << "\n";
        }
        std::cout << "------------------------\n";
    }
//    TERMINATE(" YOOOOOO ");
#endif
}

const std::vector<std::vector<DESCAM::Stmt *>> &DESCAM::FindStateBacktrack::getStateBacktracks() {
    return this->stateBacktracks;
}


// Visitor functions
namespace DESCAM {
    void DESCAM::FindStateBacktrack::visit(DESCAM::If &node) {
        node.getConditionStmt()->accept(*this);
        if (this->newExpr != nullptr) {
            if (this->condition) {
                this->statementsList.push_back(&node);
            } else
                this->statementsList.push_back(new If(new UnaryExpr("not", node.getConditionStmt())));
        }
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Read &node) {
        this->newExpr = nullptr;
        this->statementsList.push_back(&node);
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Write &node) {
        this->newExpr = nullptr;
        this->statementsList.push_back(&node);
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::SyncSignal &node) {
        this->newExpr = &node;
        TERMINATE("FindStateBacktrack: Not allowed ");
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Peek &node) {
        this->newExpr = nullptr;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Assignment &node) {
        node.getRhs()->accept(*this);
        if(this->newExpr != nullptr)
            this->statementsList.push_back(new Assignment(node.getLhs(), this->newExpr));
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::VariableOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::TimePointOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::IntegerValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::EnumValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::CompoundValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::PortOperand &node) {
        TERMINATE("FindStateBacktrack: Not allowed ");
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::UnaryExpr &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::While &node) {
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::SectionOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::SectionValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::ITE &node) {
        TERMINATE("FindStateBacktrack: Not allowed ");
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Arithmetic &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Logical &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Relational &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Bitwise &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::DataSignalOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Cast &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::FunctionOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::ArrayOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::CompoundExpr &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::ParamOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Return &node) {
        TERMINATE("FindStateBacktrack: Not allowed ");
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Notify &node) {
        TERMINATE("FindStateBacktrack: Not allowed ");
    }

    void DESCAM::FindStateBacktrack::visit(DESCAM::Wait &node) {

    }

    void FindStateBacktrack::visit(DESCAM::ArrayExpr &node) {

        this->newExpr = &node;
    }

    void FindStateBacktrack::visit(DESCAM::Ternary &node) {
        this->newExpr = &node;
    }

}
