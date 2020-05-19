//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/4/19.
//

#include "CreateOperations.h"
#include <PrintStmt.h>
#include <assert.h>
#include "OperationMiscellaneous/FindCommunication2.h"
#include "ReconstructOperations.h"
#include <regex>
#include "FatalError.h"
#include "Logger/Logger.h"


//#define DEBUG_CREATEOPERATIONS

namespace DESCAM {

    CreateOperations::CreateOperations(const std::vector<std::vector<DESCAM::CfgNode *> > &rawOperations, std::map<std::string, DESCAM::State *> statesMap, DESCAM::Module *module) :
            firstStatement(false),
            lastStatement(false),
            condition(false),
            waitOp(false),
            notSyncOp(false),
            newExpr(nullptr),
            statesMap(std::move(statesMap)),
            module(module) {

        /// create Explicit Operations
        this->operationsList.reserve(rawOperations.size());
        for (const auto& op : rawOperations) {
            auto *operation = new Operation();
            /// save operation in the final list
            this->operationsList.push_back(operation);
            this->addStates(op, operation);
            this->addStatementsList(op, operation);
        }

        /// create Implicit Operations
        for (const auto& op : rawOperations) {
            auto node = op.begin();
            if ((*node)->getStmt() == nullptr) continue;

            DESCAM::FindCommunication2 findComm;
            (*node)->getStmt()->accept(findComm);
            if (findComm.isBlockingInterface()) {
                bool isNewWaitOperation = (std::find(this->nodeWaitList.begin(), this->nodeWaitList.end(), (*node)) == this->nodeWaitList.end());
                if (!findComm.isNonBlockingAccess() && isNewWaitOperation) {
                    Operation *wait_operation = new Operation();
                    /// save operation in the final list
                    this->operationsList.push_back(wait_operation);
                    wait_operation->setWait(true);
                    this->waitOp = true;
                    this->addStates(op, wait_operation);
                    this->addStatementsList(op, wait_operation);
                    for(auto stmt: wait_operation->getCommitmentsList()){
                        ReconstructOperations reconstructOperations;
                        stmt->accept(reconstructOperations);
                    }

                    this->waitOp = false;
                    /// to avoi creating more than one wait operation for the same statement
                    this->nodeWaitList.push_back((*node));

                } else if (findComm.isNonBlockingAccess()) {
                    auto *notSynced_operation = new Operation();
                    /// save operation in the final list
                    this->operationsList.push_back(notSynced_operation);
                    this->notSyncOp = true;
                    this->addStates(op, notSynced_operation);
                    this->addStatementsList(op, notSynced_operation);
                    this->notSyncOp = false;
                }
            }
        }

#ifdef DEBUG_CREATEOPERATIONS
        for (auto operation : this->operationsList) {
            std::cout << "********* Operation ID[" << operation->getId() << "] ************\n";
            std::cout << "IsReset: " << operation->IsReset() << " - IsWait: " << operation->IsWait() << "\n";
            std::cout << "Starting State: " << operation->getState()->getName() << " - Ending State: " << operation->getNextState()->getName() << "\n\n";

            std::cout << "********* StatementsList ************\n";
            for (auto stmt : operation->getStatementsList()) {
                std::cout << PrintStmt::toString(stmt) << "\n";
            }
            std::cout << "\n\n******************************\n\n";
        }
        TERMINATE(" STOP YOOO ");
#endif
    }

    const std::vector<DESCAM::Operation*> &CreateOperations::getOperationsList() const{
        return this->operationsList;
    }

    const std::map<std::string, DESCAM::State *> &CreateOperations::getStatesMap() const {
        return this->statesMap;
    }

    void CreateOperations::addStates(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation) {
        /// Process starting state
        auto node = rawOperation.begin();
        if ((*node)->getStmt() == nullptr) {
            operation->setReset(true);
            /// Set starting state of operation as init
            auto state = this->statesMap["init"];
            operation->setState(state);
            state->addOutgoingOperation(operation);
        } else {
            auto state = this->statesMap.find((*node)->getName());
            if (state == this->statesMap.end())
                TERMINATE("CreateOperations: Operation starts from unknown state!");
            operation->setState(state->second);
            state->second->addOutgoingOperation(operation);
        }

        /// Process ending state
        if(this->waitOp) {
            /// node still refer to rawOperation.begin()
            auto state = this->statesMap.find((*node)->getName());
            if (state == this->statesMap.end())
                TERMINATE("CreateOperations: Operation starts from unknown state!");
            operation->setNextState(state->second);
            state->second->addIncomingOperation(operation);
        } else {
            node = rawOperation.end() - 1;
            auto state = this->statesMap.find((*node)->getName());
            if (state == this->statesMap.end())
                TERMINATE(" Operation ends in unknown state!");
            operation->setNextState(state->second);
            state->second->addIncomingOperation(operation);
        }
    }

