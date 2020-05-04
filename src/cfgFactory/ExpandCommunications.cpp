//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 6/24/19.
//

#include "ExpandCommunications.h"
#include <PrintStmt.h>
#include "OperationMiscellaneous/FindCommunication2.h"

namespace SCAM {

    ExpandCommunications::ExpandCommunications(const std::map<int, SCAM::CFGNode2 *> &controlFlowMap, const std::map<std::string, Port *> &modulePorts) {
        assert(controlFlowMap.at(0)->getSuccessorList().size() == 1);
        assert(controlFlowMap.at(0)->getSuccessorList().at(0) = controlFlowMap.at(1));

        auto node = controlFlowMap.begin();
        this->cfg.insert(std::make_pair(node->second->getId(), node->second));

        std::vector<CFGNode2 *> masterCommVisitVariables;
        for (auto port : modulePorts) {
            if (port.second->getInterface()->isMaster()) {
                auto commVisitOp = new VariableOperand(new Variable(port.first + "_visit", DataTypes::getDataType("bool")));
                auto commVisitNode = new CFGNode2(new Assignment(commVisitOp, new BoolValue(false)));
                this->cfg.insert(std::make_pair(commVisitNode->getId(), commVisitNode));
                if (!masterCommVisitVariables.empty()) {
                    commVisitNode->addPredecessor(masterCommVisitVariables.back());
                    masterCommVisitVariables.back()->addSuccessor(commVisitNode);
                }
                masterCommVisitVariables.push_back(commVisitNode);
            }
        }

//        if(!masterCommVisitVariables.empty()) {
//            for(auto m : masterCommVisitVariables)
//                std::cout << m->print();
//        }

        if (!masterCommVisitVariables.empty()) {
            masterCommVisitVariables.front()->addPredecessor(controlFlowMap.at(0));
            masterCommVisitVariables.back()->addSuccessor(controlFlowMap.at(1));

            controlFlowMap.at(0)->replaceSuccessor(controlFlowMap.at(1), masterCommVisitVariables.front());
            controlFlowMap.at(1)->replacePredecessor(controlFlowMap.at(0), masterCommVisitVariables.back());
        }

        node++;
        while (node != controlFlowMap.end()) {
            if (node->second->getStmt() == nullptr) {
                this->cfg.insert(std::make_pair(node->second->getId(), node->second));
            } else {
                SCAM::FindCommunication2 findComm;
                node->second->getStmt()->accept(findComm);
                if (findComm.isWrite() && (findComm.isBlockingInterface() && !findComm.isNonBlockingAccess())) { //FIXME: in future, isNonBlockingAccess() is not needed
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
                    std::vector<SCAM::CFGNode2 *> commGroup;
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                    auto writeNode = new CFGNode2(new Assignment(varOp, findComm.getWriteValue()));
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
                    writeNode->replaceId(node->second->getId());
                    auto notifyNode = new CFGNode2(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                    auto waitNode = new CFGNode2(new Wait());
                    auto ifNode = new CFGNode2(new If(findComm.getPort()->getSynchSignal()));
                    /// nullNode needed to keep the method of checking if statement validity based on nodeId.
                    ///     i.e. if ((*(node + 1))->getId() == ((*node)->getId() + 1))  ====> condition = true
                    auto nullNode = new CFGNode2();

                    for (auto pre: node->second->getPredecessorList()) {
                        pre->replaceSuccessor(node->second, writeNode);
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
                    for (auto succ: node->second->getSuccessorList()) {
                        nullNode->addSuccessor(succ);
                        succ->replacePredecessor(node->second, nullNode);
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
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node->second->getStmt()), commGroup));

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
                    std::vector<SCAM::CFGNode2 *> commGroup;
                    auto notifyNode = new CFGNode2(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                    notifyNode->replaceId(node->second->getId());
                    auto waitNode = new CFGNode2(new Wait());
                    auto ifNode = new CFGNode2(new If(findComm.getPort()->getSynchSignal()));
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));
                    auto readNode = new CFGNode2(new Assignment(findComm.getReadVariable(), varOp));

                    for (auto pre: node->second->getPredecessorList()) {
                        pre->replaceSuccessor(node->second, notifyNode);
                        notifyNode->addPredecessor(pre);
                    }
                    notifyNode->addSuccessor(waitNode);

                    waitNode->addPredecessor(notifyNode);
                    waitNode->addSuccessor(ifNode);

                    ifNode->addPredecessor(waitNode);
                    ifNode->addSuccessor(notifyNode);
                    ifNode->addSuccessor(readNode);

                    readNode->addPredecessor(ifNode);
                    for (auto succ: node->second->getSuccessorList()) {
                        readNode->addSuccessor(succ);
                        succ->replaceSuccessor(node->second, readNode);
                    }

                    this->cfg.insert(std::make_pair(notifyNode->getId(), notifyNode));
                    this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                    this->cfg.insert(std::make_pair(ifNode->getId(), ifNode));
                    this->cfg.insert(std::make_pair(readNode->getId(), readNode));

                    commGroup.push_back(notifyNode);
                    commGroup.push_back(waitNode);
                    commGroup.push_back(ifNode);
                    commGroup.push_back(readNode);
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node->second->getStmt()), commGroup));

                } else if (findComm.isMaster() && findComm.isWrite()) {
                    /**
                     * m_out->write(val);
                     *      ----------
                     *          if(writerPort_visited)
                     *              wait(0)
                     *          writerPort_data = val
                     *          writerPort_notify = true
                     *          writerPort_visited = true
                     */
                    std::vector<SCAM::CFGNode2 *> commGroup;
                    auto commVisitOp = new VariableOperand(new Variable(findComm.getPort()->getName() + "_visit", DataTypes::getDataType("bool")));
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));

                    auto ifNode = new CFGNode2(new If(commVisitOp));
                    ifNode->replaceId(node->second->getId());
                    auto waitNode = new CFGNode2(new Wait());
                    auto writeNode = new CFGNode2(new Assignment(varOp, findComm.getWriteValue()));
                    auto notifyNode = new CFGNode2(new Assignment(findComm.getPort()->getNotify(), new BoolValue(true)));
                    auto visitNode = new CFGNode2(new Assignment(commVisitOp, new BoolValue(true)));


                    for (auto pre: node->second->getPredecessorList()) {
                        pre->replaceSuccessor(node->second, ifNode);
                        ifNode->addPredecessor(pre);
                    }
                    ifNode->addSuccessor(waitNode);
                    ifNode->addSuccessor(writeNode);

                    waitNode->addPredecessor(ifNode);
                    waitNode->addSuccessor(writeNode);

                    writeNode->addPredecessor(ifNode);
                    writeNode->addPredecessor(waitNode);
                    writeNode->addSuccessor(notifyNode);

                    notifyNode->addPredecessor(writeNode);
                    notifyNode->addSuccessor(visitNode);

                    visitNode->addPredecessor(notifyNode);
                    for (auto succ: node->second->getSuccessorList()) {
                        visitNode->addSuccessor(succ);
                        succ->replacePredecessor(node->second, visitNode);
                    }

                    this->cfg.insert(std::make_pair(ifNode->getId(), ifNode));
                    this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                    this->cfg.insert(std::make_pair(writeNode->getId(), writeNode));
                    this->cfg.insert(std::make_pair(notifyNode->getId(), notifyNode));
                    this->cfg.insert(std::make_pair(visitNode->getId(), visitNode));

                    commGroup.push_back(ifNode);
                    commGroup.push_back(waitNode);
                    commGroup.push_back(writeNode);
                    commGroup.push_back(notifyNode);
                    commGroup.push_back(visitNode);
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node->second->getStmt()), commGroup));

                } else if (findComm.isMaster() && findComm.isRead()) {
                    /**
                     * m_in->read(val);
                     *      ----------
                     *          if(readerPort_visit)
                     *              wait(0)
                     *          val = readerPort_data
                     *          readerPort_visit = true
                     */
                    std::vector<SCAM::CFGNode2 *> commGroup;
                    auto commVisitOp = new VariableOperand(new Variable(findComm.getPort()->getName() + "_visit", DataTypes::getDataType("bool")));
                    auto varOp = new VariableOperand(new Variable(findComm.getPort()->getDataSignal()->getName(), findComm.getPort()->getDataSignal()->getDataType()));

                    auto ifNode = new CFGNode2(new If(commVisitOp));
                    ifNode->replaceId(node->second->getId());
                    auto waitNode = new CFGNode2(new Wait());
                    auto readNode = new CFGNode2(new Assignment(findComm.getReadVariable(), varOp));
                    auto visitNode = new CFGNode2(new Assignment(commVisitOp, new BoolValue(true)));

                    for (auto pre: node->second->getPredecessorList()) {
                        pre->replaceSuccessor(node->second, ifNode);
                        ifNode->addPredecessor(pre);
                    }
                    ifNode->addSuccessor(waitNode);
                    ifNode->addSuccessor(readNode);

                    waitNode->addPredecessor(ifNode);
                    waitNode->addSuccessor(readNode);

                    readNode->addPredecessor(ifNode);
                    readNode->addPredecessor(waitNode);
                    readNode->addSuccessor(visitNode);

                    visitNode->addPredecessor(readNode);
                    for (auto succ: node->second->getSuccessorList()) {
                        visitNode->addSuccessor(succ);
                        succ->replacePredecessor(node->second, visitNode);
                    }

                    this->cfg.insert(std::make_pair(ifNode->getId(), ifNode));
                    this->cfg.insert(std::make_pair(waitNode->getId(), waitNode));
                    this->cfg.insert(std::make_pair(readNode->getId(), readNode));
                    this->cfg.insert(std::make_pair(visitNode->getId(), visitNode));

                    commGroup.push_back(ifNode);
                    commGroup.push_back(waitNode);
                    commGroup.push_back(readNode);
                    commGroup.push_back(visitNode);
                    this->commGroups.insert(std::make_pair(PrintStmt::toString(node->second->getStmt()), commGroup));
                } else {
                    this->cfg.insert(std::make_pair(node->second->getId(), node->second));
                }
            }
            node++;
        }

//        for (auto n : this->cfg) {
//            std::cout  << n.second->print();
//        }

//        TERMINATE(" YOOOOO ");
    }

    const std::map<int, CFGNode2 *> &ExpandCommunications::getCFG() const {
        return this->cfg;
    }

    const std::multimap<std::string, std::vector<SCAM::CFGNode2 *>> &ExpandCommunications::getCommGroups() const {
        return this->commGroups;
    }

}
