//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/22/19.
//


#include <PrintStmt.h>
#include <PrintITL/ConditionVisitor.h>
#include <PrintITL/DatapathVisitor.h>
#include "OperationFactory.h"
#include "FindOperations.h"
#include "CreateOperations.h"
#include "ReconstructOperations.h"
#include "ValidOperations.h"
#include "OperationOptimizations/ConditionOptimizer2.h"
#include "OperationOptimizations/AssignmentOptimizer2.h"
#include "OperationOptimizations/OptimizeOperations2.h"
#include "PropertySuite.h"
#include "CreateOperationsSlave.h"
#include "../parser/CommandLineParameter.h"
#include <thread>

namespace SCAM {
    OperationFactory::OperationFactory(std::map<int, SCAM::CfgNode *> controlFlowMap, SCAM::Module * module) :
    propertySuite(nullptr),
    module(module),
    cfg(std::move(controlFlowMap)) {
        std::cout << "======================" << std::endl;
        std::cout << "Operations generation:" << std::endl;
        std::cout << "----------------------" << std::endl;
        std::cout << "Find Operations:" << std::endl;
        this->findOperations();
        std::cout << "\tFound: " << this->rawOperations.size() << std::endl;
        std::cout << "Create Operations: " << std::endl;
        this->createOperations();
        std::cout << "\tCreated: " << this->operations.size() << std::endl;

        std::cout << "Reconstruct Operations: " << std::endl;
        this->reconstructOperations();
        std::cout << "Valid Operations: " << std::endl;
        this->findValidOperations();
        std::cout << "\tValid: " << this->operations.size() << std::endl;
        this->checkStates();
        auto optimizerOptionsSet = CommandLineParameter::getOptimizeOptionsSet();
        if(optimizerOptionsSet.find("all")==optimizerOptionsSet.end() && optimizerOptionsSet.find("are")==optimizerOptionsSet.end()) {
            std::cout << "Optimizing conditions" << std::endl;
            this->optimizeConditions();
        }
        if(optimizerOptionsSet.find("all")==optimizerOptionsSet.end() && optimizerOptionsSet.find("sim")==optimizerOptionsSet.end()) {
            std::cout << "Optimizing Assignments" << std::endl;
            this->optimizeAssignments();
        }
        std::cout << "Optimization:" << std::endl;
        this->optimizeOperations();
        std::cout << "Generating PropertySuite:" << std::endl;
        std::map<int,State2*> stateMap;
        for(auto state: this->statesMap){
            state.second->setName(state.second->getName() + "_" + std::to_string(state.second->getStateId()));
            stateMap.insert(std::make_pair(state.second->getStateId(), state.second));
        }
        this->module->getFSM()->setStateMap(stateMap);
        this->generatePropertySuite();

    }

    PropertySuite* OperationFactory::getPropertySuite() const {
        return this->propertySuite;
    }

    void OperationFactory::findOperations() {
        SCAM::FindOperations ctest(cfg,this->module);
        this->statesMap = ctest.getStatesMap();
        this->rawOperations = ctest.getOperations();
    }

    void OperationFactory::createOperations() {
        if(this->module->isSlave()) {
            SCAM::CreateOperationsSlave cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        } else {
            SCAM::CreateOperations cOperations(this->rawOperations, this->statesMap, this->module);
            this->operations = cOperations.getOperationsList();
            this->statesMap = cOperations.getStatesMap();
        }
    }

    void OperationFactory::reconstructOperations() {
        SCAM::ReconstructOperations rOperations(this->statesMap, this->module);
        for (auto op : this->operations) {
            rOperations.sortOperation(op);
        }
    }

    void OperationFactory::findValidOperations() {
        std::vector<SCAM::Operation2*> validOperations;
        for (auto op : this->operations) {
            if (SCAM::ValidOperations::isOperationReachable(op)) {
                validOperations.push_back(op);
            } else {
                /// Remove from stateList operations
                auto state = op->getState();
                state->removeOutgoingOperation(op);

                state = op->getNextState();
                state->removeIncomingOperation(op);
            }
        }
        this->operations = validOperations;
    }

    void OperationFactory::checkStates() {
        for (const auto& state : this->statesMap) {
            if (state.second->isInit()) continue;

            if ( state.second->getIncomingOperationsList().empty())
                std::cout << "\t\033[1;33mWarning\033[0m: (" << state.first << ") is unreachable! consider removing it.\n";
        }
    }

