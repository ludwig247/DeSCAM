//
// Created by tobias on 01.07.16.
//




#include <algorithm>
#include <StmtNodeAlloc.h>
#include <NodePeekVisitor.h>
#include "PropertyFactory.h"
#include "toPPA/OnlyBlockingComm.h"
#include "../optimizePPA/OptimizeMaster.h"
#include "../optimizePPA/OptimizeSlave.h"
#include "../optimizePPA/OptimizeOperations.h"
#include "toPPA/CreateInitSection.h"
#include "OperationProperty.h"
//#include "OptimizeOperations.h"


SCAM::PropertyFactory::PropertyFactory(SCAM::Module *module) :
        module(module) {

    //Can't analyze model with  an empty section
    for (auto section: module->getFSM()->getSectionMap()) {
        if (section.second.empty()) throw std::runtime_error(module->getName() + ": Section " + section.first + " empty!");
    }

    this->createInitSection(this->module); //TODO: move to the place where the sectionMap is added to the model
    this->createPaths();

    std::cout << "" << std::endl;
    std::cout << "======================" << std::endl;
    std::cout << "PPA generation:" << std::endl;
    std::cout << "----------------------" << std::endl;
    std::cout << "Create Paths:"  << this->getPathCnt() << std::endl;
    this->addCommunication();
    std::cout << "Add communication: " << this->getPathCnt() << std::endl;
    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);
    this->createCommToCommPaths();
    std::cout << "Comm to Comm: " << this->getPathCnt() << std::endl;
    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);
    this->valuePropagation();
    std::cout << "Value Propagation:"  << this->getPathCnt() << std::endl;
    this->sectionPathMap = CleanUpPaths::deleteDuplicatedPaths(this->sectionPathMap);
    //
    this->sectionPathMap = CleanUpPaths::deleteUnreachablePaths(this->sectionPathMap);
    //
    std::cout << "Clean-up: " << this->getPathCnt() <<  std::endl;

    this->optimizeConditions();
    std::cout << "Optimized conditions" << std::endl;
    this->optimizeDataPath();
    std::cout << "Optimized datapath" << std::endl;

    std::cout << "Optimization: " << this->getPathCnt() << std::endl;
    this->createCommunicationFSM();
    //std::cout << print() << std::endl;
    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->module->getFSM()->getOperationPathMap();
    OptimizeMaster optimizeMaster(this->module->getFSM()->getStateMap(), this->module, operation_path_map);
    OptimizeSlave optimizeSlave(optimizeMaster.getNewStateMap(), this->module, optimizeMaster.getOperationPathMap());
    OptimizeOperations optimizeOperations(optimizeSlave.getNewStateMap(), this->module);
    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();


    relocateOpStmts(this->stateMap, module);
    module->setPropertySuite(generatePropertySuite());
}

SCAM::PropertyFactory::~PropertyFactory() {
    Path::resetPathCnt();
}


/** \brief Creates the InitSection
 *
 * The init section is implicitly defined through
 * the initialValues of the variables and the initialValue of the sectionVariable
 * Init section may not be used by the user -> Throw error in this case
 */
void SCAM::PropertyFactory::createInitSection(SCAM::Module *module) {
    //Does init section already exist?
    if (module->getFSM()->getSectionMap().find("init") != this->module->getFSM()->getSectionMap().end()) {
        throw std::runtime_error("@INIT: is a reserved section name, may not be used by the user");
    }

    //Add new SectionPathMap to FSM
    std::map<std::string, std::vector<SCAM::Stmt *>> newSectionPathMap = module->getFSM()->getSectionMap();
    std::vector<SCAM::Stmt *> initList = CreateInitSection::createInitSection(*module);
    newSectionPathMap.insert(std::make_pair("init", initList));
    module->getFSM()->setSectionMap(newSectionPathMap);

}

/** \brief Splits the non sequential sections into sequential paths
 *
 *  For each branch in a section there will be two paths
 */
void SCAM::PropertyFactory::createPaths() {
    SectionToPaths sectionToPaths(module->getFSM()->getSectionMap());
    this->sectionPathMap = sectionToPaths.getNewSectionPathMap();
}

