//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#include "FindStateBacktrack.h"
#include <regex>
#include <PrintStmt.h>

//#define DEBUG_FINDSTATEASSUMPTIONS

SCAM::FindStateBacktrack::FindStateBacktrack(SCAM::CfgNode * state, SCAM::CfgNode * whileNode) {
    if (state->getId() == 0) {
        this->stateBacktracks.push_back(this->statementsList);
    } else {
        std::vector<SCAM::CfgNode *> backwardPath;
        std::stack<SCAM::CfgNode *> stack;
        std::stack<int> visited;
        std::stack<SCAM::CfgNode *> branchingNodesStack;
        SCAM::CfgNode *traverseNode = state;
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
//    throw std::runtime_error(" YOOOOOO ");
#endif
}

const std::vector<std::vector<SCAM::Stmt *>> &SCAM::FindStateBacktrack::getStateBacktracks() {
    return this->stateBacktracks;
}


// Visitor functions
namespace SCAM {
    void SCAM::FindStateBacktrack::visit(SCAM::If &node) {
        node.getConditionStmt()->accept(*this);
        if (this->newExpr != nullptr) {
            if (this->condition) {
                this->statementsList.push_back(&node);
            } else
                this->statementsList.push_back(new If(new UnaryExpr("not", node.getConditionStmt())));
        }
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Read &node) {
        this->newExpr = nullptr;
        this->statementsList.push_back(&node);
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Write &node) {
        this->newExpr = nullptr;
        this->statementsList.push_back(&node);
    }

    void SCAM::FindStateBacktrack::visit(SCAM::SyncSignal &node) {
        this->newExpr = &node;
        throw std::runtime_error("FindStateBacktrack: Not allowed ");
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Peek &node) {
        this->newExpr = nullptr;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Assignment &node) {
        node.getRhs()->accept(*this);
        if(this->newExpr != nullptr)
            this->statementsList.push_back(new Assignment(node.getLhs(), this->newExpr));
    }

    void SCAM::FindStateBacktrack::visit(SCAM::VariableOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::IntegerValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::EnumValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::CompoundValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::PortOperand &node) {
        throw std::runtime_error("FindStateBacktrack: Not allowed ");
    }

    void SCAM::FindStateBacktrack::visit(SCAM::UnaryExpr &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::While &node) {
    }

    void SCAM::FindStateBacktrack::visit(SCAM::SectionOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::SectionValue &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::ITE &node) {
        throw std::runtime_error("FindStateBacktrack: Not allowed ");
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Arithmetic &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Logical &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Relational &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Bitwise &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::DataSignalOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Cast &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::FunctionOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::ArrayOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::CompoundExpr &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::ParamOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Return &node) {
        throw std::runtime_error("FindStateBacktrack: Not allowed ");
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Notify &node) {
        throw std::runtime_error("FindStateBacktrack: Not allowed ");
    }

    void SCAM::FindStateBacktrack::visit(SCAM::Wait &node) {

    }

    void FindStateBacktrack::visit(SCAM::ArrayExpr &node) {

        this->newExpr = &node;
    }

}
