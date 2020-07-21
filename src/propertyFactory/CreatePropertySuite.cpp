//
// Created by tobias on 03.02.20.
//

#include <ExprVisitor.h>
#include <PrintITL/PrintITL.h>
#include <TrueOperation.h>
#include "CreatePropertySuite.h"

#include "BoolValue.h"

void SCAM::CreatePropertySuite::addNotifySignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            auto pm = new PropertyMacro(port.second->getNotify());
            propertySuite->addNotifySignal(pm);
        }
    }

}

void SCAM::CreatePropertySuite::addSyncSignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (!interface->isMaster() && !interface->isSlaveOut()) {
            PropertyMacro *pm = new PropertyMacro(port.second->getSynchSignal());
            propertySuite->addSyncSignal(pm);
        }
    }
}

void SCAM::CreatePropertySuite::addDataSignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    // DP SIGNALS
    for (const auto &port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        //Add port as datapath signal
        auto pm = new PropertyMacro(port.second->getDataSignal());
        propertySuite->addDpSignal(pm);

        if (port.second->getDataType()->isCompoundType() || port.second->getDataType()->isArrayType()) {
            //Add all subignals of the compound type
            for (const auto &subVar: port.second->getDataType()->getSubVarMap()) {
                auto sub_macro = new PropertyMacro(port.second->getDataSignal()->getSubVar(subVar.first));
                propertySuite->addDpSignal(sub_macro);
            }
        }
    }
}

void SCAM::CreatePropertySuite::addVisibleRegisters(const Module *module, SCAM::PropertySuite *propertySuite) {
    for (const auto &var: module->getVariableMap()) {
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
                parentMacro = new PropertyMacro(parent);
                propertySuite->addVisibleRegister(parentMacro);
            }
            auto pm = new PropertyMacro(var.second);
            propertySuite->addVisibleRegister(pm);

        } else if (var.second->isSubVar()) {
            auto pm = new PropertyMacro(var.second);
            propertySuite->addVisibleRegister(pm);
        } else {
            auto pm = new PropertyMacro(var.second);
            propertySuite->addVisibleRegister(pm);
        }
    }

}