/** \brief Enforce only 1 communication point in a sequential path
 *
 *  Unitl now, sections are only translated to paths.
 *  Paths can contain multiple communication statements.
 *  A transition in the PPA starts with a communication state and ends with a communication state.
 *  In order to compute the datapath between two communication states we need a path from one communication state to another.
 *  Hence all paths are split up at a communication point.
 *  All stmts before a communication belong to the previous path.
 *  This step might be merged with createPaths, bAlteut would make debugging more complicated since flattening the paths is a recursive Method.
 *
 *  Another benefit is that it is possible to create paths that allow multiple communications within 1 step.
 *  For now, only 1 communication per path is allowed
 */
void SCAM::PropertyFactory::addCommunication() {
    //Traverse paths contain communictions and split them according a specific policy
    //SingleCommunication singleCommunication(this->sectionPathMap);
    //SingleCommV2 singleCommunication(this->sectionPathMap);
    OnlyBlockingComm onlyBlockingComm(this->sectionPathMap);

    //Update the sectionPathMap
    this->sectionPathMap = onlyBlockingComm.getNewSectionPathMap();

    //Each communication stmt will represent a state in the PPA
    this->stateMap = onlyBlockingComm.getStateMap();

}

/** \brief Create paths that start and end in a communication
 *
 * Until now creation of paths was limited to section.
 * If a paths end at a section without a communication it's nextstate will just be section.
 * In order to have a valid PPA a path starts and ends with a communication.
 *
 */
void SCAM::PropertyFactory::createCommToCommPaths() {

    CommToCommNew commToComm(this->sectionPathMap, module);
    this->sectionPathMap = commToComm.getNewSectionPathMap();

}

//
//! Optimizes the paths regarding assignments and constants
void SCAM::PropertyFactory::valuePropagation() {
    ValuePropagation valuePropagation(this->sectionPathMap, module);
    this->sectionPathMap = valuePropagation.getNewSectionPathMap();
}

/** \brief Simpliefies conditions using Z3 SMT Solver
 *
 * Expression will be simplified: e.G:
 * cnt < 10 && cnt == 3 && x == cnt
 * is simplified to:
 * cnt == 3 && x == 3
 * which is way easier to read and understand
 */
void SCAM::PropertyFactory::optimizeConditions() {

    this->sectionPathMap = ConditionOptimizer::optimize(this->sectionPathMap, module);

}

/** \brief Simpliefies the datapath expr using Z3 SMT Solver
 *
 * Expression will be simplified: e.G:
 * x = ((x+3)+2)+1
 * is simplified to:
 * x = x + 6
 * which is way easier to read and understand
 */
void SCAM::PropertyFactory::optimizeDataPath() {
    this->sectionPathMap = DataPathOptimizer::optimize(this->sectionPathMap, module);

}

/** \brief Creates the communication FSM from the paths
 *
 * Each path already contains its starting state and end state
 * Here the Operations are created by transforming the information from the paths.
 * They already contain all information.
 * The datastructure is a more efficient representation of the statemachine.
 * The communication FSM is also stored in the FSM of the module
 *
 */
void SCAM::PropertyFactory::createCommunicationFSM() {
    for (auto section: sectionPathMap) {
        for (auto path: section.second) {
            //From state -> to state
            Operation *op;
            int from = -1;
            if (path->getSection() != "init") from = std::stoi(path->getSubState());
            int to = std::stoi(path->getSubNext());
            op = new Operation(stateMap.at(from), stateMap.at(to));
            //Assumptions
            for (auto assumption: path->getConditionList()) {
                op->addAssumption(assumption);
            }
            for (auto commCond: path->getCommunicationConditionList()) {
                op->addAssumption(commCond);
            }
            //Commitment
            for (auto commitment: path->getDataPathList()) {
                op->addCommitment(commitment);
            }
            //Additional info: state a wait-state?
            op->setWait(path->isWait());
            this->operationPathMap.insert(std::make_pair(op, path));
            this->operationList.push_back(op);
        }
    }

    this->module->getFSM()->setStateMap(this->stateMap);
    this->module->getFSM()->setOperationPathMap(this->operationPathMap);

}