    void OperationFactory::optimizeConditions() {
        for (auto operation : operations) {
            ConditionOptimizer2 conditionOptimizer2(operation->getAssumptionsList(), module);
            operation->setAssumptionsList(conditionOptimizer2.getNewConditionList());
        }
    }

    void OperationFactory::optimizeAssignments() {
        for (auto op : operations) {
            AssignmentOptimizer2 assignmentOptimizer2(op->getCommitmentsList(), module);
            op->setCommitmentsList(assignmentOptimizer2.getNewAssignmentsList());
        }
    }

    void OperationFactory::optimizeOperations() {
        SCAM::OptimizeOperations2 oOperations(this->operations, module);
        this->operations = oOperations.getOperationsList();
        this->varMap = oOperations.getNewVarMap();
    }


    void OperationFactory::generatePropertySuite() {
        // Generate PropertySuite
        this->propertySuite = new PropertySuite(module->getName());


        // SYNC AND NOTIFY SIGNALS
        for (auto port: module->getPorts()) {
            auto interface = port.second->getInterface();
            if (interface->isShared()) continue;
            if (interface->isMasterOut() || interface->isBlocking()) {
                PropertyMacro *pm = new PropertyMacro(port.first + "_notify", port.second, port.second->getNotify(), DataTypes::getDataType("bool"));
                propertySuite->addNotifySignal(pm);
            }
            if (!interface->isMaster() && !interface->isSlaveOut()) {
                PropertyMacro *pm = new PropertyMacro(port.first + "_sync", port.second, port.second->getSynchSignal(), DataTypes::getDataType("bool"));
                propertySuite->addSyncSignal(pm);
            }
        }


        // DP SIGNALS
        for (const auto& port: module->getPorts()) {
            if (port.second->getDataType()->isVoid()) continue;

            if(port.second->getDataType()->isCompoundType() || port.second->getDataType()->isArrayType()){
                //Add compound type signal
                PropertyMacro *pm = new PropertyMacro(port.first + "_sig", port.second, port.second->getDataType());
                propertySuite->addDpSignal(pm);
                //Add all subignals of the compound type
                for (const auto& subVar: port.second->getDataType()->getSubVarMap()) {
                    PropertyMacro *pm = new PropertyMacro(port.first + "_sig", port.second, subVar.second, subVar.first);
                    propertySuite->addDpSignal(pm);
                }
            }else{
                PropertyMacro *pm = new PropertyMacro(port.first + "_sig", port.second, port.second->getDataType());
                propertySuite->addDpSignal(pm);
            }
        }


        // VISIBLE REGISTERS
        for (const auto& var: this->varMap) {
            // Check for Array-Types
            if (var.second->isSubVar() && var.second->getParent()->isArrayType()) {
                // Check if Macro for parent already exists
                Variable *parent = var.second->getParent();
                PropertyMacro *parentMacro;
                //TODO: remove try/Write
                try {
                    parentMacro = propertySuite->findSignal(parent);
                } catch (const std::runtime_error &e) {
                    // If not, add macro for parent
                    parentMacro = new PropertyMacro(parent->getName(), parent, parent->getDataType());
                    propertySuite->addVisibleRegister(parentMacro);
                }
                auto pm = new PropertyMacro(var.first, var.second, parentMacro, var.second->getDataType());
                propertySuite->addVisibleRegister(pm);

            } else if (var.second->isSubVar()) {
                auto pm = new PropertyMacro(var.second->getParent()->getName(), var.second, var.second->getDataType(), var.second->getName());
                propertySuite->addVisibleRegister(pm);
            } else {
                auto pm = new PropertyMacro(var.first, var.second, var.second->getDataType());
                propertySuite->addVisibleRegister(pm);
            }
        }

        // STATES
        for (const auto& state: this->statesMap) {
            if (state.second->isInit()) continue;
            //std::cout << state.second->getName() << std::endl;

            state.second->setName(state.second->getName());
            Variable *stateVar = new Variable(state.second->getName(), DataTypes::getDataType("bool"));
            PropertyMacro *pm = new PropertyMacro(state.second->getName(), stateVar);
            pm->setExpression(new BoolValue(true));
            propertySuite->addState(pm);
        }


        // FUNCTIONS
        for (const auto& function: module->getFunctionMap()) {
            propertySuite->addFunction(function.second);
        }


        // RESET PROPERTY
        for (const auto& state: this->statesMap) {
            if (!state.second->isInit()) continue;
            assert((state.second->getOutgoingOperationsList().size() == 1) && "Only one operation allowed to start from init");

            for (auto operation : state.second->getOutgoingOperationsList()) {

                assert((operation->getState()->isInit()) && "Operation should be starting from init state");
                auto t_var = new TimeExpr("t");
                auto t = new TimeExprOperand(t_var);
                PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
                auto nextStateExpr = new TemporalExpr(t, nextState->getVariableOperand());

                propertySuite->getResetProperty()->addCommitment(nextStateExpr);
                //propertySuite->getResetProperty()->setNextState(nextState);

                // Add commitments for ResetProperty
                for (auto commitment: operation->getCommitmentsList()) {
                    propertySuite->getResetProperty()->addCommitment(new TemporalExpr(t, commitment));
                    //propertySuite->getResetProperty()->addCommitment(commitment);
                }

                //Notify&Sync Signals, no notification for shareds
                std::set<Port *> usedPortsList;
                for (auto commitment: operation->getCommitmentsList()) {
                    //Add all output port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                        if (port->getInterface()->isOutput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
                if(!operation->getNextState()->isWait())
                    usedPortsList.insert(operation->getNextState()->getCommunicationPort());

                for (auto port: module->getPorts()) {
                    if (port.second->getInterface()->isShared()) continue;
                    if (port.second->getInterface()->isSlaveIn()) continue;
                    if (port.second->getInterface()->isSlaveOut()) continue;
                    if (port.second->getInterface()->isMasterIn()) continue;

                    PropertyMacro *signalMacro = propertySuite->findSignal(port.first + "_notify");
                    if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        auto commitment = new TemporalExpr(t, new Assignment(signalMacro->getNotifySignal(), new BoolValue(true)));
                        propertySuite->getResetProperty()->addCommitment(commitment);
                    } else {
                        auto commitment = new TemporalExpr(t, new Assignment(signalMacro->getNotifySignal(), new BoolValue(false)));
                        propertySuite->getResetProperty()->addCommitment(commitment);
                    }
                }
                break;
            }
        }


        // OPERATION PROPERTIES
        for (const auto& state : this->statesMap) {
            if (state.second->isInit()) continue;
            for (auto operation : state.second->getOutgoingOperationsList()) {
                if (operation->IsWait()) continue;

                std::string operationName = operation->getState()->getName() + "_" + std::to_string(operation->getId());
                auto newProperty = new Property(operationName);

                auto t_var = new TimeExpr("t");
                auto t = new TimeExprOperand(t_var);

                auto t_end_var = new TimeExpr("t_end");
                auto t_end = new TimeExprOperand(t_end_var);

                newProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", new IntegerValue(1)));

                newProperty->addConstraint(propertySuite->getConstraint("no_reset"));

                //FREEZE VARS
                std::set<SCAM::SyncSignal *> syncSignals;
                std::set<SCAM::Variable *> variables;
                std::set<SCAM::DataSignal *> dataSignals;
                std::set<std::string> freezeVars;
                for (auto assignment : operation->getCommitmentsList()) {
                    //Find all objects that need to be freezed
                    auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
                    syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                    auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                    variables.insert(newVariables.begin(), newVariables.end());
                    auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
                    dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
                }

                // TODO: Does it make sense to check for sync signals (inputs)?
                for (auto sync: syncSignals) {
                    PropertyMacro *signalMacro = propertySuite->findSignal(sync->getPort()->getName() + "_sync");
                    newProperty->addFreezeSignal(signalMacro, t_var);
                }
                for (auto var: variables) {
                        if(var->isConstant()) continue;
                        PropertyMacro *signalMacro = propertySuite->findSignal(var);
                        newProperty->addFreezeSignal(signalMacro, t_var);
                }
                for (auto dataSig: dataSignals) {
                    PropertyMacro *signalMacro;
                    //TODO remove try/catch
                    if(dataSig->isSubVar()){
                        signalMacro = propertySuite->findSignal(dataSig->getPort()->getName()+"_sig" , dataSig->getName());
                    }else{
                        signalMacro = propertySuite->findSignal(dataSig->getName());
                    }

//                    try {
//                        if(dataSig->isSubVar() && dataSig->getParent()->isArrayType())
//                            signalMacro = propertySuite->findSignal(dataSig->getParent()->getName());
//                        else
//                            signalMacro = propertySuite->findSignal(dataSig->getName());
//                    } catch (const std::runtime_error &e) {
//                        signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() , dataSig->getName());
//                    }
                    newProperty->addFreezeSignal(signalMacro, t_var);
                }

                PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
                PropertyMacro *nextState  = propertySuite->findSignal(operation->getNextState()->getName());
                auto startStateExpr = new TemporalExpr(t, startState->getVariableOperand());
                auto nextStateExpr  = new TemporalExpr(t,  nextState->getVariableOperand());
                propertySuite->getResetProperty()->addAssumption(startStateExpr);
                propertySuite->getResetProperty()->addCommitment( nextStateExpr);

                for (auto assumption : operation->getAssumptionsList()) {
                    newProperty->addAssumption(new TemporalExpr(t, assumption));
                }
                for (auto commitment : operation->getCommitmentsList()) {
                    newProperty->addCommitment(new TemporalExpr(t_end, commitment));
                }

                //Reset used ports:
                std::set<Port *> usedPortsList;
                for (auto commitment: operation->getCommitmentsList()) {
                    //Add all output port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                        if (port->getInterface()->isOutput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
                //Add all possible inputs for the next state to usedPortsList, necessary because of merge of operations
                for (auto nextOp: operation->getNextState()->getOutgoingOperationsList()) {
                    for (auto commitment: nextOp->getCommitmentsList()) {
                        //Add all input port that are used within this operation
                        for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                            if (port->getInterface()->isInput()) {
                                usedPortsList.insert(port);
                            }
                        }
                    }
                }

                auto t_plus_1 = new Arithmetic(t, "+", new IntegerValue(1));
                auto t_end_minus_1 = new Arithmetic(t_end, "-", new IntegerValue(1));

                //Notify&Sync Signals, no notification for shareds, alwaysReady in ...
                for (auto port: module->getPorts()) {
                    auto interface = port.second->getInterface();
                    if (interface->isShared()) continue;
                    if (interface->isSlaveIn()) continue;
                    if (interface->isSlaveOut()) continue;
                    if (interface->isMasterIn()) continue;

                    if (module->isSlave()) {
                        if (usedPortsList.find(port.second) != usedPortsList.end()) {
                            auto commitment = new Assignment(port.second->getNotify(), new BoolValue(true));
                            newProperty->addCommitment(new TemporalExpr(t_plus_1, commitment));
                        } else {
                            auto commitment = new Assignment(port.second->getNotify(), new BoolValue(false));
                            newProperty->addCommitment(new TemporalExpr(t_plus_1, commitment));
                        }
                    } else {
                        if (port.second == operation->getNextState()->getCommunicationPort()) { //if NextState is a wait state it will have null_ptr as CommunicationPort
                            auto commitment1 = new Assignment(port.second->getNotify(), new BoolValue(false));
                            auto commitment2 = new Assignment(port.second->getNotify(), new BoolValue(true));
                            newProperty->addCommitment(new TemporalExpr(t_plus_1, t_end_minus_1, commitment1));
                            newProperty->addCommitment(new TemporalExpr(t_end, commitment2));
                        } else if (usedPortsList.find(port.second) != usedPortsList.end()) {
                            auto commitment1 = new Assignment(port.second->getNotify(), new BoolValue(false));
                            auto commitment2 = new Assignment(port.second->getNotify(), new BoolValue(true));
                            newProperty->addCommitment(new TemporalExpr(t_plus_1, t_end_minus_1, commitment1));
                            newProperty->addCommitment(new TemporalExpr(t_end, commitment2));
                        } else {
                            auto commitment = new Assignment(port.second->getNotify(), new BoolValue(false));
                            newProperty->addCommitment(new TemporalExpr(t_plus_1, t_end, commitment));
                        }
                    }
                }
                propertySuite->addProperty(newProperty);
            }
        }

        // WAIT PROPERTIES

        for (const auto& state : this->statesMap) {
            if (state.second->isInit()) continue;
            for (auto operation : state.second->getOutgoingOperationsList()) {
                if (!operation->IsWait()) continue;

                auto *newProperty = new Property("wait_" + operation->getState()->getName());

                auto t_var = new TimeExpr("t");
                auto t = new TimeExprOperand(t_var);

                auto t_plus_1 = new Arithmetic(t, "+", new IntegerValue(1));

                newProperty->addConstraint(propertySuite->getConstraint("no_reset"));

                //FREEZE VARS
                std::set<SCAM::SyncSignal *> syncSignals;
                std::set<SCAM::Variable *> variables;
                std::set<SCAM::DataSignal *> dataSignals;
                std::set<std::string> freezeVars;
                std::map<std::string, std::string> freezeVarMap;
                for (auto assignment : operation->getCommitmentsList()) {
                    //Find all objects that need to be freezed
                    auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
                    syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                    auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                    variables.insert(newVariables.begin(), newVariables.end());
                    auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
                    dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
                }

                for (auto sync: syncSignals) {
                    PropertyMacro *signalMacro = propertySuite->findSignal(sync->getPort()->getName() + "_sync");
                    newProperty->addFreezeSignal(signalMacro, t_var);
                }
                for (auto var: variables) {
                        if(var->isConstant()) continue;
                        PropertyMacro *signalMacro = propertySuite->findSignal(var);
                        newProperty->addFreezeSignal(signalMacro, t_var);
                }
                for (auto dataSig: dataSignals) {
                    //TODO: remove try/catch
                    PropertyMacro *signalMacro;

                    try {
                        if(dataSig->isSubVar() && dataSig->getParent()->isArrayType())
                            signalMacro = propertySuite->findSignal(dataSig->getParent()->getName());
                        else
                            signalMacro = propertySuite->findSignal(dataSig->getName());
                    } catch (const std::runtime_error &e) {
                        signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
                    }
                    newProperty->addFreezeSignal(signalMacro, t_var);
                }

                PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
                PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
                auto startStateExpr = new TemporalExpr(t, startState->getVariableOperand());
                auto nextStateExpr  = new TemporalExpr(t,  nextState->getVariableOperand());
                propertySuite->getResetProperty()->addAssumption(startStateExpr);
                propertySuite->getResetProperty()->addCommitment( nextStateExpr);

                for (auto assumption : operation->getAssumptionsList()) {
                    newProperty->addAssumption(new TemporalExpr(t, assumption));
                }
                for (auto commitment : operation->getCommitmentsList()) {
                    newProperty->addCommitment(new TemporalExpr(t_plus_1, commitment));
                }

                //Notify&Sync Signals, no notification for shareds
                for (auto port: module->getPorts()) {
                    Interface *pI = port.second->getInterface();
                    if (pI->isMasterIn()) continue;
                    if (pI->isShared()) continue;

                    PropertyMacro * signalMacro = propertySuite->findSignal(port.first+"_notify");
                    if ((pI->isBlocking() || pI->isMasterOut()) && port.second != operation->getNextState()->getCommunicationPort()) { //if NextState is a wait state it will have null_ptr as CommunicationPort
                        auto commitment = new Assignment(signalMacro->getNotifySignal(), new BoolValue(false));
                        newProperty->addCommitment(new TemporalExpr(t_plus_1, commitment));
                    } else {
                        auto commitment = new Assignment(signalMacro->getNotifySignal(), new BoolValue(true));
                        newProperty->addCommitment(new TemporalExpr(t_plus_1, commitment));
                    }
                }
                propertySuite->addProperty(newProperty);
            }

        }

    }

