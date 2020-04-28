//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 8/8/19.
//

#include "CreateOperationsSlave.h"
#include <PrintStmt.h>
#include <assert.h>
#include "OperationMiscellaneous/FindCommunication2.h"
#include <regex>
#include <NodePeekVisitor.h>
#include "FatalError.h"
#include "Logger/Logger.h"


//#define DEBUG_CREATEOPERATIONS

namespace SCAM {

    CreateOperationsSlave::CreateOperationsSlave(const std::vector<std::vector<SCAM::CfgNode *> > &rawOperations, std::map<std::string, SCAM::State *> statesMap, SCAM::Module *module) :
            firstStatement(false),
            lastStatement(false),
            condition(false),
            newExpr(nullptr),
            statesMap(std::move(statesMap)),
            module(module) {

        /// checking if module has slaveIns that require extra processing
        bool hasSlaveIns = false;
        for (auto port : module->getPorts()) {
            if(port.second->getInterface()->isSlaveIn())
                hasSlaveIns = true;
        }

        if(hasSlaveIns) {
            for (const auto& op : rawOperations) {
                if(op.front()->getStmt() == nullptr) // the reset operation won't need extending
                    this->rawOperationsExtended.push_back(op);
                else
                    extendRawOperation(op); // create a graph from extending raw operation, create a list of extended raw operations and add them to rawOperationsExtended
            }
        } else {
            rawOperationsExtended = rawOperations;
        }

        /// create Explicit Operations
        for (const auto& op : rawOperationsExtended) {
            auto *operation = new Operation();
            /// save operation in the final list
            this->operationsList.push_back(operation);
            this->addStates(op, operation);
            this->addStatementsList(op, operation);
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
//        TERMINATE(" STOP YOOO ");
#endif
    }

    const std::vector<SCAM::Operation*> &CreateOperationsSlave::getOperationsList() const{
        return this->operationsList;
    }

    const std::map<std::string, SCAM::State *> &CreateOperationsSlave::getStatesMap() const {
        return this->statesMap;
    }

    void CreateOperationsSlave::extendRawOperation(const std::vector<SCAM::CfgNode *> &rawOperation) {
        /** for every slaveIn
         *  id[5] sX_in->read(var)
         *  replace
         *  id[5] if(sX_in.sync())          // this must have the same id as original in case the slaveIn_read follows an if statement
         *  id[6]       sX_in->read(var)    // this must have id+1 of sync statement to insure that the condition is considered true
         *  id[Y] nullptr                   // this is added to give balance to the successors of sync statement
         *
         *  this has to be done here for every operation separately because it's possible to use the same slaveIn with different variables
         */
        std::map<SCAM::CfgNode*, SCAM::CfgNode *> slaveInExtension;
        std::map<SCAM::CfgNode*, bool> visited;
        for(auto node : rawOperation) {
            if(node->getStmt() != nullptr ) {
                SCAM::FindCommunication2 findComm;
                node->getStmt()->accept(findComm);
                if (findComm.isCommunication() && findComm.getPort()->getInterface()->isSlaveIn()) {
                    auto syncNode = new CfgNode(new If(findComm.getPort()->getSynchSignal()));
                    syncNode->replaceId(node->getId());
                    auto readNode = new CfgNode(node->getStmt());
                    readNode->replaceId(syncNode->getId() + 1);
                    auto elseNode = new CfgNode();
                    if (Read *readStmt = dynamic_cast<Read *>(node->getStmt())) {
                        if(readStmt->getStatusOperand() != nullptr) {
                            elseNode->setStmt(new Assignment(readStmt->getStatusOperand(),readStmt->getPort()->getSynchSignal(),readStmt->getStmtInfo()));
                        }
                    } else TERMINATE("Could not dynamically cast a Read statement");

                    syncNode->addSuccessor(readNode);
                    syncNode->addSuccessor(elseNode);

                    slaveInExtension.insert(std::make_pair(node, syncNode));
                    /// create the slave visit map from the start and just apply updating to it later
                    visited.insert(std::make_pair(node,false));
                }
            }
        }

        std::vector<SCAM::CfgNode*> slaveInsStack;
        do {
            std::vector<SCAM::CfgNode *> rawOperationExtended;
            for (auto node : rawOperation) {
                if (node->getStmt() != nullptr) {
                    SCAM::FindCommunication2 findComm;
                    node->getStmt()->accept(findComm);
                    if (findComm.isCommunication() && findComm.getPort()->getInterface()->isSlaveIn()) {

                        /// add slave to the stack if this is first time passing it
                        auto it = std::find(slaveInsStack.begin(),slaveInsStack.end(),node);
                        if(it == slaveInsStack.end()) {
                            slaveInsStack.push_back(node);
                            visited[node] = false;
                        }

                        assert(slaveInExtension[node]->getSuccessorList().size() == 2);
                        if(!visited[node]) {
                            rawOperationExtended.push_back(slaveInExtension[node]);
                            rawOperationExtended.push_back(slaveInExtension[node]->getSuccessorList().front());
                        } else {
                            rawOperationExtended.push_back(slaveInExtension[node]);
                            rawOperationExtended.push_back(slaveInExtension[node]->getSuccessorList().back());

                            assert(it != slaveInsStack.end());// To make sure that visiting the second branch doesn't happen when node is added to the stack
                        }
                    } else {
                        rawOperationExtended.push_back(node);
                    }
                } else {
                    rawOperationExtended.push_back(node);
                }
            }
            this->rawOperationsExtended.push_back(rawOperationExtended);

            /// You can slave from the stack if you visited both it's branches
            while(!slaveInsStack.empty() && visited[slaveInsStack.back()]) {
                slaveInsStack.pop_back();
            }
            /// change the branching for the last slave in the stack
            if(!slaveInsStack.empty()) {
                visited[slaveInsStack.back()] = true;
            }
        } while (!slaveInsStack.empty());
    }

    void CreateOperationsSlave::addStates(const std::vector<SCAM::CfgNode *> &rawOperation, Operation *operation) {
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
                TERMINATE("CreateOperationsSlave: Operation starts from unknown state!");
            operation->setState(state->second);
            state->second->addOutgoingOperation(operation);
        }

        /// Process ending state
        node = rawOperation.end() - 1;
        auto state = this->statesMap.find((*node)->getName());
        if (state == this->statesMap.end())
            TERMINATE(" Operation ends in unknown state!");
        operation->setNextState(state->second);
        state->second->addIncomingOperation(operation);
    }

