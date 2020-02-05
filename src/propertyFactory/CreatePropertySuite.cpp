//
// Created by tobias on 03.02.20.
//

#include <ExprVisitor.h>
#include <PrintITL/PrintITL.h>
#include <PrintTrueOperation/TrueOperation.h>
#include "CreatePropertySuite.h"

#include "BoolValue.h"

void SCAM::CreatePropertySuite::addNotifySignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            auto pm = new PropertyMacro(port.first + "_notify", port.second, port.second->getNotify(), DataTypes::getDataType("bool"));
            propertySuite->addNotifySignal(pm);
        }
    }

}

void SCAM::CreatePropertySuite::addSyncSignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (!interface->isMaster() && !interface->isSlaveOut()) {
            PropertyMacro *pm = new PropertyMacro(port.first + "_sync", port.second, port.second->getSynchSignal(), DataTypes::getDataType("bool"));
            propertySuite->addSyncSignal(pm);
        }
    }
}

void SCAM::CreatePropertySuite::addDataSignals(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    // DP SIGNALS
    for (const auto &port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;

        if (port.second->getDataType()->isCompoundType() || port.second->getDataType()->isArrayType()) {
            //Add compound type signal
            auto pm = new PropertyMacro(port.first + "_sig", port.second, port.second->getDataType());
            propertySuite->addDpSignal(pm);
            //Add all subignals of the compound type
            for (const auto &subVar: port.second->getDataType()->getSubVarMap()) {
                auto pm = new PropertyMacro(port.first + "_sig", port.second, subVar.second, subVar.first);
                propertySuite->addDpSignal(pm);
            }
        } else {
            auto pm = new PropertyMacro(port.first + "_sig", port.second, port.second->getDataType());
            propertySuite->addDpSignal(pm);
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

}

void SCAM::CreatePropertySuite::addStates(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {

    for (const auto &state: module->getFSM()->getStateMap()) {
        if (state.second->isInit()) continue;
        state.second->setName(state.second->getName());
        auto stateVar = new Variable(state.second->getName(), DataTypes::getDataType("bool"));
        auto pm = new PropertyMacro(state.second->getName(), stateVar, DataTypes::getDataType("bool"));
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
            auto t_var = new TimeExpr("t");
            auto t = new TimeExprOperand(t_var);
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

            auto t_var = new TimeExpr("t");
            auto t = new TimeExprOperand(t_var);

            auto t_end_var = new TimeExpr("t_end");
            auto t_end = new TimeExprOperand(t_end_var);

            newProperty->addTimePoint(t_end_var, new Arithmetic(t, "+", new UnsignedValue(1)));

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
                if (var->isConstant()) continue;
                PropertyMacro *signalMacro = propertySuite->findSignal(var);
                newProperty->addFreezeSignal(signalMacro, t_var);
            }
            for (auto dataSig: dataSignals) {
                PropertyMacro *signalMacro;
                //TODO remove try/catch
                if (dataSig->isSubVar()) {
                    signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
                } else {
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

            auto t_var = new TimeExpr("t");
            auto t = new TimeExprOperand(t_var);

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
                //TODO: remove try/catch
                PropertyMacro *signalMacro;

                try {
                    if (dataSig->isSubVar() && dataSig->getParent()->isArrayType())
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

void SCAM::CreatePropertySuite::addTrueOperations(const SCAM::Module *module, SCAM::PropertySuite *propertySuite) {
    int cycle_cnt = 0;
    //Find cylces
    TrueOperation trueOperation(module);
    // Add a property for each cycle in the list


    for (auto cycle: trueOperation.getCycleMap()) {

        auto newProperty = new Property("cycle_" + std::to_string(cycle_cnt), cycle);
        //===============================
        // Timepoints
        //===============================
        //Add t_first timepoint:
        auto t_var = new TimeExpr("t_" + cycle.front()->getState()->getName());
        auto t_prev = new TimeExprOperand(new TimeExpr("t"));
        newProperty->addTimePoint(t_var, t_prev); // at t_state = t;
        for (auto iterator = cycle.begin(); iterator != cycle.end(); ++iterator) {
            auto operation = *iterator;
            TimeExpr *t_next_var;
            if (iterator == cycle.end() - 1) {
                t_next_var = new TimeExpr("t_end");
                std::cout << "Replacing " << operation->getNextState()->getName()  << " with t_end" <<  std::endl;
            } else {
                t_next_var = new TimeExpr("t_" + operation->getNextState()->getName());

            }
            newProperty->addTimePoint(t_next_var, new Arithmetic(t_prev, "+", new UnsignedValue(1)));
            t_prev = new TimeExprOperand(t_next_var);

        }
        propertySuite->addProperty(newProperty);

        //===============================
        // Freeze
        //===============================
        //Find all freeze variables for this cycle
        trueOperation.findFreezeVars(cycle);
        for (auto sync: trueOperation.getSyncSignals()) {
            PropertyMacro *signalMacro = propertySuite->findSignal(sync->getPort()->getName() + "_sync");
            auto state = trueOperation.getSyncSignalTimepoints().at(sync);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(),"t_"+state->getName());
            newProperty->addFreezeSignal(signalMacro, timepoint);
        }
        for (auto var: trueOperation.getVariables()) {
            if (var->isConstant()) continue;
            PropertyMacro *signalMacro = propertySuite->findSignal(var);
            auto state = trueOperation.getVariablesTimepoints().at(var);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(),"t_"+state->getName());
            newProperty->addFreezeSignal(signalMacro, t_var);
        }
        for (auto dataSig: trueOperation.getDataSignals()) {
            PropertyMacro *signalMacro;
            if (dataSig->isSubVar()) {
                signalMacro = propertySuite->findSignal(dataSig->getPort()->getName() + "_sig", dataSig->getName());
            } else {
                signalMacro = propertySuite->findSignal(dataSig->getName());
            }

            auto state = trueOperation.getDataSignalsTimepoints().at(dataSig);
            auto timepoint = CreatePropertySuite::findTimeExpr(newProperty->getTimePoints(),"t_"+state->getName());
            newProperty->addFreezeSignal(signalMacro, timepoint);
        }


        //===============================
        // Assumptions
        //===============================
        for(auto operation: cycle){
            PropertyMacro *startState = propertySuite->findSignal(operation->getState()->getName());
            TimeExpr * timepoint = findTimeExpr(newProperty->getTimePoints(),"t_"+operation->getState()->getName());
            auto timeExprOperand = new TimeExprOperand(timepoint);
            newProperty->addAssumption(new TemporalExpr(timeExprOperand,startState->getVariableOperand()));

            for (auto assumption : operation->getAssumptionsList()) {
               newProperty->addAssumption(new TemporalExpr(timeExprOperand, assumption));
            }
        }

        //===============================
        // Commitments
        //===============================
        for (auto it = cycle.begin(); it != cycle.end(); ++it) {
            auto operation = *it;
            TimeExpr * timepoint;
            if(it != cycle.end()-1){
                timepoint = findTimeExpr(newProperty->getTimePoints(),"t_"+operation->getNextState()->getName());
            }else timepoint = findTimeExpr(newProperty->getTimePoints(),"t_end");

            auto timeExprOperand = new TimeExprOperand(timepoint);
            PropertyMacro * nextState = propertySuite->findSignal(operation->getNextState()->getName());
            newProperty->addCommitment(new TemporalExpr(timeExprOperand,nextState->getVariableOperand()));

            for (auto commitment : operation->getCommitmentsList()) {
                std::cout <<*timeExprOperand  << ":" << *commitment << std::endl;
                auto test = new TemporalExpr(timeExprOperand, commitment);
                newProperty->addCommitment(test);
            }

            for (auto &&commitment : operation->getCommitmentsList()) {
                //Only one variable in set
                auto vars = ExprVisitor::getUsedVariables(commitment->getLhs());
                assert(vars.size() < 2 && "Too many variables for LHS");

                if (vars.empty() || TrueOperation::isRequired(*vars.begin(), operation, cycle)) {
                    if (vars.empty() || TrueOperation::isRequired2(*vars.begin(), operation, cycle)) {
                        auto test = new TemporalExpr(timeExprOperand, commitment);
                        newProperty->addCommitment(test);
                    }
                }
            }
        }
        cycle_cnt++;
    }


}

TimeExpr *CreatePropertySuite::findTimeExpr(const std::map<TimeExpr *, Expr *> &map, std::string state_name) {
    for(auto te: map){
        if(te.first->getName() == state_name) return te.first;
    }
    throw std::runtime_error(" Timexpr " + state_name +" not found");
}