    std::string convertDataType(std::string dataTypeName) {
        if (dataTypeName == "bool") {
            return "boolean";
        } else if (dataTypeName == "int") {
            return "signed";
        } else {
            return dataTypeName;
        }
    }

    void OperationFactory::printPropertySuite() {
        std::stringstream ss;
        std::string t_end;

        ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
        for (auto sync: this->propertySuite->getSyncSignals()) {
            ss << "macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName())
               << " := end macro;" << std::endl;
        }
        for (auto notify: this->propertySuite->getNotifySignals()) {
            ss << "macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName())
               << " := end macro;" << std::endl;
        }
        ss << std::endl << std::endl;

        ss << "-- DP SIGNALS --" << std::endl;
        for (auto dp: this->propertySuite->getDpSignals()) {
            ss << "macro " << dp->getName();
            if (dp->isCompoundType()) {
                ss << "_" + dp->getSubVarName();
            }
            ss << " : " << convertDataType(dp->getDataType()->getName()) << " := end macro;" << std::endl;
        }
        ss << std::endl << std::endl;

        ss << "-- CONSTRAINTS --" << std::endl;
        // Reset constraint is print out extra because of the quotation marks ('0')
        ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
        for (auto co: this->propertySuite->getConstraints()) {
            if (co->getName() != "no_reset") {
                ss << "constraint " << co->getName() << " : " << co->getExpression()
                   << "; end constraint;" << std::endl;
            }
        }
        ss << std::endl << std::endl;

        ss << "-- VISIBLE REGISTERS --" << std::endl;
        for (auto vr: this->propertySuite->getVisibleRegisters()) {
            if (!vr->isArrayType()) {
                ss << "macro " << vr->getName();
                if (vr->isCompoundType()) {
                    ss << "_" + vr->getSubVarName();
                }
                ss << " : " << convertDataType(vr->getDataType()->getName()) << " := end macro;" << std::endl;
            }
        }
        ss << std::endl << std::endl;

        ss << "-- STATES --" << std::endl;
        for (auto st: this->propertySuite->getStates()) {
            ss << "macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
            ss << " := " << st->getExpression() << " end macro;" << std::endl;
        }
        ss << std::endl << std::endl;

        ss << "-- OPERATIONS --" << std::endl;

        // Reset property
        ss << "property " << this->propertySuite->getResetProperty()->getName() << " is\n";
        ss << "assume:\n";
        ss << "\t reset_sequence;\n";
        ss << "prove:\n";
        //ss << "\t at t: " << this->propertySuite->getResetProperty()->getNextState()->getName() << ";\n";
        for (auto commitment : this->propertySuite->getResetProperty()->getCommitmentList()) {
            if (commitment->isAt()) {
                ss << "\t at ";
                ss << commitment->getTiming().at(0);
                ss << ": ";
            } else if (commitment->isDuring()) {
                ss << "\t during[";
                ss << commitment->getTiming().at(0);
                ss << ", ";
                ss << commitment->getTiming().at(1);
                ss << "]: ";
            }
            ss << commitment->getStatement();
        }
        ss << "end property;\n";
        ss << std::endl << std::endl;

        // Operation properties
        for (auto op : this->propertySuite->getProperties()) {
            ss << "property " << op->getName() << " is\n";

            unsigned long constraintSize = op->getConstraints().size();
            ss << "dependencies: ";
            for (auto co : op->getConstraints()) {
                ss << co->getName();
                if (constraintSize > 1) {
                    ss << ",";
                } else {
                    ss << ";\n";
                }
                constraintSize--;
            }

            unsigned long timePointSize = op->getTimePoints().size();
            ss << "for timepoints:\n";
            for (auto tp : op->getTimePoints()) {
                ss << "\t" << tp.first->getName() << " = " << tp.second;
                if (timePointSize > 1) {
                    ss << ",\n";
                } else {
                    ss << ";\n";
                }
                timePointSize--;
            }

            unsigned long freezeVarSize = op->getFreezeSignals().size();
            if (freezeVarSize > 0) {
                ss << "freeze:\n";
                for (auto freeze : op->getFreezeSignals()) {

                    ss << "\t";
                    if (freeze.first->isArrayType()) {
                        ss << freeze.first->getParent()->getName() << "_" << freeze.first->getVariable()->getName()
                           << "_at_" << freeze.second;
                        ss << " = ";
                        ss << freeze.first->getParent()->getName() << "(" << freeze.first->getVariable()->getName()
                           << ")@t";
                    } else {
                        ss << freeze.first << "_at_" << freeze.second;
                        ss << " = ";
                        ss << freeze.first << "@" << freeze.second;
                    }

                    if (freezeVarSize > 1) {
                        ss << ",\n";
                    } else {
                        ss << ";\n";
                    }
                    freezeVarSize--;
                }
            }
            ss << "assume:\n";
            for (auto assumption : this->propertySuite->getResetProperty()->getAssumptionList()) {
                if (assumption->isAt()) {
                    ss << "\t at ";
                    ss << assumption->getTiming().at(0);
                    ss << ": ";
                } else if (assumption->isDuring()) {
                    ss << "\t during[";
                    ss << assumption->getTiming().at(0);
                    ss << ", ";
                    ss << assumption->getTiming().at(1);
                    ss << "]: ";
                }
                ss << assumption->getStatement();
            }


            ss << "prove:\n";
            for (auto commitment : this->propertySuite->getResetProperty()->getCommitmentList()) {
                if (commitment->isAt()) {
                    ss << "\t at ";
                    ss << commitment->getTiming().at(0);
                    ss << ": ";
                } else if (commitment->isDuring()) {
                    ss << "\t during[";
                    ss << commitment->getTiming().at(0);
                    ss << ", ";
                    ss << commitment->getTiming().at(1);
                    ss << "]: ";
                }
                ss << commitment->getStatement();
            }
            ss << "end property;\n";
            ss << "\n\n";
        }
    }
}