    void CreateOperationsSlave::addStatementsList(const std::vector<SCAM::CfgNode *> &rawOperation, Operation *operation) {
        this->statementsList.clear();

        auto node = rawOperation.begin();
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
namespace SCAM {
    void SCAM::CreateOperationsSlave::visit(SCAM::If &node) {
        if (this->condition)
            this->statementsList.push_back(&node);
        else
            this->statementsList.push_back(new If(new UnaryExpr("not", node.getConditionStmt(),node.getStmtInfo()),node.getStmtInfo()));
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Read &node) {
        this->newExpr = nullptr;
        if(firstStatement || lastStatement)
            TERMINATE("CreateOperationsSlave::Read: can't have a communication as state in a slave module ");
        this->statementsList.push_back(&node);
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Write &node) {
        this->newExpr = nullptr;
        if(firstStatement || lastStatement)
            TERMINATE("CreateOperationsSlave::Write: can't have a communication as state in a slave module ");
        this->statementsList.push_back(&node);
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::SyncSignal &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Assignment &node) {
        node.getRhs()->accept(*this);
        if(this->newExpr != nullptr)
            this->statementsList.push_back(new Assignment(node.getLhs(), this->newExpr));
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::VariableOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::IntegerValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::UnsignedValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::BoolValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::EnumValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::CompoundValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::PortOperand &node) {
        TERMINATE("CreateOperationsSlave: Not allowed ");
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::TimePointOperand &node) {
        TERMINATE("CreateOperationsSlave: Not allowed ");
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::UnaryExpr &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::While &node) {
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::SectionOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::SectionValue &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::ITE &node) {
        TERMINATE("CreateOperationsSlave: Not allowed ");
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Arithmetic &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Logical &node) {
        this->newExpr = &node;
    }


    void SCAM::CreateOperationsSlave::visit(SCAM::Ternary &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Relational &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Bitwise &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::DataSignalOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Cast &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::FunctionOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::ArrayOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::CompoundExpr &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::ParamOperand &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Return &node) {
        TERMINATE("CreateOperationsSlave: Not allowed ");
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Notify &node) {
        TERMINATE("CreateOperationsSlave: Not allowed ");
    }

    void CreateOperationsSlave::visit(class ArrayExpr &node) {
        this->newExpr = &node;
    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Wait &node) {

    }

    void SCAM::CreateOperationsSlave::visit(SCAM::Peek &node) {
        this->newExpr = node.getPort()->getSynchSignal();
    }
}
