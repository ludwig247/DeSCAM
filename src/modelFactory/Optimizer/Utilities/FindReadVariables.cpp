//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include "FindReadVariables.h"
#include "Optimizer/Debug.h"

SCAM::FindReadVariables::FindReadVariables(const std::map<int, CfgNode *> &CFG) : CFG(CFG) {

    if (!CFG.empty()) {
        for (auto node: CFG) {
            if (auto statement = node.second->getStmt()) {
                if (auto readStmt = dynamic_cast<SCAM::Read *>(statement)) {
                    //variable operand
                    if (readStmt->getVariableOperand()->getVariable()->isSubVar()) {
                        auto parentVar = readStmt->getVariableOperand()->getVariable()->getParent();
                        this->readVariablesSet.insert(parentVar->getFullName());
                        for (auto subVar : parentVar->getSubVarList()) {
                            this->readVariablesSet.insert(subVar->getFullName());
                        }
                    } else if (readStmt->getVariableOperand()->getVariable()->isCompoundType() ||
                               readStmt->getVariableOperand()->getVariable()->isArrayType()) {
                        this->readVariablesSet.insert(readStmt->getVariableOperand()->getVariable()->getFullName());
                        for (auto subVar : readStmt->getVariableOperand()->getVariable()->getSubVarList()) {
                            this->readVariablesSet.insert(subVar->getFullName());
                        }
                    } else {
                        this->readVariablesSet.insert(readStmt->getVariableOperand()->getVariable()->getFullName());
                    }
                    //status operand
                    if (readStmt->getStatusOperand()) {
                        if (readStmt->getStatusOperand()->getVariable()->isSubVar()) {
                            auto parentVar = readStmt->getStatusOperand()->getVariable()->getParent();
                            this->readVariablesSet.insert(parentVar->getFullName());
                            this->readVariablesSet.insert(readStmt->getStatusOperand()->getVariable()->getFullName());
                        } else if (readStmt->getStatusOperand()->getVariable()->isCompoundType() ||
                                   readStmt->getStatusOperand()->getVariable()->isArrayType()) {
                            this->readVariablesSet.insert(readStmt->getStatusOperand()->getVariable()->getFullName());
                            for (auto subVar : readStmt->getStatusOperand()->getVariable()->getSubVarList()) {
                                this->readVariablesSet.insert(subVar->getFullName());
                            }
                        } else {
                            this->readVariablesSet.insert(readStmt->getStatusOperand()->getVariable()->getFullName());
                        }
                    }
                } else if (auto writeStmt = dynamic_cast<SCAM::Write *>(statement)) {
                    //status operand
                    if (writeStmt->getStatusOperand()) {
                        if (writeStmt->getStatusOperand()->getVariable()->isSubVar()) {
                            auto parentVar = writeStmt->getStatusOperand()->getVariable()->getParent();
                            this->readVariablesSet.insert(parentVar->getFullName());
                            this->readVariablesSet.insert(writeStmt->getStatusOperand()->getVariable()->getFullName());
                        } else if (writeStmt->getStatusOperand()->getVariable()->isCompoundType() ||
                                   writeStmt->getStatusOperand()->getVariable()->isArrayType()) {
                            for (auto subVar : writeStmt->getStatusOperand()->getVariable()->getSubVarList()) {
                                this->readVariablesSet.insert(subVar->getFullName());
                            }
                        } else {
                            this->readVariablesSet.insert(writeStmt->getStatusOperand()->getVariable()->getFullName());
                        }
                    }
                }
            }
        }
    }
#ifdef DEBUG_FIND_READ_VARIABLES
    std::cout << "Read Variables Set:" << std::endl;
        for(auto Variable : this->readVariablesSet ){
            std::cout << variable << " ";
        }
        std::cout << std::endl;
#endif
}

const std::set<std::string> &SCAM::FindReadVariables::getReadVariablesSet() const {
    return this->readVariablesSet;
}