    void CreateOperations::addStatementsList(const std::vector<DESCAM::CfgNode *> &rawOperation, Operation *operation) {
        this->statementsList.clear();

        auto node = rawOperation.begin();

        /// for wait operations, only first statement matters
        if(this->waitOp) {
            if ((*node)->getStmt() == nullptr)
                TERMINATE("CreateOperations: waitOp starts with null statement!");
            this->firstStatement = true;
            (*node)->getStmt()->accept(*this);
            this->firstStatement = false;
            operation->setStatementsList(this->statementsList);
            return;
        }
        /// Process cfgNodes
        this->firstStatement = true;
        while (node != (rawOperation.end()-1)) {
            if ((*node)->getStmt() != nullptr) {
                if ((*node)->getSuccessorList().size() > 1) { /// Branching node (condition)
                    if ((*(node + 1))->getId() == ((*node)->getId() + 1)) {
                        condition = true;
                    } else {
                        condition = false;
                    }
                }
                (*node)->getStmt()->accept(*this);
            }
            this->firstStatement = false;
            node++;
        }

        this->lastStatement = true;
        (*node)->getStmt()->accept(*this);
        this->lastStatement = false;

        operation->setStatementsList(this->statementsList);
    }

}


// Visitor functions
namespace DESCAM {
    void DESCAM::CreateOperations::visit(DESCAM::If &node) {
        if (this->condition)
            this->statementsList.push_back(&node);
        else
            this->statementsList.push_back(new If(new UnaryExpr("not", node.getConditionStmt(),node.getStmtInfo()),node.getStmtInfo()));
    }

    void DESCAM::CreateOperations::visit(DESCAM::Read &node) {
        if(firstStatement) {
            if (node.isBlocking())
                node.getPort()->getSynchSignal()->accept(*this);
            else
                this->newExpr = nullptr;

            /// nonblocking Read (TryRead)
            if(node.isBlocking() && node.isNonBlockingAccess()) {
                if(!this->notSyncOp) {
                    this->statementsList.push_back(&node);
                } else {
                    if(node.getStatusOperand() != nullptr)
                        this->statementsList.push_back(new Assignment(node.getStatusOperand(), this->newExpr,node.getStmtInfo()));
                }
            }
            /// normal Read
            else if(!node.isNonBlockingAccess() && !this->waitOp)
                this->statementsList.push_back(&node); // It matters whether it's a waitOp or not

        } else if (lastStatement) {
            this->newExpr = nullptr;
        } else {
            this->newExpr = nullptr;
            this->statementsList.push_back(&node);
        }
    }

    void DESCAM::CreateOperations::visit(DESCAM::Write &node) {
        if(firstStatement) {
            if(node.getPort()->getInterface()->isBlocking()) {
                node.getPort()->getSynchSignal()->accept(*this);
                /// the status of the try_write should be assigned to the successful flag
                if( node.isNonBlockingAccess() && (node.getStatusOperand() != nullptr) )
                    this->statementsList.push_back(new Assignment(node.getStatusOperand(), this->newExpr,node.getStmtInfo()));
            } else
                this->newExpr = nullptr;

            if(!node.isNonBlockingAccess() && this->waitOp)
                this->statementsList.push_back(&node);
        } else {
            this->newExpr = nullptr;
            this->statementsList.push_back(&node);
        }
    }

    void DESCAM::CreateOperations::visit(DESCAM::SyncSignal &node) {
        if(this->firstStatement) {
            if(this->waitOp || this->notSyncOp) {
                this->statementsList.push_back(new If(new UnaryExpr("not", &node,node.getStmtInfo()),node.getStmtInfo()));
            } else {
                this->statementsList.push_back(new If(&node,node.getStmtInfo()));
            }
            this->newExpr = &node;
        } else {
            TERMINATE("CreateOperations: Not allowed ");
        }
    }

    void DESCAM::CreateOperations::visit(DESCAM::Assignment &node) {
        node.getRhs()->accept(*this);
        if(this->newExpr != nullptr)
            this->statementsList.push_back(new Assignment(node.getLhs(), this->newExpr,node.getStmtInfo()));
    }

    void DESCAM::CreateOperations::visit(DESCAM::VariableOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::IntegerValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::EnumValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::CompoundValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::PortOperand &node) {
        TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(DESCAM::TimePointOperand &node) {
        TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(DESCAM::UnaryExpr &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::While &node) {
    }

    void DESCAM::CreateOperations::visit(DESCAM::SectionOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::SectionValue &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::ITE &node) {
        TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(DESCAM::Arithmetic &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Logical &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Relational &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Ternary &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Bitwise &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::DataSignalOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Cast &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::FunctionOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::ArrayOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::CompoundExpr &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::ParamOperand &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Return &node) {
        TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(DESCAM::Notify &node) {
        TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(class ArrayExpr &node) {
        this->newExpr = &node;
    }

    void DESCAM::CreateOperations::visit(DESCAM::Wait &node) {
        //TERMINATE("CreateOperations: Not allowed ");
    }

    void DESCAM::CreateOperations::visit(DESCAM::Peek &node) {
        this->newExpr = node.getPort()->getSynchSignal();
    }
}