void SCAM::CreatePropertySuite::addStates(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {

    for (const auto &state: module->getFSM()->getStateMap()) {
        if (state.second->isInit()) continue;
        state.second->setName(state.second->getName());
        auto stateVar = new Variable(state.second->getName(), DataTypes::getDataType("bool"));
        auto pm = new PropertyMacro(stateVar);
        pm->setExpression(new SCAM::BoolValue(true));
        propertySuite->addState(pm);
    }

}

void SCAM::CreatePropertySuite::addFunctions(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    // FUNCTIONS
    for (const auto &function: module->getFunctionMap()) {
        propertySuite->addFunction(function.second);
    }

}

void SCAM::CreatePropertySuite::addReset(const Module *module, PropertySuite *propertySuite) {
    for (const auto &state: module->getFSM()->getStateMap()) {
        if (!state.second->isInit()) continue;
        assert((state.second->getOutgoingOperationsList().size() == 1) && "Only one operation allowed to start from init");
        propertySuite->setResetProperty(new Property("reset", *state.second->getOutgoingOperationsList().begin()));

        for (auto operation : state.second->getOutgoingOperationsList()) {

            assert((operation->getState()->isInit()) && "Operation should be starting from init state");
            auto t_var = new Timepoint("t");
            auto t = new TimePointOperand(t_var);
            PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
            auto nextStateExpr = new TemporalExpr(t, nextState->getOperand());

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
            if (!operation->getNextState()->isWait())
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

}

void SCAM::CreatePropertySuite::addOperations(const Module *module, PropertySuite *propertySuite) {

    for (const auto &state : module->getFSM()->getStateMap()) {
        if (state.second->isInit()) continue;
        for (auto operation : state.second->getOutgoingOperationsList()) {
            if (operation->IsWait()) continue;

            std::string operationName = operation->getState()->getName() + "_" + std::to_string(operation->getId());
            auto newProperty = new Property(operationName, operation);
            newProperty->addConstraint(propertySuite->getConstraint("no_reset"));

            auto t_var = new Timepoint("t");
            auto t = new TimePointOperand(t_var);

            auto t_end_var = new Timepoint("t_end");
            auto t_end = new TimePointOperand(t_end_var);

            newProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", new UnsignedValue(1)));


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
                if (var->isConstant()) continue;
                PropertyMacro *signalMacro = propertySuite->findSignal(var);
                newProperty->addFreezeSignal(signalMacro, t_var);
            }
            for (auto dataSig: dataSignals) {
                PropertyMacro *signalMacro;
                if (dataSig->isSubVar()) {
                    signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
                } else {
                    signalMacro = propertySuite->findSignal(dataSig->getName());
                }
                newProperty->addFreezeSignal(signalMacro, t_var);
            }

            PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
            PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
            auto startStateExpr = new TemporalExpr(t, startState->getVariableOperand());
            auto nextStateExpr = new TemporalExpr(t_end, nextState->getVariableOperand());
            newProperty->addAssumption(startStateExpr);
            newProperty->addCommitment(nextStateExpr);

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

            auto t_plus_1 = new Arithmetic(t, "+", new UnsignedValue(1));
            auto t_end_minus_1 = new Arithmetic(t_end, "-", new UnsignedValue(1));

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

}

void SCAM::CreatePropertySuite::addWait(const Module *module, PropertySuite *propertySuite) {
    for (const auto &state : module->getFSM()->getStateMap()) {
        if (state.second->isInit()) continue;
        for (auto operation : state.second->getOutgoingOperationsList()) {
            if (!operation->IsWait()) continue;

            auto *newProperty = new Property("wait_" + operation->getState()->getName(), operation);

            auto t_var = new Timepoint("t");
            auto t = new TimePointOperand(t_var);

            auto t_plus_1 = new Arithmetic(t, "+", new UnsignedValue(1));

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
                if (var->isConstant()) continue;
                PropertyMacro *signalMacro = propertySuite->findSignal(var);
                newProperty->addFreezeSignal(signalMacro, t_var);
            }
            for (auto dataSig: dataSignals) {
                PropertyMacro *signalMacro;
                if (dataSig->isSubVar()) {
                    signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
                } else {
                    signalMacro = propertySuite->findSignal(dataSig->getName());
                }
                newProperty->addFreezeSignal(signalMacro, t_var);
            }

            PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
            PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
            auto startStateExpr = new TemporalExpr(t, startState->getVariableOperand());
            auto nextStateExpr = new TemporalExpr(t_plus_1, nextState->getVariableOperand());
            newProperty->addAssumption(startStateExpr);
            newProperty->addCommitment(nextStateExpr);

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

                PropertyMacro *signalMacro = propertySuite->findSignal(port.first + "_notify");
                if ((pI->isBlocking() || pI->isMasterOut()) &&
                    port.second != operation->getNextState()->getCommunicationPort()) { //if NextState is a wait state it will have null_ptr as CommunicationPort
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
/*void CreatePropertySuite::addConnections(Module *module, PropertySuite *propertySuite, Model *model) {

    int currentLevel = model->getMaxLevel();
    ModuleInstance *inst;
    while (currentLevel >= 0) {
        std::vector<ModuleInstance *> queue = model->getInstancesAtLevel(currentLevel);
        while (!queue.empty()) {
            auto helper_module = queue.front()->getStructure();
            if (helper_module == module) {
                inst = queue.front();
                currentLevel = 0;
                break;
            }
            queue.erase(queue.begin());
        }
        currentLevel--;
    }
    for (const auto &chan: inst->getChannelMap()) {
        auto channel = chan.second;
        if (channel->getType() == "Blocking") {
            std::cout << channel->getName() << std::endl;
            auto operation = new Operation();
            auto fromInstance = channel->getFromInstance();
            auto toInstance = channel->getToInstance();
            auto fromPort = channel->getFromPort();
            auto toPort = channel->getToPort();
            auto *newProperty = new Property("transmission_" + channel->getName(), operation);
            propertySuite->addProperty(newProperty);
            //===============================
            // Constraints
            //===============================
            newProperty->addConstraint(propertySuite->getConstraint("no_reset"));
            //===============================
            // Timepoints
            //===============================
            //Add t_first timepoint:
            auto t_var = new Timepoint("t");
            auto t = new TimePointOperand(t_var);

            auto t_end_var = new Timepoint("t_end");
            auto t_end = new TimePointOperand(t_end_var);
            auto variable = new Variable("cycles", DataTypes::getDataType("unsigned"));
            auto variableOperand = new VariableOperand(variable);
            newProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", variableOperand));

            //===============================
            // Timepoints
            //===============================

            //===============================
            //FREEZE VARS
            //===============================

            //freeze output channel data
            auto dataSig = fromPort->getDataSignal();
            PropertyMacro *signalMacro;
            if(dataSig->getSubVarList().empty()) {
                signalMacro = propertySuite->findSignal(dataSig->getName());
                newProperty->addFreezeSignal(signalMacro, t_var);
            } else {
                for (const auto &subVar: fromPort->getDataSignal()->getSubVarList()) {
                    signalMacro = propertySuite->findSignal(dataSig->getName(), subVar->getName());
                    newProperty->addFreezeSignal(signalMacro, t_var);
                }
            }

            //Freeze all other notifies
            for (const auto &subinst: inst->getSubmoduleInstances()) {
                if(subinst.second != channel->getToInstance() && subinst.second != channel->getFromInstance()) {
                    for (const auto &ports: subinst.second->getStructure()->getPorts()) {
                        //TODO: maybe add other interfaces aswell
                        if(ports.second->getInterface()->isBlocking()) {
                            PropertyMacro *notify = propertySuite->findSignal(subinst.first + "_" + ports.first + "_notify" );
                            newProperty->addFreezeSignal(notify, t_var);
                        }
                    }
                }
            }
            /*for (const auto &freezechan: inst->getChannelMap()) {
                auto freezechannel = freezechan.second;
                if (freezechannel->getToInstance() != channel->getToInstance()) {
                    PropertyMacro *toNotify = propertySuite->findSignal(freezechannel->getToInstance()->getName() + "_" + freezechannel->getToPort()->getName() + "_notify" );
                    PropertyMacro *fromNotify = propertySuite->findSignal(freezechannel->getFromInstance()->getName() + "_" + freezechannel->getFromPort()->getName() + "_notify" );
                    newProperty->addFreezeSignal(toNotify, t_var);
                    newProperty->addFreezeSignal(fromNotify, t_var);
                }
            }*/

//===============================
// Assumptions
//===============================
/*
auto startStateExpr_to = new TemporalExpr(t, toPort->getNotify());
auto startStateExpr_from = new TemporalExpr(t, fromPort->getNotify());
startStateExpr_to->setInstance(toInstance->getName());
startStateExpr_from->setInstance(fromInstance->getName());
newProperty->addAssumption(startStateExpr_to);
newProperty->addAssumption(startStateExpr_from);

//===============================
// Commitments
//===============================
//add commitment states from submodules
for (const auto &instance: module->getModuleInstanceMap()) {
for (const auto &state : instance.second->getStructure()->getFSM()->getStateMap()) {
if (state.second->isInit()) continue;
for (auto operation : state.second->getOutgoingOperationsList()) {
if (operation->IsWait()) continue;

if (operation->getState()->getCommunicationPort()->getName() == toPort->getName() || operation->getState()->getCommunicationPort()->getName() == fromPort->getName()) {
PropertyMacro *nextState = propertySuite->findSignal(instance.first + "_" + operation->getNextState()->getName());

auto nextStateExpr = new TemporalExpr(t_end, nextState->getVariableOperand());
nextStateExpr->setInstance(instance.first);
newProperty->addCommitment(nextStateExpr);
}
}
}
}
//add commitment for data
if (toPort->getDataSignal()->getSubVarList().empty()) {
auto c = new Assignment(new DataSignalOperand(toPort->getDataSignal()), new DataSignalOperand(fromPort->getDataSignal()));
auto commitment = new TemporalExpr(t_end, c);
commitment->setInstance(toInstance->getName());
newProperty->addCommitment(commitment);
} else {
for (const auto &subVar: toPort->getDataSignal()->getSubVarList()) {
auto c = new Assignment(new DataSignalOperand(subVar), new DataSignalOperand(fromPort->getDataSignal()->getSubVar(subVar->getName())));
auto commitment = new TemporalExpr(t_end, c);
commitment->setInstance(toInstance->getName());
newProperty->addCommitment(commitment);
}
}
//auto timePointOperand = new TimePointOperand(timepoint);
//add commitment for freeze notify
for (const auto &subinst: inst->getSubmoduleInstances()) {
if(subinst.second != channel->getToInstance() && subinst.second != channel->getFromInstance()) {
for (const auto &ports: subinst.second->getStructure()->getPorts()) {
//TODO: maybe add other interfaces aswell
if(ports.second->getInterface()->isBlocking()) {
//TO
auto commitment = new Assignment(ports.second->getNotify(), ports.second->getNotify());
auto temporalExpr = new TemporalExpr(t,t_end, commitment);
temporalExpr->setFreezeAt( subinst.first + "_" + ports.first + "_notify_at_t");
newProperty->addCommitment(temporalExpr);
temporalExpr->setInstance(subinst.first);
}
}
}
}
/*
for (const auto &freezechan: inst->getChannelMap()) {
    auto freezechannel = freezechan.second;
    if (freezechannel != channel) {
        //TO
        auto commitment_to = new Assignment(freezechannel->getToPort()->getNotify(), freezechannel->getToPort()->getNotify());
        auto temporalExpr_to = new TemporalExpr(t,t_end, commitment_to);
        temporalExpr_to->setFreezeAt( freezechannel->getToInstance()->getName() + "_" + freezechannel->getToPort()->getName() + "_notify_at_t");
        newProperty->addCommitment(temporalExpr_to);
        temporalExpr_to->setInstance(freezechannel->getToInstance()->getName());
        //FROM
        auto commitment_from = new Assignment(freezechannel->getFromPort()->getNotify(), freezechannel->getFromPort()->getNotify());
        auto temporalExpr_from = new TemporalExpr(t,t_end, commitment_from);
        temporalExpr_from->setFreezeAt( freezechannel->getFromInstance()->getName() + "_" + freezechannel->getFromPort()->getName() + "_notify_at_t");
        newProperty->addCommitment(temporalExpr_from);
        temporalExpr_from->setInstance(freezechannel->getFromInstance()->getName());
    }
}

}
}
}*/
void CreatePropertySuite::addConnections(Channel *channel, PropertySuite *propertySuite) {

    if (channel->getType() == "Blocking") {
        //For general usage
        auto fromInstance = channel->getFromInstance();
        auto toInstance = channel->getToInstance();
        auto fromPort = channel->getFromPort();
        auto toPort = channel->getToPort();
        //===============================
        // Timepoints
        //===============================
        //Add t_first timepoint:
        auto t_var = new Timepoint("t");
        auto t = new TimePointOperand(t_var);

        auto t_end_var = new Timepoint("t_end");
        auto t_end = new TimePointOperand(t_end_var);

        //===============================
        //===============================
        // Property to prove correct connection of sync and notify
        //===============================
        //===============================
        auto sync_operation = new Operation();
        auto *syncProperty = new Property("notify_sync_connection", sync_operation);
        propertySuite->addProperty(syncProperty);
        //===============================
        // Commitments
        //===============================
        //add commitment states from submodules

        //TO
        auto syncc1 = new Assignment(toPort->getSynchSignal(), fromPort->getNotify());
        auto synctE1 = new TemporalExpr(t, t_end, syncc1);
        auto syncc2 = new Assignment(fromPort->getSynchSignal(), toPort->getNotify());
        auto synctE2 = new TemporalExpr(t, t_end, syncc2);

        auto synctE21 = new TemporalExpr(t, syncc2);
        auto synctE11 = new TemporalExpr(t, syncc1);

        synctE1->setInstance(toInstance->getName());
        synctE2->setInstance(fromInstance->getName());

        synctE11->setInstance(toInstance->getName());
        synctE21->setInstance(fromInstance->getName());
        syncProperty->addCommitment(synctE11);
        syncProperty->addCommitment(synctE21);

        //===============================
        //===============================
        // Transmission Property
        //===============================
        //===============================

        std::cout << channel->getName() << std::endl;
        auto trans_operation = new Operation();
        auto *transProperty = new Property("transmission_" + channel->getName(), trans_operation);
        propertySuite->addProperty(transProperty);
        //===============================
        // Constraints
        //===============================
        transProperty->addConstraint(propertySuite->getConstraint("no_reset"));
        //===============================
        // Timepoints
        //===============================
        auto variable = new Variable("cycles", DataTypes::getDataType("unsigned"));
        auto variableOperand = new VariableOperand(variable);
        transProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", variableOperand));
        //===============================
        //FREEZE VARS
        //===============================

        //freeze output channel data
        auto dataSig = fromPort->getDataSignal();
        PropertyMacro *signalMacro;
        if(dataSig->getSubVarList().empty()) {
            signalMacro = propertySuite->findSignal(dataSig->getName());
            transProperty->addFreezeSignal(signalMacro, t_var);
        } else {
            for (const auto &subVar: fromPort->getDataSignal()->getSubVarList()) {
                signalMacro = propertySuite->findSignal(dataSig->getName(), subVar->getName());
                transProperty->addFreezeSignal(signalMacro, t_var);
            }
        }

        //===============================
        // Assumptions
        //===============================

        auto startStateExpr_to = new TemporalExpr(t, toPort->getNotify());
        auto startStateExpr_from = new TemporalExpr(t, fromPort->getNotify());
        startStateExpr_to->setInstance(toInstance->getName());
        startStateExpr_from->setInstance(fromInstance->getName());
        transProperty->addAssumption(startStateExpr_to);
        transProperty->addAssumption(startStateExpr_from);

        //===============================
        // Commitments
        //===============================

        //add commitment for data
        if (toPort->getDataSignal()->getSubVarList().empty()) {
            auto c = new Assignment(new DataSignalOperand(toPort->getDataSignal()), new DataSignalOperand(fromPort->getDataSignal()));
            auto commitment = new TemporalExpr(t_end, c);
            commitment->setInstance(toInstance->getName());
            transProperty->addCommitment(commitment);
        } else {
            for (const auto &subVar: toPort->getDataSignal()->getSubVarList()) {
                auto c = new Assignment(new DataSignalOperand(subVar), new DataSignalOperand(fromPort->getDataSignal()->getSubVar(subVar->getName())));
                auto commitment = new TemporalExpr(t_end, c);
                commitment->setInstance(toInstance->getName());
                transProperty->addCommitment(commitment);
            }
        }

        //===============================
        //===============================
        // No Transmission Property 1
        //===============================
        //===============================

        std::cout << channel->getName() << std::endl;
        auto notrans_operation = new Operation();
        auto *notransProperty = new Property("no_transmission1", notrans_operation);
        propertySuite->addProperty(notransProperty);
        //===============================
        // Constraints
        //===============================
        notransProperty->addConstraint(propertySuite->getConstraint("no_reset"));
        //===============================
        // Timepoints
        //===============================
        notransProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", new UnsignedValue(1)));
        //===============================
        //FREEZE VARS
        //===============================
        //===============================
        // Assumptions
        //===============================
        auto no_trans1_stmt = new UnaryExpr("not", toPort->getNotify());
        notrans_operation->setWait(true);
        auto no_trans1 = new TemporalExpr(t, no_trans1_stmt);
        auto no_trans2 = new TemporalExpr(t, fromPort->getNotify());
        no_trans1->setInstance(toInstance->getName());
        no_trans2->setInstance(fromInstance->getName());
        notransProperty->addAssumption(no_trans1);
        notransProperty->addAssumption(no_trans2);

        //===============================
        // Commitments
        //===============================

        //add commitment for data

        /*
        if (toPort->getDataSignal()->getSubVarList().empty()) {
            auto c = new Assignment(new DataSignalOperand(toPort->getDataSignal()), new DataSignalOperand(fromPort->getDataSignal()));
            auto commitment = new TemporalExpr(t_end, c);
            commitment->setInstance(toInstance->getName());
            notransProperty->addCommitment(commitment);
        } else {
            for (const auto &subVar: toPort->getDataSignal()->getSubVarList()) {
                auto c = new Assignment(new DataSignalOperand(subVar), new DataSignalOperand(fromPort->getDataSignal()->getSubVar(subVar->getName())));
                auto commitment = new TemporalExpr(t_end, c);
                commitment->setInstance(toInstance->getName());
                notransProperty->addCommitment(commitment);
            }
        }*/
        notransProperty->addCommitment(synctE1);
        notransProperty->addCommitment(synctE2);


        //===============================
        //===============================
        // No Transmission Property 2
        //===============================
        //===============================

        auto notrans_operation2 = new Operation();
        auto *notransProperty2 = new Property("no_transmission2", notrans_operation2);
        propertySuite->addProperty(notransProperty2);
        //===============================
        // Constraints
        //===============================
        notransProperty2->addConstraint(propertySuite->getConstraint("no_reset"));
        //===============================
        // Timepoints
        //===============================
        notransProperty2->addTimePoint(t_end_var, new Arithmetic(t, "+", new UnsignedValue(1)));
        //===============================
        //FREEZE VARS
        //===============================
        //===============================
        // Assumptions
        //===============================
        auto no_trans1_stmt2 = new UnaryExpr("not", fromPort->getNotify());
        notrans_operation2->setWait(true);
        auto no_trans12 = new TemporalExpr(t, no_trans1_stmt2);
        auto no_trans22 = new TemporalExpr(t, toPort->getNotify());
        no_trans12->setInstance(toInstance->getName());
        no_trans22->setInstance(fromInstance->getName());
        notransProperty2->addAssumption(no_trans12);
        notransProperty2->addAssumption(no_trans22);

        //===============================
        // Commitments
        //===============================

        //add commitment for data
        /*
        if (toPort->getDataSignal()->getSubVarList().empty()) {
            auto c = new Assignment(new DataSignalOperand(toPort->getDataSignal()), new DataSignalOperand(fromPort->getDataSignal()));
            auto commitment = new TemporalExpr(t_end, c);
            commitment->setInstance(toInstance->getName());
            notransProperty2->addCommitment(commitment);
        } else {
            for (const auto &subVar: toPort->getDataSignal()->getSubVarList()) {
                auto c = new Assignment(new DataSignalOperand(subVar), new DataSignalOperand(fromPort->getDataSignal()->getSubVar(subVar->getName())));
                auto commitment = new TemporalExpr(t_end, c);
                commitment->setInstance(toInstance->getName());
                notransProperty2->addCommitment(commitment);
            }
        }*/

        notransProperty2->addCommitment(synctE1);
        notransProperty2->addCommitment(synctE2);

        //===============================
        //===============================
        // No Transmission Property 3
        //===============================
        //===============================

        auto notrans_operation3 = new Operation();
        auto *notransProperty3 = new Property("no_transmission3", notrans_operation3);
        propertySuite->addProperty(notransProperty3);
        //===============================
        // Constraints
        //===============================
        notransProperty3->addConstraint(propertySuite->getConstraint("no_reset"));
        //===============================
        // Timepoints
        //===============================
        notransProperty3->addTimePoint(t_end_var, new Arithmetic(t, "+", new UnsignedValue(1)));
        //===============================
        //FREEZE VARS
        //===============================
        //===============================
        // Assumptions
        //===============================
        notrans_operation3->setWait(true);
        notransProperty3->addAssumption(no_trans12);
        notransProperty3->addAssumption(no_trans1);

        //===============================
        // Commitments
        //===============================
        /*
        //add commitment for data
        if (toPort->getDataSignal()->getSubVarList().empty()) {
            auto c = new Assignment(new DataSignalOperand(toPort->getDataSignal()), new DataSignalOperand(fromPort->getDataSignal()));
            auto commitment = new TemporalExpr(t_end, c);
            commitment->setInstance(toInstance->getName());
            notransProperty3->addCommitment(commitment);
        } else {
            for (const auto &subVar: toPort->getDataSignal()->getSubVarList()) {
                auto c = new Assignment(new DataSignalOperand(subVar), new DataSignalOperand(fromPort->getDataSignal()->getSubVar(subVar->getName())));
                auto commitment = new TemporalExpr(t_end, c);
                commitment->setInstance(toInstance->getName());
                notransProperty3->addCommitment(commitment);
            }
        }*/
        notransProperty3->addCommitment(synctE1);
        notransProperty3->addCommitment(synctE2);

    }
}

void SCAM::CreatePropertySuite::addTrueOperations(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    int cycle_cnt = 0;
    //Find cylces
    TrueOperation trueOperation(module);
    // Add a property for each cycle in the list


    for (auto cycle: trueOperation.getCycleMap()) {

        auto newProperty = new Property("cycle_" + std::to_string(cycle_cnt), cycle);
        //===============================
        // Constraints
        //===============================
        newProperty->addConstraint(propertySuite->getConstraint("no_reset"));
        //===============================
        // Timepoints
        //===============================
        //Add t_first timepoint:
        auto t_var = new Timepoint("t_" + cycle.front()->getState()->getName());
        auto t_prev = new TimePointOperand(new Timepoint("t"));
        newProperty->addTimePoint(t_var, t_prev); // at t_state = t;
        for (auto iterator = cycle.begin(); iterator != cycle.end(); ++iterator) {
            auto operation = *iterator;
            Timepoint *t_next_var;
            if (iterator == cycle.end() - 1) {
                t_next_var = new Timepoint("t_end");
            } else {
                t_next_var = new Timepoint("t_" + operation->getNextState()->getName());

            }
            newProperty->addTimePoint(t_next_var, new Arithmetic(t_prev, "+", new UnsignedValue(1)));
            t_prev = new TimePointOperand(t_next_var);

        }
        propertySuite->addProperty(newProperty);

        //===============================
        // Freeze
        //===============================
        //Find all freeze variables for this cycle
        trueOperation.findFreezeVars(cycle);
        for (auto sync: trueOperation.getSyncSignals()) {
            PropertyMacro *signalMacro = propertySuite->findSignal(sync->getPort()->getName() + "_sync");
            signalMacro->setExpression(sync);
            auto state = trueOperation.getSyncSignalTimepoints().at(sync);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(), "t_" + state->getName());
            newProperty->addFreezeSignal(signalMacro, timepoint);
        }
        for (auto var: trueOperation.getVariables()) {
//            if(cycle_cnt == 0){
//                std::cout << "yes" << std::endl;
//            }
            if (var->isConstant()) continue;
            PropertyMacro *signalMacro = propertySuite->findSignal(var);
            signalMacro->setExpression(new VariableOperand(var));
            auto state = trueOperation.getVariablesTimepoints().at(var);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(), "t_" + state->getName());
            newProperty->addFreezeSignal(signalMacro, timepoint);

        }
        for (auto dataSig: trueOperation.getDataSignals()) {
            PropertyMacro *signalMacro;
            if (dataSig->isSubVar()) {
                signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
            } else {
                signalMacro = propertySuite->findSignal(dataSig->getName());
            }
            signalMacro->setExpression(new DataSignalOperand(dataSig));
            auto state = trueOperation.getDataSignalsTimepoints().at(dataSig);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(), "t_" + state->getName());

            newProperty->addFreezeSignal(signalMacro, timepoint);
        }


        //===============================
        // Assumptions
        //===============================
        for (auto operation: cycle) {
            PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
            Timepoint *timepoint = findTimeExpr(newProperty->getTimePoints(), "t_" + operation->getState()->getName());
            auto timeExprOperand = new TimePointOperand(timepoint);
            newProperty->addAssumption(new TemporalExpr(timeExprOperand, startState->getVariableOperand()));

            for (auto assumption : operation->getAssumptionsList()) {
                newProperty->addAssumption(new TemporalExpr(timeExprOperand, assumption));
            }
        }

        //===============================
        // Commitments
        //===============================
        for (auto it = cycle.begin(); it != cycle.end(); ++it) {
            auto operation = *it;
            Timepoint *timepoint;
            if (it != cycle.end() - 1) {
                timepoint = findTimeExpr(newProperty->getTimePoints(), "t_" + operation->getNextState()->getName());
            } else timepoint = findTimeExpr(newProperty->getTimePoints(), "t_end");

            auto timePointOperand = new TimePointOperand(timepoint);
            PropertyMacro *nextState = propertySuite->findSignal(operation->getNextState()->getName());
            newProperty->addCommitment(new TemporalExpr(timePointOperand, nextState->getVariableOperand()));


            for (auto &&commitment : operation->getCommitmentsList()) {
                //Only one variable in set
                auto vars = ExprVisitor::getUsedVariables(commitment->getLhs());
                assert(vars.size() < 2 && "Too many variables for LHS");

                if (vars.empty() || TrueOperation::isRequired(*vars.begin(), operation, cycle)) {
                    if (vars.empty() || TrueOperation::isRequired2(*vars.begin(), operation, cycle)) {
                        auto temporalExpr = new TemporalExpr(timePointOperand, commitment);
                        temporalExpr->setFreezeAt("_at_t_" + operation->getState()->getName());
                        newProperty->addCommitment(temporalExpr);
                    }
                }
            }
        }
        cycle_cnt++;
    }


}

Timepoint *CreatePropertySuite::findTimeExpr(const std::map<Timepoint *, Expr *> &map, std::string state_name) {
    for (auto te: map) {
        if (te.first->getName() == state_name) return te.first;
    }
    throw std::runtime_error(" Timexpr " + state_name + " not found");
}


void SCAM::CreatePropertySuite::addNotifySignals(Channel *channel, PropertySuite *propertySuite) {
    auto toport = channel->getToPort();
    auto interface = toport->getInterface();
    if (interface->isMasterOut() || interface->isBlocking()) {
        auto pm = new PropertyMacro(toport->getNotify(), channel->getToInstance()->getName() + "_" + toport->getName() + "_notify");
        propertySuite->addNotifySignal(pm);
    }

    auto fromport = channel->getFromPort();
    interface = fromport->getInterface();
    if (interface->isMasterOut() || interface->isBlocking()) {
        auto pm = new PropertyMacro(fromport->getNotify(), channel->getFromInstance()->getName() + "_" + fromport->getName() + "_notify");
        propertySuite->addNotifySignal(pm);
    }
}

void SCAM::CreatePropertySuite::addSyncSignals(Channel *channel, PropertySuite *propertySuite) {


    auto toport = channel->getToPort();
    auto interface = toport->getInterface();
    if (!interface->isMaster() && !interface->isSlaveOut()) {
        auto pm = new PropertyMacro(toport->getSynchSignal(), channel->getToInstance()->getName() + "_" + toport->getName() + "_sync");
        propertySuite->addNotifySignal(pm);
    }

    auto fromport = channel->getFromPort();
    interface = fromport->getInterface();
    if (!interface->isMaster() && !interface->isSlaveOut()) {
        auto pm = new PropertyMacro(fromport->getSynchSignal(), channel->getFromInstance()->getName() + "_" + fromport->getName() + "_sync");
        propertySuite->addNotifySignal(pm);
    }


}

void SCAM::CreatePropertySuite::addDataSignals(Channel *channel, PropertySuite *propertySuite) {
    // DP SIGNALS
    auto toport = channel->getToPort();
    auto fromport = channel->getFromPort();

    if (!toport->getDataType()->isVoid()) {
        auto pm = new PropertyMacro(toport->getDataSignal(), channel->getToInstance()->getName() + "_" + toport->getName() + "_sig");
        propertySuite->addDpSignal(pm);

        if (toport->getDataType()->isCompoundType() || toport->getDataType()->isArrayType()) {
            //Add all subignals of the compound type
            for (const auto &subVar: toport->getDataType()->getSubVarMap()) {
                auto sub_macro = new PropertyMacro(toport->getDataSignal()->getSubVar(subVar.first), channel->getToInstance()->getName() + "_" + toport->getName() + "_sig_" + subVar.first);
                propertySuite->addDpSignal(sub_macro);
            }
        }

    }
    if (!fromport->getDataType()->isVoid()) {
        auto pm = new PropertyMacro(fromport->getDataSignal(), channel->getFromInstance()->getName() + "_" + fromport->getName() + "_sig");
        propertySuite->addDpSignal(pm);

        if (fromport->getDataType()->isCompoundType() || fromport->getDataType()->isArrayType()) {
            //Add all subignals of the compound type
            for (const auto &subVar: fromport->getDataType()->getSubVarMap()) {
                auto sub_macro = new PropertyMacro(fromport->getDataSignal()->getSubVar(subVar.first), channel->getFromInstance()->getName() + "_" + fromport->getName() + "_sig_" + subVar.first);
                propertySuite->addDpSignal(sub_macro);
            }
        }
    }

}

void SCAM::CreatePropertySuite::addStates(Channel *channel, PropertySuite *propertySuite) {
    for(auto& inst: channel->getParentInstance()->getStructure()->getModuleInstanceMap()) {
        for (const auto &state: inst.second->getStructure()->getFSM()->getStateMap()) {
            if (state.second->isInit()) continue;
            state.second->setName(state.second->getName());
            auto stateVar = new Variable(state.second->getName(), DataTypes::getDataType("bool"));
            auto pm = new PropertyMacro(stateVar, inst.first + "_" + stateVar->getName());
            pm->setExpression(new SCAM::BoolValue(true));
            propertySuite->addState(pm);
        }
    }
}

void SCAM::CreatePropertySuite::addReset(Channel *channel, PropertySuite *propertySuite) {
    auto reset_operation = new Operation();
    auto module = channel->getParentInstance()->getStructure();
    propertySuite->setResetProperty(new Property("reset", reset_operation));
    for(auto& inst: module->getModuleInstanceMap()) {
        for (const auto &state: inst.second->getStructure()->getFSM()->getStateMap()) {
            if (!state.second->isInit()) continue;
            assert((state.second->getOutgoingOperationsList().size() == 1) && "Only one operation allowed to start from init");

            for (auto operation : state.second->getOutgoingOperationsList()) {
                assert((operation->getState()->isInit()) && "Operation should be starting from init state");
                auto t_var = new Timepoint("t");
                auto t = new TimePointOperand(t_var);
                PropertyMacro *nextState = inst.second->getStructure()->getPropertySuite()->findSignal(operation->getNextState()->getName());
                auto nextStateExpr = new TemporalExpr(t, nextState->getOperand());
                nextStateExpr->setInstance(inst.first);
                propertySuite->getResetProperty()->addCommitment(nextStateExpr);



                // Add commitments for ResetProperty
                /*for (auto c: operation->getCommitmentsList()) {
                    auto commitment =  new TemporalExpr(t, c);
                    commitment->setInstance(inst.first);
                    propertySuite->getResetProperty()->addCommitment(commitment);
                }*/

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
                if (!operation->getNextState()->isWait())
                    usedPortsList.insert(operation->getNextState()->getCommunicationPort());


                for (auto port: inst.second->getStructure()->getPorts()) {
                    if (port.second->getInterface()->isShared()) continue;
                    if (port.second->getInterface()->isSlaveIn()) continue;
                    if (port.second->getInterface()->isSlaveOut()) continue;
                    if (port.second->getInterface()->isMasterIn()) continue;

                    PropertyMacro *signalMacro = inst.second->getStructure()->getPropertySuite()->findSignal(port.first + "_notify");
                    if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        auto commitment = new TemporalExpr(t, new Assignment(signalMacro->getNotifySignal(), new BoolValue(true)));
                        commitment->setInstance(inst.first);
                        propertySuite->getResetProperty()->addCommitment(commitment);
                    } else {
                        auto commitment = new TemporalExpr(t, new Assignment(signalMacro->getNotifySignal(), new BoolValue(false)));
                        commitment->setInstance(inst.first);
                        propertySuite->getResetProperty()->addCommitment(commitment);
                    }
                }
                break;

            }
        }
    }
}