std::string SCAM::PropertyFactory::print() {
    std::stringstream ss;
    //Number of total paths:
    int cnt = 0;
    ss << "Module: " << module->getName() << " \n";
    for (auto section: this->sectionPathMap) {
        for (auto path: section.second) {
            ss << path->print() << "\n";
            ss << "";
            cnt++;
        }
    }
    ss << "\n ++++++++#Paths: " << cnt << "\n";
    return ss.str();
}

std::string SCAM::PropertyFactory::printOperations() {
    std::stringstream ss;
    for (auto &&state : this->stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            ss << op->print();
            ss << "\n";
        }
    }
    return ss.str();
}

const std::map<std::string, std::vector<SCAM::Path *>> &SCAM::PropertyFactory::getSectionPathMap() const {
    return sectionPathMap;
}

int SCAM::PropertyFactory::getPathCnt() {
    int cnt = 0;
    for(auto section: sectionPathMap){
        for(auto path: section.second){
            cnt++;
        }
    }
    return cnt;
}


/** \brief Generates the PropertySuite base on the module
 *
 * Starting from the module, all necessary information for creating the properties is extracted
 * and stored in the PropertySuite
 *
 */
SCAM::PropertySuite * SCAM::PropertyFactory::generatePropertySuite() {

    // Generate PropertySuite
    PropertySuite * propertySuite = new PropertySuite(module->getName());


    // SYNC AND NOTIFY SIGNALS
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            PropertyMacro * pm = new PropertyMacro(port.first+"_notify", port.second, port.second->getNotify(), DataTypes::getDataType("bool"));
            propertySuite->addNotifySignal(pm);
        }
        if (!interface->isMaster() && !interface->isSlaveOut()) {
            PropertyMacro * pm = new PropertyMacro(port.first+"_sync", port.second, port.second->getSynchSignal(), DataTypes::getDataType("bool"));
            propertySuite->addSyncSignal(pm);
        }
    }


    // DP SIGNALS
    for (auto port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        if (!port.second->getDataType()->isCompoundType()) {
            PropertyMacro * pm = new PropertyMacro(port.first+"_sig", port.second, port.second->getDataType());
            propertySuite->addDpSignal(pm);
        } else {
            for (auto subVar: port.second->getDataType()->getSubVarMap()) {
                PropertyMacro * pm = new PropertyMacro(port.first+"_sig", port.second, subVar.second, subVar.first);
                propertySuite->addDpSignal(pm);
            }
        }
    }


    // VISIBLE REGISTERS
    for (auto stateVar: this->stateVarMap) {
        // Check for Array-Types
        if (stateVar.second->isSubVar() && stateVar.second->getParent()->isArrayType()) {

            // Check if Macro for parent already exists
            Variable * parent = stateVar.second->getParent();
            PropertyMacro * parentMacro;
            try {
                parentMacro = propertySuite->findSignal(parent);
            } catch (const std::runtime_error& e) {
                // If not, add macro for parent
                parentMacro = new PropertyMacro(parent->getName(), parent, parent->getDataType());
                propertySuite->addVisibleRegister(parentMacro);
            }
            auto pm = new PropertyMacro(stateVar.first, stateVar.second, parentMacro, stateVar.second->getDataType());
            propertySuite->addVisibleRegister(pm);

        } else if (stateVar.second->isSubVar()){
            auto pm = new PropertyMacro(stateVar.second->getParent()->getName(), stateVar.second, stateVar.second->getDataType(), stateVar.second->getName());
            propertySuite->addVisibleRegister(pm);

        } else {
            auto pm = new PropertyMacro(stateVar.first, stateVar.second, stateVar.second->getDataType());
            propertySuite->addVisibleRegister(pm);
        }
    }


    // STATES
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        //TODO: SCAM::State has no Stmt type
        Variable * stateVar = new Variable(state.second->getName(), DataTypes::getDataType("bool"));
        PropertyMacro * pm = new PropertyMacro(stateVar->getName(), stateVar);
        pm->setExpression(new BoolValue(true));
        propertySuite->addState(pm);
    }


    // FUNCTIONS
    for (auto function: module->getFunctionMap()) {
        propertySuite->addFunction(function.second);
    }


    // RESET PROPERTY
    for (auto state : this->stateMap){
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->getState()->isInit()) {

                PropertyMacro * nextState = propertySuite->findSignal(operation->getNextState()->getName());
                propertySuite->getResetProperty()->setNextState(nextState);

                // Add commitments for ResetProperty
                for (auto commitment: operation->getCommitmentList()) {
                    propertySuite->getResetProperty()->addCommitment(commitment);
                }

                //Notify&Sync Signals, no notification for shareds
                std::set<Port *> usedPortsList;
                for (auto commitment: operation->getCommitmentList()) {
                    //Add all output port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                        if (port->getInterface()->isOutput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
                for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                    for (auto commitment: nextOp->getCommitmentList()) {
                        //Add all input port that are used within this operation
                        for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                            if (port->getInterface()->isInput()) {
                                usedPortsList.insert(port);
                            }
                        }
                    }
                }

                usedPortsList.insert(operation->getNextState()->getCommPort());

                for (auto port: module->getPorts()) {
                    if (port.second->getInterface()->isShared()) continue;
                    if (port.second->getInterface()->isSlaveIn()) continue;
                    if (port.second->getInterface()->isSlaveOut()) continue;
                    if (port.second->getInterface()->isMasterIn()) continue;

                    PropertyMacro * signalMacro = propertySuite->findSignal(port.first+"_notify");
                    if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        propertySuite->getResetProperty()->addCommitment(new Assignment(signalMacro->getNotifySignal(), new BoolValue(true)));
                    } else {
                        propertySuite->getResetProperty()->addCommitment(new Assignment(signalMacro->getNotifySignal(), new BoolValue(false)));
                    }


                }

                break;
            }
        }
    }


    // OPERATION PROPERTIES
    std::string t_end;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {

            if (operation->isWait()) continue;

            std::string name;
            if (operation->getState()->isRead()) {
                name = operation->getState()->getName() + "_read_" + std::to_string(propertySuite->getOperationProperties().size());
            } else if (operation->getState()->isWrite()) {
                name = operation->getState()->getName() + "_write_" + std::to_string(propertySuite->getOperationProperties().size());
            }
            auto newOperationProperty = new OperationProperty(name);

            newOperationProperty->addConstraint(propertySuite->getConstraint("no_reset"));

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string, std::string> freezeVarMap;
            std::vector<SCAM::Assignment *, std::allocator<SCAM::Assignment *>>::const_iterator assignment;
            for (assignment = operation->getCommitmentList().begin();
                 assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }

            // TODO: Does it make sense to check for sync signals (inputs)?
            for (auto sync: syncSignals) {
                PropertyMacro * signalMacro = propertySuite->findSignal(sync->getPort()->getName()+"_sync");
                newOperationProperty->addFreezeSignal(signalMacro);
            }
            for (auto var: variables) {
                PropertyMacro * signalMacro = propertySuite->findSignal(var);
                    newOperationProperty->addFreezeSignal(signalMacro);
            }
            for (auto dataSig: dataSignals) {
                PropertyMacro * signalMacro;
                try {
                    signalMacro = propertySuite->findSignal(dataSig->getName());
                } catch (const std::runtime_error& e) {
                    signalMacro = propertySuite->findSignal(dataSig->getPort()->getName()+"_sig", dataSig->getName());
                }
                newOperationProperty->addFreezeSignal(signalMacro);
            }

            PropertyMacro * state = propertySuite->findSignal(operation->getState()->getName());
            PropertyMacro * nextState = propertySuite->findSignal(operation->getNextState()->getName());
            newOperationProperty->setState(state);
            newOperationProperty->setNextState(nextState);
            newOperationProperty->setAssumptionList(operation->getAssumptionList());
            newOperationProperty->setCommitmentList(operation->getCommitmentList());


            //Reset used ports:
            std::set<Port*> usedPortsList;
            for (auto commitment: operation->getCommitmentList()) {
                //Add all output port that are used within this operation
                for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                    if (port->getInterface()->isOutput()) {
                        usedPortsList.insert(port);
                    }
                }
            }
            //Add all possible inputs for the next state to usedPortsList, necessary because of merge of operations
            for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                for (auto commitment: nextOp->getCommitmentList()) {
                    //Add all input port that are used within this operation

                    for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                        if (port->getInterface()->isInput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
            }
            //Notify&Sync Signals, no notification for shareds, alwaysReady in ...
            for (auto port: module->getPorts()) {
                auto interface = port.second->getInterface();
                if (interface->isShared()) continue;
                if (interface->isSlaveIn()) continue;
                if (interface->isSlaveOut()) continue;
                if (interface->isMasterIn()) continue;

                if (module->isSlave()) {
                    if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        newOperationProperty->addTiming(port.second, TT_1);
                    } else {
                        newOperationProperty->addTiming(port.second, FF_1);
                    }
                } else {
                    if (port.second == operation->getNextState()->getCommPort()) {
                        newOperationProperty->addTiming(port.second, FT_e);
                    } else if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        newOperationProperty->addTiming(port.second, FT_e);
                    } else {
                        newOperationProperty->addTiming(port.second, FF_e);
                    }
                }
            }
            propertySuite->addOperationProperty(newOperationProperty);

        }
    }


    // WAIT PROPERTIES
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (!operation->isWait()) continue;

            WaitProperty* newWaitProperty = new WaitProperty("wait_" + operation->getState()->getName());

            newWaitProperty->addConstraint(propertySuite->getConstraint("no_reset"));


            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string, std::string> freezeVarMap;
            std::vector<SCAM::Assignment *, std::allocator<SCAM::Assignment *>>::const_iterator assignment;
            for (assignment = operation->getCommitmentList().begin();
                 assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }

            // TODO: Does it make sense to check for sync signals (inputs)?
            for (auto sync: syncSignals) {
                PropertyMacro * signalMacro = propertySuite->findSignal(sync->getPort()->getName()+"_sync");
                newWaitProperty->addFreezeSignal(signalMacro);
            }
            for (auto var: variables) {
                PropertyMacro * signalMacro = propertySuite->findSignal(var);
                    newWaitProperty->addFreezeSignal(signalMacro);
            }
            for (auto dataSig: dataSignals) {
                PropertyMacro * signalMacro;
                try {
                    signalMacro = propertySuite->findSignal(dataSig->getName());
                } catch (const std::runtime_error& e) {
                    signalMacro = propertySuite->findSignal(dataSig->getPort()->getName()+"_sig", dataSig->getName());
                }
                newWaitProperty->addFreezeSignal(signalMacro);
            }

            PropertyMacro * state = propertySuite->findSignal(operation->getState()->getName());
            PropertyMacro * nextState = propertySuite->findSignal(operation->getNextState()->getName());
            newWaitProperty->setState(state);
            newWaitProperty->setNextState(nextState);
            newWaitProperty->setAssumptionList(operation->getAssumptionList());
            newWaitProperty->setCommitmentList(operation->getCommitmentList());

            //Notify&Sync Signals, no notification for shareds
            for (auto port: module->getPorts()) {
                Interface *pI = port.second->getInterface();
                if (pI->isMasterIn()) continue;
                if (pI->isShared()) continue;

                PropertyMacro * signalMacro = propertySuite->findSignal(port.first+"_notify");
                if ((pI->isBlocking() || pI->isMasterOut()) && port.second != operation->getNextState()->getCommPort()) {
                    newWaitProperty->addCommitment(new Assignment(signalMacro->getNotifySignal(), new BoolValue(false)));
                } else {
                    newWaitProperty->addCommitment(new Assignment(signalMacro->getNotifySignal(), new BoolValue(true)));
                }

            }

            propertySuite->addWaitProperty(newWaitProperty);
        }
    }

    return propertySuite;
}


