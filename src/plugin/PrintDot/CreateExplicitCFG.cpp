//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/22/19.
//

#include <PrintStmt.h>
#include "CreateExplicitCFG.h"
#include "../../operationFactory/OperationMiscellaneous/FindCommunication2.h"

namespace DESCAM {

    CreateExplicitCFG::CreateExplicitCFG(const std::map<int, DESCAM::CfgNode *> &controlFlowMap, const std::vector<PropertyMacro *> &states) {
        for (auto node : controlFlowMap) {
            if (node.second->getStmt() == nullptr) {
                this->cfg.insert(std::make_pair(node.second->getId(), node.second));
            } else {
                //FIXME: translating Blocking communication resembles Master communication. for now
                DESCAM::FindCommunication2 findComm;
                node.second->getStmt()->accept(findComm);
                if (findComm.isWrite() && (findComm.isBlockingInterface() && !findComm.isNonBlockingAccess())) { //FIXME: in future, isNonBlockingAccess() is not needed
//                if(findComm.isWrite() &&
//                        ((findComm.isMaster()) ||
//                        (findComm.isBlockingInterface() && !findComm.isNonBlockingAccess()))) {
                    /**
                     * b_out->write(val);
                     *
                     * For property generation: =>
                     *      do {
                     *          writerPort_data <= val
                     *          writerPort_notify <= true
                     *          wait(0)
                     *      } while(!writerPort_sync)
                     *
                     *      ----------
                     * writeComm:
                     *      {
                     *          writerPort->write(val)
                     *          writerPort_notify = true
                     *          wait(0)
                     *      } if(!writerPort_sync)
                     *          goto writeComm
                     *
                     */
                    std::vector<DESCAM::CfgNode *> commGroup;
//                    auto writeNode = new CfgNode(findComm.getCommStmt());
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                    auto writeNode = new CfgNode(new Assignment(varOp, findComm.getWriteValue()));
//                    auto writeNode = new CfgNode(node.second->getStmt());
                    /**
                     * replace the id to preserve the order of ids resembling the original graph.
                     * This is needed for cases like the following example:
                     *          if(phase == WRITE)          // ID[x]
                     *              b_out->write(val)       // ID[x+1]
                     *
                     *      When replaced
                     *          if(phase == WRITE)          // ID[x]
                     *              writerPort_data = val   // ID[y]
                     *
                     *          ===> when checking the if statement, i.e. if ((*(node + 1))->getId() == ((*node)->getId() + 1))
                     *                  ====> condition = false
                     */
                    writeNode->replaceId(node.second->getId());
                    auto notifyNode = new CfgNode(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                    auto waitNode = new CfgNode(new Wait());
                    auto ifNode = new CfgNode(new If(findComm.getPort()->getSynchSignal()));
                    /// nullNode needed to keep the method of checking if statement validity based on nodeId.
                    ///     i.e. if ((*(node + 1))->getId() == ((*node)->getId() + 1))  ====> condition = true
                    auto nullNode = new CfgNode();

                    for (auto pre: node.second->getPredecessorList()) {
                        pre->replaceSuccessor(node.second, writeNode);
                        writeNode->addPredecessor(pre);
                    }
                    writeNode->addSuccessor(notifyNode);

                    notifyNode->addPredecessor(writeNode);
                    notifyNode->addSuccessor(waitNode);

                    waitNode->addPredecessor(notifyNode);
                    waitNode->addSuccessor(ifNode);

                    ifNode->addPredecessor(waitNode);
                    ifNode->addSuccessor(writeNode);
                    ifNode->addSuccessor(nullNode);

                    nullNode->addPredecessor(ifNode);
                    for (auto succ: node.second->getSuccessorList()) {
                        nullNode->addSuccessor(succ);
                        succ->replacePredecessor(node.second, nullNode);
                    }

                    this->cfg.insert(std::make_pair(writeNode->getId(), writeNode));
                    this->cfg.insert(std::make_pair(notifyNode->getId(), notifyNode));
                    this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                    this->cfg.insert(std::make_pair(ifNode->getId(), ifNode));
                    this->cfg.insert(std::make_pair(nullNode->getId(), nullNode));

                    commGroup.push_back(writeNode);
                    commGroup.push_back(notifyNode);
                    commGroup.push_back(waitNode);
                    commGroup.push_back(ifNode);
                    commGroup.push_back(nullNode);
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node.second->getStmt()), commGroup));

//                } else if (findComm.isRead() &&
//                        ((findComm.isMaster()) ||
//                        (findComm.isBlockingInterface() && !findComm.isNonBlockingAccess()))) {
                } else if (findComm.isRead() && (findComm.isBlockingInterface() && !findComm.isNonBlockingAccess())) { //FIXME: in future, isNonBlockingAccess() is not needed
                    /**
                     * b_in->read(val);
                     *
                     * For property generation: =>
                     * readComm:
                     *      {
                     *          readerPort_notify = true
                     *          wait(0)
                     *      } if(!readerPort_sync)
                     *          goto readComm
                     *      readerPort->read(val)
                     *
                     */
                    std::vector<DESCAM::CfgNode *> commGroup;
                    auto notifyNode = new CfgNode(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                    notifyNode->replaceId(node.second->getId());
                    auto waitNode = new CfgNode(new Wait());
                    auto ifNode = new CfgNode(new If(findComm.getPort()->getSynchSignal()));
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                    auto readNode = new CfgNode(new Assignment(findComm.getReadVariable(), varOp));
//                    auto readNode = new CfgNode(node.second->getStmt());

                    for (auto pre: node.second->getPredecessorList()) {
                        pre->replaceSuccessor(node.second, notifyNode);
                        notifyNode->addPredecessor(pre);
                    }
                    notifyNode->addSuccessor(waitNode);

                    waitNode->addPredecessor(notifyNode);
                    waitNode->addSuccessor(ifNode);

                    ifNode->addPredecessor(waitNode);
                    ifNode->addSuccessor(notifyNode);
                    ifNode->addSuccessor(readNode);

                    readNode->addPredecessor(ifNode);
                    for (auto succ: node.second->getSuccessorList()) {
                        readNode->addSuccessor(succ);
                        succ->replaceSuccessor(node.second, readNode);
                    }

                    this->cfg.insert(std::make_pair(notifyNode->getId(), notifyNode));
                    this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                    this->cfg.insert(std::make_pair(ifNode->getId(), ifNode));
                    this->cfg.insert(std::make_pair(readNode->getId(), readNode));

                    commGroup.push_back(notifyNode);
                    commGroup.push_back(waitNode);
                    commGroup.push_back(ifNode);
                    commGroup.push_back(readNode);
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node.second->getStmt()), commGroup));

                } else if (findComm.isMaster()) {
                    /**
                     * Replacing a master communication only if it represent an important state
                     *
                     * m_out->write(val);
                     *      ----------
                     *          writerPort_data = val
                     *          writerPort_notify = true
                     *          wait(0)
                     *
                     *
                     * m_in->read(val);
                     *      ----------
                     *          wait(0)
                     *          val = writerPort_data
                     */
                    /// find if node statement is an important state
                    auto it = states.begin();
                    while (it != states.end()) {
                        if ((*it)->getName() == node.second->getName())
                            break;
                        it++;
                    }

                    if (it != states.end()) {
                        if (findComm.isWrite()) {
                            std::vector<DESCAM::CfgNode *> commGroup;
                            auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                            auto writeNode = new CfgNode(new Assignment(varOp, findComm.getWriteValue()));
                            auto notifyNode = new CfgNode(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                            auto waitNode = new CfgNode(new Wait());

                            writeNode->replaceId(node.second->getId());

                            for (auto pre: node.second->getPredecessorList()) {
                                pre->replaceSuccessor(node.second, writeNode);
                                writeNode->addPredecessor(pre);
                            }
                            writeNode->addSuccessor(notifyNode);

                            notifyNode->addPredecessor(writeNode);
                            notifyNode->addSuccessor(waitNode);

                            waitNode->addPredecessor(notifyNode);
                            for (auto succ: node.second->getSuccessorList()) {
                                waitNode->addSuccessor(succ);
                                succ->replacePredecessor(node.second, waitNode);
                            }

                            this->cfg.insert(std::make_pair(writeNode->getId(), writeNode));
                            this->cfg.insert(std::make_pair(notifyNode->getId(), notifyNode));
                            this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));

                            commGroup.push_back(writeNode);
                            commGroup.push_back(notifyNode);
                            commGroup.push_back(waitNode);
                            this->commGroups.insert(std::make_pair(PrintStmt::toString(node.second->getStmt()), commGroup));
                        } else {
                            std::vector<DESCAM::CfgNode *> commGroup;
                            auto waitNode = new CfgNode(new Wait());
                            waitNode->replaceId(node.second->getId());
                            auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                            auto readNode = new CfgNode(new Assignment(findComm.getReadVariable(), varOp));


                            for (auto pre: node.second->getPredecessorList()) {
                                pre->replaceSuccessor(node.second, waitNode);
                                waitNode->addPredecessor(pre);
                            }
                            waitNode->addSuccessor(readNode);

                            readNode->addPredecessor(waitNode);
                            for (auto succ: node.second->getSuccessorList()) {
                                readNode->addSuccessor(succ);
                                succ->replacePredecessor(node.second, readNode);
                            }

                            this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                            this->cfg.insert(std::make_pair(readNode->getId(), readNode));

                            commGroup.push_back(waitNode);
                            commGroup.push_back(readNode);
                            this->commGroups.insert(std::make_pair(PrintStmt::toString(node.second->getStmt()), commGroup));
                        }
                    } else {
                        this->cfg.insert(std::make_pair(node.second->getId(), node.second));
                    }
                } else {
                    this->cfg.insert(std::make_pair(node.second->getId(), node.second));
                }
            }
        }
    }

    const std::map<int, CfgNode *> &CreateExplicitCFG::getCfg() const {
        return this->cfg;
    }

    const std::multimap<std::string, std::vector<DESCAM::CfgNode *>> &CreateExplicitCFG::getCommGroups() const {
        return this->commGroups;
    }


}