#define EXPERIMENTAL_SIMPLIFY_CONDITIONS 0

/** \brief Relocates and simplifies nodes, simplifies function conditions
 *
 * Relocates nodes and makes sure that every node is unique (no duplicate allocations)
 * Prior allocation nodes are simplified using SimplifyVisitor
 * If enabled function conditions are simplified
 */
void SCAM::PropertyFactory::relocateOpStmts(const std::map<int, SCAM::State *> &stateMap, Module *module) {
    for (auto state_it: stateMap) {
        for (auto op_it: state_it.second->getOutgoingOperationList()) {

            std::vector<Assignment *> newCommitmentList;
            bool listUpdated = false;
            for (auto commit_it: op_it->getCommitmentList()) {
                auto allocatedNodePtr = StmtNodeAlloc::allocNode(*commit_it, true);
                newCommitmentList.push_back(allocatedNodePtr);
                if (allocatedNodePtr != commit_it) {
                    listUpdated = true;
                }
            }
            if (listUpdated) {
                op_it->setCommitmentList(newCommitmentList);
            }

            std::vector<Expr *> newAssumptionList;
            listUpdated = false;
            for (auto assume_it: op_it->getAssumptionList()) {
                auto allocatedNodePtr = StmtNodeAlloc::allocNode(*assume_it, true);
                newAssumptionList.push_back(allocatedNodePtr);
                if (allocatedNodePtr != assume_it) {
                    listUpdated = true;
                }
            }
            if (listUpdated) {
                op_it->setAssumptionList(newAssumptionList);
            }
        }
    }
    bool listUpdated = false;
    for (auto func_it: module->getFunctionMap()) {
        std::vector<std::pair<Return *, std::vector<Expr *>>> newReturnValueConditionList;

#if EXPERIMENTAL_SIMPLIFY_CONDITIONS
        std::vector<Expr *> checkedConditions;
#endif
        for (auto return_it: func_it.second->getReturnValueConditionList()) {
            auto allocatedReturnNodePtr = StmtNodeAlloc::allocNode(*return_it.first, true);
            if (allocatedReturnNodePtr != return_it.first) {
                listUpdated = true;
            }

            std::vector<Expr *> conditions;
            for (auto cond_it: return_it.second) {
                auto allocatedNodePtr = StmtNodeAlloc::allocNode(*cond_it, true);

#if EXPERIMENTAL_SIMPLIFY_CONDITIONS
                // check and ignore repetitive conditions
                // TODO: should be performed using SAT solver, this is only temporary and experimental solution
                NodePeekVisitor nodePeek(allocatedNodePtr);
                if (nodePeek.nodePeekUnaryExpr()) {
                    bool entryFound = false;
                    for (auto it : checkedConditions) {
                        if (it == nodePeek.nodePeekUnaryExpr()->getExpr()) {
                            entryFound = true;
                        }
                    }
                    if (!entryFound) {
                        checkedConditions.push_back(allocatedNodePtr);
                        conditions.push_back(allocatedNodePtr);
                    } else listUpdated = true;
                } else {
                    bool entryFound = false;
                    for (auto it : checkedConditions) {
                        NodePeekVisitor nodePeek(it);
                        if (nodePeek.nodePeekUnaryExpr()) {
                            if (nodePeek.nodePeekUnaryExpr()->getExpr() == allocatedNodePtr) {
                                entryFound = true;
                            }
                        }
                    }
                    if (!entryFound) {
                        checkedConditions.push_back(allocatedNodePtr);
                        conditions.push_back(allocatedNodePtr);
                    } else listUpdated = true;
                }
#else
                conditions.push_back(allocatedNodePtr);
#endif

                if (allocatedNodePtr != cond_it) {
                    listUpdated = true;
                }
            }
            newReturnValueConditionList.push_back(std::make_pair(allocatedReturnNodePtr, conditions));
        }

        if (listUpdated) {
            func_it.second->setReturnValueConditionList(newReturnValueConditionList);
        }
    }
}










